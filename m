Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAED4582DC;
	Tue, 29 Sep 2026 22:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790720913; cv=none; b=M+9lc6hM6/dJlkqIjlwdjb3quF8S56DICGxckvFjcJK4pUG0350gzjFAFYMerItrETahUKWUk4aWiw6LYJHdGQ012+g7rjvlGBb0GL/MWB/QdoFY/TuK8dYnATfY8iSYuruTrhhs1h4wp9K6lyGDjmEB4fJg1WEf9W4vCjJYBUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790720913; c=relaxed/simple;
	bh=HICilK2qBUmcQw3dKJAn48mP2HaeF31VHil5ewha7lk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kF2v+I4b1ibDvpdPTdGavsOK5bXdOQ21kA/WuYlqdDOeGszBNy0pvYr2Kzi5fezSfT4qCVCPcPLt2SFUIQJacD1daauEzXnw66thhyE9st3bksvJxpGu8fv4r2pR6awqqQ7uCQQFCqyJlZvPXrJ1wPwd0DNJSRW9ceCve7qI614=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dPqGydfc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dPqGydfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8221F000FF;
	Tue, 29 Sep 2026 22:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790720911;
	bh=yTXe4WKxmhZ5mHyk/oIcjQ85h1OJ6xagE2yWgHSIDms=;
	h=From:To:Cc:Subject:Date;
	b=dPqGydfcttP1NDSDKWB9RVAVx+22ck9bc3uL2hVZ9SqTaOcLmsnhpeYRYVjxQcxM+
	 mO71SQgu+zrW7Lo3pizwHFolqdhaQM3l+oT7U0Lg2/e82e7P7m/wMnV/d1TZ+f36jF
	 cWz8RsUWnNuqYWB4QuwOwxHTIo2xGZdtLR8SUjOYnijGrj81YByGqJRzEPhXojVcTF
	 ifaQKzufNE16bcZCBaPJ5eZImyWPr1J+q/Ck5TvivYRy9xq9nKItS3L49OCGavNV3o
	 wPPXUWs/vecF8Q6Uu0Mi9ZJx5nMF4xyMQHiFrzuC/g6bB9HTqKRKpUje+4Eq8pvDy4
	 /Rpsun92+8SUA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stian Halseth <stian@itx.no>,
	sparclinux@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3] crypto: aes - Fix undesired override of some optimized AES modes
Date: Tue, 29 Sep 2026 15:27:52 -0700
Message-ID: <20260929222752.36427-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The new library APIs for AES encryption modes were wired up to the
traditional crypto API via crypto/aes.c.  However, for now the kernel is
still in a transitional state where various architectures still have
architecture-optimized implementations of AES modes in arch/*/crypto/,
wired up to the traditional crypto API only.  Because of that, the
crypto/aes.c algorithms were given a cra_priority of only 110 to prevent
them from overriding arch/*/crypto/ in the traditional crypto API.

However, because of how the traditional crypto API works, the
cra_priority trick doesn't work in cases where the relevant algorithm
isn't directly implemented by arch/*/crypto/ but rather is provided by a
template instance using other code in arch/*/crypto/.

For example, x86 doesn't have its own "ccm(aes)" but rather relies on
the "ccm" template constructing it from the x86-optimized "ctr(aes)".
The existence of the library-based "ccm(aes)" prevents that, even though
its priority is lower than what the template would produce.

Thus, "ccm(aes)" ends up using the slower single-block AES code.

Therefore, skip wiring up the relevant library-based code to the
traditional crypto API on architectures where this problem can occur, as
determined by what exists in arch/*/crypto/ for each architecture.

This is ugly, but it's also temporary: these conditions will go away as
architecture-optimized implementations of AES modes are migrated into
the library.  But until then, we need to prevent performance regressions
by ensuring that the optimized code continues to be used.

Fixes: 20df21a482aa ("crypto: aes - Add CBC and CBC-CTS support using library")
Fixes: 8ca62072faa1 ("crypto: aes - Add GCM support using library")
Fixes: f70ad727d1d6 ("crypto: aes - Add CCM support using library")
Fixes: 94efa0c9fb36 ("crypto: aes - Add XTS support using library")
Closes: https://github.com/sparclinux/issues/issues/106
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is intended to taken through libcrypto-fixes

v3: Also suppress xts(aes) on SPARC, and improved comments
v2: Fixed PowerPC config option, and resent as standalone patch

 crypto/aes.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 47 insertions(+), 4 deletions(-)

