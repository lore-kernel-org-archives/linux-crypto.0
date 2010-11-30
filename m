From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: algif_skcipher - Fixed overflow when sndbuf is page aligned
Date: Tue, 30 Nov 2010 16:51:21 +0800
Message-ID: <20101130085121.GA28814@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:32866 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab0K3IvY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 30 Nov 2010 03:51:24 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by fornost.hengli.com.au with esmtp (Exim 4.69 #1 (Debian))
	id 1PNLvl-0007OW-Gc
	for <linux-crypto@vger.kernel.org>; Tue, 30 Nov 2010 19:51:21 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 4.69)
	(envelope-from <herbert@gondor.apana.org.au>)
	id 1PNLvl-0007VC-Dq
	for linux-crypto@vger.kernel.org; Tue, 30 Nov 2010 16:51:21 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

Just noticed that algif_skcipher fails to apply the sk_sndbuf limit
correctly unless it is a multiple of PAGE_SIZE.  What happens is
that the merge path will exceed sk_sndbuf causing the subsequent
limit comparison to fail as it tries to do an unsigned comparison
with a negative value.

This patch fixes the problem.

commit 0f6bb83cb12e4617e696ffa566f3fc6c092686e2
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Tue Nov 30 16:49:02 2010 +0800

    crypto: algif_skcipher - Fixed overflow when sndbuf is page aligned
    
    When sk_sndbuf is not a multiple of PAGE_SIZE, the limit tests
    in sendmsg fail as the limit variable becomes negative and we're
    using an unsigned comparison.
    
    The same thing can happen if sk_sndbuf is lowered after a sendmsg
    call.
    
    This patch fixes this by always taking the signed maximum of limit
    and 0 before we perform the comparison.
    
    It also rounds the value of sk_sndbuf down to a multiple of PAGE_SIZE
    so that we don't end up allocating a page only to use a small number
    of bytes in it because we're bound by sk_sndbuf.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 9b2f440..1f33480 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -52,12 +52,18 @@ struct skcipher_ctx {
 #define MAX_SGL_ENTS ((PAGE_SIZE - sizeof(struct skcipher_sg_list)) / \
 		      sizeof(struct scatterlist) - 1)
 
-static inline bool skcipher_writable(struct sock *sk)
+static inline int skcipher_sndbuf(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct skcipher_ctx *ctx = ask->private;
 
-	return ctx->used + PAGE_SIZE <= max_t(int, sk->sk_sndbuf, PAGE_SIZE);
+	return max_t(int, max_t(int, sk->sk_sndbuf & PAGE_MASK, PAGE_SIZE) -
+			  ctx->used, 0);
+}
+
+static inline bool skcipher_writable(struct sock *sk)
+{
+	return PAGE_SIZE <= skcipher_sndbuf(sk);
 }
 
 static int skcipher_alloc_sgl(struct sock *sk)
@@ -245,7 +251,6 @@ static int skcipher_sendmsg(struct kiocb *unused, struct socket *sock,
 	struct af_alg_control con = {};
 	long copied = 0;
 	bool enc = 0;
-	int limit;
 	int err;
 	int i;
 
@@ -281,9 +286,6 @@ static int skcipher_sendmsg(struct kiocb *unused, struct socket *sock,
 			memcpy(ctx->iv, con.iv->iv, ivsize);
 	}
 
-	limit = max_t(int, sk->sk_sndbuf, PAGE_SIZE);
-	limit -= ctx->used;
-
 	while (size) {
 		struct scatterlist *sg;
 		unsigned long len = size;
@@ -309,20 +311,16 @@ static int skcipher_sendmsg(struct kiocb *unused, struct socket *sock,
 			ctx->used += len;
 			copied += len;
 			size -= len;
-			limit -= len;
 			continue;
 		}
 
-		if (limit < PAGE_SIZE) {
+		if (!skcipher_writable(sk)) {
 			err = skcipher_wait_for_wmem(sk, msg->msg_flags);
 			if (err)
 				goto unlock;
-
-			limit = max_t(int, sk->sk_sndbuf, PAGE_SIZE);
-			limit -= ctx->used;
 		}
 
-		len = min_t(unsigned long, len, limit);
+		len = min_t(unsigned long, len, skcipher_sndbuf(sk));
 
 		err = skcipher_alloc_sgl(sk);
 		if (err)
@@ -352,7 +350,6 @@ static int skcipher_sendmsg(struct kiocb *unused, struct socket *sock,
 			ctx->used += plen;
 			copied += plen;
 			size -= plen;
-			limit -= plen;
 			sgl->cur++;
 		} while (len && sgl->cur < MAX_SGL_ENTS);
 
@@ -380,7 +377,6 @@ static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
 	struct skcipher_ctx *ctx = ask->private;
 	struct skcipher_sg_list *sgl;
 	int err = -EINVAL;
-	int limit;
 
 	lock_sock(sk);
 	if (!ctx->more && ctx->used)
@@ -389,16 +385,10 @@ static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
 	if (!size)
 		goto done;
 
-	limit = max_t(int, sk->sk_sndbuf, PAGE_SIZE);
-	limit -= ctx->used;
-
-	if (limit < PAGE_SIZE) {
+	if (!skcipher_writable(sk)) {
 		err = skcipher_wait_for_wmem(sk, flags);
 		if (err)
 			goto unlock;
-
-		limit = max_t(int, sk->sk_sndbuf, PAGE_SIZE);
-		limit -= ctx->used;
 	}
 
 	err = skcipher_alloc_sgl(sk);

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
