#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

{
    package Foo::Meta::Attribute;
    use Moose::Role;
}

{
    package Foo::Meta::Attribute2;
    use Moose::Role;
}

{
    package Foo::Role;
    use Moose::Role;

    has foo => (is => 'ro');
}

{
    package Foo;
    use Moose;
    Moose::Util::MetaRole::apply_metaroles(
        for => __PACKAGE__,
        class_metaroles => { attribute => ['Foo::Meta::Attribute'] },
        role_metaroles  => { applied_attribute => ['Foo::Meta::Attribute2'] },
    );
    with 'Foo::Role';

    has bar => (is => 'ro');
}

ok(Moose::Util::does_role(Foo->meta->get_attribute('bar'), 'Foo::Meta::Attribute'), "attrs defined in the class get the class metarole applied");
ok(!Moose::Util::does_role(Foo->meta->get_attribute('bar'), 'Foo::Meta::Attribute2'), "attrs defined in the class don't get the role metarole applied");
ok(!Moose::Util::does_role(Foo->meta->get_attribute('foo'), 'Foo::Meta::Attribute'), "attrs defined in the role don't get the metarole applied");
ok(!Moose::Util::does_role(Foo->meta->get_attribute('foo'), 'Foo::Meta::Attribute'), "attrs defined in the role don't get the role metarole defined in the class applied");

{
    package Bar::Meta::Attribute;
    use Moose::Role;
}

{
    package Bar::Meta::Attribute2;
    use Moose::Role;
}

{
    package Bar::Role;
    use Moose::Role;
    Moose::Util::MetaRole::apply_metaroles(
        for => __PACKAGE__,
        class_metaroles => { attribute => ['Bar::Meta::Attribute'] },
        role_metaroles  => { applied_attribute => ['Bar::Meta::Attribute2'] },
    );

    has foo => (is => 'ro');
}

{
    package Bar;
    use Moose;
    with 'Bar::Role';

    has bar => (is => 'ro');
}

ok(!Moose::Util::does_role(Bar->meta->get_attribute('bar'), 'Bar::Meta::Attribute'), "attrs defined in the class don't get the class metarole from the role applied");
ok(!Moose::Util::does_role(Bar->meta->get_attribute('bar'), 'Bar::Meta::Attribute2'), "attrs defined in the class don't get the role metarole applied");
ok(Moose::Util::does_role(Bar->meta->get_attribute('foo'), 'Bar::Meta::Attribute2'), "attrs defined in the role get the role metarole applied");
ok(!Moose::Util::does_role(Bar->meta->get_attribute('foo'), 'Bar::Meta::Attribute'), "attrs defined in the role don't get the class metarole applied");

{
    package Baz::Meta::Attribute;
    use Moose::Role;
}

{
    package Baz::Meta::Attribute2;
    use Moose::Role;
}

{
    package Baz::Role;
    use Moose::Role;
    Moose::Util::MetaRole::apply_metaroles(
        for => __PACKAGE__,
        class_metaroles => { attribute => ['Baz::Meta::Attribute'] },
        role_metaroles  => { applied_attribute => ['Baz::Meta::Attribute2'] },
    );

    has foo => (is => 'ro');
}

{
    package Baz;
    use Moose;
    Moose::Util::MetaRole::apply_metaroles(
        for => __PACKAGE__,
        class_metaroles => { attribute => ['Baz::Meta::Attribute'] },
        role_metaroles  => { applied_attribute => ['Baz::Meta::Attribute2'] },
    );
    with 'Baz::Role';

    has bar => (is => 'ro');
}

ok(Moose::Util::does_role(Baz->meta->get_attribute('bar'), 'Baz::Meta::Attribute'), "attrs defined in the class get the class metarole applied");
ok(!Moose::Util::does_role(Baz->meta->get_attribute('bar'), 'Baz::Meta::Attribute2'), "attrs defined in the class don't get the role metarole applied");
ok(Moose::Util::does_role(Baz->meta->get_attribute('foo'), 'Baz::Meta::Attribute2'), "attrs defined in the role get the role metarole applied");
ok(!Moose::Util::does_role(Baz->meta->get_attribute('foo'), 'Baz::Meta::Attribute'), "attrs defined in the role don't get the class metarole applied");

done_testing;
