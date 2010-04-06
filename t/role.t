use strict;
use warnings;
use Test::More tests => 4;

{
    package MyRole;
    use Moose::Role;
    use MooseX::MultiMethods;

    multi method foo (Int $x) { 'Int' }
    multi method foo (Str $x) { 'Str' }
}
{
    package MyClass;
    use Moose;
    
    with 'MyRole';
    
}
{
    package MyClassWithMethod;
    use Moose;
    use MooseX::MultiMethods;
    
    with 'MyRole';
    
    multi method foo (HashRef $x) { 'HashRef' }
    
}

use Test::Exception;

my $obj = MyClass->new;
is $obj->foo(1),       'Int';
is $obj->foo('Hello'), 'Str';

throws_ok {
    is $obj->foo([]),      'Array';
} qr/no variant of method 'foo' found for/;



TODO: {
    local $TODO = "Method composing isn't working yet";
    lives_and {
        my $obj2 = MyClassWithMethod->new;

        is $obj2->foo(1),   'Int';
    } "we find the one in the role";
}
1;
