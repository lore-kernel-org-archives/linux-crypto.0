Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502CB288C8E;
	Thu,  3 Jul 2025 17:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751563507; cv=none; b=asDjqt1vkONhJNZa0gJZlqbFs9p68W0gmKo4xdXgWEx82CIN5EWdimfnjVAP7uSrIogxOg7jf3gpt5K4E6IX2xo2+EMM63Rs2NPSMTM4gvFi8HQajdqsrjRdeyW8LrPQXDFrLdpE2RGCF+mhI2SWduN7WKJ7lYNEdqgas2Z45PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751563507; c=relaxed/simple;
	bh=A15z3AA71ydQ9j/FLKzepHpNvIVkbCiQdVaADIO/60w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k/O1zvMYgzr/8mGwHp95MfcGYIr/gw7tz8jeidMcabFUVQwfOt8bi5yrTuUAelKrWuh4H6uZnGStFggNWiGzzQvQ7sHp8zTTfWO/rbJ18ObG1oHUVUvk8U4OJUKVIgc9Yu5ugu/QcjeHYZ+a3kaGYhO9rrA1q74R7TzP5KVZpk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m16XJT2h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m16XJT2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5E4C4CEE3;
	Thu,  3 Jul 2025 17:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751563506;
	bh=A15z3AA71ydQ9j/FLKzepHpNvIVkbCiQdVaADIO/60w=;
	h=From:To:Cc:Subject:Date:From;
	b=m16XJT2hqQXJpfk5u6m0DE15gcd5YTtkSD+i3RI3aspNCD9Hdp3X9B6oHk1MjQMlQ
	 +8PRfaqvLo4KYeALIcvvunkm63qf+hNd5xyFLykaUZ3kYTJykD1RUob4u+DBu0zUlJ
	 gURZrBgB9uKoi1HPNQPBgLc06r0aI4oGW9B27UVbFmiVTvysEDNdRAZueoloOvS4P2
	 vLmlVFSMEqo31PoSrCCH8Q6nxYjnxrbE/1RVV4WoAbw9XjR/ZGmSlBJrO3rxh2wyPU
	 mtQoVh7n0TrfM1yPRrNWXW/hden970MiDJmUq3aD1D8MpxPvbrSOIUep3LWvP6v9K6
	 5XWOvhVLo9WNA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Joerg Schmidbauer <jschmidb@de.ibm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org,
	Ingo Franzki <ifranzki@linux.ibm.com>
Subject: [PATCH v2] crypto: s390/sha - Fix uninitialized variable in SHA-1 and SHA-2
Date: Thu,  3 Jul 2025 10:23:16 -0700
Message-ID: <20250703172316.7914-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

v2:
  - Also fix s390_sha1_import() and sha512_import()
  - Use 0 instead of false
  - Improved commit message

 arch/s390/crypto/sha1_s390.c   | 2 ++
 arch/s390/crypto/sha512_s390.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/arch/s390/crypto/sha1_s390.c b/arch/s390/crypto/sha1_s390.c
index d229cbd2ba229..9b0d55be12394 100644
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
@@ -58,10 +59,11 @@ static int s390_sha1_import(struct shash_desc *desc, const void *in)
 	const struct sha1_state *ictx = in;
 
 	sctx->count = ictx->count;
 	memcpy(sctx->state, ictx->state, sizeof(ictx->state));
 	sctx->func = CPACF_KIMD_SHA_1;
+	sctx->first_message_part = 0;
 	return 0;
 }
 
 static struct shash_alg alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
diff --git a/arch/s390/crypto/sha512_s390.c b/arch/s390/crypto/sha512_s390.c
index 33711a29618c3..6cbbf5e8555f8 100644
--- a/arch/s390/crypto/sha512_s390.c
+++ b/arch/s390/crypto/sha512_s390.c
@@ -30,10 +30,11 @@ static int sha512_init(struct shash_desc *desc)
 	ctx->sha512.state[6] = SHA512_H6;
 	ctx->sha512.state[7] = SHA512_H7;
 	ctx->count = 0;
 	ctx->sha512.count_hi = 0;
 	ctx->func = CPACF_KIMD_SHA_512;
+	ctx->first_message_part = 0;
 
 	return 0;
 }
 
 static int sha512_export(struct shash_desc *desc, void *out)
@@ -55,10 +56,11 @@ static int sha512_import(struct shash_desc *desc, const void *in)
 	sctx->count = ictx->count[0];
 	sctx->sha512.count_hi = ictx->count[1];
 
 	memcpy(sctx->state, ictx->state, sizeof(ictx->state));
 	sctx->func = CPACF_KIMD_SHA_512;
+	sctx->first_message_part = 0;
 	return 0;
 }
 
 static struct shash_alg sha512_alg = {
 	.digestsize	=	SHA512_DIGEST_SIZE,
@@ -95,10 +97,11 @@ static int sha384_init(struct shash_desc *desc)
 	ctx->sha512.state[6] = SHA384_H6;
 	ctx->sha512.state[7] = SHA384_H7;
 	ctx->count = 0;
 	ctx->sha512.count_hi = 0;
 	ctx->func = CPACF_KIMD_SHA_512;
+	ctx->first_message_part = 0;
 
 	return 0;
 }
 
 static struct shash_alg sha384_alg = {

base-commit: 64f7548aad63d2fbca2eeb6eb33361c218ebd5a5
-- 
2.50.0

