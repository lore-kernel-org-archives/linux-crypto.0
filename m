Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12815320CD1
	for <linux-crypto@vger.kernel.org>; Thu, 26 Mar 2026 06:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774506630; cv=none; b=uCI0EYvRoMCwPSyO7z3HW7rFkBV7Q9dukuBaMe1oRvHxuDE2u9w4LCKFAlm5yI34EE+hnOE/8vFGC6HCPyIWrUDxzdrwVDbK+aFRDtf+Um9jeQIfX1Y9U/6JJwpbYmCrsoj3Egsj1sCfLQ0GwCArYuukN1pMyqozoGVKTWrRGsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774506630; c=relaxed/simple;
	bh=On2gcMMz7Hy8p4xq0koBkH+aA8TInTagqbkPOL5oAKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qTBYqH2n4co+Bp6D0n4plIYIrVKVbtJo6PUR2UhHJc2fCd6vpJ56azAL7a0HMZQulvEygyAfiWPm+NyHU1L/D3NrgcAxF34oB9WxT9X+k5wYCme0PRqjFrcGVj11RDpw9Kx9deE0Nze6Aw7EnfEaAM+CmGeKhIfr9lH35at76M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=XqCqdeTR; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="XqCqdeTR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=6DC6fXmFr8SUUzQs5guGThTobomDtZ4etH0YW/ifnQs=; 
	b=XqCqdeTRG4est1IRvwUEzqWBW6cl64swGKzvsMNY6GcDkusyL+SJK7h3kAYzO4BdU4fsFZDgYE1
	j5g6U/0+UgLHVlewSuqaqdhAhWyQ0YXWogu8L2TRyIULrhpiHHQ1wnWzX2CN8WHWwl3bn1ZAmmK24
	OsNlUk8vJL84vtJTl69vaZ2QU0i30VQp5m/6mW7/D0JVabPbh/kMbL03Mxylb1atiAVM7f1XawNPf
	/GuGFj5SNWNIa6VDlgB+E4deEPZ2o26WYp9BzHiRX6+edyTWVl90ocdiGx0j9DcuNb3+BFzWgeP5R
	F37W4ajg7fpUWNpDWqzYdZVnaimm9MfYDp+A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w5dp3-001DHa-1B;
	Thu, 26 Mar 2026 14:30:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 26 Mar 2026 15:30:20 +0900
Date: Thu, 26 Mar 2026 15:30:20 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Taeyang Lee <0wn@theori.io>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net,
	Brian Pak <bpak@theori.io>, Juno Im <juno@theori.io>,
	Jungwon Lim <setuid0@theori.io>
Subject: [PATCH] crypto: algif_aead - Revert to operating out-of-place
Message-ID: <acTSfLPWDGTaGIf7@gondor.apana.org.au>
References: <acOpDrnN3cVfiASk@gondor.apana.org.au>
 <CAH-2XvLZD_-CVQT0omao2+GrdQt1Loq+oo4X6q=0NUAeUk==1w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH-2XvLZD_-CVQT0omao2+GrdQt1Loq+oo4X6q=0NUAeUk==1w@mail.gmail.com>

On Thu, Mar 26, 2026 at 02:59:24AM +0900, Taeyang Lee wrote:
> 
> I don't think checking only `src != dst` is sufficient for the issue I
> reported.
> 
> In the AF_ALG AEAD decrypt path, the child AEAD request is intentionally
> set up to look in-place: `req->src == req->dst` on the RX SGL head, and
> the TX-backed authentication-tag pages are then chained behind that RX
> SGL. So from authencesn's point of view this still takes the `src == dst`
> path, while `dst[assoclen + cryptlen]` can still resolve to TX-backed
> pages, including splice()/MSG_SPLICE_PAGES-backed page-cache pages.

Right, that's a separate bug.  algif_aead should not attach a
read-only mapping to the dst SG list, which will be written to.

---8<---
This mostly reverts commit 72548b093ee3 except for the copying of
the associated data.

There is no benefit in operating in-place in algif_aead since the
source and destination come from different mappings.  Get rid of
all the complexity added for in-place operation and just copy the
AD directly.

