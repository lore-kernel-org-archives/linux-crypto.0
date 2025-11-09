Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98332749CB;
	Sun,  9 Nov 2025 23:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762732197; cv=none; b=i8KwpVtsMgi9wKh93GnUBru4vjlbaRjomR1yuFxJZZpk2EAKzpkuZXWWH8AxxoLt+9fCKSYZwE2tFW++1qxt2heiO0R7k7Pi2q07uyTHSXfL3ZyL6tzAW34LdvMb3ASiyYMU6Hm6dIjm01xDo12KCnuXwAhRmVAh2VyAT+B7EWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762732197; c=relaxed/simple;
	bh=Wc6TlqQavzVYtanyrw+qZw+ADFSh9UnmNvIiDQ/B1sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VofbYy/dGL0XiLdig9imcmlS30zO7gZKIjkF1sHcx+KVbAUa66eaIz7dQN8S1QjlzprHxTYRTLJip41t9xbpEyCrV9wo9hKjyEnYlLYqzoeOhio3rDUAtXUmdB9dNOGz1Z4K2nf10qEx95oJDC2f7Xsm0l9RO8d8FXK5nrDITqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f9pErZCU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f9pErZCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7ABC4CEF7;
	Sun,  9 Nov 2025 23:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762732197;
	bh=Wc6TlqQavzVYtanyrw+qZw+ADFSh9UnmNvIiDQ/B1sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9pErZCU3vr/wPmWxMCjMcN5UIoJJKvaV4aok4iQLPiHYK09ywK3sqT/5GlnW6E40
	 zrZ+7Fg5cUYumJ8487nV1zKnE6xRVhI/psbr9H6pjwnLqNBc9noTgL1PkAkpfnHC8Y
	 JuiG7finQtE2EX3QZkvdWZ30PevIqk5tN/qgbF1AZjanbnHkmacbtTq5uL5Mhou3U9
	 8xT1Jqn2ghdqHqjg4f2Ixe0Ulj16OxOBh0duYzhgDN2zjiuqs6ymNDpGQl83BOQ3Zx
	 aOKptcsseS9CGiO2SjCjfniZG29xRshs105B3Wayq2R+J08JXFkvgrtKov19VTKBtu
	 8F/5RXLEuKakA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/9] crypto: polyval - Rename conflicting functions
Date: Sun,  9 Nov 2025 15:47:16 -0800
Message-ID: <20251109234726.638437-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251109234726.638437-1-ebiggers@kernel.org>
References: <20251109234726.638437-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename polyval_init() and polyval_update(), in preparation for adding
library functions with the same name to <crypto/polyval.h>.

Note that polyval-generic.c will be removed later, as it will be
superseded by the library.  This commit just keeps the kernel building
for the initial introduction of the library.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/polyval-generic.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/polyval-generic.c b/crypto/polyval-generic.c
index db8adb56e4ca..fe5b01a4000d 100644
--- a/crypto/polyval-generic.c
+++ b/crypto/polyval-generic.c
@@ -97,21 +97,21 @@ static int polyval_setkey(struct crypto_shash *tfm,
 		return -ENOMEM;
 
 	return 0;
 }
 
-static int polyval_init(struct shash_desc *desc)
+static int polyval_generic_init(struct shash_desc *desc)
 {
 	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
 
 	memset(dctx, 0, sizeof(*dctx));
 
 	return 0;
 }
 
-static int polyval_update(struct shash_desc *desc,
-			 const u8 *src, unsigned int srclen)
+static int polyval_generic_update(struct shash_desc *desc,
+				  const u8 *src, unsigned int srclen)
 {
 	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
 	const struct polyval_tfm_ctx *ctx = crypto_shash_ctx(desc->tfm);
 	u8 tmp[POLYVAL_BLOCK_SIZE];
 
@@ -133,11 +133,11 @@ static int polyval_finup(struct shash_desc *desc, const u8 *src,
 
 	if (len) {
 		u8 tmp[POLYVAL_BLOCK_SIZE] = {};
 
 		memcpy(tmp, src, len);
-		polyval_update(desc, tmp, POLYVAL_BLOCK_SIZE);
+		polyval_generic_update(desc, tmp, POLYVAL_BLOCK_SIZE);
 	}
 	copy_and_reverse(dst, dctx->buffer);
 	return 0;
 }
 
@@ -164,12 +164,12 @@ static void polyval_exit_tfm(struct crypto_shash *tfm)
 	gf128mul_free_4k(ctx->gf128);
 }
 
 static struct shash_alg polyval_alg = {
 	.digestsize	= POLYVAL_DIGEST_SIZE,
-	.init		= polyval_init,
-	.update		= polyval_update,
+	.init		= polyval_generic_init,
+	.update		= polyval_generic_update,
 	.finup		= polyval_finup,
 	.setkey		= polyval_setkey,
 	.export		= polyval_export,
 	.import		= polyval_import,
 	.exit_tfm	= polyval_exit_tfm,
-- 
2.51.2

