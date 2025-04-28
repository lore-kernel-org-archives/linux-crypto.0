Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4504319ABC6;
	Mon, 28 Apr 2025 19:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745867098; cv=none; b=Rf3hQAQYnj19cJP2CSP07flIh93UVBBNSqou9G0qNgOcpXbBmkLum8vlH48ldpw6jGHsKDGZ7UY+bGRGermmoMVKKli3KcN6TGGF1LIRJO6Tp6k78dYpzyirxSU/TOxJo1VEmTFccK1LoNRDSdF5Ff1yn0525E2zKuUztb8ntXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745867098; c=relaxed/simple;
	bh=yd3XTTVHcnpHFArsoHLF/KSZ5TfDWwJCeAmdln9qQkU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M/G6bCopdcDgKTUKTeHIGVK88zvB5+4LPpcIqS3mLYn7BBYwOw7npvAo1HDRruMgMlhnsaVCktgFz5OQJZuhkI2amz9He7dDgHueFeL5iyJe1ObpoG4Fr3w6u2T5i7Xun393w8ReMsDwUWmiOMznBnUgdwifDNBKMOPMfUAQvig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ALJYc9PR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ALJYc9PR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E886C4CEE4;
	Mon, 28 Apr 2025 19:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745867097;
	bh=yd3XTTVHcnpHFArsoHLF/KSZ5TfDWwJCeAmdln9qQkU=;
	h=From:To:Cc:Subject:Date:From;
	b=ALJYc9PR+AUq1lxvddH9AbDiAfljYdiuvDEbETp9zB1F3uSSjOOkV+wbgNTg4eYfu
	 XZRQBn9i9BZ/+YyRZapwV5j6BhmvkzO83Kcq7epw/hPqbeL2zsGaOYdT/KdDmwDvIs
	 nhqApA8jty67E5MhvES4Ktr9Ih1v7zWMTK3Uj5mjrAK8uYOu+5/dR32eZERKpSs+v9
	 43GlLTj6W3H2HBBUSpcTLpoNDVL5edUePZkedWJA+fgB7NF6JTqkyydNCReleYV/sE
	 kpzr0GzI3opXLnT0ZE8fShBuBQG0YQXzesLUXufuRdpbnwYcAOiXbmS6e9mfnjBhHb
	 E1FJS7is8lGuw==
From: Eric Biggers <ebiggers@kernel.org>
To: John Johansen <john.johansen@canonical.com>,
	apparmor@lists.ubuntu.com
Cc: linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH] apparmor: use SHA-256 library API instead of crypto_shash API
Date: Mon, 28 Apr 2025 12:04:30 -0700
Message-ID: <20250428190430.850240-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

This user of SHA-256 does not support any other algorithm, so the
crypto_shash abstraction provides no value.  Just use the SHA-256
library API instead, which is much simpler and easier to use.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

This patch is targeting the apparmor tree for 6.16.

 security/apparmor/Kconfig  |  3 +-
 security/apparmor/crypto.c | 85 ++++++--------------------------------
 2 files changed, 13 insertions(+), 75 deletions(-)

diff --git a/security/apparmor/Kconfig b/security/apparmor/Kconfig
index 64cc3044a42ce..1e3bd44643dac 100644
--- a/security/apparmor/Kconfig
+++ b/security/apparmor/Kconfig
@@ -57,12 +57,11 @@ config SECURITY_APPARMOR_INTROSPECT_POLICY
 	  cpu is paramount.
 
 config SECURITY_APPARMOR_HASH
 	bool "Enable introspection of sha256 hashes for loaded profiles"
 	depends on SECURITY_APPARMOR_INTROSPECT_POLICY
-	select CRYPTO
-	select CRYPTO_SHA256
+	select CRYPTO_LIB_SHA256
 	default y
 	help
 	  This option selects whether introspection of loaded policy
 	  hashes is available to userspace via the apparmor
 	  filesystem. This option provides a light weight means of
