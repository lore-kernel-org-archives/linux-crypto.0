Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D972192F9;
	Tue,  8 Jul 2025 21:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752011089; cv=none; b=G/qeEDfhLiTtC9wcjCDZ1bVkC9CDdcUJuRgmZjSIw2532M6VxlxfmLkn62RthvSB5WtdmMgShyGxBTekVlJ6gL8ByRzFmMNnXSKCB/utC9v+xZ+kirOQ0A/bDtbeWIP/OyJwy+6GI4IrUwajHIro6N/OPSeJH8+hS2wPUQmhZM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752011089; c=relaxed/simple;
	bh=7Jf91Uu04pu+2C+bUdrSkKkCPNCAdHpoDzfsFFQwnSU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AmT8pn2UNhXKJsH5P8SnBNrg+vNdE7eewn8LsfUsg92IKIJ8TEZRWtCzhJrsJBl/S8J//ChTL3nxmlgi8KESP4awe/rSAsSZWS8HgmwX8Yvva+EaVgUMmRZXBqY9WUJhcBnrwUHAg2ypalEUWRkkAqm7txjMQx8yQx6oVXUSDMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ar3U1XoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ar3U1XoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65905C4CEF1;
	Tue,  8 Jul 2025 21:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752011088;
	bh=7Jf91Uu04pu+2C+bUdrSkKkCPNCAdHpoDzfsFFQwnSU=;
	h=From:To:Cc:Subject:Date:From;
	b=Ar3U1XoXkziTibmwnOYMYVcBQLAdcE080fj9vJ+YXi1hJp2HgB5J5aAK0kd4tQ+FL
	 /5cPMXE/BLXPyY9L6dhk/zrsABU6NSAJ+tMLbeyTO9UdkOQUPX6Udt9ok6BmXeXHdy
	 7fHMF5JmY3mJNs0+DVvb9lw62eE/y4CnZ8zHUlQkUD118FyWpmgZ49vn4GVa0HNy6V
	 vFdzdmITQYFJiQ86ljGe2YFZdtVpdcRTPAswUfXn1Rv48gA8n8Oq+Oc7us0Kkmmla8
	 BhLFgZw0gZkuH39DDkXZEL2H2y92O8ojPT+5d5PIK5YgmMKVJdeOsUMwqxWJEiQ0Uw
	 AylIjmKyJkLqg==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-s390@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.12,6.15] crypto: s390/sha - Fix uninitialized variable in SHA-1 and SHA-2
Date: Tue,  8 Jul 2025 21:44:23 +0000
Message-ID: <20250708214423.3786226-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 68279380266a5fa70e664de754503338e2ec3f43 upstream.

Commit 88c02b3f79a6 ("s390/sha3: Support sha3 performance enhancements")
added the field s390_sha_ctx::first_message_part and made it be used by
s390_sha_update() (now s390_sha_update_blocks()).  At the time,
s390_sha_update() was used by all the s390 SHA-1, SHA-2, and SHA-3
algorithms.  However, only the initialization functions for SHA-3 were
updated, leaving SHA-1 and SHA-2 using first_message_part uninitialized.

This could cause e.g. the function code CPACF_KIMD_SHA_512 |
CPACF_KIMD_NIP to be used instead of just CPACF_KIMD_SHA_512.  This
apparently was harmless, as the SHA-1 and SHA-2 function codes ignore
CPACF_KIMD_NIP; it is recognized only by the SHA-3 function codes
(https://lore.kernel.org/r/73477fe9-a1dc-4e38-98a6-eba9921e8afa@linux.ibm.com/).
Therefore, this bug was found only when first_message_part was later
converted to a boolean and UBSAN detected its uninitialized use.
Regardless, let's fix this by just initializing to zero.

Note: in 6.16, we need to patch SHA-1, SHA-384, and SHA-512.  In 6.15
and earlier, we'll also need to patch SHA-224 and SHA-256, as they
hadn't yet been librarified (which incidentally fixed this bug).

Fixes: 88c02b3f79a6 ("s390/sha3: Support sha3 performance enhancements")
Cc: stable@vger.kernel.org
Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
Closes: https://lore.kernel.org/r/12740696-595c-4604-873e-aefe8b405fbf@linux.ibm.com
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://lore.kernel.org/r/20250703172316.7914-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/s390/crypto/sha1_s390.c   | 2 ++
 arch/s390/crypto/sha256_s390.c | 3 +++
 arch/s390/crypto/sha512_s390.c | 3 +++
 3 files changed, 8 insertions(+)

diff --git a/arch/s390/crypto/sha1_s390.c b/arch/s390/crypto/sha1_s390.c
index bc3a22704e09..10950953429e 100644
--- a/arch/s390/crypto/sha1_s390.c
+++ b/arch/s390/crypto/sha1_s390.c
@@ -36,10 +36,11 @@ static int s390_sha1_init(struct shash_desc *desc)
 	sctx->state[2] = SHA1_H2;
 	sctx->state[3] = SHA1_H3;
 	sctx->state[4] = SHA1_H4;
 	sctx->count = 0;
 	sctx->func = CPACF_KIMD_SHA_1;
+	sctx->first_message_part = 0;
 
 	return 0;
 }
 
 static int s390_sha1_export(struct shash_desc *desc, void *out)
