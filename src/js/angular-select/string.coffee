String::replaceAll = (str1, str2, ignore) ->
  @replace new RegExp("([^(" + str1 + ")]*)(" + str1 + ")([^(" + str1 + ")]*)", "gi"), "$1<span class=\"" + str2 + "\">$2</span>$3"