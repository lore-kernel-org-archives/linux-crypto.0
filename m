From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH v12 3/4] Linux Random Number Generator
Date: Sun, 23 Jul 2017 17:47:57 -0400
Message-ID: <20170723214757.qil4p7s4d6xc2ker@thunk.org>
References: <3910055.ntkqcq1Chb@positron.chronox.de>
 <150039607.torZXMN7kc@positron.chronox.de>
 <20170718085212.GB25267@kroah.com>
 <1780567.qGdv4EjEMp@positron.chronox.de>
 <20170718210816.o6c4iziaqj5dnnd3@thunk.org>
 <CACXcFmmFGYb-JteJZB8gS+uGJZ4zNLMU=AwPQf0td+xiG0+9Qw@mail.gmail.com>
 <CACXcFm=mQ9namu2R32fJDDRe_gEGxiAar=Hne6012Vnq9x+uRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52226 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751427AbdGWVsE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 23 Jul 2017 17:48:04 -0400
Content-Disposition: inline
In-Reply-To: <CACXcFm=mQ9namu2R32fJDDRe_gEGxiAar=Hne6012Vnq9x+uRA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jul 23, 2017 at 02:05:38PM -0400, Sandy Harris wrote:
> Sandy Harris <sandyinchina@gmail.com> wrote:
> 
> > The biggest problem with random(4) is that you cannot generate good
> > output without a good seed & just after boot, ...
> >
> > The only really good solution I know of is to find a way to provide a
> > chunk of randomness early in the boot process. John Denker has a good
> > discussion of doing this by modifying the kernel image & Ted talks of
> > doing it via the boot loader. ...
> 
> Would it be enough to have a kernel module that does more-or-less what
> the current shell scripts do, but earlier in the boot process? Throw
> the stored data into the random(4) driver at module init time & update
> it periodically later. This would not help much for first boot on a
> new system, unless its store could be updated during install; Denker's
> point that you need each system provisioned differently is important.
> However it looks like it would be enough on other boots.

There are two things that make this hard.  The first is progamming
environment for, say, the GRUB bootloader, is very different from that
of, say, a System V init script.  The second is that it's not obvious
where you can safely store the information across boots.

For a specific architecture --- say, a PC desktop/server using a MBR
or GPT partition table, it's not that hard.  At which point, if you
want to assume that you are using a distribution kernel which is using
an initial ramdisk, you might not even need a kernel module; you could
just do it in the initrd before systemd gets a chance to run, and then
you can do it as a straight-forward shell script.  So that's actually
not hard, and not that different from what we have today.

It won't solve the problem for, say a Tails system, where you could be
booting off of a DVD (in which case you might not have any place to
store state), or a USB or SD card.  That's *also* not hard, but you
end up having to have a different solution for that case.

> It also looks like it might be easier to implement & test. In
> particular it is an isolated do-one-thing-well tool; the programmer
> only needs to worry about his or her module, not several different
> boot loaders or the procedures that distros have for CD images or
> manufacturers for device setup.

Unfortunately, you *do* still have to worry about multiple partition
tables, and potential places where the entropy could be stored.  The
solution for MBR, GPT, and Tails will all have to be slightly
different.

Again, none of this is terribly tricky work.  There are lots of fiddly
details, and if you get it right for one configuration, you will still
have to do something else for the next configuration.  So it's a lot
of grunt work, and since you can't come up for one solution that will
solve it for all systems, it won't be terribly glorious.

Note that you can also solve this problem by diddling the systemd unit
files, if you can make sure that you can fix the dependencies such
that the entropy setup is the very thing that happens after root file
system is mounted read/write, and before anything that might try to
generate keys is allowed to run.  That's going to be roughly the same
level of coverage as a kernel module and doesn't require trying to
store it in some partition-table unique place, but instead you have to
learn a lot of about systemd unit file configuration.

Cheers,

						- Ted
