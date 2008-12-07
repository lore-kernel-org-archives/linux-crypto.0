From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Runaway loop with the current git.
Date: Sun, 7 Dec 2008 18:31:12 +0000
Message-ID: <20081207183112.3ef31caa@lxorguk.ukuu.org.uk>
References: <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
	<20081207170108.39dfd93f@lxorguk.ukuu.org.uk>
	<ac3eb2510812070922q2531a188v37874a042b259ac9@mail.gmail.com>
	<20081207172855.55fee78f@lxorguk.ukuu.org.uk>
	<20081207174435.GB1687@ioremap.net>
	<20081207175245.2d074299@lxorguk.ukuu.org.uk>
	<20081207175438.GA3181@ioremap.net>
	<20081207180302.339bf58d@lxorguk.ukuu.org.uk>
	<ac3eb2510812071013o5d9f3319i44fb7f54b17025ca@mail.gmail.com>
	<20081207181559.63549cfc@lxorguk.ukuu.org.uk>
	<ac3eb2510812071021g44207efftb1e74f21578433be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Evgeniy Polyakov" <zbr@ioremap.net>,
	"Herbert Xu" <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org,
	"Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40957 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754952AbYLGSbP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 13:31:15 -0500
In-Reply-To: <ac3eb2510812071021g44207efftb1e74f21578433be@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> > The loop is detected and terminated.
> 
> No. Please back up what you are trying to talk about.

Let me introduce you to.. drum roll.. the source code. Its a useful
resource, why don't you use it for once.


        max_modprobes = min(max_threads/2, MAX_KMOD_CONCURRENT);
        atomic_inc(&kmod_concurrent);
        if (atomic_read(&kmod_concurrent) > max_modprobes) {
                /* We may be blaming an innocent here, but unlikely */
                if (kmod_loop_msg++ < 5)
                        printk(KERN_ERR
                               "request_module: runaway loop modprobe
%s\n", module_name);
                atomic_dec(&kmod_concurrent);
                return -ENOMEM;
        }

Happy now. Print it out, share it with friends, find someone who can read
C if you are stuck.

> The boxes of the reporters hang! Read the bug! Please!

They would still hang. As I repeatedly said for the benefit of two people
who don't seem to be able to read source code, the loop is detected and
terminated. So it already fails the open when it sees it has gotten five
layers deep.

> There is no cheap way out of the problem, it's a kernel bug, and we
> will fix it - you may just delay it with your zero arguments.

Oh I see. Allow me to explain your position in the words of some small
children I know

	"ME!! ME!! ME!! ME!! ME!!"

I don't care about your obscure corner-case non bug that in fact was a
crypto bug combined with a modprobe bug and where the crypto bug is
now fixed. I do care about not breaking existing users systems. The fact
we do this is why Linux doesn't suck.

Alan
