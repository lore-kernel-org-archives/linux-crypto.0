From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Dead code in crypto/tcrypt.c
Date: Wed, 27 Sep 2006 21:09:28 +1000
Message-ID: <E1GSXI8-0000tl-00@gondolin.me.apana.org.au>
References: <1159268741.5661.4.camel@alice>
Cc: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:25870 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S965563AbWI0LJb
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Sep 2006 07:09:31 -0400
To: snakebyte@gmx.de (Eric Sesterhenn)
In-Reply-To: <1159268741.5661.4.camel@alice>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Eric Sesterhenn <snakebyte@gmx.de> wrote:
> 
> the following commit added some code in test_hash_cycles() which coverity flags as dead code.
> http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=e9d41164e2fdd897fe4520c2079ea0000f6e0ec3

Thanks for spotting this.  I've put the following patch
into the tree.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 8330742..587a135 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -646,7 +646,7 @@ static int test_hash_cycles(struct hash_
 			if (ret)
 				goto out;
 		}
-		crypto_hash_final(desc, out);
+		ret = crypto_hash_final(desc, out);
 		if (ret)
 			goto out;
 	}
