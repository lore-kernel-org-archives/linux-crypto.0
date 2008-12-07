From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: Runaway loop with the current git.
Date: Sun, 7 Dec 2008 20:54:38 +0300
Message-ID: <20081207175438.GA3181@ioremap.net>
References: <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au> <20081207155507.GA15355@gondor.apana.org.au> <ac3eb2510812070803i150d91e7led58128796e8045e@mail.gmail.com> <20081207160921.693f637a@lxorguk.ukuu.org.uk> <20081207163151.GA31838@ioremap.net> <20081207170108.39dfd93f@lxorguk.ukuu.org.uk> <ac3eb2510812070922q2531a188v37874a042b259ac9@mail.gmail.com> <20081207172855.55fee78f@lxorguk.ukuu.org.uk> <20081207174435.GB1687@ioremap.net> <20081207175245.2d074299@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kay Sievers <kay.sievers@vrfy.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cs-studio.ru ([195.178.208.66]:40253 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbYLGRyk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 12:54:40 -0500
Content-Disposition: inline
In-Reply-To: <20081207175245.2d074299@lxorguk.ukuu.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 07, 2008 at 05:52:45PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > Alan, let's make some progress on this fingerpointing. If Herbert's
> > patch fixes the crypto loading problem, it will find its way upstream
> > for the current tree, and in the merge window Kay's patch may be applied
> > and widely tested. Thoughts?
> 
> I have no intention of applying Kay's patch because it is wrong and it
> will only break things not fix them.

And you are sure it breaks something based on what?

-- 
	Evgeniy Polyakov
