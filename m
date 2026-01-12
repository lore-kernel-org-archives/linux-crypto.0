Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451FF389DE3;
	Mon, 12 Jan 2026 19:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768245810; cv=none; b=OGSpWg2JqTtjsk+4iqV2ojl7ZL1s252kemLZ6PtmghW0W9m3FyTvaj36/HMd8joU1MxBAkZztgO6M6Fp/cTdGko05I5EVx3dqTszztYyaHGfgZxYIZDsQ3zGFAsP3VVYKhn9Gk4zPKM9tmgXwsuIK57YxLGnYA2hePYL2M4AMr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768245810; c=relaxed/simple;
	bh=wXdwY1WoVa5ZNu1Fe87Z9mILsLA3s28tZHNhWF6S8gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVfsLHKysBKRQ7u8mr+SF4WxCLFQyRZzXAou8BoOAlMkY21h4oFd/OSWmmJqX5tOCffNxU5D3IiqzwfgwsZ3X5uasUNk16KX8XElOGW4WEY5z7T3frNY6q7jKbZu978QSzF87hU8i/QZOqwZfMb++tUAWuX36I/rrPwWF4eZ/AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gj85ij8q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gj85ij8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A322C2BC86;
	Mon, 12 Jan 2026 19:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768245810;
	bh=wXdwY1WoVa5ZNu1Fe87Z9mILsLA3s28tZHNhWF6S8gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gj85ij8qJIew+bWKcniT1QlwS/ryjNF9CQBcnJ8+C99RNEOoBqERPk4+1FRbNhhw0
	 FZGVIA1d56xRQ+5i2prmCgQ5T+K156MKnGC9hAtOYNu+5kRR2YT0qGwptAkoCBCf54
	 rDdZRiy4YuiA9Tsxq+bEV3KDyjzv6XZto+e39v5MAzqLjDYypucU44X5+AGKiAuMm1
	 gVy605yDG4qjxS5/wUd5S5E9WiRd3DZKQ3uVMlmVp9KBGAKsdjvi+/8jWGd1aisRvp
	 db/Cr2lSi0DrDychLsRvaGIBD9agCrol/u3YT7AOB4sZgb0wbn1k5hbcfcWAHgexUs
	 LUbeyOTiy34tg==
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
Subject: [PATCH v2 22/35] staging: rtl8723bs: core: Use new AES library API
Date: Mon, 12 Jan 2026 11:20:20 -0800
Message-ID: <20260112192035.10427-23-ebiggers@kernel.org>
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
 drivers/staging/rtl8723bs/core/rtw_security.c | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_security.c b/drivers/staging/rtl8723bs/core/rtw_security.c
index 2f941ffbd465..8ee5bed252bf 100644
--- a/drivers/staging/rtl8723bs/core/rtw_security.c
+++ b/drivers/staging/rtl8723bs/core/rtw_security.c
@@ -635,15 +635,15 @@ u32 rtw_tkip_decrypt(struct adapter *padapter, u8 *precvframe)
 /* Performs a 128 bit AES encrypt with  */
 /* 128 bit data.                        */
 /****************************************/
 static void aes128k128d(u8 *key, u8 *data, u8 *ciphertext)
 {
-	struct crypto_aes_ctx ctx;
+	struct aes_enckey aes;
 
-	aes_expandkey(&ctx, key, 16);
-	aes_encrypt(&ctx, ciphertext, data);
-	memzero_explicit(&ctx, sizeof(ctx));
+	aes_prepareenckey(&aes, key, 16);
+	aes_encrypt(&aes, ciphertext, data);
+	memzero_explicit(&aes, sizeof(aes));
 }
 
 /************************************************/
 /* construct_mic_iv()                           */
 /* Builds the MIC IV from header fields and PN  */
@@ -1404,17 +1404,17 @@ static void gf_mulx(u8 *pad)
  * (SP) 800-38B.
  */
 static int omac1_aes_128_vector(u8 *key, size_t num_elem,
 				u8 *addr[], size_t *len, u8 *mac)
 {
-	struct crypto_aes_ctx ctx;
+	struct aes_enckey aes;
 	u8 cbc[AES_BLOCK_SIZE], pad[AES_BLOCK_SIZE];
 	u8 *pos, *end;
 	size_t i, e, left, total_len;
 	int ret;
 
-	ret = aes_expandkey(&ctx, key, 16);
+	ret = aes_prepareenckey(&aes, key, 16);
 	if (ret)
 		return -1;
 	memset(cbc, 0, AES_BLOCK_SIZE);
 
 	total_len = 0;
@@ -1434,16 +1434,16 @@ static int omac1_aes_128_vector(u8 *key, size_t num_elem,
 				pos = addr[e];
 				end = pos + len[e];
 			}
 		}
 		if (left > AES_BLOCK_SIZE)
-			aes_encrypt(&ctx, cbc, cbc);
+			aes_encrypt(&aes, cbc, cbc);
 		left -= AES_BLOCK_SIZE;
 	}
 
 	memset(pad, 0, AES_BLOCK_SIZE);
-	aes_encrypt(&ctx, pad, pad);
+	aes_encrypt(&aes, pad, pad);
 	gf_mulx(pad);
 
 	if (left || total_len == 0) {
 		for (i = 0; i < left; i++) {
 			cbc[i] ^= *pos++;
@@ -1457,12 +1457,12 @@ static int omac1_aes_128_vector(u8 *key, size_t num_elem,
 		gf_mulx(pad);
 	}
 
 	for (i = 0; i < AES_BLOCK_SIZE; i++)
 		pad[i] ^= cbc[i];
-	aes_encrypt(&ctx, pad, mac);
-	memzero_explicit(&ctx, sizeof(ctx));
+	aes_encrypt(&aes, pad, mac);
+	memzero_explicit(&aes, sizeof(aes));
 	return 0;
 }
 
 /**
  * omac1_aes_128 - One-Key CBC MAC (OMAC1) hash with AES-128 (aka AES-CMAC)
-- 
2.52.0

