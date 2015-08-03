String::replaceAll = (str1, str2, ignore) ->
  str1 = str1.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&")
  @replace new RegExp("([^(" + str1 + ")]*)(" + str1 + ")([^(" + str1 + ")]*)", "gi"), "$1<span class=\"" + str2 + "\">$2</span>$3"