Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E943914F8;
	Mon, 20 Apr 2026 06:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667029; cv=none; b=E7XKMLKS7wCnVaL8UNMzz3srOY4xdr+JTHYTBXBADZ5ZjBvYEXEOeXSFzjYEpMjeX24DQWJ1nLERcWn/DQF8U1sXDUhyJPN4Ki44iawNP+lMLJddXtwmJWT5oBHRzoLUe5TDP1I3khrXuQy3f15jItk4lYJ8o6HgOGN90h5BPS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667029; c=relaxed/simple;
	bh=af1vIQArVKzExARYuYWCoJA9/jR49J1y5i9toiE3TbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+pUatnjxnMtO0oXRJRc0DH4BSUNB2DSkiBSOmy1lk/9FW6EZSs6kLeh7285I1k1Gb+ZAaQpTDKVyoHgTNuoIj2AF+b9oPgIRTpgu5reu2pZGt9b0NsbjG2Qv2DbAzSAInIjBJI8oMO9aoQHBqG+ez6E5vvkQ9H/TCMkwwLoh4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SaKZai4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SaKZai4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEC7C2BCB7;
	Mon, 20 Apr 2026 06:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667029;
	bh=af1vIQArVKzExARYuYWCoJA9/jR49J1y5i9toiE3TbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SaKZai4tsNUVCxKRYHEbIvQXHVJGgpecZVPFSDjMaHADR/Y1DdlUM3hslwY+w0vSa
	 JFrGRG6KnpzCkO2vSoeizEvOsdqloS7m0NPDmMCFhonWwZHRZINt16UqGX9JM/7B7t
	 GyRILpVbxI3R6ssjbRCyKMkRZnCg+FUzJLj6DIstkxNZZNHB76f5MaKHGm3NcsOs2q
	 h5lpJPRY0OwL4rwXlRD6MjLu4rxMmymvXvrtbCGgkRpNIvA4qFA5EeNI9VJ7fi+Sbf
	 U5zUA+g1hbhBglok534LdJXzX2sfJvrKbOkvRx43Sj/Lj2An44obdrElNmcxN9tFXK
	 jCi9Ne8ZONdYw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 32/38] crypto: drbg - Fold drbg_prepare_hrng() into drbg_kcapi_seed()
Date: Sun, 19 Apr 2026 23:34:16 -0700
Message-ID: <20260420063422.324906-33-ebiggers@kernel.org>
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

Fold drbg_prepare_hrng() into its only caller.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c | 34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index a9d586107ebe..45d97f3ba4ef 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -504,29 +504,10 @@ static int drbg_generate(struct drbg_state *drbg,
 	len = 0;
 err:
 	return len;
 }
 
-static int drbg_prepare_hrng(struct drbg_state *drbg)
-{
-	/* We do not need an HRNG in test mode. */
-	if (drbg->test_entropylen != 0)
-		return 0;
-
-	drbg->jent = crypto_alloc_rng("jitterentropy_rng", 0, 0);
-	if (IS_ERR(drbg->jent)) {
-		const int err = PTR_ERR(drbg->jent);
-
-		drbg->jent = NULL;
-		if (fips_enabled)
-			return err;
-		pr_info("DRBG: Continuing without Jitter RNG\n");
-	}
-
-	return 0;
-}
-
 /*
  * DRBG uninstantiate function as required by SP800-90A - this function
  * frees all buffers and the DRBG handle
  *
  * @drbg DRBG state handle
@@ -600,13 +581,22 @@ static int drbg_kcapi_seed(struct crypto_rng *tfm,
 	drbg->last_seed_time = 0;
 	drbg->reseed_threshold = DRBG_MAX_REQUESTS;
 	memset(drbg->V, 1, DRBG_STATE_LEN);
 	hmac_sha512_preparekey(&drbg->key, initial_key, DRBG_STATE_LEN);
 
-	ret = drbg_prepare_hrng(drbg);
-	if (ret)
-		goto free_everything;
+	/* Allocate jitterentropy_rng if not in test mode. */
+	if (drbg->test_entropylen == 0) {
+		drbg->jent = crypto_alloc_rng("jitterentropy_rng", 0, 0);
+		if (IS_ERR(drbg->jent)) {
+			ret = PTR_ERR(drbg->jent);
+			drbg->jent = NULL;
+			if (fips_enabled)
+				goto free_everything;
+			pr_info("DRBG: Continuing without Jitter RNG\n");
+		}
+	}
+
 	ret = drbg_seed(drbg, pers, pers_len, /* reseed= */ false);
 	if (ret)
 		goto free_everything;
 
 	return ret;
-- 
2.53.0

