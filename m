Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676C123ABB1;
	Mon, 30 Jun 2025 17:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751305790; cv=none; b=CYIM0O+0WWPHCwCR+/3NUHfmgHhHg0LXcOVlSyxS5x9bez8FCvqb/vPVz2Mjb6n/kxo4sWK+Um/H2D+ksnIQRDgjO4reHEw/Hdo0Z7WJjX1Z5RCWJP/omcfm8NiU7YHR81XeZMCIrOGgrGbTh66+6trxLT1kzjn0a3RF+WK6OWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751305790; c=relaxed/simple;
	bh=yoi4i5n4fYavqimbjruoWqPfoDDaWyBF/Jq0f8YDWfk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b+kZQWM3s/4j4YMrgMG7UUm1V3MP7RPHrLqwKe6YMvFGlotj8kbVPHU6H8J9L8ZtapWRwpLjiy9Sn0VjsyEHYxxBaGhAKw85YLUGOKhVOiz0932KmlLWJYfZkFO7SrEKxj0M/zFA9UhJLyDXau6Kn6+DCPXEh3I6hwn3VtkYgCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=obBBMxy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="obBBMxy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0854C4CEE3;
	Mon, 30 Jun 2025 17:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751305790;
	bh=yoi4i5n4fYavqimbjruoWqPfoDDaWyBF/Jq0f8YDWfk=;
	h=From:To:Cc:Subject:Date:From;
	b=obBBMxy3BYFAIbQN+AMObBhPvreutHdvFk7yTDY8A+cNTdYBk98gSFqk4GADNqSyd
	 sMZOT50584KhZdRUf44ZW1Ln4r+VePJl3cs+r3TMEZ86ltMHeYenz76amLMVgnU1sG
	 uUHhQM3lFDfFjdY4cSNIc2e+kqdXzmcAoA9V3KIw+OKgTUhXQzUdkXVCKCDNVLZ/Nc
	 7lQs8RZs7Eyc2nNAck9+1lUBJojyJA6vbs05Dr4ipTZRyIUL9R4JlKDwPVuPMHWREr
	 5J7CGBabK0eGVLp/aR6suj+69CAzzk+UZdeSln7gJV51/KAIzejM1eVpjhTQ90eFun
	 gHic5WT98P90g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: apparmor@lists.ubuntu.com,
	John Johansen <john.johansen@canonical.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2] apparmor: use SHA-256 library API instead of crypto_shash API
Date: Mon, 30 Jun 2025 10:48:05 -0700
Message-ID: <20250630174805.59010-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This user of SHA-256 does not support any other algorithm, so the
crypto_shash abstraction provides no value.  Just use the SHA-256
library API instead, which is much simpler and easier to use.

Acked-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This is the slightly revised version of
https://lore.kernel.org/r/20250428190430.850240-1-ebiggers@kernel.org/
that I'm planning to apply to libcrypto-next for 6.17 to avoid a silent
conflict with the sha256_state => sha256_ctx rename, as per the
discussion in that thread.

You can also get this patch and its dependencies from:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git apparmor-sha256-lib-v2

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
index aad486b2fca65..227d47c149074 100644
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
+	struct sha256_ctx sctx;
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
+	sha256_init(&sctx);
+	sha256_update(&sctx, (u8 *)&le32_version, 4);
+	sha256_update(&sctx, (u8 *)start, len);
+	sha256_final(&sctx, profile->hash);
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

base-commit: 1f7eb3c393ab9e56b5746f5fd31796a73bdd4d48
-- 
2.50.0

