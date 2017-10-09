From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: skcipher - noop for enc/dec with NULL data
Date: Mon, 9 Oct 2017 22:19:25 +0800
Message-ID: <20171009141925.GA7592@gondor.apana.org.au>
References: <3874163.dZU00zCVt8@positron.chronox.de>
 <4036185.N3O6K43VGH@positron.chronox.de>
 <20171007032948.GA29578@gondor.apana.org.au>
 <12183583.FhH6M9YiZ5@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:56458 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751636AbdJIOTr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Oct 2017 10:19:47 -0400
Content-Disposition: inline
In-Reply-To: <12183583.FhH6M9YiZ5@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 07, 2017 at 02:56:24PM +0200, Stephan Müller wrote:
>
> Though, this opens up the shash issue I tried to fix.

Does this patch fix the crash?

---8<---
Subject: crypto: shash - Fix zero-length shash ahash digest crash

The shash ahash digest adaptor function may crash if given a
zero-length input together with a null SG list.  This is because
it tries to read the SG list before looking at the length.

This patch fixes it by checking the length first.

Cc: <stable@vger.kernel.org>
Reported-by: Stephan Müller<smueller@chronox.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/shash.c b/crypto/shash.c
index 8fcecc6..a8322b0 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -275,11 +275,17 @@ static int shash_async_finup(struct ahash_request *req)
 
 int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
 {
-	struct scatterlist *sg = req->src;
-	unsigned int offset = sg->offset;
 	unsigned int nbytes = req->nbytes;
+	struct scatterlist *sg;
+	unsigned int offset;
 	int err;
 
+	if (!nbytes)
+		return 0;
+
+	sg = req->src;
+	offset = sg->offset;
+
 	if (nbytes < min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset)) {
 		void *data;
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
