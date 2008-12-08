From: Theodore Tso <tytso@mit.edu>
Subject: Re: Runaway loop with the current git.
Date: Sun, 7 Dec 2008 20:18:51 -0500
Message-ID: <20081208011850.GA10289@mit.edu>
References: <20081207175245.2d074299@lxorguk.ukuu.org.uk> <20081207175438.GA3181@ioremap.net> <20081207180302.339bf58d@lxorguk.ukuu.org.uk> <ac3eb2510812071013o5d9f3319i44fb7f54b17025ca@mail.gmail.com> <20081207181559.63549cfc@lxorguk.ukuu.org.uk> <ac3eb2510812071021g44207efftb1e74f21578433be@mail.gmail.com> <20081207183112.3ef31caa@lxorguk.ukuu.org.uk> <ac3eb2510812071102s40ed4704we2221b2e53e4c099@mail.gmail.com> <20081207200008.5af2d1e9@lxorguk.ukuu.org.uk> <ac3eb2510812071426n2bd1bbefjd4fcdcd0e2efff80@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Evgeniy Polyakov <zbr@ioremap.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:56027 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751066AbYLHBTE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 20:19:04 -0500
Content-Disposition: inline
In-Reply-To: <ac3eb2510812071426n2bd1bbefjd4fcdcd0e2efff80@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Let's take a step back, shall we?  Fundamentally, what's going on here
is that a particular distribution's initrd (Debian's, to be precise)
is running into an error in response to a modprobe request for
char-major-5-1, and it is attempting to write to the console, which is
resulting in another modprobe request.... ad infinitum.

There is a dispute about whether it is looping forever, or whether it
should be getting caught by kernel/kmod.c's modprobe recursion
detector.  Alan has checked the recursion detector and reports that it
works just fine; Evgeniy and Kay are claiming that it in fact loops
forever, and the recursion detector is not working.  I'm going to
guess that Alan tested on Fedora, where it did work just fine, and
reason why people using a Debian-derived initrd is seeing a recursive
loop is because the recursive loop detector works by detecting up to
five concurrent calls to modprobe.  That is, while the userspace
helper process is running, another userspace helper is invoked, and so
on, so that there are five userspace helpers piled up on one another,
this will trigger the automatic recursion detector.  I'm guessing why
it isn't working given Debian's initrd setup is that whatever is
ultimately opening /dev/console isn't being called until after the
helper script has exited.

Given that the general purpose recursion detector is apparently not
working at least in this case, Kay has proposed that we special case a
kludge wihch prevents the userspace helper be called in the case of
5:1.  His argument in favor of doing this is that /dev/console is
never a module, so requesting char-major-5-1 will never be helpful,
and this error can only happen in early userspace, when the tty
subsystem hasn't been initialized yet.  Alan claims this could also
happen if the appropriate low-level console driver hasn't been loaded,
and so perhaps the right thing in response to the request for
char-major-5-1 is to load 8250_pci.  Here, I think Alan is wrong, and
Kay is right.  From looking at the source, if there is no low-level
console driver loaded, there is no call to request_module(); the only
time this can happen is when tty driver hasn't been initialized in
early startup.

On the other hand, Alan is right that in general it is the usermode
helper and initrd's responsibility not create a recursive dependency.
This is in general true, not just for /dev/console.  So based on that,
it can be argued that the recursion kludge checking for 5:1 should
just as much be put in userspace.  In addition, the fact that
recursion detection isn't working also seems to indicate that initrd
in question is also doing something very wrong.

So I would think the best thing to do is to figure out what Debian's
initrd is doing that is evading the recursion detection.  Fixing that
is going to make things much more robust.

Regards,

						- Ted
