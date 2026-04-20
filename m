Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3294838F923;
	Mon, 20 Apr 2026 06:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667029; cv=none; b=UeLOfoVaxB2U9Jq8CQmC96cM17rnWD/FHEZOOjB265uv8fYjD0ZSMjIp74XVmnS7leao/raaYMSKYVEjTPsLPmRraDgLEzUArb35G/wIxC4Om/WNvGn9i1s3zYdocbCwjoX7Hc0XJ1rjNdjKrbSDvxwzk9olamGQ46KStUugx3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667029; c=relaxed/simple;
	bh=wla75adFQXRnNMgLq0IS0PfZXeGDq1tsGETDptDTDVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpYheyFCigX8xAykiLPk3a7OI9jlpamRjCw/mLSOQX141ejuAr37aFWh0/s4xVeEk1BqiPqCpoHcKohb75AUigUMSWFYcnWC+AURf/82foFoTnbrR8FFieH0oXce+49esqPjZdOiVw15yodrjvaGiAgL3cCtLAGia6UOL7GMwvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=leBgm3Qk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="leBgm3Qk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5685C2BCB8;
	Mon, 20 Apr 2026 06:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667029;
	bh=wla75adFQXRnNMgLq0IS0PfZXeGDq1tsGETDptDTDVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=leBgm3QkGkD7EVBxmyPWC1lxuNOj+BvZIeN+N2Z8PBC8KDp+iSoRoRPikLDA/CA9W
	 IBgLmWBmZwFRlXoW/+P7NtJ+zSCbAHngYSu9oEWbOkb4GukBxJTGg1PfM3itw9Gt9r
	 YEUa9CF7387tdMloi19GsXTcmZ7oEujnYTWHxo6AsOOZ6aJmwNgAZmcky8rAHM0dzi
	 MZZtr+2fquTCPg4YbaQabmW/tAxjpIcAjoXDsBA8hKyL52ds/luqUF1t1cJ3Ipt55Y
	 DsXMW7s1jgNTs5j98YX1uef/28L4mB7j7ijA/ZmMJDN4tBU2N0SbygdRnL5SYTLOkE
	 CLQXHV1/avWxg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 31/38] crypto: drbg - Separate "reseed" case in drbg_kcapi_seed()
Date: Sun, 19 Apr 2026 23:34:15 -0700
Message-ID: <20260420063422.324906-32-ebiggers@kernel.org>
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

Clearly separate the code for the "reseed" and "instantiate" cases,
since what they need to do is quite different.

Note that the mutex guard makes the mutex start being held during the
call to drbg_uninstantiate(), which is fine.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c | 38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 763c14e3786c..a9d586107ebe 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -575,51 +575,45 @@ static int drbg_kcapi_seed(struct crypto_rng *tfm,
 			   const u8 *pers, size_t pers_len, bool pr)
 {
 	static const u8 initial_key[DRBG_STATE_LEN]; /* all zeroes */
 	struct drbg_state *drbg = crypto_rng_ctx(tfm);
 	int ret;
-	bool reseed = true;
 
 	pr_devel("DRBG: Initializing DRBG with prediction resistance %s\n",
 		 str_enabled_disabled(pr));
-	mutex_lock(&drbg->drbg_mutex);
+	guard(mutex)(&drbg->drbg_mutex);
+
+	if (drbg->instantiated)
+		return drbg_seed(drbg, pers, pers_len, /* reseed= */ true);
 
 	/* 9.1 step 1 is implicit with the selected DRBG type */
 
 	/*
 	 * 9.1 step 2 is implicit as caller can select prediction resistance
 	 * all DRBG types support prediction resistance
 	 */
 
 	/* 9.1 step 4 is implicit in DRBG_SEC_STRENGTH */
 
-	if (!drbg->instantiated) {
-		drbg->instantiated = true;
-		drbg->pr = pr;
-		drbg->seeded = DRBG_SEED_STATE_UNSEEDED;
-		drbg->last_seed_time = 0;
-		drbg->reseed_threshold = DRBG_MAX_REQUESTS;
-		memset(drbg->V, 1, DRBG_STATE_LEN);
-		hmac_sha512_preparekey(&drbg->key, initial_key, DRBG_STATE_LEN);
-
-		ret = drbg_prepare_hrng(drbg);
-		if (ret)
-			goto free_everything;
-
-		reseed = false;
-	}
-
-	ret = drbg_seed(drbg, pers, pers_len, reseed);
+	drbg->instantiated = true;
+	drbg->pr = pr;
+	drbg->seeded = DRBG_SEED_STATE_UNSEEDED;
+	drbg->last_seed_time = 0;
+	drbg->reseed_threshold = DRBG_MAX_REQUESTS;
+	memset(drbg->V, 1, DRBG_STATE_LEN);
+	hmac_sha512_preparekey(&drbg->key, initial_key, DRBG_STATE_LEN);
 
-	if (ret && !reseed)
+	ret = drbg_prepare_hrng(drbg);
+	if (ret)
+		goto free_everything;
+	ret = drbg_seed(drbg, pers, pers_len, /* reseed= */ false);
+	if (ret)
 		goto free_everything;
 
-	mutex_unlock(&drbg->drbg_mutex);
 	return ret;
 
 free_everything:
-	mutex_unlock(&drbg->drbg_mutex);
 	drbg_uninstantiate(drbg);
 	return ret;
 }
 
 static int drbg_kcapi_seed_pr(struct crypto_rng *tfm,
-- 
2.53.0

