From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: Runaway loop with the current git.
Date: Sun, 7 Dec 2008 19:33:24 +0300
Message-ID: <20081207163323.GB31838@ioremap.net>
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk> <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au> <20081207155507.GA15355@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, kay.sievers@vrfy.org,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tservice.ru ([195.178.208.66]:58881 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088AbYLGQdZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 11:33:25 -0500
Content-Disposition: inline
In-Reply-To: <20081207155507.GA15355@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 07, 2008 at 11:55:07PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> Having said that I think this patch should remove this particular
> trigger.  Unfortunately I couldn't find a more succinct way of
> expressing this relationship: if ALGAPI is built-in because it's
> selected by an algorithm, and CRYPTO_MANAGER is enabled then we
> require CRYPTO_MANAGER to be built-in as well.
> 
> Evgeniy, please let me know whether this fixes the problem.

Holy shit... This looks 'excellent' :)

I will try it tomorrow and report back the results.

-- 
	Evgeniy Polyakov