@@ -60,10 +61,11 @@ static int s390_sha1_import(struct shash_desc *desc, const void *in)
 
 	sctx->count = ictx->count;
 	memcpy(sctx->state, ictx->state, sizeof(ictx->state));
 	memcpy(sctx->buf, ictx->buffer, sizeof(ictx->buffer));
 	sctx->func = CPACF_KIMD_SHA_1;
+	sctx->first_message_part = 0;
 	return 0;
 }
 
 static struct shash_alg alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
diff --git a/arch/s390/crypto/sha256_s390.c b/arch/s390/crypto/sha256_s390.c
index 6f1ccdf93d3e..0204d4bca340 100644
--- a/arch/s390/crypto/sha256_s390.c
+++ b/arch/s390/crypto/sha256_s390.c
@@ -29,10 +29,11 @@ static int s390_sha256_init(struct shash_desc *desc)
 	sctx->state[5] = SHA256_H5;
 	sctx->state[6] = SHA256_H6;
 	sctx->state[7] = SHA256_H7;
 	sctx->count = 0;
 	sctx->func = CPACF_KIMD_SHA_256;
+	sctx->first_message_part = 0;
 
 	return 0;
 }
 
 static int sha256_export(struct shash_desc *desc, void *out)
@@ -53,10 +54,11 @@ static int sha256_import(struct shash_desc *desc, const void *in)
 
 	sctx->count = ictx->count;
 	memcpy(sctx->state, ictx->state, sizeof(ictx->state));
 	memcpy(sctx->buf, ictx->buf, sizeof(ictx->buf));
 	sctx->func = CPACF_KIMD_SHA_256;
+	sctx->first_message_part = 0;
 	return 0;
 }
 
 static struct shash_alg sha256_alg = {
 	.digestsize	=	SHA256_DIGEST_SIZE,
@@ -88,10 +90,11 @@ static int s390_sha224_init(struct shash_desc *desc)
 	sctx->state[5] = SHA224_H5;
 	sctx->state[6] = SHA224_H6;
 	sctx->state[7] = SHA224_H7;
 	sctx->count = 0;
 	sctx->func = CPACF_KIMD_SHA_256;
+	sctx->first_message_part = 0;
 
 	return 0;
 }
 
 static struct shash_alg sha224_alg = {
diff --git a/arch/s390/crypto/sha512_s390.c b/arch/s390/crypto/sha512_s390.c
index 04f11c407763..b53a7793bd24 100644
--- a/arch/s390/crypto/sha512_s390.c
+++ b/arch/s390/crypto/sha512_s390.c
@@ -30,10 +30,11 @@ static int sha512_init(struct shash_desc *desc)
 	*(__u64 *)&ctx->state[10] = SHA512_H5;
 	*(__u64 *)&ctx->state[12] = SHA512_H6;
 	*(__u64 *)&ctx->state[14] = SHA512_H7;
 	ctx->count = 0;
 	ctx->func = CPACF_KIMD_SHA_512;
+	ctx->first_message_part = 0;
 
 	return 0;
 }
 
 static int sha512_export(struct shash_desc *desc, void *out)
@@ -58,10 +59,11 @@ static int sha512_import(struct shash_desc *desc, const void *in)
 	sctx->count = ictx->count[0];
 
 	memcpy(sctx->state, ictx->state, sizeof(ictx->state));
 	memcpy(sctx->buf, ictx->buf, sizeof(ictx->buf));
 	sctx->func = CPACF_KIMD_SHA_512;
+	sctx->first_message_part = 0;
 	return 0;
 }
 
 static struct shash_alg sha512_alg = {
 	.digestsize	=	SHA512_DIGEST_SIZE,
@@ -95,10 +97,11 @@ static int sha384_init(struct shash_desc *desc)
 	*(__u64 *)&ctx->state[10] = SHA384_H5;
 	*(__u64 *)&ctx->state[12] = SHA384_H6;
 	*(__u64 *)&ctx->state[14] = SHA384_H7;
 	ctx->count = 0;
 	ctx->func = CPACF_KIMD_SHA_512;
+	ctx->first_message_part = 0;
 
 	return 0;
 }
 
 static struct shash_alg sha384_alg = {

base-commit: 7b59ab988c01c190f1b528cf750d6f33b738d1e2
-- 
2.50.0.727.gbf7dc18ff4-goog

