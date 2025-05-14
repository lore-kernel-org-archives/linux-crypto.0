Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1F91862BB;
	Wed, 14 May 2025 05:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747199218; cv=none; b=Upuv/dy2jKjCMz15+yHBHXCk3U+b1dnyWWfiizKAmrlVPTIfAMpKu97YbdUS2OGSjOiS3a+lXr9kuncaLZZQAs8hiiEXcXvuO4Z4FillDG2i3u1V9MplfLfVqAojjOmjgGjbhvUTtROGMZUAOXMwAf6WtStpTpRQ8mh45GxJQ7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747199218; c=relaxed/simple;
	bh=k57HVPVcev5O8s0L2S+SuCnpZBmGwPnMelaElVsD2gY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VN7/Aes5S8LoQxTjKWVeAFhAhXGgNiokCUH5bCHvzZzIKza/UK1aaQi6vpOM1Q+j7eWxW5PYmJNaH2qdrLd/tZ9nWYwhf8Yl1znCWCfrX4wrG3Z4MJAEG8a8grcV2yYedXOGd/pCVRcDHjHbu8Op3LcFmomtpesezW3fzRtYQos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sOCKSdm/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sOCKSdm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECC0C4CEEF;
	Wed, 14 May 2025 05:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747199218;
	bh=k57HVPVcev5O8s0L2S+SuCnpZBmGwPnMelaElVsD2gY=;
	h=From:To:Cc:Subject:Date:From;
	b=sOCKSdm/EbTOaGKQu6YlYD8C8zQc/L3CeGPIbHCsKnKlBPgLRzTE5q/SpFdN2A7NC
	 bez8m5il/14xhoHwdzF5fu+kyva73P1i3YiPrTOwt9w0e5DUXNJkBUZdhWDpnGTkwR
	 kUmsyCu44Z6yMKvGieKeNWXivS0J3cvJNHwHlBNkgUdHT6TEiTB4YceT+chFWEOU/a
	 RPkDfpZhvN10IvXkbG4umJGuqj+yDlLxVvtU+JCpkU1cp5gde29kl3M072Lx8dgpxs
	 KCZyTZmpDTjM+HmLwpxptVP+okhWFTN8cOpxqhVYm7yebZTMPYQpnTIuouH/5/CgZU
	 aQ2cEUY9VYqyg==
From: Eric Biggers <ebiggers@kernel.org>
To: Fan Wu <wufan@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E . Hallyn" <serge@hallyn.com>
Cc: linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH] ipe: use SHA-256 library API instead of crypto_shash API
Date: Tue, 13 May 2025 22:05:46 -0700
Message-ID: <20250514050546.155041-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

audit_policy() does not support any other algorithm, so the crypto_shash
abstraction provides no value.  Just use the SHA-256 library API
instead, which is much simpler and easier to use.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 security/ipe/Kconfig |  1 +
 security/ipe/audit.c | 33 +++++----------------------------
 2 files changed, 6 insertions(+), 28 deletions(-)

diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
index 3c75bf267da46..a110a6cd848b7 100644
--- a/security/ipe/Kconfig
+++ b/security/ipe/Kconfig
@@ -4,10 +4,11 @@
 #
 
 menuconfig SECURITY_IPE
 	bool "Integrity Policy Enforcement (IPE)"
 	depends on SECURITY && SECURITYFS && AUDIT && AUDITSYSCALL
+	select CRYPTO_LIB_SHA256
 	select PKCS7_MESSAGE_PARSER
 	select SYSTEM_DATA_VERIFICATION
 	select IPE_PROP_DM_VERITY if DM_VERITY
 	select IPE_PROP_DM_VERITY_SIGNATURE if DM_VERITY && DM_VERITY_VERIFY_ROOTHASH_SIG
 	select IPE_PROP_FS_VERITY if FS_VERITY
diff --git a/security/ipe/audit.c b/security/ipe/audit.c
index 9668ecc5acd53..de5fed62592e1 100644
--- a/security/ipe/audit.c
+++ b/security/ipe/audit.c
@@ -4,22 +4,22 @@
  */
 
 #include <linux/slab.h>
 #include <linux/audit.h>
 #include <linux/types.h>
-#include <crypto/hash.h>
+#include <crypto/sha2.h>
 
 #include "ipe.h"
 #include "eval.h"
 #include "hooks.h"
 #include "policy.h"
 #include "audit.h"
 #include "digest.h"
 
 #define ACTSTR(x) ((x) == IPE_ACTION_ALLOW ? "ALLOW" : "DENY")
 
-#define IPE_AUDIT_HASH_ALG "sha256"
+#define IPE_AUDIT_HASH_ALG "sha256" /* keep in sync with audit_policy() */
 
 #define AUDIT_POLICY_LOAD_FMT "policy_name=\"%s\" policy_version=%hu.%hu.%hu "\
 			      "policy_digest=" IPE_AUDIT_HASH_ALG ":"
 #define AUDIT_POLICY_LOAD_NULL_FMT "policy_name=? policy_version=? "\
 				   "policy_digest=?"
@@ -180,41 +180,18 @@ void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
  */
 static void audit_policy(struct audit_buffer *ab,
 			 const char *audit_format,
 			 const struct ipe_policy *const p)
 {
-	SHASH_DESC_ON_STACK(desc, tfm);
-	struct crypto_shash *tfm;
-	u8 *digest = NULL;
+	u8 digest[SHA256_DIGEST_SIZE];
 
-	tfm = crypto_alloc_shash(IPE_AUDIT_HASH_ALG, 0, 0);
-	if (IS_ERR(tfm))
-		return;
-
-	desc->tfm = tfm;
-
-	digest = kzalloc(crypto_shash_digestsize(tfm), GFP_KERNEL);
-	if (!digest)
-		goto out;
-
-	if (crypto_shash_init(desc))
-		goto out;
-
-	if (crypto_shash_update(desc, p->pkcs7, p->pkcs7len))
-		goto out;
-
-	if (crypto_shash_final(desc, digest))
-		goto out;
+	sha256(p->pkcs7, p->pkcs7len, digest);
 
 	audit_log_format(ab, audit_format, p->parsed->name,
 			 p->parsed->version.major, p->parsed->version.minor,
 			 p->parsed->version.rev);
-	audit_log_n_hex(ab, digest, crypto_shash_digestsize(tfm));
-
-out:
-	kfree(digest);
-	crypto_free_shash(tfm);
+	audit_log_n_hex(ab, digest, sizeof(digest));
 }
 
 /**
  * ipe_audit_policy_activation() - Audit a policy being activated.
  * @op: Supplies a pointer to the previously activated policy to audit.

base-commit: aa94665adc28f3fdc3de2979ac1e98bae961d6ca
-- 
2.49.0

