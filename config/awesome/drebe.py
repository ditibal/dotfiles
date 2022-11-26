import re
import time
import requests
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--cookie')
cookie = parser.parse_args().cookie

if not cookie:
    raise SystemExit('Необходима авторизация')

PERIOD_LAST_THIRTY_DAYS = 12
PERIOD_THIS_MONTH = 1
PERIOD_THIS_DAY = 7


def get_report(period, only_fun=False):
    headers = {
        'Connection': 'keep-alive',
        'Pragma': 'no-cache',
        'Cache-Control': 'no-cache',
        'sec-ch-ua': '"Chromium";v="92", " Not A;Brand";v="99", "Google Chrome";v="92"',
        'Accept': 'text/javascript, text/html, application/xml, text/xml, */*',
        'X-Prototype-Version': '1.7',
        'X-Requested-With': 'XMLHttpRequest',
        'sec-ch-ua-mobile': '?0',
        'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36',
        'Content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'Origin': 'https://www.drebedengi.ru',
        'Sec-Fetch-Site': 'same-origin',
        'Sec-Fetch-Mode': 'cors',
        'Sec-Fetch-Dest': 'empty',
        'Referer': 'https://www.drebedengi.ru/?module=v2_homeBuhPrivateTextReportMain',
        'Accept-Language': 'ru,en-US;q=0.9,en;q=0.8,fr;q=0.7,es;q=0.6',
        'Cookie': cookie,
    }

    payload = {
        'r_what': '3',
        'r_how': '3',
        'r_period': period,
        'r_who': '0',
        'period_to': '2021-04-30',
        'period_from': '2021-04-01',
        'r_middle': '0',
        'r_is_place': '0',
        'r_is_category': '1' if only_fun else '0',
        'r_currency': '1548909',
        'r_search_comment': '',
        'r_is_tag': '0',
        'is_cat_childs': 'true' if only_fun else 'false',
        'is_with_rest': 'false',
        'is_with_planned': 'false',
        'is_course_hist': 'false',
        'is_search_dbls': 'false',
        'r_duty': '0',
        'r_sum': '0',
        'r_sum_from': '',
        'r_sum_to': '',
        'r_place[]': '12545003',
        'r_category[]': '16409565' if only_fun else '0',
        'r_tag[]': '0',
        'action': 'show_report',
    }

    host = 'https://www.drebedengi.ru/?module=v2_homeBuhPrivateReport'

    out = requests.post(host, headers=headers, data=payload).text

    out = out.replace("\n", "")
    out = out.replace("\t", "")

    pattern = r'<div.*><span.*>Итого<\/span>.*<div\s+class=\"sum\"><div\s+class=\"s\">(.*?)<span.*?>(.*?)</span><\/div>'
    result = re.search(pattern, out, re.UNICODE)
    amount = '0'

    if result:
        amount = result.group(1).replace('&nbsp;', ' ')

    time.sleep(1)
    return amount


print(get_report(PERIOD_LAST_THIRTY_DAYS))
# exit()
#
# print("\n".join([
#     'month: ' + get_report(PERIOD_THIS_MONTH),
#     'thirty_days: ' + get_report(PERIOD_LAST_THIRTY_DAYS),
#     'fun: ' + get_report(PERIOD_LAST_THIRTY_DAYS, True),
# ]))
