Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7864215F6D;
	Wed, 19 Feb 2025 18:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739989470; cv=none; b=aYt8CCpid1M0ntSwBKYGxOuO0uXURumwESaAh2B8RT+6t9HmfYQQbdD0a0/fuf5BU7hkRJhdFGjTpIICWAgxhUAtqh8A11kS3d3OzackUUyLFP5FAbddBM7ct5fEKEusjQCTRGj47emRoYE0RZiFVl9Sa0MocIqMEC55Dw+5y6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739989470; c=relaxed/simple;
	bh=IweyEzHVugUZRfF2BC17ceLBJxhhb+nfKN/4JWYuPNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9zc0jIIeweJqcQefjxYF5RPy3f7/pnBTUPxXQCDZMzC/jj9T9oydzApiz39mv9X8QGMECncDLXKpAHoqAINybHsonuur9lueI3UUjGrBPwtPIMjK5bxTqheW44WnOljkF4svr99i+r+fhRpFkSxnW/S3qzYBqHMJIJuNAEl054=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YfocSNg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YfocSNg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACC3C4CEE0;
	Wed, 19 Feb 2025 18:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739989469;
	bh=IweyEzHVugUZRfF2BC17ceLBJxhhb+nfKN/4JWYuPNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YfocSNg/nuCK5LdQF7MglpbQVv42eWvN2zezEudFgrSUsQW4AbTtaROP1eL8CftyQ
	 nsG4zrsleyoIGoU+mFwHuYEGqBzFszKwi37PMutZj9o4uhDjZhZ2NiOv5skkbPqh6q
	 GXgtZl4SCb/ZJRaTj4CpL1Op0hPnK5TYR5P1oa/xrhCXGQzDWAnv+Nt8Mvqd1/Rmaw
	 CxPlSwUc6yZeIhrS/5BywE0/UQOB02wDVQ240Jy7YiscmC/P2jg0Adj7GmqyeopAbD
	 92YYQovjY2HnoD4jc9842Bay59Xx3GwSH4xFmBKocxfSGVTHlnpZLuJJtFcxiZ0Gay
	 sAGAlwX0Vhstw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Naveen N Rao <naveen@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 10/19] crypto: nx - use the new scatterwalk functions
Date: Wed, 19 Feb 2025 10:23:32 -0800
Message-ID: <20250219182341.43961-11-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219182341.43961-1-ebiggers@kernel.org>
References: <20250219182341.43961-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

- In nx_walk_and_build(), use scatterwalk_start_at_pos() instead of a
  more complex way to achieve the same result.

- Also in nx_walk_and_build(), use the new functions scatterwalk_next()
  which consolidates scatterwalk_clamp() and scatterwalk_map(), and use
  scatterwalk_done_src() which consolidates scatterwalk_unmap(),
  scatterwalk_advance(), and scatterwalk_done().  Remove unnecessary
  code that seemed to be intended to advance to the next sg entry, which
  is already handled by the scatterwalk functions.

  Note that nx_walk_and_build() does not actually read or write the
  mapped virtual address, and thus it is misusing the scatter_walk API.
  It really should just access the scatterlist directly.  This patch
  does not try to address this existing issue.

- In nx_gca(), use memcpy_from_sglist() instead of a more complex way to
  achieve the same result.

- In various functions, replace calls to scatterwalk_map_and_copy() with
  memcpy_from_sglist() or memcpy_to_sglist() as appropriate.  Note that
  this eliminates the confusing 'out' argument (which this driver had
  tried to work around by defining the missing constants for it...)

Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/nx/nx-aes-ccm.c | 16 ++++++----------
 drivers/crypto/nx/nx-aes-gcm.c | 17 ++++++-----------
 drivers/crypto/nx/nx.c         | 31 +++++--------------------------
 drivers/crypto/nx/nx.h         |  3 ---
 4 files changed, 17 insertions(+), 50 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-ccm.c b/drivers/crypto/nx/nx-aes-ccm.c
