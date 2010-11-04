From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: RFC: Crypto API User-interface
Date: Thu, 4 Nov 2010 13:02:26 -0500
Message-ID: <20101104180226.GA1598@gondor.apana.org.au>
References: <20101104173156.GA1255@gondor.apana.org.au> <1944766358.1362881288892596101.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Miloslav Trmac <mitr@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:35251 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab0KDSDt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Nov 2010 14:03:49 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by fornost.hengli.com.au with esmtp (Exim 4.69 #1 (Debian))
	id 1PE4A8-0003L4-8J
	for <linux-crypto@vger.kernel.org>; Fri, 05 Nov 2010 05:03:48 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 4.69)
	(envelope-from <herbert@gondor.apana.org.au>)
	id 1PE4A8-0000Sg-6T
	for linux-crypto@vger.kernel.org; Thu, 04 Nov 2010 13:03:48 -0500
Content-Disposition: inline
In-Reply-To: <1944766358.1362881288892596101.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 04, 2010 at 01:43:16PM -0400, Miloslav Trmac wrote:
>
> shash_async_import() - it assumes that the struct shash_desc placed in ahash_request_ctx() of the struct ahash_request was initialized to point to the tfm, which is only done in shash_async_init().

Thanks for catching this.  This patch should fix the problem.

commit 8850e3641dcc7446628681bd7c5f771005e0b208
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu Nov 4 13:00:22 2010 -0500

    crypto: hash - Fix async import on shash algorithm
    
    The function shash_async_import did not initialise the descriptor
    correctly prior to calling the underlying shash import function.
    
    This patch adds the required initialisation.
    
    Reported-by: Miloslav Trmac <mitr@redhat.com>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/shash.c b/crypto/shash.c
index 22fd943..76f74b9 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -310,7 +310,13 @@ static int shash_async_export(struct ahash_request *req, void *out)
 
 static int shash_async_import(struct ahash_request *req, const void *in)
 {
-	return crypto_shash_import(ahash_request_ctx(req), in);
+	struct crypto_shash **ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	struct shash_desc *desc = ahash_request_ctx(req);
+
+	desc->tfm = *ctx;
+	desc->flags = req->base.flags;
+
+	return crypto_shash_import(desc, in);
 }
 
 static void crypto_exit_shash_ops_async(struct crypto_tfm *tfm)

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
