From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: Runaway loop with the current git.
Date: Mon, 8 Dec 2008 04:35:20 +0100
Message-ID: <ac3eb2510812071935v7e1b8c75x4d8fa9ce1c8dba6@mail.gmail.com>
References: <20081207175245.2d074299@lxorguk.ukuu.org.uk>
	 <20081207180302.339bf58d@lxorguk.ukuu.org.uk>
	 <ac3eb2510812071013o5d9f3319i44fb7f54b17025ca@mail.gmail.com>
	 <20081207181559.63549cfc@lxorguk.ukuu.org.uk>
	 <ac3eb2510812071021g44207efftb1e74f21578433be@mail.gmail.com>
	 <20081207183112.3ef31caa@lxorguk.ukuu.org.uk>
	 <ac3eb2510812071102s40ed4704we2221b2e53e4c099@mail.gmail.com>
	 <20081207200008.5af2d1e9@lxorguk.ukuu.org.uk>
	 <ac3eb2510812071426n2bd1bbefjd4fcdcd0e2efff80@mail.gmail.com>
	 <20081208011850.GA10289@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "Theodore Tso" <tytso@mit.edu>,
	"Kay Sievers" <kay.sievers@vrfy.org>,
	"Alan Cox" <alan@lxorguk.ukuu.org.uk>,
	"Evgeniy Polyakov" <zbr@ioremap.net>,
	"Herbert Xu" <herbert@gondor.apana.
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.183]:31550 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbYLHDfX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 22:35:23 -0500
Received: by ik-out-1112.google.com with SMTP id c29so736333ika.5
        for <linux-crypto@vger.kernel.org>; Sun, 07 Dec 2008 19:35:21 -0800 (PST)
In-Reply-To: <20081208011850.GA10289@mit.edu>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 8, 2008 at 02:18, Theodore Tso <tytso@mit.edu> wrote:
> Let's take a step back, shall we?  Fundamentally, what's going on here
> is that a particular distribution's initrd (Debian's, to be precise)
> is running into an error in response to a modprobe request for
> char-major-5-1, and it is attempting to write to the console, which is
> resulting in another modprobe request.... ad infinitum.
>
> There is a dispute about whether it is looping forever, or whether it
> should be getting caught by kernel/kmod.c's modprobe recursion
> detector.  Alan has checked the recursion detector and reports that it
> works just fine; Evgeniy and Kay are claiming that it in fact loops
> forever, and the recursion detector is not working.  I'm going to
> guess that Alan tested on Fedora, where it did work just fine, and
> reason why people using a Debian-derived initrd is seeing a recursive
> loop is because the recursive loop detector works by detecting up to
> five concurrent calls to modprobe.  That is, while the userspace
> helper process is running, another userspace helper is invoked, and so
> on, so that there are five userspace helpers piled up on one another,
> this will trigger the automatic recursion detector.  I'm guessing why
> it isn't working given Debian's initrd setup is that whatever is
> ultimately opening /dev/console isn't being called until after the
> helper script has exited.
>
> Given that the general purpose recursion detector is apparently not
> working at least in this case, Kay has proposed that we special case a
> kludge wihch prevents the userspace helper be called in the case of
> 5:1.  His argument in favor of doing this is that /dev/console is
> never a module, so requesting char-major-5-1 will never be helpful,
> and this error can only happen in early userspace, when the tty
> subsystem hasn't been initialized yet.  Alan claims this could also
> happen if the appropriate low-level console driver hasn't been loaded,
> and so perhaps the right thing in response to the request for
> char-major-5-1 is to load 8250_pci.  Here, I think Alan is wrong, and
> Kay is right.  From looking at the source, if there is no low-level
> console driver loaded, there is no call to request_module(); the only
> time this can happen is when tty driver hasn't been initialized in
> early startup.
>
> On the other hand, Alan is right that in general it is the usermode
> helper and initrd's responsibility not create a recursive dependency.
> This is in general true, not just for /dev/console.  So based on that,
> it can be argued that the recursion kludge checking for 5:1 should
> just as much be put in userspace.  In addition, the fact that
> recursion detection isn't working also seems to indicate that initrd
> in question is also doing something very wrong.
>
> So I would think the best thing to do is to figure out what Debian's
> initrd is doing that is evading the recursion detection.  Fixing that
> is going to make things much more robust.

I tested it with an initramfs image with /sbin/modprobe being a shell
script that writes a few bytes to /dev/console, and does nothing else.
It did run for minutes here, until I stopped it.

Sure, if we can make userspace behave nicely, I'm all for doing it. On
the other hand, I think it's a good thing to provide a sane
environment by the kernel for any "non-initramfs-optimized" helper.
Writing to /dev/console is a usual behavior for tools used in
initramfs, to be able to debug bootup problems. In many cases it is
just glibc's fallback LOG_CONS, if syslog is not available.

Modprobe has syslog code, so it might very well be, that the Debian
initramfs isn't doing anything obscure.  The current behavior, is very
easy to trigger bug, and a pretty hard to debug setup, if you do not
add debugging code to the kernel code itself.

That's why I still think it's a good thing, to connect the core tty
devices to their dev_t handler internally, before we init all the
other drivers and run userspace. It will prevent any further needless
searches by the kernel, for a driver for the already created but just
not registered tty devices. We will do exactly the same dev_t
<->device connection (register_chrdev_region) anyway, directly after
loading all the other drivers.

Thanks,
Kay
