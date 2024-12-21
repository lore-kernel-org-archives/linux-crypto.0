Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBE51F2379
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734772294; cv=none; b=X/4LSy++BGesHsgAfJx0RrQWHkpmnecsS0VI9EmRMS8MfKH5z/8xDifv2/Zo2H6Apo9JIzzdRhC1l1d0b3XdwsWJqUG5iCtKQWVBXP4u3uCPankSHi7CvwQ5r++84MgHf6sKKUviO58Ct8rV7/1HC34DQq7mYfH5TjUNYJ3zohE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734772294; c=relaxed/simple;
	bh=mSW8mWLKgO+z9pqafkyRDJs4ecTLipklsIRH/V4AmPg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=doLJgFhTqSieiMVIeC6GEB9PNZKF7+zomUprUufXZ+YPvbKPEa0B1cW4dgl7W2MdJ4MWyg4n+WPsKoucIs78bN+FfYl+DDpYEh3HMwI8j4091vT8arc/RLitU8mGjRCNaxPxsp3cr52fshfA1Qone6G94QyDlW5bqtUME0iUH6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FqIHPQpO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FqIHPQpO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59390C4CED7
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734772294;
	bh=mSW8mWLKgO+z9pqafkyRDJs4ecTLipklsIRH/V4AmPg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FqIHPQpOXLPHJLxvBjN1aw3o4x+3607L406ANER6Rb1YI3jotUQBzQ1i3YWpJ0Zk0
	 gqhCdEET+cM+WL2HcxiZvu2+Y1UDxF141qAJMCEfhOlXJJ7kqnoNCz2C3hZQ3Fp5Ax
	 G8B+uvtvUMVqu6itRVEzLrQHg0C/IqoJKoCRPc8XbcmhHW2w33NQg853MvysydSIfz
	 BhMimxGfYhwlbg4wzqAHyl68VaUEHgo2X/nJ00yEDVqAxtGHZLarmdh0nGlNmulIGY
	 Om90T8Lb/jpjQEPIDzIdj7CiJna6vGTmG3OAbzhNajCL+Pj/NVeePk5Bly6qmdEOGW
	 37yK++XQJEO/g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 18/29] crypto: arm64 - use the new scatterwalk functions
