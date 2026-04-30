Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980A9377ED4;
	Thu, 30 Apr 2026 06:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777530583; cv=none; b=f+zRCyvGKrPPdq2/C6yHContfubHaMAq+iwu29vxlpLk+pu84spth2i8RuEoflD5lqjwa1Zyka1YgGvPH5Q8eIv80h2ahnBv2nrtPXnGGr+RD8ANS1/1MsRJ9fRX/3+LcT8dh03VUuAhCasmPRuQ8TfAjpzWmyFoKeh0a1xeEY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777530583; c=relaxed/simple;
	bh=ASYV1Ii65x+WmzwYMDYjn4qFhbPK93vv+OExqn3z7q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qVsohB2dSCMFatAJNL5BE0uE4r5ZZYn7+vgPwoSH1eKkZ6hg9Lwl0tTLftTCfXWpbpZeoNea8Kx0DzPQeF53krIbtF3pWsHTkdhbCFIaLQHxk+PBT3R0NqGugOZaRlWsSbxPWMTgoLa4rhwB4sAFFWudboguWcmBvHYriCo7EpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sjVBfH3C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sjVBfH3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF793C2BCB8;
	Thu, 30 Apr 2026 06:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777530583;
	bh=ASYV1Ii65x+WmzwYMDYjn4qFhbPK93vv+OExqn3z7q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sjVBfH3CHXrlGvfvIj6l1zGfETbDgAPclKi0ffVIXfrGXLgbrLJGGJrZUQzhieSU4
	 LlFLeYSvQZvS8/Mgqn1j9XlTaieJPywGkAbTXonY8DdgfLcSlLMc9kUJOTyKkDBIpO
	 LDUELBCaUnHRgSS2fNR/E0UqLt/OCP7jpSxNnFd9v6LBta3Y0Tbwf3MXwPTfVWF9kY
	 cG7Le+uUFfiQJsy7Z4A5gQYG/GoZ9mNOjJrT/mTFLYjR9dBV+iIjGYcg/ovJ9HlKXv
	 IgOvIBPsMCdgKVViABxY2/7gn/sSrdGtmEx9D1GzVKZO8YVk/1OmRRpN60QjZRgEFE
	 EvF/6n3pvFVmg==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Taeyang Lee <0wn@theori.io>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.1 3/9] crypto: algif_aead - Revert to operating out-of-place
Date: Wed, 29 Apr 2026 23:27:25 -0700
Message-ID: <20260430062731.140497-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430062731.140497-1-ebiggers@kernel.org>
References: <20260430062731.140497-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

commit a664bf3d603dc3bdcf9ae47cc21e0daec706d7a5 upstream.

This mostly reverts commit 72548b093ee3 except for the copying of
the associated data.

There is no benefit in operating in-place in algif_aead since the
source and destination come from different mappings.  Get rid of
all the complexity added for in-place operation and just copy the
AD directly.

Fixes: 72548b093ee3 ("crypto: algif_aead - copy AAD from src to dst")
Reported-by: Taeyang Lee <0wn@theori.io>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/af_alg.c         | 49 +++++---------------
 crypto/algif_aead.c     | 99 ++++++++---------------------------------
 crypto/algif_skcipher.c |  6 +--
 include/crypto/if_alg.h |  5 +--
 4 files changed, 34 insertions(+), 125 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 1bb0ab702c98..edf13ab8bf37 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -524,19 +524,17 @@ static int af_alg_alloc_tsgl(struct sock *sk)
 }
 
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
 	const struct af_alg_tsgl *sgl;
 	unsigned int i;
@@ -547,29 +545,15 @@ unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes, size_t offset)
 
 	list_for_each_entry(sgl, &ctx->tsgl_list, list) {
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
 
 	return sgl_count;
 }
@@ -577,23 +561,18 @@ EXPORT_SYMBOL_GPL(af_alg_count_tsgl);
 
 /**
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
 	struct af_alg_tsgl *sgl;
 	struct scatterlist *sg;
@@ -614,22 +593,14 @@ void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
 			/*
 			 * Assumption: caller created af_alg_count_tsgl(len)
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
 			sg[i].offset += plen;
 
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 38a4ab8c90c7..f59728c021fc 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -24,11 +24,10 @@
  */
 
 #include <crypto/internal/aead.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/if_alg.h>
-#include <crypto/skcipher.h>
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/module.h>
@@ -70,13 +69,12 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	struct alg_sock *ask = alg_sk(sk);
 	struct sock *psk = ask->parent;
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
 	size_t outlen = 0;		/* [out] RX bufs produced by kernel */
 	size_t usedpages = 0;		/* [in]  RX bufs to be used from user */
