class HangulUtils {
  // 초성 리스트
  static const List<String> CHOSUNG_LIST = [
    'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ',
    'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'
  ];

  // 한글 문자를 초성으로 변환
  static String getChosung(String char) {
    if (char.isEmpty) return '';

    int code = char.codeUnitAt(0);

    // 한글 유니코드 범위: 0xAC00(가) ~ 0xD7A3(힣)
    if (code >= 0xAC00 && code <= 0xD7A3) {
      int chosungIndex = ((code - 0xAC00) / 28 / 21).floor();
      return CHOSUNG_LIST[chosungIndex];
    }

    // 초성 자체인 경우
    if (CHOSUNG_LIST.contains(char)) {
      return char;
    }

    return char;
  }

  // 문자열 전체를 초성으로 변환
  static String getChosungString(String text) {
    return text.split('').map((char) => getChosung(char)).join('');
  }

  // 검색어가 텍스트와 매칭되는지 확인 (초성 + 일반 텍스트 모두 지원)
  static bool matchesSearch(String text, String query) {
    if (query.isEmpty) return true;
    if (text.isEmpty) return false;

    // 일반 텍스트 포함 검사
    if (text.contains(query)) {
      return true;
    }

    // 초성 검사
    String textChosung = getChosungString(text);
    return textChosung.contains(query);
  }
}