index c843f4c6f684d..56a0b3a67c330 100644
--- a/drivers/crypto/nx/nx-aes-ccm.c
+++ b/drivers/crypto/nx/nx-aes-ccm.c
@@ -215,17 +215,15 @@ static int generate_pat(u8                   *iv,
 	 */
 	if (b1) {
 		memset(b1, 0, 16);
 		if (assoclen <= 65280) {
 			*(u16 *)b1 = assoclen;
-			scatterwalk_map_and_copy(b1 + 2, req->src, 0,
-					 iauth_len, SCATTERWALK_FROM_SG);
+			memcpy_from_sglist(b1 + 2, req->src, 0, iauth_len);
 		} else {
 			*(u16 *)b1 = (u16)(0xfffe);
 			*(u32 *)&b1[2] = assoclen;
-			scatterwalk_map_and_copy(b1 + 6, req->src, 0,
-					 iauth_len, SCATTERWALK_FROM_SG);
+			memcpy_from_sglist(b1 + 6, req->src, 0, iauth_len);
 		}
 	}
 
 	/* now copy any remaining AAD to scatterlist and call nx... */
 	if (!assoclen) {
@@ -339,13 +337,12 @@ static int ccm_nx_decrypt(struct aead_request   *req,
 	spin_lock_irqsave(&nx_ctx->lock, irq_flags);
 
 	nbytes -= authsize;
 
 	/* copy out the auth tag to compare with later */
-	scatterwalk_map_and_copy(priv->oauth_tag,
-				 req->src, nbytes + req->assoclen, authsize,
-				 SCATTERWALK_FROM_SG);
+	memcpy_from_sglist(priv->oauth_tag, req->src, nbytes + req->assoclen,
+			   authsize);
 
 	rc = generate_pat(iv, req, nx_ctx, authsize, nbytes, assoclen,
 			  csbcpb->cpb.aes_ccm.in_pat_or_b0);
 	if (rc)
 		goto out;
@@ -463,13 +460,12 @@ static int ccm_nx_encrypt(struct aead_request   *req,
 		processed += to_process;
 
 	} while (processed < nbytes);
 
 	/* copy out the auth tag */
-	scatterwalk_map_and_copy(csbcpb->cpb.aes_ccm.out_pat_or_mac,
-				 req->dst, nbytes + req->assoclen, authsize,
-				 SCATTERWALK_TO_SG);
+	memcpy_to_sglist(req->dst, nbytes + req->assoclen,
+			 csbcpb->cpb.aes_ccm.out_pat_or_mac, authsize);
 
 out:
 	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
 	return rc;
 }
diff --git a/drivers/crypto/nx/nx-aes-gcm.c b/drivers/crypto/nx/nx-aes-gcm.c
index 4a796318b4306..b7fe2de96d962 100644
--- a/drivers/crypto/nx/nx-aes-gcm.c
+++ b/drivers/crypto/nx/nx-aes-gcm.c
@@ -101,20 +101,17 @@ static int nx_gca(struct nx_crypto_ctx  *nx_ctx,
 		  u8                    *out,
 		  unsigned int assoclen)
 {
 	int rc;
 	struct nx_csbcpb *csbcpb_aead = nx_ctx->csbcpb_aead;
-	struct scatter_walk walk;
 	struct nx_sg *nx_sg = nx_ctx->in_sg;
 	unsigned int nbytes = assoclen;
 	unsigned int processed = 0, to_process;
 	unsigned int max_sg_len;
 
 	if (nbytes <= AES_BLOCK_SIZE) {
-		scatterwalk_start(&walk, req->src);
-		scatterwalk_copychunks(out, &walk, nbytes, SCATTERWALK_FROM_SG);
-		scatterwalk_done(&walk, SCATTERWALK_FROM_SG, 0);
+		memcpy_from_sglist(out, req->src, 0, nbytes);
 		return 0;
 	}
 
 	NX_CPB_FDM(csbcpb_aead) &= ~NX_FDM_CONTINUATION;
 
@@ -389,23 +386,21 @@ static int gcm_aes_nx_crypt(struct aead_request *req, int enc,
 	} while (processed < nbytes);
 
 mac:
 	if (enc) {
 		/* copy out the auth tag */
-		scatterwalk_map_and_copy(
-			csbcpb->cpb.aes_gcm.out_pat_or_mac,
+		memcpy_to_sglist(
 			req->dst, req->assoclen + nbytes,
-			crypto_aead_authsize(crypto_aead_reqtfm(req)),
-			SCATTERWALK_TO_SG);
+			csbcpb->cpb.aes_gcm.out_pat_or_mac,
+			crypto_aead_authsize(crypto_aead_reqtfm(req)));
 	} else {
 		u8 *itag = nx_ctx->priv.gcm.iauth_tag;
 		u8 *otag = csbcpb->cpb.aes_gcm.out_pat_or_mac;
 
-		scatterwalk_map_and_copy(
+		memcpy_from_sglist(
 			itag, req->src, req->assoclen + nbytes,
-			crypto_aead_authsize(crypto_aead_reqtfm(req)),
-			SCATTERWALK_FROM_SG);
+			crypto_aead_authsize(crypto_aead_reqtfm(req)));
 		rc = crypto_memneq(itag, otag,
 			    crypto_aead_authsize(crypto_aead_reqtfm(req))) ?
 		     -EBADMSG : 0;
 	}
 out:
diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index 010e87d9da36b..dd95e5361d88c 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -151,44 +151,23 @@ struct nx_sg *nx_walk_and_build(struct nx_sg       *nx_dst,
 				unsigned int        start,
 				unsigned int       *src_len)
 {
 	struct scatter_walk walk;
 	struct nx_sg *nx_sg = nx_dst;
-	unsigned int n, offset = 0, len = *src_len;
+	unsigned int n, len = *src_len;
 	char *dst;
 
 	/* we need to fast forward through @start bytes first */
-	for (;;) {
-		scatterwalk_start(&walk, sg_src);
-
-		if (start < offset + sg_src->length)
-			break;
-
-		offset += sg_src->length;
-		sg_src = sg_next(sg_src);
-	}
-
-	/* start - offset is the number of bytes to advance in the scatterlist
-	 * element we're currently looking at */
-	scatterwalk_advance(&walk, start - offset);
+	scatterwalk_start_at_pos(&walk, sg_src, start);
 
 	while (len && (nx_sg - nx_dst) < sglen) {
-		n = scatterwalk_clamp(&walk, len);
-		if (!n) {
-			/* In cases where we have scatterlist chain sg_next
-			 * handles with it properly */
-			scatterwalk_start(&walk, sg_next(walk.sg));
-			n = scatterwalk_clamp(&walk, len);
-		}
-		dst = scatterwalk_map(&walk);
+		dst = scatterwalk_next(&walk, len, &n);
 
 		nx_sg = nx_build_sg_list(nx_sg, dst, &n, sglen - (nx_sg - nx_dst));
-		len -= n;
 
-		scatterwalk_unmap(dst);
-		scatterwalk_advance(&walk, n);
-		scatterwalk_done(&walk, SCATTERWALK_FROM_SG, len);
+		scatterwalk_done_src(&walk, dst, n);
+		len -= n;
 	}
 	/* update to_process */
 	*src_len -= len;
 
 	/* return the moved destination pointer */
diff --git a/drivers/crypto/nx/nx.h b/drivers/crypto/nx/nx.h
index 2697baebb6a35..e1b4b6927bec3 100644
--- a/drivers/crypto/nx/nx.h
+++ b/drivers/crypto/nx/nx.h
@@ -187,9 +187,6 @@ extern struct shash_alg nx_shash_aes_xcbc_alg;
 extern struct shash_alg nx_shash_sha512_alg;
 extern struct shash_alg nx_shash_sha256_alg;
 
 extern struct nx_crypto_driver nx_driver;
 
-#define SCATTERWALK_TO_SG	1
-#define SCATTERWALK_FROM_SG	0
-
 #endif
-- 
2.48.1

