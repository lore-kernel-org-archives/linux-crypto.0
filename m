Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F764502A;
	Fri, 27 Jun 2025 18:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751050710; cv=none; b=SUBXmbPQY1ywa8Ik/zPnW8kytWHu0Pchh/waN/NUNzJE5BtWB11j6x0QWo/t4qUvmzv9YBOwKDIfcO19gF+9dYl3XJChXCuT+nWw4f0rmKS0zVe8x6BU47/QXJ2pItWh/L3Fj+Kh24aE8+8Mb+CqHkynwgoJ1eQ2aNzvAdDU5iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751050710; c=relaxed/simple;
	bh=9RDwtHBhtKqPblXPI9Fl8+SOfUWmVmsCQUmrhnB+dXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dnw2CoFHg0aNJ3SlpZ80xXWpXwMQZ+kUynaIUS34eQO3LpCoNiv5Oo7Wh5nmlvxZT4+Q5EZrrWrMN/FNWo6h7pnPTALW6jnAYxN/7LmomFQZNDhFWe6I7AG6idHW5br8BRn1H4E4gwDBUxFnRuvXHUDIv1m2cNI4UMWzWlUHmIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K8B8+Fbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K8B8+Fbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCD9C4CEE3;
	Fri, 27 Jun 2025 18:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751050710;
	bh=9RDwtHBhtKqPblXPI9Fl8+SOfUWmVmsCQUmrhnB+dXQ=;
	h=From:To:Cc:Subject:Date:From;
	b=K8B8+Fbv7KXzak+U3czwcfQhzenUICqY1D1SNkNyEBEVO8dWtodGLnYZc/2yTKvdL
	 3XLV+AE++myPPGNeWKzP583+2086g1bo25VwRU964W6u47ykRh/0S12m662cX1XDFJ
	 bvG6rslCukIPs3KEzU5dcZsnstElmkvBDVhslAbvTH40bcF1A5SJEA3AggAdMuIbJq
	 a24jq0Ch4UnNaPoS+sDFbp8SL/uGM5MU3Z6yQOdxhG0lFRzpfLe1Z4J6YrErMNnHcX
	 zMasnhAnR615OWywI09i0qUKSIhqdv5bvkWgkGv2RGQT3/X3i06Vw+omFnBI3Bx+bw
	 KVTkhIUq38keg==
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
Subject: [PATCH] crypto: s390/sha - Fix uninitialized variable in SHA-1 and SHA-2
Date: Fri, 27 Jun 2025 11:56:49 -0700
Message-ID: <20250627185649.35321-1-ebiggers@kernel.org>
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
s390_sha_update_blocks().  At the time, s390_sha_update_blocks() was
used by all the s390 SHA-1, SHA-2, and SHA-3 algorithms.  However, only
the initialization functions for SHA-3 were updated, leaving SHA-1 and
SHA-2 using first_message_part uninitialized.

This could cause e.g. CPACF_KIMD_SHA_512 | CPACF_KIMD_NIP to be used
instead of just CPACF_KIMD_NIP.  It's unclear why this didn't cause a
problem earlier; this bug was found only when UBSAN detected the
uninitialized boolean.  Perhaps the CPU ignores CPACF_KIMD_NIP for SHA-1
and SHA-2.  Regardless, let's fix this.  For now just initialize to
false, i.e. don't try to "optimize" the SHA state initialization.

Note: in 6.16, we need to patch SHA-1, SHA-384, and SHA-512.  In 6.15
and earlier, we'll also need to patch SHA-224 and SHA-256, as they
hadn't yet been librarified (which incidentally fixed this bug).

Fixes: 88c02b3f79a6 ("s390/sha3: Support sha3 performance enhancements")
Cc: stable@vger.kernel.org
Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
Closes: https://lore.kernel.org/r/12740696-595c-4604-873e-aefe8b405fbf@linux.ibm.com
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This is targeting 6.16.  I'd prefer to take this through
libcrypto-fixes, since the librarification work is also touching this
area.  But let me know if there's a preference for the crypto tree or
the s390 tree instead.

 arch/s390/crypto/sha1_s390.c   | 1 +
 arch/s390/crypto/sha512_s390.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/s390/crypto/sha1_s390.c b/arch/s390/crypto/sha1_s390.c
index d229cbd2ba229..73672e76a88f9 100644
--- a/arch/s390/crypto/sha1_s390.c
+++ b/arch/s390/crypto/sha1_s390.c
@@ -36,10 +36,11 @@ static int s390_sha1_init(struct shash_desc *desc)
 	sctx->state[2] = SHA1_H2;
 	sctx->state[3] = SHA1_H3;
 	sctx->state[4] = SHA1_H4;
 	sctx->count = 0;
 	sctx->func = CPACF_KIMD_SHA_1;
+	sctx->first_message_part = false;
 
 	return 0;
 }
 
 static int s390_sha1_export(struct shash_desc *desc, void *out)
diff --git a/arch/s390/crypto/sha512_s390.c b/arch/s390/crypto/sha512_s390.c
index 33711a29618c3..e9e112025ff22 100644
--- a/arch/s390/crypto/sha512_s390.c
+++ b/arch/s390/crypto/sha512_s390.c
@@ -30,10 +30,11 @@ static int sha512_init(struct shash_desc *desc)
 	ctx->sha512.state[6] = SHA512_H6;
 	ctx->sha512.state[7] = SHA512_H7;
 	ctx->count = 0;
 	ctx->sha512.count_hi = 0;
 	ctx->func = CPACF_KIMD_SHA_512;
+	ctx->first_message_part = false;
 
 	return 0;
 }
 
 static int sha512_export(struct shash_desc *desc, void *out)
@@ -95,10 +96,11 @@ static int sha384_init(struct shash_desc *desc)
 	ctx->sha512.state[6] = SHA384_H6;
 	ctx->sha512.state[7] = SHA384_H7;
 	ctx->count = 0;
 	ctx->sha512.count_hi = 0;
 	ctx->func = CPACF_KIMD_SHA_512;
+	ctx->first_message_part = false;
 
 	return 0;
 }
 
 static struct shash_alg sha384_alg = {

base-commit: e540341508ce2f6e27810106253d5de194b66750
-- 
2.50.0

