# Convert all pbms to jpeg and resize them
Get-ChildItem . -Filter *.pbm | Foreach-Object {
    $file = $_.FullName
    $filename = $_.BaseName
    $dir = $_.DirectoryName
    magick convert $file -filter point -resize '2000%' "$dir/$filename.jpg"
    rm $_.FullName
}
# Create video out of pictures
ffmpeg -y -f image2 -r 25 -i %d.jpg out.mp4
# Delete jpgs
Get-ChildItem . -Filter *.jpg | Foreach-Object {
    rm $_.FullName
}