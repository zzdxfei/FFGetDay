function! IsLeapYear(year)
    let year = a:year
    if year % 400 == 0
        return v:true
    endif
    if year % 100 != 0 && year % 4 == 0
        return v:true
    endif
    return v:false
endfunction

function! GetTodayDay()
    let daystring = strftime("%Y %m %d")
    let daylist = split(daystring, ' ')
    let daylist = [str2nr(daylist[0]), str2nr(daylist[1]), str2nr(daylist[2])]
    return daylist
endfunction

function! GetDaysFromYearMouth(y, m)
    let year = a:y
    let mouth = a:m
    let day31 = [1, 3, 5, 7, 8, 10, 12]
    if count(day31, mouth) == 1
        return 31
    endif
    if mouth == 2
        return 28 + IsLeapYear(year)
    endif
    return 30
endfunction

function! GetDayAfterDuring(begin_date, during)
    let begin_date = a:begin_date
    let during = a:during
    let end_date = begin_date
    let week = during / 7
    let day = during % 7
    while during > 0
        let end_date[2] = end_date[2] + 1
        if end_date[2] > GetDaysFromYearMouth(end_date[0], end_date[1])
            let end_date[1] += 1
            let end_date[2] = 1
            if end_date[1] > 12
                let end_date[0] += 1
                let end_date[1] = 1
            endif
        endif
        let during -= 1
    endwhile
    let end_date = end_date + [week, day]
    return end_date
endfunction

function! GetDuring(begin_date, end_date)
    let begin_date = a:begin_date
    let end_date = deepcopy(begin_date)
    let total_day = 1
    while v:true
        let end_date[2] = end_date[2] + 1
        if end_date[2] > GetDaysFromYearMouth(end_date[0], end_date[1])
            let end_date[1] += 1
            let end_date[2] = 1
            if end_date[1] > 12
                let end_date[0] += 1
                let end_date[1] = 1
            endif
        endif
        if end_date == a:end_date
            break
        endif
        let total_day += 1
    endwhile
    return [total_day, total_day / 7, total_day % 7]
endfunction

let s:begin_date = [2020, 8, 16]
command! -nargs=1 FFGetDayAfter :echo GetDayAfterDuring(deepcopy(s:begin_date), <args>)
command! -nargs=0 FFGetToday :echo GetDuring(deepcopy(s:begin_date), GetTodayDay())
