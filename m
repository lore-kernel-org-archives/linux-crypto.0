From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2] crypto: shash - Fix zero-length shash ahash digest crash
Date: Mon, 9 Oct 2017 23:30:02 +0800
Message-ID: <20171009153002.GA7963@gondor.apana.org.au>
References: <3874163.dZU00zCVt8@positron.chronox.de>
 <12183583.FhH6M9YiZ5@positron.chronox.de>
 <20171009141925.GA7592@gondor.apana.org.au>
 <1629795.0592ersqdG@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:56554 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754108AbdJIPaX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Oct 2017 11:30:23 -0400
Content-Disposition: inline
In-Reply-To: <1629795.0592ersqdG@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 09, 2017 at 05:13:48PM +0200, Stephan Müller wrote:
> Am Montag, 9. Oktober 2017, 16:19:25 CEST schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > On Sat, Oct 07, 2017 at 02:56:24PM +0200, Stephan Müller wrote:
> > > Though, this opens up the shash issue I tried to fix.
> > 
> > Does this patch fix the crash?
> 
> I get the following during boot:

Thanks for the quick response.  Obviously not doing the hash
at all isn't right.

Does this patch work better?

---8<---
The shash ahash digest adaptor function may crash if given a
zero-length input together with a null SG list.  This is because
it tries to read the SG list before looking at the length.

This patch fixes it by checking the length first.

Cc: <stable@vger.kernel.org>
Reported-by: Stephan Müller<smueller@chronox.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/shash.c b/crypto/shash.c
index 8fcecc6..325a14d 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -275,12 +275,14 @@ static int shash_async_finup(struct ahash_request *req)
 
 int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
 {
-	struct scatterlist *sg = req->src;
-	unsigned int offset = sg->offset;
 	unsigned int nbytes = req->nbytes;
+	struct scatterlist *sg;
+	unsigned int offset;
 	int err;
 
-	if (nbytes < min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset)) {
+	if (nbytes &&
+	    (sg = req->src, offset = sg->offset,
+	     nbytes < min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset))) {
 		void *data;
 
 		data = kmap_atomic(sg_page(sg));
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
