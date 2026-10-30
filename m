Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793379853;
	b=esLCjIB9CQbd0j1IoPfGTWIlbl4C1ylHvhLrU+LFIxqXU1aZZZvyVhhNhP18MEFW2OLT
	 tAZFbb1g/NKTJtxydYdGwQnD71ta6ppI2D8eQOtkc9iGM837vwsaV8D3AoUWQoCNLJHk6
	 mUo6HV1pqosekQ13cp/vstTejTspGg7q0R//xw2EOSadCCZ92kViCth3MCHlEATK2qNSu
	 qwnDYSMmwJjrS0frrL8bJnL5cqksgibFE26U6jIHtbvQBpFMhhr8oScXmCW4WxQtC/lMO
	 uyo0Szx5KZsVhP7SpGEO52QOQ898Wf+KB0Kj9LWWNalfJoga8DA/AHI7IoZ3ckj1jTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793379853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ZCvQA/lz1U479mSBoEFV1YWXVgiQrsnQ3qUR7tVQrJE=;
	b=CJcn1+1yGivLaMEvHVrHr1klHzZfjqoR/CkSvEQvu2BpRdG6yDnnyvNEiNpUv++qmmzQ
	 LJhapTWaVbigzXXZDZ7I2k98wx2EdLZRTb53H35pAYiTdXcacJD76bumLCc5S7iCo+ymF
	 KN8UP3ChUCqO4xjwbK+TMOKz081hLE5EEk+6zpu+m0oSnjtpmrWDfRYMJglCOCV+DlMr6
	 eDoJaVN1qxjpep/JmMc0oQ1pctaoI5QHhZe0OfBZgHTaDN6hYSRxqWT1BdkG6HEM7pzPk
	 M+rWZ3YaazzfPQ6JdOs0Td7tgevANw008El6IyZQdyXUthSodInBKcFBJJ/+cZ1uu1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YAgw6J45;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AB4606A321;
	Fri, 30 Oct 2026 17:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YAgw6J45
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E491F00A02;
	Fri, 30 Oct 2026 17:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793379852;
	bh=ZCvQA/lz1U479mSBoEFV1YWXVgiQrsnQ3qUR7tVQrJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YAgw6J45vLRQBsBQN3i4Vw1xB9HeikBBMsepcDK2N6gkre+pISwCxN4kRXZOSxCbo
	 4nl+p6GdCiEPtE+ZJmLbphBmwEhIeY63DX3NPaXcsxQkSZw43ua7w/0P+r7Hu/1Cd+
	 fxRfs1m70KKSbfe+Yi3ssSFaf5yZgGD0FbwlT/Lkna7s3K6Fy23pSU0YSVnFhAB5wJ
	 Ekdj+PRDL6J/N0vy+8KuUchiTVLZBdCvRzHgs4a5mvTwp1NhaDguJNgR63wSi3D5x0
	 AqCK47JPPTZeDw0Y6hccZme5uc/ttuIEsyUH9u2vdFuVM9lx82bLXZNq9WI3e7IqKs
	 FM/xNEfwCFUcw==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Haixin Xu <jerryxucs@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.1 3/3] crypto: jitterentropy - replace long-held spinlock with mutex
Date: Fri, 30 Oct 2026 10:02:20 -0700
Message-ID: <20261030170220.120015-4-ebiggers@kernel.org>
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

From: Haixin Xu <jerryxucs@gmail.com>

commit 01d798e9feb30212952d4e992801ba6bd6a82351 upstream.

jent_kcapi_random() serializes the shared jitterentropy state, but it
currently holds a spinlock across the jent_read_entropy() call. That
path performs expensive jitter collection and SHA3 conditioning, so
parallel readers can trigger stalls as contending waiters spin for
the same lock.

To prevent non-preemptible lock hold, replace rng->jent_lock with a
mutex so contended readers sleep instead of spinning on a shared lock
held across expensive entropy generation.

Fixes: bb5530e40824 ("crypto: jitterentropy - add jitterentropy RNG")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Haixin Xu <jerryxucs@gmail.com>
Reviewed-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ebiggers: backported without commit bb897c55042e ("crypto: jitter -
 replace LFSR with SHA3-256")]
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/jitterentropy-kcapi.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index b9edfaa51b273..29c830b47c5e2 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -40,6 +40,7 @@
 #include <linux/fips.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <crypto/internal/rng.h>
@@ -96,7 +97,7 @@ void jent_get_nstime(__u64 *out)
  ***************************************************************************/
 
 struct jitterentropy {
-	spinlock_t jent_lock;
+	struct mutex jent_lock;
 	struct rand_data *entropy_collector;
 };
 
@@ -109,7 +110,7 @@ static int jent_kcapi_init(struct crypto_tfm *tfm)
 	if (!rng->entropy_collector)
 		ret = -ENOMEM;
 
-	spin_lock_init(&rng->jent_lock);
+	mutex_init(&rng->jent_lock);
 	return ret;
 }
 
@@ -117,11 +118,11 @@ static void jent_kcapi_cleanup(struct crypto_tfm *tfm)
 {
 	struct jitterentropy *rng = crypto_tfm_ctx(tfm);
 
-	spin_lock(&rng->jent_lock);
+	mutex_lock(&rng->jent_lock);
 	if (rng->entropy_collector)
 		jent_entropy_collector_free(rng->entropy_collector);
 	rng->entropy_collector = NULL;
-	spin_unlock(&rng->jent_lock);
+	mutex_unlock(&rng->jent_lock);
 }
 
 static int jent_kcapi_random(struct crypto_rng *tfm,
@@ -131,7 +132,7 @@ static int jent_kcapi_random(struct crypto_rng *tfm,
 	struct jitterentropy *rng = crypto_rng_ctx(tfm);
 	int ret = 0;
 
-	spin_lock(&rng->jent_lock);
+	mutex_lock(&rng->jent_lock);
 
 	ret = jent_read_entropy(rng->entropy_collector, rdata, dlen);
 
@@ -157,7 +158,7 @@ static int jent_kcapi_random(struct crypto_rng *tfm,
 		ret = -EINVAL;
 	}
 
-	spin_unlock(&rng->jent_lock);
+	mutex_unlock(&rng->jent_lock);
 
 	return ret;
 }
-- 
2.56.0