@@ -152,104 +150,45 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 		}
 		used -= less;
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
 	 *
 	 * The AAD is copied to the destination buffer without change. Even
 	 * when user space uses an in-place cipher operation, the kernel
 	 * will copy the data as it does not see whether such in-place operation
 	 * is initiated.
-	 *
-	 * To ensure efficiency, the following implementation ensure that the
-	 * ciphers are invoked to perform a crypto operation in-place. This
-	 * is achieved by memory management specified as follows.
 	 */
 
 	/* Use the RX SGL as source (and destination) for crypto op. */
 	rsgl_src = areq->first_rsgl.sgl.sg;
 
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
-		memcpy_sglist(areq->first_rsgl.sgl.sg, tsgl_src, processed);
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
-		memcpy_sglist(areq->first_rsgl.sgl.sg, tsgl_src, outlen);
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
-
-			sg_unmark_end(sgl_prev->sg + sgl_prev->npages - 1);
-			sg_chain(sgl_prev->sg, sgl_prev->npages + 1,
-				 areq->tsgl);
-		} else
-			/* no RX SGL present (e.g. authentication only) */
-			rsgl_src = areq->tsgl;
-	}
+	memcpy_sglist(rsgl_src, tsgl_src, ctx->aead_assoclen);
 
 	/* Initialize the crypto operation */
-	aead_request_set_crypt(&areq->cra_u.aead_req, rsgl_src,
+	aead_request_set_crypt(&areq->cra_u.aead_req, tsgl_src,
 			       areq->first_rsgl.sgl.sg, used, ctx->iv);
 	aead_request_set_ad(&areq->cra_u.aead_req, ctx->aead_assoclen);
 	aead_request_set_tfm(&areq->cra_u.aead_req, tfm);
 
 	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) {
@@ -461,11 +400,11 @@ static void aead_sock_destruct(struct sock *sk)
 	struct sock *psk = ask->parent;
 	struct alg_sock *pask = alg_sk(psk);
 	struct crypto_aead *tfm = pask->private;
 	unsigned int ivlen = crypto_aead_ivsize(tfm);
 
-	af_alg_pull_tsgl(sk, ctx->used, NULL, 0);
+	af_alg_pull_tsgl(sk, ctx->used, NULL);
 	sock_kzfree_s(sk, ctx->iv, ivlen);
 	sock_kfree_s(sk, ctx, ctx->len);
 	af_alg_release_parent(sk);
 }
 
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index ee8890ee8f33..8b314260929f 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -87,22 +87,22 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 
 	/*
 	 * Create a per request TX SGL for this request which tracks the
 	 * SG entries from the global TX SGL.
 	 */
-	areq->tsgl_entries = af_alg_count_tsgl(sk, len, 0);
+	areq->tsgl_entries = af_alg_count_tsgl(sk, len);
 	if (!areq->tsgl_entries)
 		areq->tsgl_entries = 1;
 	areq->tsgl = sock_kmalloc(sk, array_size(sizeof(*areq->tsgl),
 						 areq->tsgl_entries),
 				  GFP_KERNEL);
 	if (!areq->tsgl) {
 		err = -ENOMEM;
 		goto free;
 	}
 	sg_init_table(areq->tsgl, areq->tsgl_entries);
-	af_alg_pull_tsgl(sk, len, areq->tsgl, 0);
+	af_alg_pull_tsgl(sk, len, areq->tsgl);
 
 	/* Initialize the crypto operation */
 	skcipher_request_set_tfm(&areq->cra_u.skcipher_req, tfm);
 	skcipher_request_set_crypt(&areq->cra_u.skcipher_req, areq->tsgl,
 				   areq->first_rsgl.sgl.sg, len, ctx->iv);
@@ -311,11 +311,11 @@ static void skcipher_sock_destruct(struct sock *sk)
 	struct af_alg_ctx *ctx = ask->private;
 	struct sock *psk = ask->parent;
 	struct alg_sock *pask = alg_sk(psk);
 	struct crypto_skcipher *tfm = pask->private;
 
-	af_alg_pull_tsgl(sk, ctx->used, NULL, 0);
+	af_alg_pull_tsgl(sk, ctx->used, NULL);
 	sock_kzfree_s(sk, ctx->iv, crypto_skcipher_ivsize(tfm));
 	sock_kfree_s(sk, ctx, ctx->len);
 	af_alg_release_parent(sk);
 }
 
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 9af84cad92e9..bc23cd65879b 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -228,13 +228,12 @@ static inline int af_alg_rcvbuf(struct sock *sk)
 static inline bool af_alg_readable(struct sock *sk)
 {
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
 		   unsigned int ivsize);
 ssize_t af_alg_sendpage(struct socket *sock, struct page *page,
-- 
2.54.0

