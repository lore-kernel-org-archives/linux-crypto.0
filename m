From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: Runaway loop with the current git.
Date: Sun, 7 Dec 2008 23:26:43 +0100
Message-ID: <ac3eb2510812071426n2bd1bbefjd4fcdcd0e2efff80@mail.gmail.com>
References: <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
	 <20081207175245.2d074299@lxorguk.ukuu.org.uk>
	 <20081207175438.GA3181@ioremap.net>
	 <20081207180302.339bf58d@lxorguk.ukuu.org.uk>
	 <ac3eb2510812071013o5d9f3319i44fb7f54b17025ca@mail.gmail.com>
	 <20081207181559.63549cfc@lxorguk.ukuu.org.uk>
	 <ac3eb2510812071021g44207efftb1e74f21578433be@mail.gmail.com>
	 <20081207183112.3ef31caa@lxorguk.ukuu.org.uk>
	 <ac3eb2510812071102s40ed4704we2221b2e53e4c099@mail.gmail.com>
	 <20081207200008.5af2d1e9@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Evgeniy Polyakov" <zbr@ioremap.net>,
	"Herbert Xu" <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org,
	"Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.183]:2575 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbYLGW0q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 17:26:46 -0500
Received: by ik-out-1112.google.com with SMTP id c29so679035ika.5
        for <linux-crypto@vger.kernel.org>; Sun, 07 Dec 2008 14:26:44 -0800 (PST)
In-Reply-To: <20081207200008.5af2d1e9@lxorguk.ukuu.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 7, 2008 at 21:00, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> >        max_modprobes = min(max_threads/2, MAX_KMOD_CONCURRENT);
>> >        atomic_inc(&kmod_concurrent);
>> >        if (atomic_read(&kmod_concurrent) > max_modprobes) {
>> >                /* We may be blaming an innocent here, but unlikely */
>> >                if (kmod_loop_msg++ < 5)
>> >                        printk(KERN_ERR
>> >                               "request_module: runaway loop modprobe
>> > %s\n", module_name);
>> >                atomic_dec(&kmod_concurrent);
>> >                return -ENOMEM;
>> >        }
>> >
>> > Happy now. Print it out, share it with friends, find someone who can read
>> > C if you are stuck.
>>
>> It does not work, that's all.
>
> It works for me.

It runs in a loop here, just like the $subject says, and bko#12153 says.

>> Reproduce the bug and look at it for yourself.
>
> Well since you've got a reproducer and this code works for me (I've tested
> it just fine), why don't you go and reproduce the problem then post a fix
> to that code I quoted instead of all this reordering rubbish. If you fix
> this code not only won't you risk all the mess from re-ordering
> initialisations around the kernel but you'll fix non console related
> looping which you imply is also broken as you claim that code doesn't
> work for you.
>
> If I deliberately break my module utils I see a sequence of modprobes
> which then hits kmod_concurrent limit then causes a -ENOMEM back to
> userspace which then fails the file open. The bug report also shows the
> printk is displayed so the runaway loop *was* detected and the code paths
> taken which stopped the loop.

Sure, I can try to find out why the limiter does does not work here.

> I get open -> modprobe -> open -> modprobe -> open -> modprobe ... ->
> open fail, then open fail, open fail, open fail, open fail back to the
> first modprobe exiting.
>
> Your proposal to keep the current recent modprobe parameter strings would
> shorten the amount of recursion but it wouldn't change the result that I
> can see. If I open /dev/console early and wrongly from a modprobe then I
> ultimately get a failing open just as I should do.

No, my proposal would prevent the kernel to call any modprobe for the
special built-in device 5:1, it shortens the recursion to zero, which
sounds like the right fix. It's really weird to fix the symptoms,
instead of the real problem.

The kernel forks a binary with a broken environment. Even the
in-kernel-tree cpio generator creates /dev/console, and accessing it
from a kernel forked binary makes it crash. The kernel must provide a
sane environment for stuff that it calls, I think, that is pretty
obvious.

Device 5:1 is a core device, which never makes sense to call modprobe
for it. No other later driver will ever register that dev_t, so we
should do it before calling out to other random userspace stuff which
triggers the kernel to go crazy with its own devices.

My proposal was to connect 5:1 to the kobject map at the same time as
we register the whole tty class. We allocate the class, create sysfs
entries, run /sbin/modprobe at that time, why shouldn't we just
register the dev_t that time too?

It properly prevents the needless userspace "driver searching" for a
well known, already created, but not properly registered core device.

It makes the process environment sane, and prevents the root cause of
the bug, and does not just limit the damage.

Thanks,
Kay
