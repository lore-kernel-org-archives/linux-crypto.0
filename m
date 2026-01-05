Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B5932AABD;
	Mon,  5 Jan 2026 05:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767590106; cv=none; b=oWfxGIm0cn+E5nEaCMzR67D1VzRJbsHaGDlsA9akmOG0fcDzIx/oT8A57/GJOm90Li4jV14TypydUknuJJsLcqNiEKFF5HaLLuY+aw8BaEaMrWE7dGzHApc4AlaaAGs3m5tw/i0AlDY6mYxgRiFUFOuAx4P3Ab3FadwuwcDurEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767590106; c=relaxed/simple;
	bh=4EW0N35+HHe/JqWcRGzDlUw5apTDeyYhZ2K2O9GZlcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2j1wwJC4iWS6qngcqfd9sp8EeEF4kLUS/+8Qz77H8WQOh6/UZOrAo5/IJhil6SXf+ramm8GYpnFHAOlVGK/KujOjh2Ipgv7j+YQJtCxFw38cCFYXYYUHjCMLaLfSNI205f46WVKXfvol9Jbz5lMUjM8fWaxD88znqu5JDpzhgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vEUIRbux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vEUIRbux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED002C116D0;
	Mon,  5 Jan 2026 05:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767590105;
	bh=4EW0N35+HHe/JqWcRGzDlUw5apTDeyYhZ2K2O9GZlcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vEUIRbuxPtyDpcgmvaJX3BlnFYwziFzZ5LfbmtiO1eZS18vDNbYb6RE8wz6jnFJBr
	 kvSoc+6RJvlqMWm6zGwwF3J8K9CRcgRwTFqq5ruJiQHv9pKFl6sisZiRTmU5umyMV6
	 5y/D8y9+nH/tgL9Zzp8ALotiaPDgASAI8NUwirGnKJt0rW0IFK0YFO4Kwq/4OiZeaA
	 qpBlNBlePkfHmuyQURnujm3lufzjXc0b8jB0p/K4gDvjHb7mJ6JjrKq79aDQ2hjan6
	 vDml3XCcwpnT15sp+GsYP8x5G92t4t4yFwKshaqoy+fQHo6AU+dXUug8XcyQd//w8l
	 9Nt6JW399D6kA==
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
Subject: [PATCH 22/36] staging: rtl8723bs: core: Use new AES library API
Date: Sun,  4 Jan 2026 21:12:55 -0800
Message-ID: <20260105051311.1607207-23-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260105051311.1607207-1-ebiggers@kernel.org>
References: <20260105051311.1607207-1-ebiggers@kernel.org>
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

Note: aes_encrypt_new() will be renamed to aes_encrypt() once all
callers of the old aes_encrypt() have been updated.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_security.c | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_security.c b/drivers/staging/rtl8723bs/core/rtw_security.c
index 2f941ffbd465..79825324e70f 100644
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
+	aes_encrypt_new(&aes, ciphertext, data);
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
+			aes_encrypt_new(&aes, cbc, cbc);
 		left -= AES_BLOCK_SIZE;
 	}
 
 	memset(pad, 0, AES_BLOCK_SIZE);
-	aes_encrypt(&ctx, pad, pad);
+	aes_encrypt_new(&aes, pad, pad);
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
+	aes_encrypt_new(&aes, pad, mac);
+	memzero_explicit(&aes, sizeof(aes));
 	return 0;
 }
 
 /**
  * omac1_aes_128 - One-Key CBC MAC (OMAC1) hash with AES-128 (aka AES-CMAC)
-- 
2.52.0

