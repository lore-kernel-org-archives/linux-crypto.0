From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH 1/7] A couple of generated files
Date: Sat, 7 Nov 2015 13:50:52 -0500
Message-ID: <CACXcFmkw0O3Od7oAYz8+ZSrRaT-L1kDL=2yStLvKbwOt1QGR2A@mail.gmail.com>
References: <1446906642-19372-1-git-send-email-sandyinchina@gmail.com>
	<20151107165343.GA29133@io.lakedaemon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts\\'o" <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>, John Denker <jsd@av8n.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: Jason Cooper <jason@lakedaemon.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:35026 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbbKGSuw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 7 Nov 2015 13:50:52 -0500
In-Reply-To: <20151107165343.GA29133@io.lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Jason Cooper <jason@lakedaemon.net> wrote:

> I know we talked  about this series offlist, but we need to fill in
> folks who are seeing it for the first time.  Usually, this is done with
> a coverletter (--coverletter for git format-patch).

Yes, your help plus the O'Reilly book got me using git without
too many errors, but I'm still getting things wrong & missing
the cover letter was one.

> No need to resend
> before receiving feedback, but would you mind replying with a
> description of the problem you're attempting to solve and how the series
> solves it?

There are two groups of changes, each controlled by a config
variable. Default for both is 'n'.

CONFIG_RANDOM_INIT: initialise the pools with data from
/dev/urandom on the machine that compiles the kernel.
Comments for the generator program scripts/gen_random.c
have details.

The main change in random.c is adding conditionals
to make it use the random data if CONFIG_RANDOM_INIT
is set. There is also a trivial fix updating a reference to an
obsoleted in a comment, and I added some sanity-check
#if tests for odd #define parameter values.

This is a fairly simple change. I do not think it needs a config
variable; it should just be the default. However I put it under
config control for testing.

CONFIG_RANDOM_GCM controls a much larger and
less clearly desirable set of changes. It switches
compilation between random.c and and a heavily
modified version random_gcm.c

This uses the hash from AES-GCM instead of SHA-1,
and that allows a lot of other changes. The main
design goal was to decouple the two output pools
so that heavy use of the nonblocking pool cannot
deplete entropy in the input pool. The nonblocking
pool usually rekeys from the blocking pool instead.
random_gcm.c has extensive comments on both
the rationale for this approach & the details of my
implementation.

random_gcm.c is not close to being a finished
product, in particular my code is not yet well
integrated with existing driver code.

Most of the code was developed and has been
fairly well tested outside the kernel.
Test program is at:
https://github.com/sandy-harris/random.test

I just dropped a large chunk of that code into
a copy of random.c, made modifications to
make the style match better & to get it to
compile in the kernel context, then deleted
a few chunks of existing driver code and
replaced them with calls to my stuff.

Proper integration would involve both
replacing more of the existing code with
new and moving a few important bits of
the existing code into some of my functions.
In particular, my stuff does not yet block
in the right places.
