Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEE84A2A5E
	for <linux-crypto@vger.kernel.org>; Sun, 18 Oct 2026 20:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792356568; cv=none; b=XVEycwruqkz33CbXr/2IjLDGo20n2E1ZdYObj05R1JjNDNbYkDdnD9f5O88u26J3OY8xsr+ifQVh8cRM926Mqjc4lyjf7LulcxPiJCpmOtsIXGzidPfJXQXcp9aCvUBdtkWINYkNaV8Dl5iAPh/AUOyTpRkVv+bPJKVgyjeeCds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792356568; c=relaxed/simple;
	bh=YTdK9LaxmsX3g/LfFoNnNQTQ4it5L27L6vUmZN9RKG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6BZmG9JvO22SIPrsp3kfb/Mg/LRoGyk3Hrbfyb0eecmU7VKuqkBG4EI+WcOFEQkb41UtwrUzOxnhDQygja+/K2Dy/fLS76sq0ZNOh3DAvQfF/OHTrHRo3OU7hVfXp6ZEJ6KFWdV0jk3aNgAHh0gyMBXbdE+PuIKB5C4hsWvS4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z5eJoTgJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z5eJoTgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE471F000C6;
	Sun, 18 Oct 2026 20:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792356567;
	bh=ncikLi33swpNqzxTy700hInyCqEKhpKVtKIMsS4YdX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z5eJoTgJ27CzMqBJWjte9ICTHZfnFGiJLm8c3RHGCMHZpZgChlsDEp6G3pBosk1rU
	 DrPqAKjEuZKNLSuc4pJuxo2r+PPcqPAHw5rtkVQtDT1PEAfY5xbV2M050IJFcBLrT7
	 CCVhRD+oReBRYcrSkn5qA0MqbDI+PQ9c3+p/cWcQIEWnYWtrLlJgbRnXXkreWoeaYo
	 +IteD8cz9dcYFhdMuVXYqtYm4vw6QhLFGLWzPSP5B94buIdKZ50qztUszfVuOXsXpI
	 rVJ5oVMxxwUIglI4cO/+rz9BorSvxaQfhslmRLHraVaFur6Zl6x99szRKHZ1YBbNTd
	 I3qH60HQMqQ7A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 06/14] crypto: drbg - Add library API
Date: Sun, 18 Oct 2026 13:46:10 -0700
Message-ID: <20261018204618.104876-7-ebiggers@kernel.org>
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

Make the SP800-90A DRBG accessible using a regular set of functions.

This will allow __crypto_stdrng_get_bytes() to just access it directly,
instead of going through the overly-general crypto_rng abstraction.

Later commits will remove crypto_rng.

Update the example code in the file comment to use the library API.
There were also multiple bugs in the example code (missing seeding and
out-of-bounds reads), so fix those too.

For consistency with other RNG functions, crypto_drbg_get_bytes() takes
a size_t length rather than unsigned int as crypto_rng did, and it
returns 0 rather than an error if asked to generate 0 bytes.

Note that the library API should also continue to meet all the same
certification requirements, including the self-test which the next
commit adds to crypto_drbg_alloc() to replace the testmgr.c one.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c | 144 +++++++++++++++++++++++++++++++++++++++++++-------
 crypto/drbg.h |  20 +++++++
 2 files changed, 146 insertions(+), 18 deletions(-)
 create mode 100644 crypto/drbg.h

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 6015822129edc..7d8be036e9be8 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -41,46 +41,45 @@
  * ==========
  * The SP 800-90A DRBG allows the user to specify a personalization string
  * for initialization as well as an additional information string for each
- * random number request. The following code fragments show how a caller
- * uses the kernel crypto API to use the full functionality of the DRBG.
+ * random number request. The following code snippets show example use:
  *
  * Usage without any additional data
  * ---------------------------------
- * struct crypto_rng *drng;
+ * struct drbg_state *drbg;
  * int err;
  * char data[DATALEN];
  *
- * drng = crypto_alloc_rng(drng_name, 0, 0);
- * err = crypto_rng_get_bytes(drng, data, DATALEN);
- * crypto_free_rng(drng);
+ * drbg = crypto_drbg_alloc();
+ * err = crypto_drbg_seed(drbg, NULL, 0);
+ * err = crypto_drbg_get_bytes(drbg, data, sizeof(data), NULL, 0);
+ * crypto_drbg_free(drbg);
  *
  *
  * Usage with personalization string during initialization
  * -------------------------------------------------------
- * struct crypto_rng *drng;
+ * struct drbg_state *drbg;
  * int err;
  * char data[DATALEN];
  * char personalization[11] = "some-string";
  *
- * drng = crypto_alloc_rng(drng_name, 0, 0);
- * // The reset completely re-initializes the DRBG with the provided
- * // personalization string
- * err = crypto_rng_reset(drng, personalization, strlen(personalization));
- * err = crypto_rng_get_bytes(drng, data, DATALEN);
- * crypto_free_rng(drng);
+ * drbg = crypto_drbg_alloc();
+ * err = crypto_drbg_seed(drbg, personalization, sizeof(personalization));
+ * err = crypto_drbg_get_bytes(drbg, data, sizeof(data), NULL, 0);
+ * crypto_drbg_free(drbg);
  *
  *
  * Usage with additional information string during random number request
  * ---------------------------------------------------------------------
- * struct crypto_rng *drng;
+ * struct drbg_state *drbg;
  * int err;
  * char data[DATALEN];
  * char addtl_string[11] = "some-string";
  *
