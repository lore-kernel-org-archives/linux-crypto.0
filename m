Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7873BCD19
	for <linux-crypto@vger.kernel.org>; Sun, 18 Oct 2026 20:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792356567; cv=none; b=c94D4gXA2BGCrXaBr6h6m+FJWTJ/SOblVi2pMC81F8P5m2Ag39apI8yX79prZ6iF+rU9NCl416sTkJzwYQ9dPJsL2JcYwYZMwSfH8c/cTHBPRLtoHbWm6aMVBAaX74Z9srys8QeA4DIpY0xPm6+DIkq3snqIgeeiJrtxZ/iM4Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792356567; c=relaxed/simple;
	bh=VnnPbvngYuq2QjNGh6UfYtsXE9NMr3JhRn1Uh6r/ILQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJ5+EY2vHHOmufS40IxlkODm36C2LPlk0r0LFj32KdG8D70kZSjvcKWwCnHwig3msQr7KW6YUEirCa+2xJ1zplU6/l+enW9tYN1ts9iVledCb3fMMMzexRdGOitUi3iR6o2VUx5ldzRejqUCLsnoS2qTRqjJe/ccvfkG1WtDjiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z7jSqKlr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z7jSqKlr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591D41F000C4;
	Sun, 18 Oct 2026 20:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792356566;
	bh=xIfBvjkt17vv+QnYpR9iTA6d+nrK8pHVd6D90GXYGkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z7jSqKlrWwc4ZQ0DniyofvtzKj5lsMLRn6qa5Jl3//e7FXBKDVTvFu/1ginltJHbX
	 PlRnleGdG+gZC8/IrSIqzwvWp2I3Rrsh5KzFdCx7Z9TdzJIkrTFTAuofIt1Yk3oUiJ
	 yOIwHaKkN4pfb8SDwn51KBB7Q7rKAqZ2xoStanFsR4xcqSGFlynaAbPwIh3xxBGD2Z
	 Q4D+ab2R4ZCxLwuYsFhvYtKzDFY0IuYt2/njkVMX+DHd4Inf82XcYmRRTCxgf6e+Hm
	 klG7wgoFHbNgRAW5PkaQcst9QL4NeUHWR+eX6DzKQeN5hTij3mr+FG6/8w7a/SMx8b
	 dTE/O/4FsAosw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 04/14] crypto: jitterentropy - Add library API
Date: Sun, 18 Oct 2026 13:46:08 -0700
Message-ID: <20261018204618.104876-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261018204618.104876-1-ebiggers@kernel.org>
References: <20261018204618.104876-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make the jitterentropy RNG accessible using a regular set of functions.

This will allow drbg.c to just access it directly, instead of going
through the overly-general crypto_rng abstraction.

Later commits will remove crypto_rng.

Note that the library API should also continue to meet all the same
certification requirements, including the health check which occurs on
the first call to crypto_jent_alloc().

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/jitterentropy-kcapi.c | 80 +++++++++++++++++++++++++++++++++++-
 crypto/jitterentropy-kcapi.h | 17 ++++++++
 2 files changed, 95 insertions(+), 2 deletions(-)
 create mode 100644 crypto/jitterentropy-kcapi.h

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 84c2c74240a0a..2786303195950 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -1,6 +1,6 @@
 /*
  * Non-physical true random number generator based on timing jitter --
- * Linux Kernel Crypto API specific code
+ * Public API
  *
  * Copyright Stephan Mueller <smueller@chronox.de>, 2015 - 2023
  *
@@ -47,6 +47,7 @@
 #include <crypto/internal/rng.h>
 
 #include "jitterentropy.h"
+#include "jitterentropy-kcapi.h"
 
 /***************************************************************************
  * Helper function
@@ -169,7 +170,7 @@ void jent_read_random_block(struct sha3_ctx *hash_state, char *dst,
 }
 
 /***************************************************************************
- * Kernel crypto API interface
+ * Public API
  ***************************************************************************/
 
 struct jitterentropy {
@@ -226,6 +227,81 @@ static int jent_init(void)
 	return 0;
 }
 
+struct jitterentropy *crypto_jent_alloc(void)
+{
+	struct jitterentropy *rng;
+	int err;
+
+	err = jent_init();
+	if (err)
+		return ERR_PTR(err);
+
+	rng = kzalloc_obj(*rng);
+	if (!rng)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_init(&rng->jent_lock);
+
+	/* Use SHA3-256 as conditioner */
+	sha3_256_init(&rng->hash_state);
+
+	rng->entropy_collector = jent_entropy_collector_alloc(
+		CONFIG_CRYPTO_JITTERENTROPY_OSR, 0, &rng->hash_state);
+	if (!rng->entropy_collector) {
+		crypto_jent_free(rng);
+		return ERR_PTR(-ENOMEM);
+	}
+	return rng;
+}
+EXPORT_SYMBOL_NS_GPL(crypto_jent_alloc, "CRYPTO_INTERNAL");
+
+int crypto_jent_get_bytes(struct jitterentropy *rng, u8 *out,
+			  unsigned int out_len)
+{
+	int ret;
+
+	guard(mutex)(&rng->jent_lock);
+
+	ret = jent_read_entropy(rng->entropy_collector, out, out_len);
+
+	if (ret == -3) {
+		/* Handle permanent health test error */
+		/*
+		 * If the kernel was booted with fips=1, it implies that
+		 * the entire kernel acts as a FIPS 140 module. In this case
+		 * an SP800-90B permanent health test error is treated as
+		 * a FIPS module error.
+		 */
+		if (fips_enabled)
+			panic("Jitter RNG permanent health test failure\n");
+
+		pr_err("Jitter RNG permanent health test failure\n");
+		return -EFAULT;
+	}
+	if (ret == -2) {
+		/* Handle intermittent health test error */
+		pr_warn_ratelimited("Reset Jitter RNG due to intermittent health test failure\n");
+		return -EAGAIN;
+	}
+	if (ret == -1) {
+		/* Handle other errors */
+		return -EINVAL;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_NS_GPL(crypto_jent_get_bytes, "CRYPTO_INTERNAL");
+
+void crypto_jent_free(struct jitterentropy *rng)
+{
+	if (!IS_ERR_OR_NULL(rng)) {
+		mutex_destroy(&rng->jent_lock);
+		if (rng->entropy_collector)
+			jent_entropy_collector_free(rng->entropy_collector);
+		kfree_sensitive(rng);
+	}
+}
+EXPORT_SYMBOL_NS_GPL(crypto_jent_free, "CRYPTO_INTERNAL");
+
 static void jent_kcapi_cleanup(struct crypto_tfm *tfm)
 {
 	struct jitterentropy *rng = crypto_tfm_ctx(tfm);
diff --git a/crypto/jitterentropy-kcapi.h b/crypto/jitterentropy-kcapi.h
new file mode 100644
index 0000000000000..9909df28ed7a6
--- /dev/null
+++ b/crypto/jitterentropy-kcapi.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright 2026 Google LLC
+ */
+#ifndef _CRYPTO_JITTERENTROPY_KCAPI_H
+#define _CRYPTO_JITTERENTROPY_KCAPI_H
+
+#include <linux/types.h>
+
+struct jitterentropy;
+
+struct jitterentropy *crypto_jent_alloc(void);
+int crypto_jent_get_bytes(struct jitterentropy *rng, u8 *out,
+			  unsigned int out_len);
+void crypto_jent_free(struct jitterentropy *rng);
+
+#endif /* _CRYPTO_JITTERENTROPY_KCAPI_H */
-- 
2.56.0