diff --git a/crypto/aes.c b/crypto/aes.c
index 94791f481e98..51eee78396ea 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -637,7 +637,18 @@ static struct skcipher_alg skcipher_algs[] = {
 		.decrypt = crypto_aes_cbc_decrypt,
 	},
 #endif
-#if IS_ENABLED(CONFIG_CRYPTO_CTS)
+	/*
+	 * Don't register library-based "cts(cbc(aes))" on architectures where
+	 * it might block a "better" implementation from being instantiated via
+	 * the "cts" template.  These exclusions are temporary and will go away
+	 * as the arch-optimized AES code is migrated into the library.
+	 */
+#if IS_ENABLED(CONFIG_CRYPTO_CTS) && \
+	!(IS_ENABLED(CONFIG_ARM) || \
+	  IS_ENABLED(CONFIG_ARM64) || \
+	  IS_ENABLED(CONFIG_PPC) || \
+	  IS_ENABLED(CONFIG_S390) || \
+	  IS_ENABLED(CONFIG_SPARC))
 	{
 		.base.cra_name = "cts(cbc(aes))",
 		.base.cra_driver_name = "cts-cbc-aes-lib",
@@ -687,7 +698,13 @@ static struct skcipher_alg skcipher_algs[] = {
 		.decrypt = crypto_aes_xctr_crypt,
 	},
 #endif
-#if IS_ENABLED(CONFIG_CRYPTO_XTS)
+	/*
+	 * Don't register library-based "xts(aes)" on architectures where it
+	 * might block a "better" implementation from being instantiated via the
+	 * "xts" template.  This exclusion is temporary and will go away when
+	 * the library AES-XTS is optimized for SPARC.
+	 */
+#if IS_ENABLED(CONFIG_CRYPTO_XTS) && !IS_ENABLED(CONFIG_SPARC)
 	{
 		.base.cra_name = "xts(aes)",
 		.base.cra_driver_name = "xts-aes-lib",
@@ -980,7 +997,20 @@ static __maybe_unused int crypto_aes_ccm_decrypt(struct aead_request *req)
 }
 
 static struct aead_alg aead_algs[] = {
-#if IS_ENABLED(CONFIG_CRYPTO_GCM)
+	/*
+	 * Don't register library-based "gcm(aes)" and "rfc4106(gcm(aes))" on
+	 * architectures where they might block a "better" implementation from
+	 * being instantiated via the "gcm" and "rfc4106" templates.  These
+	 * exclusions are temporary and will go away as the arch-optimized AES
+	 * code is migrated into the library.
+	 */
+#if IS_ENABLED(CONFIG_CRYPTO_GCM) && \
+	!(IS_ENABLED(CONFIG_ARM) || \
+	  IS_ENABLED(CONFIG_ARM64) || \
+	  IS_ENABLED(CONFIG_PPC) || \
+	  IS_ENABLED(CONFIG_RISCV) || \
+	  IS_ENABLED(CONFIG_S390) || \
+	  IS_ENABLED(CONFIG_SPARC))
 	{
 		.base.cra_name = "gcm(aes)",
 		.base.cra_driver_name = "gcm-aes-lib",
@@ -1012,7 +1042,20 @@ static struct aead_alg aead_algs[] = {
 		.chunksize = AES_BLOCK_SIZE,
 	},
 #endif /* CONFIG_CRYPTO_GCM */
-#if IS_ENABLED(CONFIG_CRYPTO_CCM)
+	/*
+	 * Don't register library-based "ccm(aes)" on architectures where it
+	 * might block a "better" implementation from being instantiated via the
+	 * "ccm" template.  These exclusions are temporary and will go away as
+	 * the arch-optimized AES code is migrated into the library.
+	 */
+#if IS_ENABLED(CONFIG_CRYPTO_CCM) && \
+	!(IS_ENABLED(CONFIG_ARM) || \
+	  IS_ENABLED(CONFIG_ARM64) || \
+	  IS_ENABLED(CONFIG_PPC) || \
+	  IS_ENABLED(CONFIG_RISCV) || \
+	  IS_ENABLED(CONFIG_S390) || \
+	  IS_ENABLED(CONFIG_SPARC) || \
+	  IS_ENABLED(CONFIG_X86))
 	{
 		.base.cra_name = "ccm(aes)",
 		.base.cra_driver_name = "ccm-aes-lib",

base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
2.55.0