diff --git a/security/apparmor/crypto.c b/security/apparmor/crypto.c
index aad486b2fca65..40e17e153f1e5 100644
--- a/security/apparmor/crypto.c
+++ b/security/apparmor/crypto.c
@@ -9,115 +9,54 @@
  * Fns to provide a checksum of policy that has been loaded this can be
  * compared to userspace policy compiles to check loaded policy is what
  * it should be.
  */
 
-#include <crypto/hash.h>
+#include <crypto/sha2.h>
 
 #include "include/apparmor.h"
 #include "include/crypto.h"
 
-static unsigned int apparmor_hash_size;
-
-static struct crypto_shash *apparmor_tfm;
-
 unsigned int aa_hash_size(void)
 {
-	return apparmor_hash_size;
+	return SHA256_DIGEST_SIZE;
 }
 
 char *aa_calc_hash(void *data, size_t len)
 {
-	SHASH_DESC_ON_STACK(desc, apparmor_tfm);
 	char *hash;
-	int error;
-
-	if (!apparmor_tfm)
-		return NULL;
 
-	hash = kzalloc(apparmor_hash_size, GFP_KERNEL);
+	hash = kzalloc(SHA256_DIGEST_SIZE, GFP_KERNEL);
 	if (!hash)
 		return ERR_PTR(-ENOMEM);
 
-	desc->tfm = apparmor_tfm;
-
-	error = crypto_shash_init(desc);
-	if (error)
-		goto fail;
-	error = crypto_shash_update(desc, (u8 *) data, len);
-	if (error)
-		goto fail;
-	error = crypto_shash_final(desc, hash);
-	if (error)
-		goto fail;
-
+	sha256(data, len, hash);
 	return hash;
-
-fail:
-	kfree(hash);
-
-	return ERR_PTR(error);
 }
 
 int aa_calc_profile_hash(struct aa_profile *profile, u32 version, void *start,
 			 size_t len)
 {
-	SHASH_DESC_ON_STACK(desc, apparmor_tfm);
-	int error;
+	struct sha256_state state;
 	__le32 le32_version = cpu_to_le32(version);
 
 	if (!aa_g_hash_policy)
 		return 0;
 
-	if (!apparmor_tfm)
-		return 0;
-
-	profile->hash = kzalloc(apparmor_hash_size, GFP_KERNEL);
+	profile->hash = kzalloc(SHA256_DIGEST_SIZE, GFP_KERNEL);
 	if (!profile->hash)
 		return -ENOMEM;
 
-	desc->tfm = apparmor_tfm;
-
-	error = crypto_shash_init(desc);
-	if (error)
-		goto fail;
-	error = crypto_shash_update(desc, (u8 *) &le32_version, 4);
-	if (error)
-		goto fail;
-	error = crypto_shash_update(desc, (u8 *) start, len);
-	if (error)
-		goto fail;
-	error = crypto_shash_final(desc, profile->hash);
-	if (error)
-		goto fail;
-
+	sha256_init(&state);
+	sha256_update(&state, (u8 *)&le32_version, 4);
+	sha256_update(&state, (u8 *)start, len);
+	sha256_final(&state, profile->hash);
 	return 0;
-
-fail:
-	kfree(profile->hash);
-	profile->hash = NULL;
-
-	return error;
 }
 
 static int __init init_profile_hash(void)
 {
-	struct crypto_shash *tfm;
-
-	if (!apparmor_initialized)
-		return 0;
-
-	tfm = crypto_alloc_shash("sha256", 0, 0);
-	if (IS_ERR(tfm)) {
-		int error = PTR_ERR(tfm);
-		AA_ERROR("failed to setup profile sha256 hashing: %d\n", error);
-		return error;
-	}
-	apparmor_tfm = tfm;
-	apparmor_hash_size = crypto_shash_digestsize(apparmor_tfm);
-
-	aa_info_message("AppArmor sha256 policy hashing enabled");
-
+	if (apparmor_initialized)
+		aa_info_message("AppArmor sha256 policy hashing enabled");
 	return 0;
 }
-
 late_initcall(init_profile_hash);

base-commit: 33035b665157558254b3c21c3f049fd728e72368
-- 
2.49.0

