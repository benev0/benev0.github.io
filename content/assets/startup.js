let colorTheme = localStorage.getItem('color-theme');

if (colorTheme === null) {
  document.documentElement.dataset.appliedMode = "default"
}
else {
  document.documentElement.dataset.appliedMode = "set"
  document.documentElement.dataset.theme = preferDark;
}
