From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] geode: PTR_ERR return of wrong pointer in
 fallback_init_cip()
Date: Mon, 7 Dec 2009 14:40:13 +0100
Message-ID: <20091207134012.GA21388@Chamillionaire.breakpoint.cc>
References: <4B1D02F7.2020505@gmail.com>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Sergey Mironov <ierton@gmail.com>
To: Roel Kluin <roel.kluin@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46357 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934845AbZLGNkN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Dec 2009 08:40:13 -0500
Content-Disposition: inline
In-Reply-To: <4B1D02F7.2020505@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Roel Kluin | 2009-12-07 14:28:23 [+0100]:

>Return the PTR_ERR of the correct pointer.
>
>Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>---
> drivers/crypto/geode-aes.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
>index 4801162..12cf864 100644
>--- a/drivers/crypto/geode-aes.c
>+++ b/drivers/crypto/geode-aes.c
>@@ -263,7 +263,7 @@ static int fallback_init_cip(struct crypto_tfm *tfm)
> 
> 	if (IS_ERR(op->fallback.cip)) {
> 		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
>-		return PTR_ERR(op->fallback.blk);
>+		return PTR_ERR(op->fallback.cip);
> 	}

This is correct however you missed one spot a few lines above that one.
Sergey Mironov sent a patch a while ago unfortunatelly a mangled one and
he hasn't resent it yet.
Could you please look at [0] for the missing spot? If you had fun fixing
that one, I've a made a similar mistake in s390's driver [1]. If not
please say so.

> 
> 	return 0;

[0] http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg03883.html
[1] http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg03888.html

Sebastian
