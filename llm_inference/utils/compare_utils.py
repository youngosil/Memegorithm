def find_starting_word(string, word_set, except_word="중립"):
    """
    Checks if the string starts with any word in the given set and returns that word.

    :param string: The string to check
    :param word_set: A set of words to check against
    :return: The starting word if found, otherwise None
    """
    for word in word_set:
        if string.startswith(word):
            return word
    return except_word


# If main module, run this
if __name__ == '__main__':
    label_to_class = ['불안', '중립', '당황', '슬픔', '상처', '분노', '기쁨']
    string = "아아아..."
    print(find_starting_word(string, set(label_to_class)))

