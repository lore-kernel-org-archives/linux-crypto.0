From: Theodore Tso <tytso@mit.edu>
Subject: Re: Runaway loop with the current git.
Date: Mon, 8 Dec 2008 20:09:37 -0500
Message-ID: <20081209010937.GL2501@mit.edu>
References: <20081207180302.339bf58d@lxorguk.ukuu.org.uk> <ac3eb2510812071013o5d9f3319i44fb7f54b17025ca@mail.gmail.com> <20081207181559.63549cfc@lxorguk.ukuu.org.uk> <ac3eb2510812071021g44207efftb1e74f21578433be@mail.gmail.com> <20081207183112.3ef31caa@lxorguk.ukuu.org.uk> <ac3eb2510812071102s40ed4704we2221b2e53e4c099@mail.gmail.com> <20081207200008.5af2d1e9@lxorguk.ukuu.org.uk> <ac3eb2510812071426n2bd1bbefjd4fcdcd0e2efff80@mail.gmail.com> <20081208011850.GA10289@mit.edu> <ac3eb2510812071935v7e1b8c75x4d8fa9ce1c8dba6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Evgeniy Polyakov <zbr@ioremap.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51943 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753639AbYLIBJt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Dec 2008 20:09:49 -0500
Content-Disposition: inline
In-Reply-To: <ac3eb2510812071935v7e1b8c75x4d8fa9ce1c8dba6@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 08, 2008 at 04:35:20AM +0100, Kay Sievers wrote:
> Sure, if we can make userspace behave nicely, I'm all for doing it. On
> the other hand, I think it's a good thing to provide a sane
> environment by the kernel for any "non-initramfs-optimized" helper.
> Writing to /dev/console is a usual behavior for tools used in
> initramfs, to be able to debug bootup problems. In many cases it is
> just glibc's fallback LOG_CONS, if syslog is not available.

Well, can we agree that (a) there is a generalized modprobe recursion
detector already in the kernel, and (b) for some reason, Debian isn't
triggering it?  That seems like a bug, and while it may not be 100%
clear whether the bug is on the userspace side or the kernel side, it
would seem that finding and fixing *that* would be a Good Thing, and
it could be argued that a specific don't request char-major-5-1 would
be papering over this bug (whether it is in Debian's initrd or in the
kernel side code).  It would be good to make sure we understand what
the root causes for while the modprobe recursion detector is
apparently not triggering, since it could be that Debian's initrd
might cause some other uncaught recursion loop if we don't drive this
problem determination to root cause.

> That's why I still think it's a good thing, to connect the core tty
> devices to their dev_t handler internally, before we init all the
> other drivers and run userspace.

Um, how early?  (/me searches lkml.org for the original patch).  Ah,
OK, you want to do it postcore....  There may actually be a problem
with that, because it looks like vtconsole_class_init (which is
currently run as a postcore initcall) really wants to happen before
the tty layer initializes itself.  So moving tty into postcore could
potentially run into problems, depending on whether vt.c's or
tty_io.c's initcalls are run first.

						- Ted
