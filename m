From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: Runaway loop with the current git.
Date: Tue, 9 Dec 2008 03:00:01 +0100
Message-ID: <ac3eb2510812081800id4b1a88je311fcbbf574e06b@mail.gmail.com>
References: <20081207180302.339bf58d@lxorguk.ukuu.org.uk>
	 <20081207181559.63549cfc@lxorguk.ukuu.org.uk>
	 <ac3eb2510812071021g44207efftb1e74f21578433be@mail.gmail.com>
	 <20081207183112.3ef31caa@lxorguk.ukuu.org.uk>
	 <ac3eb2510812071102s40ed4704we2221b2e53e4c099@mail.gmail.com>
	 <20081207200008.5af2d1e9@lxorguk.ukuu.org.uk>
	 <ac3eb2510812071426n2bd1bbefjd4fcdcd0e2efff80@mail.gmail.com>
	 <20081208011850.GA10289@mit.edu>
	 <ac3eb2510812071935v7e1b8c75x4d8fa9ce1c8dba6@mail.gmail.com>
	 <20081209010937.GL2501@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "Theodore Tso" <tytso@mit.edu>,
	"Kay Sievers" <kay.sievers@vrfy.org>,
	"Alan Cox" <alan@lxorguk.ukuu.org.uk>,
	"Evgeniy Polyakov" <zbr@ioremap.net>,
	"Herbert Xu" <herbert@gondor.apana.
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:1116 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbYLICAD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Dec 2008 21:00:03 -0500
Received: by nf-out-0910.google.com with SMTP id d3so704148nfc.21
        for <linux-crypto@vger.kernel.org>; Mon, 08 Dec 2008 18:00:01 -0800 (PST)
In-Reply-To: <20081209010937.GL2501@mit.edu>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 9, 2008 at 02:09, Theodore Tso <tytso@mit.edu> wrote:
> On Mon, Dec 08, 2008 at 04:35:20AM +0100, Kay Sievers wrote:
>> Sure, if we can make userspace behave nicely, I'm all for doing it. On
>> the other hand, I think it's a good thing to provide a sane
>> environment by the kernel for any "non-initramfs-optimized" helper.
>> Writing to /dev/console is a usual behavior for tools used in
>> initramfs, to be able to debug bootup problems. In many cases it is
>> just glibc's fallback LOG_CONS, if syslog is not available.
>
> Well, can we agree that (a) there is a generalized modprobe recursion
> detector already in the kernel, and (b) for some reason, Debian isn't
> triggering it?  That seems like a bug, and while it may not be 100%
> clear whether the bug is on the userspace side or the kernel side, it
> would seem that finding and fixing *that* would be a Good Thing, and
> it could be argued that a specific don't request char-major-5-1 would
> be papering over this bug (whether it is in Debian's initrd or in the
> kernel side code).  It would be good to make sure we understand what
> the root causes for while the modprobe recursion detector is
> apparently not triggering, since it could be that Debian's initrd
> might cause some other uncaught recursion loop if we don't drive this
> problem determination to root cause.

Right, it would be good to know for sure what's going on.

In my test script it was just a simple access to /dev/console, so it
might just be that modprobe wants to log something on Debian. At least
that would match the behavior I've seen here.

And we really rely on these tools to be able to print debug messages
sometimes to find other bugs (at least at the time it's theoretically
possible to log). And I don't see how modprobe could find out, that it
is not allowed to access /dev/console.

As an ideal solution, I would like to have /dev/console working before
_any_ userspace is called, and it would put all the stuff that is
written to it the kernel "dmesg buffer" as long as the console isn't
working, just to be able to see what's going on, if needed. As the
second choice, it would return -ENODEV. The current looping is
definitely not what we want. :)

>> That's why I still think it's a good thing, to connect the core tty
>> devices to their dev_t handler internally, before we init all the
>> other drivers and run userspace.
>
> Um, how early?  (/me searches lkml.org for the original patch).  Ah,
> OK, you want to do it postcore....  There may actually be a problem
> with that, because it looks like vtconsole_class_init (which is
> currently run as a postcore initcall) really wants to happen before
> the tty layer initializes itself.  So moving tty into postcore could
> potentially run into problems, depending on whether vt.c's or
> tty_io.c's initcalls are run first.

Sure, we might need to change that, if it is a problem. It was mainly
to find out what was going on, because people thought that some serial
driver is involved in the loop, which I didn't believe.

To be safer, maybe we just want to move the cdev_add(),
register_chrdev_region() call, which should prevent the "userspace
driver search".

Thanks,
Kay
