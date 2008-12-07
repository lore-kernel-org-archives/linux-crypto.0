From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: Runaway loop with the current git.
Date: Sun, 7 Dec 2008 20:03:49 +0300
Message-ID: <20081207170349.GA472@ioremap.net>
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk> <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au> <20081207155507.GA15355@gondor.apana.org.au> <ac3eb2510812070803i150d91e7led58128796e8045e@mail.gmail.com> <20081207160921.693f637a@lxorguk.ukuu.org.uk> <ac3eb2510812070821w53ffccfbn73ac40d6a1380553@mail.gmail.com> <20081207165740.2c4bbb0d@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kay Sievers <kay.sievers@vrfy.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tservice.net.ru ([195.178.208.66]:35945 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbYLGRDv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 12:03:51 -0500
Content-Disposition: inline
In-Reply-To: <20081207165740.2c4bbb0d@lxorguk.ukuu.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 07, 2008 at 04:57:40PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> The userspace opens major 5 minor 1. The kernel has no driver mapped to
> that so the kernel asks user space to load a module of its choice for

It has. It really has it. It was not yet initialized though because,
because, because... Hmm, userspace code started and built-in kernel
subsystem was not yet initialized.

> major 5 minor 1. What user space does with that is and has always been a
> problem for user space.
> 
> User space is quite at liberty to go .. 5,1  and I have a serial console
> I want to load 8250_pci please.
> 
> What it must not do is try and re-open it again and again and again.

Heh, init is not allowed to write something to the console or any other
tty?

-- 
	Evgeniy Polyakov
