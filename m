Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F36718C006
	for <linux-crypto@vger.kernel.org>; Mon, 27 Jan 2025 21:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738012605; cv=none; b=HQiHBVOJZ2apsp84HrC4V6pIBZEYV5bjQLjcq375bcSKyOI6DPlEriE2qzJTOL9hcS6UvBOaeOZMBUPNVHXnUPBfPSmCXTfGpE3p4xUeIw9uA747xvWBcX/CNwXjK36vMQd6Y/UDBqvfkfv4AxZSDAgvEnoG0NnpUnl7lL88d2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738012605; c=relaxed/simple;
	bh=mBBcVbU4wfK/UiN1No0h6Kb2pRN1QEsQpk1bNAcMs/U=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=dnjLN4dv6Y53dGLnnqBIYuJKEnV8fyRJA3UM5ummVQOLyoS93tDDOngHTSTMgsTe9LKdW8EwWMvfLtN+WasYnbD5Si08wbbRKF4dFsnUjipviVLC3Z+ET80a5dNDToJI7fQHD4gw8PEJ06ls27g/KPf7pt5ko3OAbSSqB8Ju//w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SZN6py2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SZN6py2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D69C4CED2
	for <linux-crypto@vger.kernel.org>; Mon, 27 Jan 2025 21:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738012604;
	bh=mBBcVbU4wfK/UiN1No0h6Kb2pRN1QEsQpk1bNAcMs/U=;
	h=From:To:Subject:Date:From;
	b=SZN6py2s6fe4bsEsnydD3AmjL2dm6PMSM39Fxt5yo2PTdyB8ef32f7Z/kloifrrRM
	 nd+ldogUbmr2G+3IFWGmBw7flOx/OCsbLWqT/eX7DO8slvYMgzLPibCOH4iA16KNrx
	 prb/DQPVXn4leUNS4D6vxwZ2r5DFyPmgyos85J1fm/xLkrOpfeJdJREw9HCM+dTVFB
	 YM/oYM5Oz75u/CpjQu62n/UTbIH0nECKUFBoxMxRNezUdFzhXkmrHciWsCZyevrb4i
	 cupWZprUIlPr2/R0uhUDLEW9RSmheCevGEAp5cKEtF31UPy5O2XFViInhIeT8zBB1M
	 CRrGRTbMhTTXg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: x86/aes-xts - make the fast path 64-bit specific
Date: Mon, 27 Jan 2025 13:16:09 -0800
Message-ID: <20250127211609.43938-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Remove 32-bit support from the fast path in xts_crypt().  Then optimize
it for 64-bit, and simplify the code, by switching to sg_virt() and
removing the now-unnecessary checks for crossing a page boundary.

The result is simpler code that is slightly smaller and faster in the
case that actually matters (64-bit).

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 11e95fc62636e..3e0cc15050f32 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -579,39 +579,29 @@ static __always_inline int
 xts_crypt(struct skcipher_request *req, xts_encrypt_iv_func encrypt_iv,
 	  xts_crypt_func crypt_func)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	const struct aesni_xts_ctx *ctx = aes_xts_ctx(tfm);
-	const unsigned int cryptlen = req->cryptlen;
-	struct scatterlist *src = req->src;
-	struct scatterlist *dst = req->dst;
 
-	if (unlikely(cryptlen < AES_BLOCK_SIZE))
+	if (unlikely(req->cryptlen < AES_BLOCK_SIZE))
 		return -EINVAL;
 
 	kernel_fpu_begin();
 	(*encrypt_iv)(&ctx->tweak_ctx, req->iv);
 
 	/*
 	 * In practice, virtually all XTS plaintexts and ciphertexts are either
-	 * 512 or 4096 bytes, aligned such that they don't span page boundaries.
-	 * To optimize the performance of these cases, and also any other case
-	 * where no page boundary is spanned, the below fast-path handles
-	 * single-page sources and destinations as efficiently as possible.
+	 * 512 or 4096 bytes and do not use multiple scatterlist elements.  To
+	 * optimize the performance of these cases, the below fast-path handles
+	 * single-scatterlist-element messages as efficiently as possible.  The
+	 * code is 64-bit specific, as it assumes no page mapping is needed.
 	 */
-	if (likely(src->length >= cryptlen && dst->length >= cryptlen &&
-		   src->offset + cryptlen <= PAGE_SIZE &&
-		   dst->offset + cryptlen <= PAGE_SIZE)) {
-		struct page *src_page = sg_page(src);
-		struct page *dst_page = sg_page(dst);
-		void *src_virt = kmap_local_page(src_page) + src->offset;
-		void *dst_virt = kmap_local_page(dst_page) + dst->offset;
-
-		(*crypt_func)(&ctx->crypt_ctx, src_virt, dst_virt, cryptlen,
-			      req->iv);
-		kunmap_local(dst_virt);
-		kunmap_local(src_virt);
+	if (IS_ENABLED(CONFIG_X86_64) &&
+	    likely(req->src->length >= req->cryptlen &&
+		   req->dst->length >= req->cryptlen)) {
+		(*crypt_func)(&ctx->crypt_ctx, sg_virt(req->src),
+			      sg_virt(req->dst), req->cryptlen, req->iv);
 		kernel_fpu_end();
 		return 0;
 	}
 	kernel_fpu_end();
 	return xts_crypt_slowpath(req, crypt_func);

base-commit: 805ba04cb7ccfc7d72e834ebd796e043142156ba
-- 
2.48.1

