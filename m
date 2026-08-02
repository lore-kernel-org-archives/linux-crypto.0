Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD63F33B6D6;
	Sun,  2 Aug 2026 23:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785711724; cv=none; b=C3fMzWzPISyv3e5x/Ob2o4aQ8Xl+vF0sbkLOB/ngyWjDqyqf4mTBiLqR9p9BLoDG5BQSgEbKbCUyYSF1afBU+ILLgF/8OPfZo8a/N3UvIkVu9lRobDxwWxPbceJ4MYEsp8tS8i6pOsLCecjB/2A5/JF2LdLBy/nG4LWLdS/ory8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785711724; c=relaxed/simple;
	bh=HpmGyOC5i+V9OsGBPyzzkUSXu/sFkWbNfcFFPKqkzAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=droOQSrWQ90G87P+NIfc8CietrnltNJroGBL+rca0o3+TkH2C/HnFYywV91Kt4qpDFZuYV0Lq/H0jwYqgMbLh3e2PLngFyzrSgCLvgo2AE/mxFX/W0wIZBn7c2o95jJkbfb/z1Vn5ENkOyc0jvyKdk+jCblqAfOcKLOG5RsrXpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n5UX3XSU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n5UX3XSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EAE71F00A3F;
	Sun,  2 Aug 2026 23:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785711723;
	bh=KaAPm6xsRE/SAQjze+2Z5h80E28qgp02afNZXVMba84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n5UX3XSUbyNqQpZZsoLg+Z+Z/MK5FKmBjsU8kQxQVrrUWDiROpnjcZIVhg1O7Z27d
	 lJxhu7v5rb6clL9oCtr9yNB+LMkvyTgqCLYavj0giQyHLM1+JrQsv9cbaLKazsdSw8
	 R22NPPnVGYLQBHB+hrXnVFYN+fAfKHDIMkXSbdIsIRoTCjHqgsfxUTE5LEvqrIcADM
	 BeeDhB8zGEpRupt4hahfO4zAe77qZlT5GLvLBfb+5sPwXosTpZRjbRkC4dIUwNGQ5+
	 rJSPCK+cbGx2B6J4e6OvrgO4kLW1kU8KCZbgH8S7mQ+2Xkvn4uZn9gFAc9Qt1U32ib
	 ASpu437XWF3KQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Richard Weinberger <richard@nod.at>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/3] crypto: af_alg - Replace 'bool privileged' with flags
Date: Sun,  2 Aug 2026 16:00:54 -0700
Message-ID: <20260802230055.100746-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260802230055.100746-1-ebiggers@kernel.org>
References: <20260802230055.100746-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It isn't obvious what false/true mean at the definition sites, so let's
replace it with flags instead.  Also flip the polarity to make the
default zero-initialized value be the secure (privileged-only) value.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/af_alg.c         |  3 ++-
 crypto/algif_aead.c     |  2 +-
 crypto/algif_hash.c     | 28 ++++++++++++++--------------
 crypto/algif_skcipher.c | 28 ++++++++++++++--------------
 include/crypto/if_alg.h |  6 +++++-
 5 files changed, 36 insertions(+), 31 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 34b801568fba..1e5da61b315c 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -146,7 +146,8 @@ int af_alg_check_restriction(const char *name,
 		for (const struct af_alg_allowlist_entry *ent = allowlist;
 		     ent->name; ent++) {
 			if (strcmp(name, ent->name) == 0 &&
-			    (!ent->privileged || af_alg_capable()))
+			    ((ent->flags & AF_ALG_UNPRIVILEGED) ||
+			     af_alg_capable()))
 				return 0;
 		}
 	}
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index b9217f9086aa..5574e2d70539 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -35,7 +35,7 @@
 #include <net/sock.h>
 
 static const struct af_alg_allowlist_entry aead_allowlist[] = {
-	{ "ccm(aes)", true }, /* bluez */
+	{ "ccm(aes)" }, /* bluez */
 	{},
 };
 
diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index a8d958d51ece..6e8b5fb82a7f 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -17,20 +17,20 @@
 #include <net/sock.h>
 
 static const struct af_alg_allowlist_entry hash_allowlist[] = {
-	{ "cmac(aes)", true }, /* iwd, bluez */
-	{ "hmac(md5)", true }, /* iwd */
-	{ "hmac(sha1)", true }, /* iwd */
-	{ "hmac(sha224)", true }, /* iwd */
-	{ "hmac(sha256)", true }, /* iwd */
-	{ "hmac(sha384)", true }, /* iwd */
-	{ "hmac(sha512)", true }, /* iwd, sha512hmac */
-	{ "md4", true }, /* iwd */
-	{ "md5", true }, /* iwd */
-	{ "sha1", false }, /* iwd, iproute2 < 7.0 */
-	{ "sha224", true }, /* iwd */
-	{ "sha256", true }, /* iwd */
-	{ "sha384", true }, /* iwd */
-	{ "sha512", true }, /* iwd */
+	{ "cmac(aes)" }, /* iwd, bluez */
+	{ "hmac(md5)" }, /* iwd */
+	{ "hmac(sha1)" }, /* iwd */
+	{ "hmac(sha224)" }, /* iwd */
+	{ "hmac(sha256)" }, /* iwd */
+	{ "hmac(sha384)" }, /* iwd */
+	{ "hmac(sha512)" }, /* iwd, sha512hmac */
+	{ "md4" }, /* iwd */
+	{ "md5" }, /* iwd */
+	{ "sha1", AF_ALG_UNPRIVILEGED }, /* iwd, iproute2 < 7.0 */
+	{ "sha224" }, /* iwd */
+	{ "sha256" }, /* iwd */
+	{ "sha384" }, /* iwd */
+	{ "sha512" }, /* iwd */
 	{},
 };
 
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 68b48d805e92..1e61fe6e24b9 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -36,20 +36,20 @@
 #include <net/sock.h>
 
 static const struct af_alg_allowlist_entry skcipher_allowlist[] = {
-	{ "adiantum(xchacha12,aes)", false }, /* cryptsetup */
-	{ "adiantum(xchacha20,aes)", false }, /* cryptsetup */
-	{ "cbc(aes)", true }, /* iwd */
-	{ "cbc(des)", true }, /* iwd */
-	{ "cbc(des3_ede)", true }, /* iwd */
-	{ "cbc(paes)", true }, /* caam and others */
-	{ "ctr(aes)", true }, /* iwd */
-	{ "ecb(aes)", true }, /* iwd, bluez */
-	{ "ecb(des)", true }, /* iwd */
-	{ "hctr2(aes)", false }, /* cryptsetup */
-	{ "xts(aes)", false }, /* cryptsetup benchmark */
-	{ "xts(camellia)", false }, /* cryptsetup */
-	{ "xts(serpent)", false }, /* cryptsetup */
-	{ "xts(twofish)", false }, /* cryptsetup */
+	{ "adiantum(xchacha12,aes)", AF_ALG_UNPRIVILEGED }, /* cryptsetup */
+	{ "adiantum(xchacha20,aes)", AF_ALG_UNPRIVILEGED }, /* cryptsetup */
+	{ "cbc(aes)" }, /* iwd */
+	{ "cbc(des)" }, /* iwd */
+	{ "cbc(des3_ede)" }, /* iwd */
+	{ "cbc(paes)" }, /* caam and others */
+	{ "ctr(aes)" }, /* iwd */
+	{ "ecb(aes)" }, /* iwd, bluez */
+	{ "ecb(des)" }, /* iwd */
+	{ "hctr2(aes)", AF_ALG_UNPRIVILEGED }, /* cryptsetup */
+	{ "xts(aes)", AF_ALG_UNPRIVILEGED }, /* cryptsetup benchmark */
+	{ "xts(camellia)", AF_ALG_UNPRIVILEGED }, /* cryptsetup */
+	{ "xts(serpent)", AF_ALG_UNPRIVILEGED }, /* cryptsetup */
+	{ "xts(twofish)", AF_ALG_UNPRIVILEGED }, /* cryptsetup */
 	{},
 };
 
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index dbf6a97c72a2..0d51428c1da4 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -8,6 +8,7 @@
 #ifndef _CRYPTO_IF_ALG_H
 #define _CRYPTO_IF_ALG_H
 
+#include <linux/bits.h>
 #include <linux/compiler.h>
 #include <linux/completion.h>
 #include <linux/if_alg.h>
@@ -161,9 +162,12 @@ struct af_alg_ctx {
 	unsigned int inflight;
 };
 
+/* Flags for af_alg_allowlist_entry::flags: */
+#define AF_ALG_UNPRIVILEGED BIT(0) /* Unprivileged use is allowed */
+
 struct af_alg_allowlist_entry {
 	const char *name;
-	bool privileged;
+	u32 flags;
 };
 
 int af_alg_register_type(const struct af_alg_type *type);
-- 
2.55.0

