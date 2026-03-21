Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1247C34EEFC;
	Sat, 21 Mar 2026 04:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774066323; cv=none; b=bMLGg++sXEPkvauc4V7SwHcIRKtU2pq8zH/bt1XRVg7odB1Y4hajPE4+zwH4FWAAGURp+6g2MTK59O8+tQucATAd8dATQOgmfmYH9p7YaMRIxgobhUnnTKTtftBtOeX3qS6sz3n42rfSnOXbpEf4NdRqSGIdksRlU8xOZu2guqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774066323; c=relaxed/simple;
	bh=aPexQl25sVpfd7KJG7INV55g5JGQD/xd4wrqdkbZ9eU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SH9qIEP5abRBRNt1SPOtlKBcEj7qipe5kOeqIK9b6UjpS00uIKqyl44KiN7BqNr/iE1hluzpcdlG5Dhqh9lg6t79eAweOEayx9VmOMRRkMDS6SO55IYddiFiXBXJnvQtcIK5SQnt7eu1iHXTFOnHOOMvH+kaffe7bKUTuHdotao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IODjViXx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IODjViXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9262BC19421;
	Sat, 21 Mar 2026 04:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774066322;
	bh=aPexQl25sVpfd7KJG7INV55g5JGQD/xd4wrqdkbZ9eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IODjViXxp/PXolRvvTJOaPuZ4v3pS6wk/V5GOneRwdFYZJttusDpllhUTpsS12qkn
	 ds01YusVFrDi7lLx5E1+gYG8y2OJ2BlHy0HQPt/1LeFJhVZYB8yUNpz18Ly5Noe0Sw
	 HASZd5+U4IC55Na4SL3ZzTrGD5B+6BKJU8qzkFsIv/n5K0LE6qaa28kX+K2R8kcDeV
	 10jjL4DtuvyjyJgfWI6JKFv08EhdZ+DWYnESx+rkykN9rI4uvmYcS4GpuBeWOhpjnE
	 jGyL1pEy2WS+QBhWeR7ue0vxVxpMpHekJ/2UgJ47yUUjyX7v6vHuGb9wn3BReMxRWt
	 /gLljYo/oHc6g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 11/12] crypto: sm3 - Remove the original "sm3_block_generic()"
Date: Fri, 20 Mar 2026 21:09:34 -0700
Message-ID: <20260321040935.410034-12-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321040935.410034-1-ebiggers@kernel.org>
References: <20260321040935.410034-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the architecture-optimized SM3 code was migrated into lib/crypto/,
sm3_block_generic() is no longer called.  Remove it.  Then, since this
frees up the name, rename sm3_transform() to sm3_block_generic()
(matching the naming convention used in other hash algorithms).

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/sm3.h |  2 --
 lib/crypto/sm3.c     | 19 +++----------------
 2 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/include/crypto/sm3.h b/include/crypto/sm3.h
index 702c5326b4be..34d7eb32b7db 100644
--- a/include/crypto/sm3.h
+++ b/include/crypto/sm3.h
@@ -29,12 +29,10 @@ struct sm3_state {
 	u32 state[SM3_DIGEST_SIZE / 4];
 	u64 count;
 	u8 buffer[SM3_BLOCK_SIZE];
 };
 
-void sm3_block_generic(struct sm3_state *sctx, u8 const *data, int blocks);
-
 /* State for the SM3 compression function */
 struct sm3_block_state {
 	u32 h[SM3_DIGEST_SIZE / 4];
 };
 
diff --git a/lib/crypto/sm3.c b/lib/crypto/sm3.c
index 20500cf4b8c0..b02b8a247adf 100644
--- a/lib/crypto/sm3.c
+++ b/lib/crypto/sm3.c
@@ -77,12 +77,12 @@ static const u32 ____cacheline_aligned K[64] = {
 			^ W[(i-9) & 0x0f]		\
 			^ rol32(W[(i-3) & 0x0f], 15))	\
 		^ rol32(W[(i-13) & 0x0f], 7)		\
 		^ W[(i-6) & 0x0f])
 
-static void sm3_transform(struct sm3_block_state *state,
-			  const u8 data[SM3_BLOCK_SIZE], u32 W[16])
+static void sm3_block_generic(struct sm3_block_state *state,
+			      const u8 data[SM3_BLOCK_SIZE], u32 W[16])
 {
 	u32 a, b, c, d, e, f, g, h, ss1, ss2;
 
 	a = state->h[0];
 	b = state->h[1];
@@ -175,30 +175,17 @@ static void sm3_transform(struct sm3_block_state *state,
 #undef R2
 #undef I
 #undef W1
 #undef W2
 
-void sm3_block_generic(struct sm3_state *sctx, u8 const *data, int blocks)
-{
-	u32 W[16];
-
-	do {
-		sm3_transform((struct sm3_block_state *)sctx->state, data, W);
-		data += SM3_BLOCK_SIZE;
-	} while (--blocks);
-
-	memzero_explicit(W, sizeof(W));
-}
-EXPORT_SYMBOL_GPL(sm3_block_generic);
-
 static void __maybe_unused sm3_blocks_generic(struct sm3_block_state *state,
 					      const u8 *data, size_t nblocks)
 {
 	u32 W[16];
 
 	do {
-		sm3_transform(state, data, W);
+		sm3_block_generic(state, data, W);
 		data += SM3_BLOCK_SIZE;
 	} while (--nblocks);
 
 	memzero_explicit(W, sizeof(W));
 }
-- 
2.53.0

