From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 8/8] [CRYPTO] aead: Add authenc
Date: Fri, 28 Sep 2007 09:10:23 +0800
Message-ID: <20070928011023.GB22657@gondor.apana.org.au>
References: <200709272229.l8RMT4n3003226@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Joy Latten <latten@austin.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3249 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753222AbXI1BKZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Sep 2007 21:10:25 -0400
Content-Disposition: inline
In-Reply-To: <200709272229.l8RMT4n3003226@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 27, 2007 at 05:29:04PM -0500, Joy Latten wrote:
>
> Thus if user enters template without whitespaces,
> then the above would cause a problem because the 
> name in the template would not match up with the name
> in the instance above. 

Indeed, white spaces are not allowed so they should go from
these prints.  I've fixed it in my tree as below.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/authenc.c b/crypto/authenc.c
index 86b3ac8..0b29a6a 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -312,12 +312,12 @@ static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME,
-		     "authenc(%s, %u, %s, %u)", auth->cra_name, authsize,
+		     "authenc(%s,%u,%s,%u)", auth->cra_name, authsize,
 		     enc->cra_name, enckeylen) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
 	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "authenc(%s, %u, %s, %u)", auth->cra_driver_name,
+		     "authenc(%s,%u,%s,%u)", auth->cra_driver_name,
 		     authsize, enc->cra_driver_name, enckeylen) >=
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
