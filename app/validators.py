import re;

def valid_fio(name: str) -> bool:
    pattern = r'^[А-ЯЁ][а-яё]+\s[А-ЯЁ][а-яё]+(?:\s[А-ЯЁ][а-яё]+)?$'
    return bool(re.match(pattern, name))

def valid_age(age: str) -> bool:
    pattern = r"^(1[89]|[2-9]\d)$"
    return bool(re.match(pattern, age))

def valid_weight(weight: str) -> bool:
    pattern = r"^\d+([.]\d+)?$"
    return bool(re.match(pattern, weight))

def valid_time(time: str) -> bool:
    pattern = r"^([01]\d|2[0-3]):([0-5]\d) (\d{2})\.(\d{2})\.(\d{4})$"
    return bool(re.match(pattern, time))

def valid_loc(num: str) -> bool:
    pattern = r"^\d{1,3}$"

    if not re.match(pattern, num):
        return False

    try:
        num = int(num)
    except ValueError:
        return False

    return 0 <= num < 956 