Fixes: 72548b093ee3 ("crypto: algif_aead - copy AAD from src to dst")
Reported-by: Taeyang Lee <0wn@theori.io>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/af_alg.c         |  49 +++++-------------------
 crypto/algif_aead.c     | 100 +++++++++---------------------------------------
 crypto/algif_skcipher.c |   6 +--
 include/crypto/if_alg.h |   5 +--
 4 files changed, 34 insertions(+), 126 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 0bb609fbec7d..0d2305ac1b52 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -635,15 +635,13 @@ static int af_alg_alloc_tsgl(struct sock *sk)
 /**
  * af_alg_count_tsgl - Count number of TX SG entries
  *
- * The counting starts from the beginning of the SGL to @bytes. If
- * an @offset is provided, the counting of the SG entries starts at the @offset.
+ * The counting starts from the beginning of the SGL to @bytes.
  *
  * @sk: socket of connection to user space
  * @bytes: Count the number of SG entries holding given number of bytes.
- * @offset: Start the counting of SG entries from the given offset.
  * Return: Number of TX SG entries found given the constraints
  */
-unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes, size_t offset)
+unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes)
 {
 	const struct alg_sock *ask = alg_sk(sk);
 	const struct af_alg_ctx *ctx = ask->private;
@@ -658,25 +656,11 @@ unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes, size_t offset)
 		const struct scatterlist *sg = sgl->sg;
 
 		for (i = 0; i < sgl->cur; i++) {
-			size_t bytes_count;
-
-			/* Skip offset */
-			if (offset >= sg[i].length) {
-				offset -= sg[i].length;
-				bytes -= sg[i].length;
-				continue;
-			}
-
-			bytes_count = sg[i].length - offset;
-
-			offset = 0;
 			sgl_count++;
-
-			/* If we have seen requested number of bytes, stop */
-			if (bytes_count >= bytes)
+			if (sg[i].length >= bytes)
 				return sgl_count;
 
-			bytes -= bytes_count;
+			bytes -= sg[i].length;
 		}
 	}
 
@@ -688,19 +672,14 @@ EXPORT_SYMBOL_GPL(af_alg_count_tsgl);
  * af_alg_pull_tsgl - Release the specified buffers from TX SGL
  *
  * If @dst is non-null, reassign the pages to @dst. The caller must release
- * the pages. If @dst_offset is given only reassign the pages to @dst starting
- * at the @dst_offset (byte). The caller must ensure that @dst is large
- * enough (e.g. by using af_alg_count_tsgl with the same offset).
+ * the pages.
  *
  * @sk: socket of connection to user space
  * @used: Number of bytes to pull from TX SGL
  * @dst: If non-NULL, buffer is reassigned to dst SGL instead of releasing. The
  *	 caller must release the buffers in dst.
- * @dst_offset: Reassign the TX SGL from given offset. All buffers before
- *	        reaching the offset is released.
  */
-void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
-		      size_t dst_offset)
+void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct af_alg_ctx *ctx = ask->private;
@@ -725,18 +704,10 @@ void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
 			 * SG entries in dst.
 			 */
 			if (dst) {
-				if (dst_offset >= plen) {
-					/* discard page before offset */
-					dst_offset -= plen;
-				} else {
-					/* reassign page to dst after offset */
-					get_page(page);
-					sg_set_page(dst + j, page,
-						    plen - dst_offset,
-						    sg[i].offset + dst_offset);
-					dst_offset = 0;
-					j++;
-				}
+				/* reassign page to dst after offset */
+				get_page(page);
+				sg_set_page(dst + j, page, plen, sg[i].offset);
+				j++;
 			}
 
 			sg[i].length -= plen;
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 79b016a899a1..dda15bb05e89 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -26,7 +26,6 @@
 #include <crypto/internal/aead.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/if_alg.h>
-#include <crypto/skcipher.h>
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/kernel.h>
@@ -72,9 +71,8 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	struct alg_sock *pask = alg_sk(psk);
 	struct af_alg_ctx *ctx = ask->private;
 	struct crypto_aead *tfm = pask->private;
