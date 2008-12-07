From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: Runaway loop with the current git.
Date: Sun, 7 Dec 2008 20:29:05 +0300
Message-ID: <20081207172904.GA1687@ioremap.net>
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk> <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au> <20081207155507.GA15355@gondor.apana.org.au> <ac3eb2510812070803i150d91e7led58128796e8045e@mail.gmail.com> <20081207160921.693f637a@lxorguk.ukuu.org.uk> <ac3eb2510812070821w53ffccfbn73ac40d6a1380553@mail.gmail.com> <20081207165740.2c4bbb0d@lxorguk.ukuu.org.uk> <20081207170349.GA472@ioremap.net> <20081207172447.3ff2d58f@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kay Sievers <kay.sievers@vrfy.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tservice.ru ([195.178.208.66]:52876 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbYLGR3G (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 12:29:06 -0500
Content-Disposition: inline
In-Reply-To: <20081207172447.3ff2d58f@lxorguk.ukuu.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 07, 2008 at 05:24:47PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > Heh, init is not allowed to write something to the console or any other
> > tty?
> 
> init is not run as the helper of a modprobe.

I hope it is not another limitation for the early userspace? :)
I worked with systems where init made everything. Not showing that as an
example of particulary good design, but still there may be situations
when userspace code does something, which kernel is not ready for. And
it is a kernel problem that it is not ready for some usespace behaviour.

Btw, modprobe can not print error message to the console, that's the
rule ;)

-- 
	Evgeniy Polyakov
