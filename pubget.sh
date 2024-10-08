#!/bin/bash

# 현재 폴더 바로 아래의 폴더들을 배열 변수 folders 에 담기
folders=($(ls -d */))

# 배열 변수 출력 (디버깅용)
echo "Folders To Run 'flutter pub get': ${folders[@]}"

# for 루프로 배열 변수 folders 의 각 요소를 처리
for folder in "${folders[@]}"; do
  echo "Entering folder: $folder"
  cd "$folder" || continue  # 폴더로 이동, 실패 시 다음 폴더로 넘어감
  flutter pub get  # 현재 폴더의 내용 출력

  # example 폴더가 있는지 검사
  if [ -d "example" ]; then
    echo "Entering example folder in $folder"
    cd example
    flutter pub get  # example 폴더에서 pub get 실행
    cd ..  # example 폴더에서 나옴
  fi

  cd ..  # 원래 폴더로 돌아옴
done