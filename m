Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793379852;
	b=VChd1qhji87I5tj78wzmgvgA9GYCzTbWdipkNkXECwVN0zRC5z+QTteQHsIVhQtVm/RL
	 if1vqOjAMm8PDDDU/levV9PCd96gZjByHPAfzItSw5c76cNcJO75hDMu4aC5PZHLgowlY
	 JJQwZNdfSQX4RqKn1o69KZ2LjpO2f+qZKMxZt0FD9dho0kWNwSX5c/hgqO/+EXGpupBWb
	 8gKR0RUvhu0osT9Of5LDubtK46lWxlxq9fxilaXzHX6MZP4GZwtGOr3IDXULoO5KJqMBc
	 2PKXCcBvllbCNcHUADoF5S04q26X0hWX7Y/DfOgGOfmVrqLjRZASwwLFEYvbwB5zRzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793379852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=seM7soGbHQPvqWwOtTJ+EwTnDU4xqI1VJWNKvfkoonw=;
	b=iw03HwPKriat9AFXRyLwP42fcvCDzxX6Kf3Jg8OoT+jlo8yd/GHc24esQn4E/uyuAF2g
	 Ucs/3xeAtg0W2APITkId5J6/COBSnS1uml8w5ntf2i0bBcJ0KSYPFP7e9g+RFRl47MNCg
	 kBW9C7GsR7Lue6JJ+jO8jU1kpiC3jTkJJxsVMzYg+vDJppKztbIoqxDEZWf1WuvhBehNt
	 MjiElMCtn1flPZAMNXPMgOzWHv2rBEQtmL9somw40Uu0Ef6aqtfU4Sq2oEE/k4YxlXRE/
	 4qpvOW1lLlNstuJ1Ydj9HPf5wh8Lk+klh7g065FuOvZCPb2advHAnv/kilGBTmFYYLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=blVAeqco;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597AC606A31C;
	Fri, 30 Oct 2026 17:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=blVAeqco
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77C31F000C1;
	Fri, 30 Oct 2026 17:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793379852;
	bh=seM7soGbHQPvqWwOtTJ+EwTnDU4xqI1VJWNKvfkoonw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=blVAeqco776Fo2OiQh+mOAJwY20maVFppJdfX3uSsq+/l7Pc45atjxTa0iPIOrOR2
	 an67cjT4xWDmDuAGRo5ijQv91Plk/nTAGRM0UaT96V8SILo0EWIZutnJF36I7qQlCL
	 5rV0EtZXwrD3952IfDQYKoNjKhiRVOHI5b69qZye7sVK/KPi2wNkHVh4/4iW8cK6Tp
	 Dt3eyT7nTPS4F2aCZkvgICldtrHpaY0I6wLMjsvhbXlKPXWwoyEf0RMEhNNDjmZStN
	 X+mos+JZszAJua84mg2SaefiU12VbIPIZ5jkeBXTgmXtzXcIN8fLyqGJRKCCeoP7U5
	 el/zXWqJbrjdQ==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.1 1/3] Revert "crypto: jitterentropy - replace long-held spinlock with mutex"
Date: Fri, 30 Oct 2026 10:02:18 -0700
Message-ID: <20261030170220.120015-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261030170220.120015-1-ebiggers@kernel.org>
References: <20261030170220.120015-1-ebiggers@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 21de77d06f6b540e870e64ef5ff56be4eb8ba08f.

This is needed to cleanly revert commit fc659f1a6903 ("crypto: jitter -
replace LFSR with SHA3-256").  It will be reapplied.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/jitterentropy-kcapi.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 74d5c8da0e8ab..4b50cbc8a2faf 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -42,7 +42,6 @@
 #include <linux/fips.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <crypto/internal/rng.h>
@@ -181,7 +180,7 @@ int jent_read_random_block(void *hash_state, char *dst, unsigned int dst_len)
  ***************************************************************************/
 
 struct jitterentropy {
-	struct mutex jent_lock;
+	spinlock_t jent_lock;
 	struct rand_data *entropy_collector;
 	struct crypto_shash *tfm;
 	struct shash_desc *sdesc;
@@ -191,7 +190,7 @@ static void jent_kcapi_cleanup(struct crypto_tfm *tfm)
 {
 	struct jitterentropy *rng = crypto_tfm_ctx(tfm);
 
-	mutex_lock(&rng->jent_lock);
+	spin_lock(&rng->jent_lock);
 
 	if (rng->sdesc) {
 		shash_desc_zero(rng->sdesc);
@@ -206,7 +205,7 @@ static void jent_kcapi_cleanup(struct crypto_tfm *tfm)
 	if (rng->entropy_collector)
 		jent_entropy_collector_free(rng->entropy_collector);
 	rng->entropy_collector = NULL;
-	mutex_unlock(&rng->jent_lock);
+	spin_unlock(&rng->jent_lock);
 }
 
 static int jent_kcapi_init(struct crypto_tfm *tfm)
@@ -216,7 +215,7 @@ static int jent_kcapi_init(struct crypto_tfm *tfm)
 	struct shash_desc *sdesc;
 	int size, ret = 0;
 
-	mutex_init(&rng->jent_lock);
+	spin_lock_init(&rng->jent_lock);
 
 	/*
 	 * Use SHA3-256 as conditioner. We allocate only the generic
@@ -251,6 +250,7 @@ static int jent_kcapi_init(struct crypto_tfm *tfm)
 		goto err;
 	}
 
+	spin_lock_init(&rng->jent_lock);
 	return 0;
 
 err:
@@ -265,7 +265,7 @@ static int jent_kcapi_random(struct crypto_rng *tfm,
 	struct jitterentropy *rng = crypto_rng_ctx(tfm);
 	int ret = 0;
 
-	mutex_lock(&rng->jent_lock);
+	spin_lock(&rng->jent_lock);
 
 	ret = jent_read_entropy(rng->entropy_collector, rdata, dlen);
 
@@ -291,7 +291,7 @@ static int jent_kcapi_random(struct crypto_rng *tfm,
 		ret = -EINVAL;
 	}
 
-	mutex_unlock(&rng->jent_lock);
+	spin_unlock(&rng->jent_lock);
 
 	return ret;
 }
-- 
2.56.0