-	unsigned int i, as = crypto_aead_authsize(tfm);
+	unsigned int as = crypto_aead_authsize(tfm);
 	struct af_alg_async_req *areq;
-	struct af_alg_tsgl *tsgl, *tmp;
 	struct scatterlist *rsgl_src, *tsgl_src = NULL;
 	int err = 0;
 	size_t used = 0;		/* [in]  TX bufs to be en/decrypted */
@@ -154,23 +152,24 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 		outlen -= less;
 	}
 
+	/*
+	 * Create a per request TX SGL for this request which tracks the
+	 * SG entries from the global TX SGL.
+	 */
 	processed = used + ctx->aead_assoclen;
-	list_for_each_entry_safe(tsgl, tmp, &ctx->tsgl_list, list) {
-		for (i = 0; i < tsgl->cur; i++) {
-			struct scatterlist *process_sg = tsgl->sg + i;
-
-			if (!(process_sg->length) || !sg_page(process_sg))
-				continue;
-			tsgl_src = process_sg;
-			break;
-		}
-		if (tsgl_src)
-			break;
-	}
-	if (processed && !tsgl_src) {
-		err = -EFAULT;
+	areq->tsgl_entries = af_alg_count_tsgl(sk, processed);
+	if (!areq->tsgl_entries)
+		areq->tsgl_entries = 1;
+	areq->tsgl = sock_kmalloc(sk, array_size(sizeof(*areq->tsgl),
+					         areq->tsgl_entries),
+				  GFP_KERNEL);
+	if (!areq->tsgl) {
+		err = -ENOMEM;
 		goto free;
 	}
+	sg_init_table(areq->tsgl, areq->tsgl_entries);
+	af_alg_pull_tsgl(sk, processed, areq->tsgl);
+	tsgl_src = areq->tsgl;
 
 	/*
 	 * Copy of AAD from source to destination
@@ -179,76 +178,15 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	 * when user space uses an in-place cipher operation, the kernel
 	 * will copy the data as it does not see whether such in-place operation
 	 * is initiated.
-	 *
-	 * To ensure efficiency, the following implementation ensure that the
-	 * ciphers are invoked to perform a crypto operation in-place. This
-	 * is achieved by memory management specified as follows.
 	 */
 
 	/* Use the RX SGL as source (and destination) for crypto op. */
 	rsgl_src = areq->first_rsgl.sgl.sgt.sgl;
 
-	if (ctx->enc) {
-		/*
-		 * Encryption operation - The in-place cipher operation is
-		 * achieved by the following operation:
-		 *
-		 * TX SGL: AAD || PT
-		 *	    |	   |
-		 *	    | copy |
-		 *	    v	   v
-		 * RX SGL: AAD || PT || Tag
-		 */
-		memcpy_sglist(areq->first_rsgl.sgl.sgt.sgl, tsgl_src,
-			      processed);
-		af_alg_pull_tsgl(sk, processed, NULL, 0);
-	} else {
-		/*
-		 * Decryption operation - To achieve an in-place cipher
-		 * operation, the following  SGL structure is used:
-		 *
-		 * TX SGL: AAD || CT || Tag
-		 *	    |	   |	 ^
-		 *	    | copy |	 | Create SGL link.
-		 *	    v	   v	 |
-		 * RX SGL: AAD || CT ----+
-		 */
-
-		/* Copy AAD || CT to RX SGL buffer for in-place operation. */
-		memcpy_sglist(areq->first_rsgl.sgl.sgt.sgl, tsgl_src, outlen);
-
-		/* Create TX SGL for tag and chain it to RX SGL. */
-		areq->tsgl_entries = af_alg_count_tsgl(sk, processed,
-						       processed - as);
-		if (!areq->tsgl_entries)
-			areq->tsgl_entries = 1;
-		areq->tsgl = sock_kmalloc(sk, array_size(sizeof(*areq->tsgl),
-							 areq->tsgl_entries),
-					  GFP_KERNEL);
-		if (!areq->tsgl) {
-			err = -ENOMEM;
-			goto free;
-		}
-		sg_init_table(areq->tsgl, areq->tsgl_entries);
-
-		/* Release TX SGL, except for tag data and reassign tag data. */
-		af_alg_pull_tsgl(sk, processed, areq->tsgl, processed - as);
-
-		/* chain the areq TX SGL holding the tag with RX SGL */
-		if (usedpages) {
-			/* RX SGL present */
-			struct af_alg_sgl *sgl_prev = &areq->last_rsgl->sgl;
-			struct scatterlist *sg = sgl_prev->sgt.sgl;
-
-			sg_unmark_end(sg + sgl_prev->sgt.nents - 1);
-			sg_chain(sg, sgl_prev->sgt.nents + 1, areq->tsgl);
-		} else
-			/* no RX SGL present (e.g. authentication only) */
-			rsgl_src = areq->tsgl;
-	}
+	memcpy_sglist(rsgl_src, tsgl_src, ctx->aead_assoclen);
 
 	/* Initialize the crypto operation */
-	aead_request_set_crypt(&areq->cra_u.aead_req, rsgl_src,
+	aead_request_set_crypt(&areq->cra_u.aead_req, tsgl_src,
 			       areq->first_rsgl.sgl.sgt.sgl, used, ctx->iv);
 	aead_request_set_ad(&areq->cra_u.aead_req, ctx->aead_assoclen);
 	aead_request_set_tfm(&areq->cra_u.aead_req, tfm);
@@ -450,7 +388,7 @@ static void aead_sock_destruct(struct sock *sk)
 	struct crypto_aead *tfm = pask->private;
 	unsigned int ivlen = crypto_aead_ivsize(tfm);
 
-	af_alg_pull_tsgl(sk, ctx->used, NULL, 0);
+	af_alg_pull_tsgl(sk, ctx->used, NULL);
 	sock_kzfree_s(sk, ctx->iv, ivlen);
 	sock_kfree_s(sk, ctx, ctx->len);
 	af_alg_release_parent(sk);
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 125d395c5e00..82735e51be10 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -138,7 +138,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	 * Create a per request TX SGL for this request which tracks the
 	 * SG entries from the global TX SGL.
 	 */
-	areq->tsgl_entries = af_alg_count_tsgl(sk, len, 0);
+	areq->tsgl_entries = af_alg_count_tsgl(sk, len);
 	if (!areq->tsgl_entries)
 		areq->tsgl_entries = 1;
 	areq->tsgl = sock_kmalloc(sk, array_size(sizeof(*areq->tsgl),
@@ -149,7 +149,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 		goto free;
 	}
 	sg_init_table(areq->tsgl, areq->tsgl_entries);
-	af_alg_pull_tsgl(sk, len, areq->tsgl, 0);
+	af_alg_pull_tsgl(sk, len, areq->tsgl);
 
 	/* Initialize the crypto operation */
 	skcipher_request_set_tfm(&areq->cra_u.skcipher_req, tfm);
@@ -363,7 +363,7 @@ static void skcipher_sock_destruct(struct sock *sk)
 	struct alg_sock *pask = alg_sk(psk);
 	struct crypto_skcipher *tfm = pask->private;
 
-	af_alg_pull_tsgl(sk, ctx->used, NULL, 0);
+	af_alg_pull_tsgl(sk, ctx->used, NULL);
 	sock_kzfree_s(sk, ctx->iv, crypto_skcipher_ivsize(tfm));
 	if (ctx->state)
 		sock_kzfree_s(sk, ctx->state, crypto_skcipher_statesize(tfm));
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 107b797c33ec..0cc8fa749f68 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -230,9 +230,8 @@ static inline bool af_alg_readable(struct sock *sk)
 	return PAGE_SIZE <= af_alg_rcvbuf(sk);
 }
 
-unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes, size_t offset);
-void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
-		      size_t dst_offset);
+unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes);
+void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst);
 void af_alg_wmem_wakeup(struct sock *sk);
 int af_alg_wait_for_data(struct sock *sk, unsigned flags, unsigned min);
 int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
