Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD22A322DD0;
	Mon, 12 Jan 2026 19:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768245813; cv=none; b=e8+hn3hZao3yhs8A8xW7S5nI1YuUGl9qsjH8wNvV3yP8j/hvQ/5FW4ZTkXLXhCiZFEy2Z7idDjA+Gqp3fSWEPulWJWoFl7zqYBCPHHGU5PpfgKxZk9V9pYDBQi1ebzIni1QEh9BG4fplufKqGoe85dAxuwEO0AHCqzuGPEeRbZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768245813; c=relaxed/simple;
	bh=GPQcbp+wkmbK7/Rcub4Dq0N8RBzNaIdUT4Zzk3rORWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePbB/iBDpMrQ+guJHAp8ZEFilHC/BckwOboZ5z5tzpVA1/ZEAmNHPda3LI6zsEtbsnegkfJJFX2v75tX00tfqzWvZJG88eS/lyYKPydEC9Q8N+H9aMUHwDpUkSyxpb4mc2l3I/PaiOf2Nf5hWMB62tzYHT6BleZsfFNsmvag12Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SmkNXd0h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SmkNXd0h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF904C2BC86;
	Mon, 12 Jan 2026 19:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768245813;
	bh=GPQcbp+wkmbK7/Rcub4Dq0N8RBzNaIdUT4Zzk3rORWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SmkNXd0hD/a01rRbzRoTIUUxSVbiJvtS+SpBFPSqlginPRz7r1QpIVUkNBhUwlClB
	 wu7xWBaWVGiKfKI9UnXxuZtlKeU8IiiMoqEFFelz3rk02+N6/Ank4/srRBvn70In9G
	 TW3YnOBfyBvX8uDGz5ETCyjwSMU7T2kILTMPcTbBiDJx863zpNVbcPeU2e8YeqUDme
	 OKVwnwn6rI4vz1BrTpM6yj2boVtQGcfUBLdrDX6PC76mEZZDQv8p+qcrg9dMkE9RcZ
	 2/n/32QyL0RrxoLGdj2WxAIAMcosZ6xQGFyXIiGN3aSSA9+IaoKihFMAyf5aRVrEQR
	 cNQ3vcNviQ8PQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 28/35] crypto: crypto4xx - Use new AES library API
Date: Mon, 12 Jan 2026 11:20:26 -0800
Message-ID: <20260112192035.10427-29-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260112192035.10427-1-ebiggers@kernel.org>
References: <20260112192035.10427-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Switch from the old AES library functions (which use struct
crypto_aes_ctx) to the new ones (which use struct aes_enckey).  This
eliminates the unnecessary computation and caching of the decryption
round keys.  The new AES en/decryption functions are also much faster
and use AES instructions when supported by the CPU.

Note that in addition to the change in the key preparation function and
the key struct type itself, the change in the type of the key struct
results in aes_encrypt() (which is temporarily a type-generic macro)
calling the new encryption function rather than the old one.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/crypto/amcc/crypto4xx_alg.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index 38e8a61e9166..3177dc4f5f7b 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -489,23 +489,23 @@ static int crypto4xx_aes_gcm_validate_keylen(unsigned int keylen)
 }
 
 static int crypto4xx_compute_gcm_hash_key_sw(__le32 *hash_start, const u8 *key,
 					     unsigned int keylen)
 {
-	struct crypto_aes_ctx ctx;
+	struct aes_enckey aes;
 	uint8_t src[16] = { 0 };
 	int rc;
 
-	rc = aes_expandkey(&ctx, key, keylen);
+	rc = aes_prepareenckey(&aes, key, keylen);
 	if (rc) {
-		pr_err("aes_expandkey() failed: %d\n", rc);
+		pr_err("aes_prepareenckey() failed: %d\n", rc);
 		return rc;
 	}
 
-	aes_encrypt(&ctx, src, src);
+	aes_encrypt(&aes, src, src);
 	crypto4xx_memcpy_to_le32(hash_start, src, 16);
-	memzero_explicit(&ctx, sizeof(ctx));
+	memzero_explicit(&aes, sizeof(aes));
 	return 0;
 }
 
 int crypto4xx_setkey_aes_gcm(struct crypto_aead *cipher,
 			     const u8 *key, unsigned int keylen)
-- 
2.52.0

