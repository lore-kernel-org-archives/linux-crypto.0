From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: Runaway loop with the current git.
Date: Sun, 7 Dec 2008 20:13:56 +0300
Message-ID: <20081207171356.GB472@ioremap.net>
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk> <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au> <20081207155507.GA15355@gondor.apana.org.au> <ac3eb2510812070803i150d91e7led58128796e8045e@mail.gmail.com> <20081207160921.693f637a@lxorguk.ukuu.org.uk> <20081207163151.GA31838@ioremap.net> <20081207170108.39dfd93f@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kay Sievers <kay.sievers@vrfy.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from corega.com.ru ([195.178.208.66]:50331 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbYLGRN6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 12:13:58 -0500
Content-Disposition: inline
In-Reply-To: <20081207170108.39dfd93f@lxorguk.ukuu.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 07, 2008 at 05:01:08PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > Wrong. First at least because tty/console stuff is built in.
> 
> Are you two people or just two names and email addresses for
> the same ?

Depending on who you are asking for.

> /dev/console is a logical mapping to a device which may well be
> different, loaded after PCI is initialised and dependant on PCI.

Yup. It may. But in showed case it is not. In showed case it showed a
bug. Which you call a feature.

> > But we alredy got, that you decided that Debian's initramfs-tools (0.92e)
> > are allowed not to boot with some kernel configs.
> 
> Yes. They won't boot if you don't include any disk drivers. They won't
> boot if you don't include any file systems. They wont boot in a million
> other cases. That is the user space not the kernel at fault.

But right now _everything_ is presented. All things are in places.
Disk drivers, filesystem, and even that stupid console/tty driver.
It _IS_ in the kernel.

> The kernel is doing precisely what it is supposed to. It is even logging
> the user space bug and stopping trying to get stuck in a loop loading a
> module in order to attempt to cope with the user space bug.
> 
> If you want to complain then file a debian bug, go fix the user space.

You introduce so naive rules for the initramfs userspace... It should
not use console, it should not load modules, which may load another
one... What next, not to use syscalls? Sigh, instead of thinking on how
to fix the weak boot process so that next time similar problem arises,
we ended up with pointing a finger one to another... Hope we will not
get another similar cases though.

-- 
	Evgeniy Polyakov
