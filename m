Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AEC39479D;
	Mon, 20 Apr 2026 06:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667031; cv=none; b=nbJLc/xlX0RNCl0GmXrsk5XEmEYsbrWJFMMOmaroh9kbvv0RMIrvrww3wilnUOS5CoT0udRNjU3SgpwRA0Q/xJbWEDGCM/HT8qEpB66EW5wrgooQJjkYwQBiMcZmnnaqHzsxolnqej/wq1uS73lNj77vM0QKjedicunjPaimZmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667031; c=relaxed/simple;
	bh=pa6SwK8StZ2Ab/1JoqAmWt9nbpuSbITMNoLFBxS8+i8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzQqF+Dc841TDp/mY4RLkKqZgpVo+f933CETvuShSh7lrMT2lMeLWjrzd4Vt6saf6OCcB9ppqYJ867tYTSotLIiTEpJFfPdujqe25m8BAFKsAStDGWt7QP9v9hISKuvQf2XHdcDxFP7gEXNaa1rVUWg0Qug4Wrc2k3nLoxO8avw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LXu8/UKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LXu8/UKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07191C2BCB3;
	Mon, 20 Apr 2026 06:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667031;
	bh=pa6SwK8StZ2Ab/1JoqAmWt9nbpuSbITMNoLFBxS8+i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXu8/UKsrZSf2oz/gX3qNQQyrDo4e3syyveSui29kMC4d75eG5NINzzSnt7sbv4WA
	 nIdwI3oxQ6vA764EAj4kZt9Kvjl72d3g1xyteJ9uvvbs54kVeZVk7qkoU6sRMvQsxp
	 bGuxRlGFXLhFbRvyK6dqwr1dk5KAAf0ea7kW/my7Dd2WBk7DmagydkwCiRTtNWC5OE
	 pzSeaQhZR1xKrg1FgPlBLxmMyKnxnGPAV1Aiae6ZNs5moeBtl3avdqPomW3aAvHwf7
	 dN0J3RvDqA8suFE04KUcjL67/6EIK2+RWfT1NLr+juUz1Vwz3ACIU2iveU0gwZYOCK
	 CF3DmnVEOUpDA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 38/38] crypto: drbg - Clean up loop in drbg_hmac_update()
Date: Sun, 19 Apr 2026 23:34:22 -0700
Message-ID: <20260420063422.324906-39-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420063422.324906-1-ebiggers@kernel.org>
References: <20260420063422.324906-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This loop is a bit hard to read, with the loop counter that's used in
the HMAC being separate from the actual loop counter, which counts
backwards for some reason.  Just replace it with a regular loop.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index b54c807930af..ad7b9577479e 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -135,37 +135,27 @@ struct drbg_state {
 	struct crypto_rng *jent;
 	const u8 *test_entropy;
 	size_t test_entropylen;
 };
 
-enum drbg_prefixes {
-	DRBG_PREFIX0 = 0x00,
-	DRBG_PREFIX1,
-};
-
 /******************************************************************
  * HMAC DRBG functions
  ******************************************************************/
 
 /* update function of HMAC DRBG as defined in 10.1.2.2 */
 static void drbg_hmac_update(struct drbg_state *drbg,
 			     const u8 *data1, size_t data1_len,
 			     const u8 *data2, size_t data2_len)
 {
-	int i = 0;
 	struct hmac_sha512_ctx hmac_ctx;
 	u8 new_key[DRBG_STATE_LEN];
 
-	for (i = 2; 0 < i; i--) {
-		/* first round uses 0x0, second 0x1 */
-		unsigned char prefix = DRBG_PREFIX0;
-		if (1 == i)
-			prefix = DRBG_PREFIX1;
+	for (u8 i = 0; i < 2; i++) {
 		/* 10.1.2.2 step 1 and 4 -- concatenation and HMAC for key */
 		hmac_sha512_init(&hmac_ctx, &drbg->key);
 		hmac_sha512_update(&hmac_ctx, drbg->V, DRBG_STATE_LEN);
-		hmac_sha512_update(&hmac_ctx, &prefix, 1);
+		hmac_sha512_update(&hmac_ctx, &i, 1);
 		hmac_sha512_update(&hmac_ctx, data1, data1_len);
 		hmac_sha512_update(&hmac_ctx, data2, data2_len);
 		hmac_sha512_final(&hmac_ctx, new_key);
 		hmac_sha512_preparekey(&drbg->key, new_key, DRBG_STATE_LEN);
 
-- 
2.53.0

