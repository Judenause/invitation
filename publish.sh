#!/usr/bin/env bash
set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "여기는 Git 프로젝트 폴더가 아니에요."
  exit 1
fi

branch="$(git branch --show-current)"
if [ -z "$branch" ]; then
  echo "현재 브랜치를 찾을 수 없어요. Git 상태를 확인해 주세요."
  exit 1
fi

if ! git remote get-url origin >/dev/null 2>&1; then
  echo "GitHub 저장소(origin)가 연결되어 있지 않아요."
  exit 1
fi

message="${*:-Update wedding invitation}"

echo "변경된 파일을 확인하는 중..."

if [ -z "$(git status --porcelain)" ]; then
  echo "새로 저장할 변경 사항은 없어요."
else
  git add -A
  git commit -m "$message"
  echo "로컬 저장 완료: $message"
fi

echo "GitHub에 올리는 중..."
git push -u origin "$branch"

echo "업로드 완료!"
echo "https://github.com/Judenause/invitation"
