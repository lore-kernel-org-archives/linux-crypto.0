From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: VIA Padlock driver no longer loads automatically
Date: Tue, 21 Apr 2009 13:53:31 +0800
Message-ID: <20090421055331.GA14062@gondor.apana.org.au>
References: <20090420181402.2b0424f4@dhcp-100-2-144.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Chuck Ebbert <cebbert@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47232 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751137AbZDUFxg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Apr 2009 01:53:36 -0400
Content-Disposition: inline
In-Reply-To: <20090420181402.2b0424f4@dhcp-100-2-144.bos.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 20, 2009 at 06:14:02PM -0400, Chuck Ebbert wrote:
> On x86 machines only aes_generic and aes_i586 get loaded automatically as of
> kernel 2.6.29. Looks like this was caused by:
> 
>   commit a760a6656e6f00bb0144a42a048cf0266646e22c
>   crypto: api - Fix module load deadlock with fallback algorithms

Thanks for the report.  This patch should fix the problem.

commit 37fc334cc8eb84f5fe0a5a1cbe6a6a68049e142a
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Tue Apr 21 13:27:16 2009 +0800

    crypto: api - Fix algorithm module auto-loading
    
    The commit a760a6656e6f00bb0144a42a048cf0266646e22c (crypto:
    api - Fix module load deadlock with fallback algorithms) broke
    the auto-loading of algorithms that require fallbacks.  The
    problem is that the fallback mask check is missing an and which
    cauess bits that should be considered to interfere with the
    result.
    
    Reported-by: Chuck Ebbert <cebbert@redhat.com>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/api.c b/crypto/api.c
index 314dab9..fd2545d 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -221,7 +221,8 @@ struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
 
 		request_module(name);
 
-		if (!((type ^ CRYPTO_ALG_NEED_FALLBACK) & mask) &&
+		if (!((type ^ CRYPTO_ALG_NEED_FALLBACK) & mask &
+		      CRYPTO_ALG_NEED_FALLBACK) &&
 		    snprintf(tmp, sizeof(tmp), "%s-all", name) < sizeof(tmp))
 			request_module(tmp);
 
Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
