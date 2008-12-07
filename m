From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Runaway loop with the current git.
Date: Sun, 7 Dec 2008 17:01:08 +0000
Message-ID: <20081207170108.39dfd93f@lxorguk.ukuu.org.uk>
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk>
	<E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
	<20081207155507.GA15355@gondor.apana.org.au>
	<ac3eb2510812070803i150d91e7led58128796e8045e@mail.gmail.com>
	<20081207160921.693f637a@lxorguk.ukuu.org.uk>
	<20081207163151.GA31838@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Kay Sievers <kay.sievers@vrfy.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51016 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753784AbYLGRA7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 12:00:59 -0500
In-Reply-To: <20081207163151.GA31838@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> Wrong. First at least because tty/console stuff is built in.

Are you two people or just two names and email addresses for
the same ?

/dev/console is a logical mapping to a device which may well be
different, loaded after PCI is initialised and dependant on PCI.

> But we alredy got, that you decided that Debian's initramfs-tools (0.92e)
> are allowed not to boot with some kernel configs.

Yes. They won't boot if you don't include any disk drivers. They won't
boot if you don't include any file systems. They wont boot in a million
other cases. That is the user space not the kernel at fault.

The kernel is doing precisely what it is supposed to. It is even logging
the user space bug and stopping trying to get stuck in a loop loading a
module in order to attempt to cope with the user space bug.

If you want to complain then file a debian bug, go fix the user space.

Alan
