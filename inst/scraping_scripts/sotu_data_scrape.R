if (!require("pacman")) install.packages("pacman")
pacman::p_load(xml2, rvest, dplyr, stringi, qdapRegex)


presidents <- xml2::read_html('http://www.presidency.ucsb.edu/sou.php') %>%
        rvest::html_nodes('.datatitle10')  %>%
        rvest::html_text() %>%
        {grep("^[A-Za-z. ]+$", ., value=TRUE)} %>%
        {.[grep("^Barack", .):grep("^George Wash", .)]}

tags <- xml2::read_html('http://www.presidency.ucsb.edu/sou.php') %>%
        rvest::html_nodes(xpath='//a')

years <- tags %>%
        rvest::html_text() %>%
        {grep("\\d{4}", .)}

ids <- tags %>%
    rvest::html_attrs() %>%
    {.[years]} %>%
    unlist() %>%
    ex_default(pattern="(?<=[=])[0-9]+$") %>%
    unlist()%>%
    na.omit()

sotu_raw <- lapply(ids, function(x){

    doc <- try(xml2::read_html(sprintf("http://www.presidency.ucsb.edu/ws/index.php?pid=%s", x)))
    if (inherits(doc, 'try-error')) return(NULL)

    out <- try(dplyr::data_frame(
        id = x,

        President = doc %>%
            rvest::html_nodes('.ver10') %>%
            rvest::html_text() %>%
            {grep("[A-Za-z.: ]", ., value=TRUE)} %>%
            {gsub(":.*$", "", .)} %>%
            {gsub("\\d+$", "", .)} %>%
            {.[nchar(.) < max(nchar(presidents))]} %>%
            {presidents[na.omit(stringdist::amatch(., presidents, maxDist = 4))]} %>%
            `[`(1),

        #title = doc %>%
        #    rvest::html_nodes('.paperstitle') %>%
        #    rvest::html_text(),

        Delivered = doc %>%
            rvest::html_nodes('.docdate') %>%
            rvest::html_text() %>%
            as.Date(format="%B %d, %Y"),

        Text = doc %>%
            rvest::html_nodes(xpath='//p') %>%
            rvest::html_text() %>%
            {gsub("(^\\d+)(.+?)(Address)", "\\1th \\3", .)},

        Paragraph = seq_along(Text)
    ))

    if (out[["President"]][1] == "Grover Cleveland") {
        out[["President"]] <- paste0(out[["President"]], ifelse(format(out[["Delivered"]][1], "%Y") %in% 1885:1889, 1, 2))
    }
    if (inherits(out, 'try-error')) return(NA)
    out
})

# no messages: "James A. Garfield" "William Henry Harrison"

## check all presidents are there
all.equal(
    unique(sapply(sotu_raw, function(x) x$person[1])),
    unique(presidents[!presidents %in% c("James A. Garfield", "William Henry Harrison")])
)


president_demographics <- xml2::read_html('http://www.enchantedlearning.com/history/us/pres/list.shtml') %>%
    rvest::html_nodes('table')  %>%
    #lapply(function(x) try(rvest::html_table(x)))
    `[[`(9) %>%
    rvest::html_table() %>%
    {names(.)[names(.) == 'Vice-President'] <- "Vice_President"; .} %>%
    {names(.)[names(.) == 'Term as President'] <- "Presidential_Years"; .} %>%
    dplyr::mutate(
        Born = ex_default(President, pattern="(?<=[(])[^(]*?(?=[-])") %>% as_numeric2(),
        Died = ex_default(President, pattern="(?<=[-]).*?(?=[)])") %>% as_numeric2(),
        Vice_President = rm_round(ifelse(Vice_President == ".", NA, Vice_President)),
        President = {rev(presidents)}
    ) %>%
    tidyr::separate(Presidential_Years, c("Start", "End"), "-") %>%
    dplyr::mutate(
        End = ifelse(End == "", "2017", End),
        End = ifelse(is.na(End), Start, End) %>% as_numeric2(),
        Start = Start %>% as_numeric2()
    ) %>%
    dplyr::select(-Vice_President) %>%
    {.[['President']][.[['President']] %in% 'Grover Cleveland'] <- paste0('Grover Cleveland', 1:2); .} %>%
    mutate(Order = 1:n())



sotu <- sotu_raw %>%
    dplyr::bind_rows() %>%
    dplyr::mutate(
        Text = gsub("[^ -~]", "", Text)
    ) %>%
    dplyr::full_join(president_demographics, "President") %>%
    dplyr::arrange(Order, Delivered, Paragraph)  %>%
    dplyr::mutate(
        Word_Count = stringi::stri_count_words(Text),
        President = gsub("\\d+$", "", President)
    ) %>%
    dplyr::select(id, Order, President, Party, Born, Died, Start, End, Delivered, Word_Count, Paragraph, Text)
