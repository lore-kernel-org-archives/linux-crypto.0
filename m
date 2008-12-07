From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Runaway loop with the current git.
Date: Sun, 7 Dec 2008 16:57:40 +0000
Message-ID: <20081207165740.2c4bbb0d@lxorguk.ukuu.org.uk>
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk>
	<E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
	<20081207155507.GA15355@gondor.apana.org.au>
	<ac3eb2510812070803i150d91e7led58128796e8045e@mail.gmail.com>
	<20081207160921.693f637a@lxorguk.ukuu.org.uk>
	<ac3eb2510812070821w53ffccfbn73ac40d6a1380553@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, zbr@ioremap.net,
	linux-kernel@vger.kernel.org,
	"Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45682 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753493AbYLGQ5e (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 11:57:34 -0500
In-Reply-To: <ac3eb2510812070821w53ffccfbn73ac40d6a1380553@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> > It isn't a problem. It is trying to have hotplug load a suitable driver.
> > This is what is supposed to happen.
> 
> No, it's not. 5:1 is _in_ the kernel, and must not be tried to be
> loaded by the kernel. We need to make /dev/console access return
> -ENODEV if not available, not try to load a module for it.

Hello earth calling, wake up.

The userspace opens major 5 minor 1. The kernel has no driver mapped to
that so the kernel asks user space to load a module of its choice for
major 5 minor 1. What user space does with that is and has always been a
problem for user space.

User space is quite at liberty to go .. 5,1  and I have a serial console
I want to load 8250_pci please.

What it must not do is try and re-open it again and again and again.

You may not assume that a given device load mapping is solely used to
create the most basic device node involved. It isn't that simple. In many
cases a device node translates to a series of module loads of otherwise
apparently unrelated devices.

