param(
    [Parameter(Mandatory=$true)][string]$workdir
)
# Convert all pbms to jpeg and resize them
Get-ChildItem $workdir -Filter *.pbm | Foreach-Object {
    $file = $_.FullName
    $filename = $_.BaseName
    magick convert $file -filter point -resize '2000%' "$workdir/$filename.jpg"
    rm $_.FullName
}
# Create video out of pictures
ffmpeg -y -f image2 -r 25 -i "$workdir/%d.jpg" "$workdir/out.mp4"
# Delete jpgs
Get-ChildItem $workdir -Filter *.jpg | Foreach-Object {
    rm $_.FullName
}