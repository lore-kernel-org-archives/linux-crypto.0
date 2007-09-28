From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 8/8] [CRYPTO] aead: Add support for multiple template parameters
Date: Fri, 28 Sep 2007 09:09:17 +0800
Message-ID: <20070928010917.GA22657@gondor.apana.org.au>
References: <200709272225.l8RMPjb5003200@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Joy Latten <latten@austin.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3239 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752348AbXI1BJq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Sep 2007 21:09:46 -0400
Content-Disposition: inline
In-Reply-To: <200709272225.l8RMPjb5003200@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 27, 2007 at 05:25:45PM -0500, Joy Latten wrote:
>
> Shouldn't p be incremented after this check? Otherwise, it will 
> still be pointing to ')' after breaking from this for-loop and we will
> end up copying "hmac(sha1" instead of "hmac(sha1)", right?
> Also, I think we will prematurely break from top for-loop 
> because of check, "if (*p == ')') break;" which is done further down...

Good catch, I've checked in the following patch.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/cryptomgr.c b/crypto/cryptomgr.c
index c83884f..e5e3cf8 100644
--- a/crypto/cryptomgr.c
+++ b/crypto/cryptomgr.c
@@ -129,6 +129,7 @@ static int cryptomgr_schedule_probe(struct crypto_larval *larval)
 			}
 
 			notnum = 1;
+			p++;
 		}
 
 		len = p - name;
@@ -151,7 +152,7 @@ static int cryptomgr_schedule_probe(struct crypto_larval *larval)
 		param->tb[i + 1] = &param->attrs[i].attr;
 		i++;
 
-		if (WARN_ON(i >= CRYPTO_MAX_ATTRS))
+		if (i >= CRYPTO_MAX_ATTRS)
 			goto err_free_param;
 
 		if (*p == ')')
