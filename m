Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AABC388E53;
	Mon, 20 Apr 2026 06:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667027; cv=none; b=pekXHNqT6zvlvynw4p2JAN11ceTovU1FbZOZN88Ir2WVWbNEOWKaR3YueP/1cgUSolsQF/4Gjr0CvNacqE2AkPe7aHhvCdemOlAtlk/UyjNOct+Myek7R8KTm23W+C5col1nFNIsvimO8V0tdomqlbaqe9lnRJ/mjgO2D8X1XdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667027; c=relaxed/simple;
	bh=2Fx7oBiBOH+4qFsLRNrpYJ5NAI+tttSSeoQs9ybRhXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=espLdz4R+MfbMZLYOSN9v+m7aLk8+Q66GRXwoTUQKsnNrVaoBC7XYf0LGZ1u45mFPMfMmc5CeTfQ16hzb4bN7k9Pf7IlpMepIJCj3NRD11L3VQoAm0f1XjlJx8En6LY8VUt13FBlXANQyCUEmg8k21cqxUlNATuLo44XqfYFy/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JRwHVHcL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JRwHVHcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65EAC2BCB7;
	Mon, 20 Apr 2026 06:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667026;
	bh=2Fx7oBiBOH+4qFsLRNrpYJ5NAI+tttSSeoQs9ybRhXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRwHVHcLAhIgx1AjtY/9Ci4BDikPaeHBYtTaebB86y9qz6MeEzipP4+S+r7q40jvY
	 KhRrJpzJt1QXuJFx92m2lDvWKmlBMzOpetzpJekxxHMnBiyACUHK9hSCLKRqbO6r6s
	 dc/PMXBkm660BuTkNd/xICjiCa7d6mVbT3R0he8Iq/4yexHsNbG++GjT2+3zBZJGbh
	 H3q2omEYWfueoiEJJ85wUwFzgH2emW5OPL4IxiR4Gf56fIxtria3rScLtZ5EuTQEnL
	 rxGWnLIJ0t96pUQifykALmOxTTBaxJ4wsk9Z3U6/WWW/O05Pxqzl1C3OdOGqGgq1jB
	 X6VcpTkZH38aQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 24/38] crypto: drbg - Install separate seed functions for pr and nopr
Date: Sun, 19 Apr 2026 23:34:08 -0700
Message-ID: <20260420063422.324906-25-ebiggers@kernel.org>
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

Set rng_alg::seed to different functions for the prediction-resistant
and non-prediction-resistant algorithms, so that the function does not
need to parse the algorithm name to figure out which algorithm it is.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 161070b10f85..c29f4ca93d1b 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -731,20 +731,15 @@ static int drbg_kcapi_random(struct crypto_rng *tfm,
 	}
 
 	return drbg_generate_long(drbg, dst, dlen, addtl);
 }
 
-/*
- * Seed the DRBG invoked by the kernel crypto API
- */
+/* Seed (i.e. instantiate) or re-seed the DRBG. */
 static int drbg_kcapi_seed(struct crypto_rng *tfm,
-			   const u8 *seed, unsigned int slen)
+			   const u8 *seed, unsigned int slen, bool pr)
 {
 	struct drbg_state *drbg = crypto_rng_ctx(tfm);
-	struct crypto_tfm *tfm_base = crypto_rng_tfm(tfm);
-	bool pr = memcmp(crypto_tfm_alg_driver_name(tfm_base),
-			 "drbg_nopr_", 10) != 0;
 	struct drbg_string string;
 	struct drbg_string *seed_string = NULL;
 
 	if (0 < slen) {
 		drbg_string_fill(&string, seed, slen);
@@ -752,10 +747,22 @@ static int drbg_kcapi_seed(struct crypto_rng *tfm,
 	}
 
 	return drbg_instantiate(drbg, seed_string, pr);
 }
 
+static int drbg_kcapi_seed_pr(struct crypto_rng *tfm,
+			      const u8 *seed, unsigned int slen)
+{
+	return drbg_kcapi_seed(tfm, seed, slen, /* pr= */ true);
+}
+
+static int drbg_kcapi_seed_nopr(struct crypto_rng *tfm,
+				const u8 *seed, unsigned int slen)
+{
+	return drbg_kcapi_seed(tfm, seed, slen, /* pr= */ false);
+}
+
 /***************************************************************
  * Kernel module: code to load the module
  ***************************************************************/
 
 /*
@@ -825,11 +832,11 @@ static struct rng_alg drbg_algs[] = {
 		.base.cra_priority	= 200,
 		.base.cra_ctxsize	= sizeof(struct drbg_state),
 		.base.cra_module	= THIS_MODULE,
 		.base.cra_init		= drbg_kcapi_init,
 		.set_ent		= drbg_kcapi_set_entropy,
-		.seed			= drbg_kcapi_seed,
+		.seed			= drbg_kcapi_seed_pr,
 		.generate		= drbg_kcapi_random,
 		.base.cra_exit		= drbg_kcapi_cleanup,
 	},
 	{
 		.base.cra_name		= "stdrng",
@@ -837,11 +844,11 @@ static struct rng_alg drbg_algs[] = {
 		.base.cra_priority	= 201,
 		.base.cra_ctxsize	= sizeof(struct drbg_state),
 		.base.cra_module	= THIS_MODULE,
 		.base.cra_init		= drbg_kcapi_init,
 		.set_ent		= drbg_kcapi_set_entropy,
-		.seed			= drbg_kcapi_seed,
+		.seed			= drbg_kcapi_seed_nopr,
 		.generate		= drbg_kcapi_random,
 		.base.cra_exit		= drbg_kcapi_cleanup,
 	},
 };
 
-- 
2.53.0

