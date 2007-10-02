From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC/Patch] fix typo on algorithm comparison
Date: Tue, 2 Oct 2007 22:29:13 +0800
Message-ID: <20071002142913.GB31978@gondor.apana.org.au>
References: <20071001202859.GB15421@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3060 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751116AbXJBO3R (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Oct 2007 10:29:17 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IcikM-0000To-8M
	for <linux-crypto@vger.kernel.org>; Wed, 03 Oct 2007 00:29:14 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IcikL-0008MN-00
	for <linux-crypto@vger.kernel.org>; Tue, 02 Oct 2007 22:29:13 +0800
Content-Disposition: inline
In-Reply-To: <20071001202859.GB15421@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 01, 2007 at 10:28:59PM +0200, Sebastian Siewior wrote:
>
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -153,7 +153,7 @@ static int __crypto_register_alg(struct 
>  			struct crypto_larval *larval = (void *)q;
>  
>  			if (strcmp(alg->cra_name, q->cra_name) &&
> -			    strcmp(alg->cra_driver_name, q->cra_name))
> +			    strcmp(alg->cra_driver_name, q->cra_driver_name))

Actually this is intentional.  I've added a comment.

[CRYPTO] api: Explain the comparison on larval cra_name

This patch adds a comment to explain why we compare the cra_driver_name of
the algorithm being registered against the cra_name of a larval as opposed
to the cra_driver_name of the larval.

In fact larvals have only one name, cra_name which is the name that was
requested by the user.  The test here is simply trying to find out whether
the algorithm being registered can or can not satisfy the larval.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/algapi.c b/crypto/algapi.c
index 58cc191..8ff8c26 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -149,6 +149,11 @@ static int __crypto_register_alg(struct crypto_alg *alg,
 		if (crypto_is_larval(q)) {
 			struct crypto_larval *larval = (void *)q;
 
+			/*
+			 * Check to see if either our generic name or
+			 * specific name can satisfy the name requested
+			 * by the larval entry q.
+			 */
 			if (strcmp(alg->cra_name, q->cra_name) &&
 			    strcmp(alg->cra_driver_name, q->cra_name))
 				continue;
