From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: skcipher - noop for enc/dec with NULL data
Date: Sat, 7 Oct 2017 11:29:48 +0800
Message-ID: <20171007032948.GA29578@gondor.apana.org.au>
References: <3874163.dZU00zCVt8@positron.chronox.de>
 <2010633.8rTN3NahbQ@positron.chronox.de>
 <20171007030752.GA29495@gondor.apana.org.au>
 <4036185.N3O6K43VGH@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:57230 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752278AbdJGDaM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Oct 2017 23:30:12 -0400
Content-Disposition: inline
In-Reply-To: <4036185.N3O6K43VGH@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 07, 2017 at 05:21:38AM +0200, Stephan Müller wrote:
>
> The bug happens with the following invocation sequence:
> 
> setsockopt(3, SOL_ALG, 5, NULL, 1)      = -1 EBUSY (Device or resource busy)
> sendmsg(6, {msg_name=NULL, msg_namelen=0, msg_iov=NULL, msg_iovlen=0, 
> msg_control=[{cmsg_len=20, cmsg_level=SOL_ALG, cmsg_type=0x3}, {cmsg_len=40, 
> cmsg_level=SOL_ALG, cmsg_type=0x2}, {cmsg_len=20, cmsg_level=SOL_ALG, 
> cmsg_type=0x4}], msg_controllen=88, msg_flags=0}, MSG_MORE) = 0
> vmsplice(5, [{iov_base="V", iov_len=1}], 1, SPLICE_F_GIFT) = 1
> splice(4, NULL, 6, NULL, 1, 0)          = 1
> read(6,  <unfinished ...>)              = ?
> +++ killed by SIGKILL +++

I see the problem now.  This was introduced with the skcipher walk
interface.  The blkcipher walk interface didn't have this issue.

I guess we should add a zero test vector once this is fixed.

---8<---
Subject: crypto: skcipher - Fix crash on zero-length input

The skcipher walk interface doesn't handle zero-length input
properly as the old blkcipher walk interface did.  This is due
to the fact that the length check is done too late.

This patch moves the length check forward so that it does the
right thing.

Fixes: b286d8b1a690 ("crypto: skcipher - Add skcipher walk...")
Cc: <stable@vger.kernel.org>
Reported-by: Stephan Müller <smueller@chronox.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 4faa0fd..d5692e3 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -426,14 +426,9 @@ static int skcipher_copy_iv(struct skcipher_walk *walk)
 
 static int skcipher_walk_first(struct skcipher_walk *walk)
 {
-	walk->nbytes = 0;
-
 	if (WARN_ON_ONCE(in_irq()))
 		return -EDEADLK;
 
-	if (unlikely(!walk->total))
-		return 0;
-
 	walk->buffer = NULL;
 	if (unlikely(((unsigned long)walk->iv & walk->alignmask))) {
 		int err = skcipher_copy_iv(walk);
@@ -452,10 +447,15 @@ static int skcipher_walk_skcipher(struct skcipher_walk *walk,
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 
+	walk->total = req->cryptlen;
+	walk->nbytes = 0;
+
+	if (unlikely(!walk->total))
+		return 0;
+
 	scatterwalk_start(&walk->in, req->src);
 	scatterwalk_start(&walk->out, req->dst);
 
-	walk->total = req->cryptlen;
 	walk->iv = req->iv;
 	walk->oiv = req->iv;
 
@@ -509,6 +509,11 @@ static int skcipher_walk_aead_common(struct skcipher_walk *walk,
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	int err;
 
+	walk->nbytes = 0;
+
+	if (unlikely(!walk->total))
+		return 0;
+
 	walk->flags &= ~SKCIPHER_WALK_PHYS;
 
 	scatterwalk_start(&walk->in, req->src);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
