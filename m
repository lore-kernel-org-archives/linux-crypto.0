Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D60B18CBE1;
	Thu, 26 Mar 2026 00:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774484213; cv=none; b=tCcdpxUQ0mAtWl7Mdqv1BPVflM7/0EK5hy5Rs4rpKoxUPlAOlHTGt4hFRFsFULZzHVBc3UQK4WjX2A9JHH10zVNKPiDFdsveK3/5vpmRJ1RiQPkQ9zBvTP+FPHKbkBoAKc+Ywv5NlNQugRMjf9/+/AQzEn91SebVkHYUiAOFqJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774484213; c=relaxed/simple;
	bh=RXIR7mC7JY9QlvcxmBcv1kp5mVy6xC1YKrj0WphyGMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuqYE9QcZnDmMeN9AfVQ5Evc5z+qAUjJS/tTH5vrZHA2s9LfazaQqQ8Dzkv0mcsU/OVThUO+wnoqJ3Pl/uBoRI4OjxyOMpe6lJSWIPSOWzN9HoiHczs1p+emXv0hut7m2VgYFJRcAjwcAC6Ducr4xlr4IqgHLH4FLVkOXYEeHHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hZmR1veT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hZmR1veT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1281C2BCB0;
	Thu, 26 Mar 2026 00:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774484213;
	bh=RXIR7mC7JY9QlvcxmBcv1kp5mVy6xC1YKrj0WphyGMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZmR1veTizFuzFNomq0BeGssGbIyndMbPU4ITx+VrhgP60qa++DZZJHKfrc1s41b+
	 MnbAmyJ+uhake7+d7yUG2UF/5cJLc9fWJj7tcLvBhStL6ZS8aH+kYbPIJZTkRUdVGC
	 xkzs11NjFL2nRjqusE1/7ST5EPN072kT2oFQBR0Q4Ia7eJu0ZFQFpiZsFR3mRUm4tW
	 cvlsEoVujDPQpeiAczxRXWeoFvD6MdgLU2XzvnuFK3/hmx9QNE312v8geDuV44/hZY
	 PnoHrZtMxn1eoDfLXCBkksXq7T3FDCCl2ino1W2/VY67BePCLWvbYHV+79+85L4Yzn
	 YUp9x95vhEBog==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Stephan Mueller <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 08/11] crypto: rng - Unexport "default RNG" symbols
Date: Wed, 25 Mar 2026 17:15:04 -0700
Message-ID: <20260326001507.66500-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260326001507.66500-1-ebiggers@kernel.org>
References: <20260326001507.66500-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that crypto_default_rng, crypto_get_default_rng(), and
crypto_put_default_rng() have no users outside crypto/rng.c itself,
unexport them and make them static.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/rng.c         | 9 +++------
 include/crypto/rng.h | 5 -----
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/crypto/rng.c b/crypto/rng.c
index 53a268ad5104..f52f4793f9ea 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -22,12 +22,11 @@
 #include <net/netlink.h>
 
 #include "internal.h"
 
 static DEFINE_MUTEX(crypto_default_rng_lock);
-struct crypto_rng *crypto_default_rng;
-EXPORT_SYMBOL_GPL(crypto_default_rng);
+static struct crypto_rng *crypto_default_rng;
 static int crypto_default_rng_refcnt;
 
 int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
 {
 	u8 *buf = NULL;
@@ -104,11 +103,11 @@ struct crypto_rng *crypto_alloc_rng(const char *alg_name, u32 type, u32 mask)
 {
 	return crypto_alloc_tfm(alg_name, &crypto_rng_type, type, mask);
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_rng);
 
-int crypto_get_default_rng(void)
+static int crypto_get_default_rng(void)
 {
 	struct crypto_rng *rng;
 	int err;
 
 	mutex_lock(&crypto_default_rng_lock);
@@ -133,19 +132,17 @@ int crypto_get_default_rng(void)
 unlock:
 	mutex_unlock(&crypto_default_rng_lock);
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(crypto_get_default_rng);
 
-void crypto_put_default_rng(void)
+static void crypto_put_default_rng(void)
 {
 	mutex_lock(&crypto_default_rng_lock);
 	crypto_default_rng_refcnt--;
 	mutex_unlock(&crypto_default_rng_lock);
 }
-EXPORT_SYMBOL_GPL(crypto_put_default_rng);
 
 int crypto_stdrng_get_bytes(void *buf, unsigned int len)
 {
 	int err;
 
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index db6c3962a7df..f61e037afed9 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -55,15 +55,10 @@ struct rng_alg {
 
 struct crypto_rng {
 	struct crypto_tfm base;
 };
 
-extern struct crypto_rng *crypto_default_rng;
-
-int crypto_get_default_rng(void);
-void crypto_put_default_rng(void);
-
 /**
  * crypto_stdrng_get_bytes() - get cryptographically secure random bytes
  * @buf: output buffer holding the random numbers
  * @len: length of the output buffer
  *
-- 
2.53.0

