module HTML::FormHelpers;

proto sub text      is export { }
proto sub button    is export { }
proto sub hidden    is export { }
proto sub select    is export { }
proto sub checkbox  is export { }
proto sub radio     is export { }

my sub attr (*%_) { 
    return ?%_ ?? " " ~ join " ", %_.pairs.map({ $_.key ~ '="' ~ $_.value ~'"' }) ~ " " !! ' ';
}

multi sub text ($name, $value, *%_) {
    return '<input type="text" name="' ~ $name ~ '" value="' ~ $value ~ '"' ~ attr(|%_) ~ '/>';
}

multi sub text ($obj where { $obj.can("id") }, $name, $value?, *%_) {
    my $fname = $name ~ '[' ~ $obj.id ~ ']';
    my $val = defined($value) ?? $value !! $obj."$name"();
    return text($fname, $val, |%_);
}

multi sub button ($name, $value, *%_) {
    return '<input type="button" name="' ~ $name ~ '" value="' ~ $value ~ '"' ~ attr(|%_) ~ '/>';
}

multi sub button ($obj where { $obj.can("id") }, $name, $value?, *%_) {
    my $fname = $name ~ '[' ~ $obj.id ~ ']';
    my $val = defined($value) ?? $value !! $obj."$name"();
    return button($fname, $val, |%_);
}

multi sub hidden ($name, $value, *%_) {
    return '<input type="hidden" name="' ~ $name ~ '" value="' ~ $value ~ '"' ~ attr(|%_) ~ '/>';
}

multi sub hidden ($obj where { $obj.can("id") }, $name, $value?, *%_) {
    my $fname = $name ~ '[' ~ $obj.id ~ ']';
    my $val = defined($value) ?? $value !! $obj."$name"();
    return hidden($fname, $val, |%_);
}

multi sub select (@options) {
    return '<select>' ~ @options.map({ '<option value="' ~ $_ ~ '">' ~ $_ ~ '</option>' }).join("") ~ 
           '</select>';
}

multi sub select ($name, @options, $selected?) {
    return '<select name="' ~ $name ~ '">' ~ 
            @options.map({ 
                my ($k,$v) = .does(Pair) ?? (.key,.value) !! ($_, $_);
                '<option value="' ~ $k ~ '"' ~ (" selected " if ?$selected && $v eq $selected ) ~ '>' ~ $v ~ '</option>' 
            }).join("") ~ '</select>';

}

multi sub select ($obj where { $obj.can("id") }, $name, @options) {
    my $fname = $name ~ '[' ~ $obj.id ~ ']';
    return select($fname, @options, $obj."$name"());
}


multi sub radio ($name, @options, $selected?, :$sep = '') {
    my @ret;
    for @options {
        my ($k,$v) = .does(Pair) ?? (.key,.value) !! ($_, $_);
        my $checked = ?$selected && $v ~~ $selected ?? "checked" !! "";
warn "($_) checked = $checked";
        @ret.push: '<label><input type="radio" name="' ~ $name ~ '" value="' ~ $k ~ '" ' ~ $checked ~ '/>' ~ $v ~ '</label>';
    }
    return @ret.join($sep);
}

multi sub radio ($obj where { $obj.can("id") }, $name, @options) {
    my $fname = $name ~ '[' ~ $obj.id ~ ']';
    return radio($fname, @options, $obj."$name"());
}


# vim: perl6
