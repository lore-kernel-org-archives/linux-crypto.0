From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] crypto: cts wrapper mode errata
Date: Mon, 31 Mar 2008 21:24:44 +0200
Message-ID: <20080331192444.GB32563@Chamillionaire.breakpoint.cc>
References: <20080331183913.3095.59520.stgit@jazz.citi.umich.edu>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Kevin Coffman <kwc@citi.umich.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60831 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757623AbYCaTYs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 31 Mar 2008 15:24:48 -0400
Content-Disposition: inline
In-Reply-To: <20080331183913.3095.59520.stgit@jazz.citi.umich.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Kevin Coffman | 2008-03-31 14:39:13 [-0400]:

>This patch fixes a couple of minor issues found by J. Bruce Fields
>while reviewing with the CTS mode patch already applied.
>
There is no functional change in your patch. Did you forget something
or is this on purpose? I assume "a couple of minor issues" is > 1 :)

>---
>
> crypto/cts.c |    6 +++---
> 1 files changed, 3 insertions(+), 3 deletions(-)
>
>diff --git a/crypto/cts.c b/crypto/cts.c
>index 6fe968a..c4e70bf 100644
>--- a/crypto/cts.c
>+++ b/crypto/cts.c
>@@ -201,7 +201,7 @@ static int cts_cbc_decrypt(struct crypto_cts_ctx *ctx,
> 	sg_set_buf(&sgdst[0], d, bsize);
> 	err = crypto_blkcipher_decrypt_iv(&lcldesc, sgdst, sgsrc, bsize);
> 
>-	/* XXX xor with previous block ?? */
>+	/* XOR with previous block */
> 	crypto_xor(d, desc->info, bsize);
> 
> 	scatterwalk_map_and_copy(d, dst, offset, nbytes, 1);

Sebastian
