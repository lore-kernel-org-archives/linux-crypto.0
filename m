From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] tcrypt: Test algorithms by name
Date: Fri, 19 Jun 2009 20:38:15 +0800
Message-ID: <20090619123815.GA18826@gondor.apana.org.au>
References: <20090608070749.GR20366@secunet.com> <20090608071246.GW20366@secunet.com> <20090619105325.GA17647@gondor.apana.org.au> <20090619105627.GA17781@gondor.apana.org.au> <20090619114058.GY20366@secunet.com> <20090619114737.GC17647@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:45289 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757552AbZFSMiR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Jun 2009 08:38:17 -0400
Content-Disposition: inline
In-Reply-To: <20090619114737.GC17647@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 19, 2009 at 07:47:37PM +0800, Herbert Xu wrote:
> On Fri, Jun 19, 2009 at 01:40:58PM +0200, Steffen Klassert wrote:
> > This adds the 'alg' module parameter to be able to test an
> > algorithm by name. If the algorithm type is not ad-hoc
> > clear for a algorithm (e.g. pcrypt, cryptd) it is possilbe
> > to set the algorithm type with the 'type' module parameter.
> > 
> > Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> 
> That was quick :)
> 
> Patch applied.  Thanks a lot Steffen!

BTW, I added this on top so that modprobe doesn't complain about
the return code:

tcrypt: one or more tests failed!
sys_init_module: 'tcrypt'->init suspiciously returned 1, it should follow 0/-E convention
sys_init_module: loading module anyway...
Pid: 3064, comm: modprobe Not tainted 2.6.30 #2
Call Trace:
 [<ffffffff81076826>] level2_spare_pgt+0x6e826/0x2d1760
 [<ffffffff8100b4ab>] level2_spare_pgt+0x34ab/0x2d1760

commit ea4006576945195ed35824acfb4007ca7cb78b70
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Jun 19 20:37:00 2009 +0800

    crypto: tcrypt - Fix module return code when testing by name
    
    We should return 0/-ENOENT instead of 1/0 when testing by name.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index dfeec0c..a890a67 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -889,7 +889,7 @@ static int do_test(int m)
 
 static int do_alg_test(const char *alg, u32 type)
 {
-	return crypto_has_alg(alg, type, CRYPTO_ALG_TYPE_MASK);
+	return crypto_has_alg(alg, type, CRYPTO_ALG_TYPE_MASK) ? 0 : -ENOENT;
 }
 
 static int __init tcrypt_mod_init(void)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
