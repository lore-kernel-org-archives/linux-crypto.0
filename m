From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Runaway loop with the current git.
Date: Sun, 7 Dec 2008 20:00:08 +0000
Message-ID: <20081207200008.5af2d1e9@lxorguk.ukuu.org.uk>
References: <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
	<20081207172855.55fee78f@lxorguk.ukuu.org.uk>
	<20081207174435.GB1687@ioremap.net>
	<20081207175245.2d074299@lxorguk.ukuu.org.uk>
	<20081207175438.GA3181@ioremap.net>
	<20081207180302.339bf58d@lxorguk.ukuu.org.uk>
	<ac3eb2510812071013o5d9f3319i44fb7f54b17025ca@mail.gmail.com>
	<20081207181559.63549cfc@lxorguk.ukuu.org.uk>
	<ac3eb2510812071021g44207efftb1e74f21578433be@mail.gmail.com>
	<20081207183112.3ef31caa@lxorguk.ukuu.org.uk>
	<ac3eb2510812071102s40ed4704we2221b2e53e4c099@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Evgeniy Polyakov" <zbr@ioremap.net>,
	"Herbert Xu" <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org,
	"Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49003 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750826AbYLGUAJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 15:00:09 -0500
In-Reply-To: <ac3eb2510812071102s40ed4704we2221b2e53e4c099@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> >        max_modprobes = min(max_threads/2, MAX_KMOD_CONCURRENT);
> >        atomic_inc(&kmod_concurrent);
> >        if (atomic_read(&kmod_concurrent) > max_modprobes) {
> >                /* We may be blaming an innocent here, but unlikely */
> >                if (kmod_loop_msg++ < 5)
> >                        printk(KERN_ERR
> >                               "request_module: runaway loop modprobe
> > %s\n", module_name);
> >                atomic_dec(&kmod_concurrent);
> >                return -ENOMEM;
> >        }
> >
> > Happy now. Print it out, share it with friends, find someone who can read
> > C if you are stuck.
> 
> It does not work, that's all. 

It works for me. 

> Reproduce the bug and look at it for yourself.

Well since you've got a reproducer and this code works for me (I've tested
it just fine), why don't you go and reproduce the problem then post a fix
to that code I quoted instead of all this reordering rubbish. If you fix
this code not only won't you risk all the mess from re-ordering
initialisations around the kernel but you'll fix non console related
looping which you imply is also broken as you claim that code doesn't
work for you.

If I deliberately break my module utils I see a sequence of modprobes
which then hits kmod_concurrent limit then causes a -ENOMEM back to
userspace which then fails the file open. The bug report also shows the
printk is displayed so the runaway loop *was* detected and the code paths
taken which stopped the loop.

I get open -> modprobe -> open -> modprobe -> open -> modprobe ... ->
open fail, then open fail, open fail, open fail, open fail back to the
first modprobe exiting.

Your proposal to keep the current recent modprobe parameter strings would
shorten the amount of recursion but it wouldn't change the result that I
can see. If I open /dev/console early and wrongly from a modprobe then I
ultimately get a failing open just as I should do.

Alan