- * drng = crypto_alloc_rng(drng_name, 0, 0);
- * err = crypto_rng_generate(drng, addtl_string, strlen(addtl_string),
-			     data, DATALEN);
- * crypto_free_rng(drng);
+ * drbg = crypto_drbg_alloc();
+ * err = crypto_drbg_seed(drbg, NULL, 0);
+ * err = crypto_drbg_get_bytes(drbg, data, sizeof(data), addtl_string,
+ *			       sizeof(addtl_string));
+ * crypto_drbg_free(drbg);
  *
  *
  * Usage with personalization and additional information strings
@@ -94,8 +93,10 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <linux/string_choices.h>
 #include <linux/unaligned.h>
+#include "drbg.h"
 #include "jitterentropy-kcapi.h"
 
 /* State length in bytes */
@@ -517,6 +518,113 @@ static void drbg_kcapi_exit(struct crypto_tfm *tfm)
 	memzero_explicit(drbg, sizeof(*drbg));
 }
 
+/***************************************************************
+ * Public API
+ ***************************************************************/
+
+struct drbg_state *crypto_drbg_alloc(void)
+{
+	struct drbg_state *drbg = kzalloc_obj(*drbg);
+
+	if (!drbg)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_init(&drbg->drbg_mutex);
+	return drbg;
+}
+EXPORT_SYMBOL_NS_GPL(crypto_drbg_alloc, "CRYPTO_INTERNAL");
+
+/* Set test entropy in the DRBG. */
+void crypto_drbg_set_entropy(struct drbg_state *drbg, const u8 *data,
+			     size_t len)
+{
+	guard(mutex)(&drbg->drbg_mutex);
+	drbg->test_entropy = data;
+	drbg->test_entropylen = len;
+}
+EXPORT_SYMBOL_NS_GPL(crypto_drbg_set_entropy, "CRYPTO_INTERNAL");
+
+/* Seed (i.e. instantiate) or re-seed the DRBG. */
+int crypto_drbg_seed(struct drbg_state *drbg, const u8 *pers, size_t pers_len)
+{
+	static const u8 initial_key[DRBG_STATE_LEN]; /* all zeroes */
+	int ret;
+
+	pr_devel("DRBG: Initializing DRBG\n");
+	guard(mutex)(&drbg->drbg_mutex);
+
+	if (drbg->instantiated)
+		return drbg_seed(drbg, pers, pers_len, /* reseed= */ true);
+
+	/* 9.1 step 1 is implicit with the selected DRBG type */
+
+	/*
+	 * 9.1 step 2 is implicit, as this implementation doesn't support
+	 * prediction resistance
+	 */
+
+	/* 9.1 step 4 is implicit in DRBG_SEC_STRENGTH */
+
+	memset(drbg->V, 1, DRBG_STATE_LEN);
+	hmac_sha512_preparekey(&drbg->key, initial_key, DRBG_STATE_LEN);
+
+	/* Allocate jitterentropy if not in test mode. */
+	if (drbg->test_entropylen == 0) {
+		drbg->jent = crypto_jent_alloc();
+		if (IS_ERR(drbg->jent)) {
+			ret = PTR_ERR(drbg->jent);
+			drbg->jent = NULL;
+			if (fips_enabled)
+				return ret;
+			pr_info("DRBG: Continuing without Jitter RNG\n");
+		}
+	}
+
+	ret = drbg_seed(drbg, pers, pers_len, /* reseed= */ false);
+	if (ret) {
+		crypto_jent_free(drbg->jent);
+		drbg->jent = NULL;
+		return ret;
+	}
+	drbg->instantiated = true;
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(crypto_drbg_seed, "CRYPTO_INTERNAL");
+
+int crypto_drbg_get_bytes(struct drbg_state *drbg, u8 *out, size_t out_len,
+			  const u8 *addtl, size_t addtl_len)
+{
+	/*
+	 * Break the request into multiple requests if needed, to avoid
+	 * exceeding the maximum request length of the core algorithm.
+	 */
+	while (out_len) {
+		size_t n = min(out_len, DRBG_MAX_REQUEST_BYTES);
+		int err;
+
+		mutex_lock(&drbg->drbg_mutex);
+		err = drbg_generate(drbg, out, n, addtl, addtl_len);
+		mutex_unlock(&drbg->drbg_mutex);
+		if (err < 0)
+			return err;
+		out += n;
+		out_len -= n;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(crypto_drbg_get_bytes, "CRYPTO_INTERNAL");
+
+/* Uninstantiate the DRBG. */
+void crypto_drbg_free(struct drbg_state *drbg)
+{
+	if (!IS_ERR_OR_NULL(drbg)) {
+		mutex_destroy(&drbg->drbg_mutex);
+		crypto_jent_free(drbg->jent);
+		kfree_sensitive(drbg);
+	}
+}
+EXPORT_SYMBOL_NS_GPL(crypto_drbg_free, "CRYPTO_INTERNAL");
+
 /*
  * Tests as defined in 11.3.2 in addition to the cipher tests: testing
  * of the error handling.
diff --git a/crypto/drbg.h b/crypto/drbg.h
new file mode 100644
index 0000000000000..f07a362374043
--- /dev/null
+++ b/crypto/drbg.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright 2026 Google LLC
+ */
+#ifndef _CRYPTO_DRBG_H
+#define _CRYPTO_DRBG_H
+
+#include <linux/types.h>
+
+struct drbg_state;
+
+struct drbg_state *crypto_drbg_alloc(void);
+void crypto_drbg_set_entropy(struct drbg_state *drbg, const u8 *data,
+			     size_t len);
+int crypto_drbg_seed(struct drbg_state *drbg, const u8 *pers, size_t pers_len);
+int crypto_drbg_get_bytes(struct drbg_state *drbg, u8 *out, size_t out_len,
+			  const u8 *addtl, size_t addtl_len);
+void crypto_drbg_free(struct drbg_state *drbg);
+
+#endif /* _CRYPTO_DRBG_H */
-- 
2.56.0