Date: Sat, 21 Dec 2024 01:10:45 -0800
Message-ID: <20241221091056.282098-19-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241221091056.282098-1-ebiggers@kernel.org>
References: <20241221091056.282098-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Use scatterwalk_next() which consolidates scatterwalk_clamp() and
scatterwalk_map(), and use scatterwalk_done_src() which consolidates
scatterwalk_unmap(), scatterwalk_advance(), and scatterwalk_done().
Remove unnecessary code that seemed to be intended to advance to the
next sg entry, which is already handled by the scatterwalk functions.
Adjust variable naming slightly to keep things consistent.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/aes-ce-ccm-glue.c | 17 ++++------------
 arch/arm64/crypto/ghash-ce-glue.c   | 16 ++++-----------
 arch/arm64/crypto/sm4-ce-ccm-glue.c | 27 ++++++++++---------------
 arch/arm64/crypto/sm4-ce-gcm-glue.c | 31 ++++++++++++-----------------
 4 files changed, 32 insertions(+), 59 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index a2b5d6f20f4d..1c29546983bf 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -154,27 +154,18 @@ static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
 	macp = ce_aes_ccm_auth_data(mac, (u8 *)&ltag, ltag.len, macp,
 				    ctx->key_enc, num_rounds(ctx));
 	scatterwalk_start(&walk, req->src);
 
 	do {
-		u32 n = scatterwalk_clamp(&walk, len);
-		u8 *p;
-
-		if (!n) {
-			scatterwalk_start(&walk, sg_next(walk.sg));
-			n = scatterwalk_clamp(&walk, len);
-		}
-		p = scatterwalk_map(&walk);
+		unsigned int n;
+		const u8 *p;
 
+		p = scatterwalk_next(&walk, len, &n);
 		macp = ce_aes_ccm_auth_data(mac, p, n, macp, ctx->key_enc,
 					    num_rounds(ctx));
-
+		scatterwalk_done_src(&walk, p, n);
 		len -= n;
-
-		scatterwalk_unmap(p);
-		scatterwalk_advance(&walk, n);
-		scatterwalk_done(&walk, 0, len);
 	} while (len);
 }
 
 static int ccm_encrypt(struct aead_request *req)
 {
diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index da7b7ec1a664..69d4fb78c30d 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -306,25 +306,17 @@ static void gcm_calculate_auth_mac(struct aead_request *req, u64 dg[], u32 len)
 	int buf_count = 0;
 
 	scatterwalk_start(&walk, req->src);
 
 	do {
-		u32 n = scatterwalk_clamp(&walk, len);
-		u8 *p;
-
-		if (!n) {
-			scatterwalk_start(&walk, sg_next(walk.sg));
-			n = scatterwalk_clamp(&walk, len);
-		}
-		p = scatterwalk_map(&walk);
+		unsigned int n;
+		const u8 *p;
 
+		p = scatterwalk_next(&walk, len, &n);
 		gcm_update_mac(dg, p, n, buf, &buf_count, ctx);
+		scatterwalk_done_src(&walk, p, n);
 		len -= n;
-
-		scatterwalk_unmap(p);
-		scatterwalk_advance(&walk, n);
-		scatterwalk_done(&walk, 0, len);
 	} while (len);
 
 	if (buf_count) {
 		memset(&buf[buf_count], 0, GHASH_BLOCK_SIZE - buf_count);
 		ghash_do_simd_update(1, dg, buf, &ctx->ghash_key, NULL,
diff --git a/arch/arm64/crypto/sm4-ce-ccm-glue.c b/arch/arm64/crypto/sm4-ce-ccm-glue.c
index 5e7e17bbec81..119f86eb7cc9 100644
--- a/arch/arm64/crypto/sm4-ce-ccm-glue.c
+++ b/arch/arm64/crypto/sm4-ce-ccm-glue.c
@@ -110,21 +110,16 @@ static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
 	crypto_xor(mac, (const u8 *)&aadlen, len);
 
 	scatterwalk_start(&walk, req->src);
 
 	do {
-		u32 n = scatterwalk_clamp(&walk, assoclen);
-		u8 *p, *ptr;
+		unsigned int n, orig_n;
+		const u8 *p, *orig_p;
 
-		if (!n) {
-			scatterwalk_start(&walk, sg_next(walk.sg));
-			n = scatterwalk_clamp(&walk, assoclen);
-		}
-
-		p = ptr = scatterwalk_map(&walk);
-		assoclen -= n;
-		scatterwalk_advance(&walk, n);
+		orig_p = scatterwalk_next(&walk, assoclen, &orig_n);
+		p = orig_p;
+		n = orig_n;
 
 		while (n > 0) {
 			unsigned int l, nblocks;
 
 			if (len == SM4_BLOCK_SIZE) {
@@ -134,30 +129,30 @@ static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
 
 					len = 0;
 				} else {
 					nblocks = n / SM4_BLOCK_SIZE;
 					sm4_ce_cbcmac_update(ctx->rkey_enc,
-							     mac, ptr, nblocks);
+							     mac, p, nblocks);
 
-					ptr += nblocks * SM4_BLOCK_SIZE;
+					p += nblocks * SM4_BLOCK_SIZE;
 					n %= SM4_BLOCK_SIZE;
 
 					continue;
 				}
 			}
 
 			l = min(n, SM4_BLOCK_SIZE - len);
 			if (l) {
-				crypto_xor(mac + len, ptr, l);
+				crypto_xor(mac + len, p, l);
 				len += l;
-				ptr += l;
+				p += l;
 				n -= l;
 			}
 		}
 
-		scatterwalk_unmap(p);
-		scatterwalk_done(&walk, 0, assoclen);
+		scatterwalk_done_src(&walk, orig_p, orig_n);
+		assoclen -= orig_n;
 	} while (assoclen);
 }
 
 static int ccm_crypt(struct aead_request *req, struct skcipher_walk *walk,
 		     u32 *rkey_enc, u8 mac[],
diff --git a/arch/arm64/crypto/sm4-ce-gcm-glue.c b/arch/arm64/crypto/sm4-ce-gcm-glue.c
index 73bfb6972d3a..2e27d7752d4f 100644
--- a/arch/arm64/crypto/sm4-ce-gcm-glue.c
+++ b/arch/arm64/crypto/sm4-ce-gcm-glue.c
@@ -80,53 +80,48 @@ static void gcm_calculate_auth_mac(struct aead_request *req, u8 ghash[])
 	unsigned int buflen = 0;
 
 	scatterwalk_start(&walk, req->src);
 
 	do {
-		u32 n = scatterwalk_clamp(&walk, assoclen);
-		u8 *p, *ptr;
+		unsigned int n, orig_n;
+		const u8 *p, *orig_p;
 
-		if (!n) {
-			scatterwalk_start(&walk, sg_next(walk.sg));
-			n = scatterwalk_clamp(&walk, assoclen);
-		}
-
-		p = ptr = scatterwalk_map(&walk);
-		assoclen -= n;
-		scatterwalk_advance(&walk, n);
+		orig_p = scatterwalk_next(&walk, assoclen, &orig_n);
+		p = orig_p;
+		n = orig_n;
 
 		if (n + buflen < GHASH_BLOCK_SIZE) {
-			memcpy(&buffer[buflen], ptr, n);
+			memcpy(&buffer[buflen], p, n);
 			buflen += n;
 		} else {
 			unsigned int nblocks;
 
 			if (buflen) {
 				unsigned int l = GHASH_BLOCK_SIZE - buflen;
 
-				memcpy(&buffer[buflen], ptr, l);
-				ptr += l;
+				memcpy(&buffer[buflen], p, l);
+				p += l;
 				n -= l;
 
 				pmull_ghash_update(ctx->ghash_table, ghash,
 						   buffer, 1);
 			}
 
 			nblocks = n / GHASH_BLOCK_SIZE;
 			if (nblocks) {
 				pmull_ghash_update(ctx->ghash_table, ghash,
-						   ptr, nblocks);
-				ptr += nblocks * GHASH_BLOCK_SIZE;
+						   p, nblocks);
+				p += nblocks * GHASH_BLOCK_SIZE;
 			}
 
 			buflen = n % GHASH_BLOCK_SIZE;
 			if (buflen)
-				memcpy(&buffer[0], ptr, buflen);
+				memcpy(&buffer[0], p, buflen);
 		}
 
-		scatterwalk_unmap(p);
-		scatterwalk_done(&walk, 0, assoclen);
+		scatterwalk_done_src(&walk, orig_p, orig_n);
+		assoclen -= orig_n;
 	} while (assoclen);
 
 	/* padding with '0' */
 	if (buflen) {
 		memset(&buffer[buflen], 0, GHASH_BLOCK_SIZE - buflen);
-- 
2.47.1

