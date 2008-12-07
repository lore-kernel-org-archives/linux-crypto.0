From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Runaway loop with the current git.
Date: Sun, 7 Dec 2008 17:52:45 +0000
Message-ID: <20081207175245.2d074299@lxorguk.ukuu.org.uk>
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk>
	<E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
	<20081207155507.GA15355@gondor.apana.org.au>
	<ac3eb2510812070803i150d91e7led58128796e8045e@mail.gmail.com>
	<20081207160921.693f637a@lxorguk.ukuu.org.uk>
	<20081207163151.GA31838@ioremap.net>
	<20081207170108.39dfd93f@lxorguk.ukuu.org.uk>
	<ac3eb2510812070922q2531a188v37874a042b259ac9@mail.gmail.com>
	<20081207172855.55fee78f@lxorguk.ukuu.org.uk>
	<20081207174435.GB1687@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Kay Sievers <kay.sievers@vrfy.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60738 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752009AbYLGRwg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 12:52:36 -0500
In-Reply-To: <20081207174435.GB1687@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> Alan, let's make some progress on this fingerpointing. If Herbert's
> patch fixes the crypto loading problem, it will find its way upstream
> for the current tree, and in the merge window Kay's patch may be applied
> and widely tested. Thoughts?

I have no intention of applying Kay's patch because it is wrong and it
will only break things not fix them.

Alan
