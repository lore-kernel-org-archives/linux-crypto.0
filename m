Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAA4352C5B;
	Mon, 21 Sep 2026 05:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789967765; cv=none; b=roNQz8ea1jYhNmglSBlbQitTpF/q9K3LbURlZAuOwwpBnPtDKzGMKFdxAEWsCyqpfI89uuHsot2JmtL28WOIt2OLG6BzDBTQKrjeh/e2wnIHMNwv2cpsk+H1ei5zN4rFqGIbb3qbGaGt/PpZlzhKKCCz/ZaTtjnqolGozezfTtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789967765; c=relaxed/simple;
	bh=cJ/f3I9nHV0BnFI5TMqcZcGC8JGPk0cuKcXko1DNkrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DV7uBCoIcmtwqxr8D+9fxEhMn78JSbK6WgkL/5ziREs/DbTj0Qg2t3QeZ7yqE5KJ+8oBF3CCTg6e7J4pnhJDEAla7DBcWq3IEdUYoHX9kmF90Idx8yDWOa/1D9cer9nMlMstkIAVxquJLanbQz/e2HIbFeZV6rogMweNQ7gzpVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jZeziMwR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jZeziMwR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97D01F00899;
	Mon, 21 Sep 2026 05:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789967764;
	bh=DmrQnWAp+PfddUGRztDV+bpGLhcW7RlUL0r9TlxAYCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jZeziMwRSQcDUOCfNw+OPJIdK57/XDgsSnwJ4Fd/PYUQjXmeqejrpt7IoS3FiPndS
	 BOq+HV3nZak15huEPJZYE+fGb3RYFZ+MCFdQ9rioFuawemy/lsBhFeDwWhdIIWDx4h
	 ec67PmRHQ80qrWtwD62fAm+Fn0Eg+bc+BpHGOLjBbrvT/EGJLRK+rbj19+eTRvnnBm
	 R1Mxd7KJUz4AB9S1rBNg2Z9Jteb0T0GiEcyHWRw4MfsDBkooMZnJK18XqD6aDunqZx
	 dVL90HiO6iJauPKn+wGfxtaSmn+xA9cE6C05VSivQbRFWKOl98iV6aqEwQLh4Dr3S0
	 51yo1VPjN6BHQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 02/20] lib/crypto: aes-xctr: Pass counter by value to aes_xctr_arch()
Date: Sun, 20 Sep 2026 22:08:48 -0700
Message-ID: <20260921050910.296144-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921050910.296144-1-ebiggers@kernel.org>
References: <20260921050910.296144-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update the calling convention for aes_xctr_arch() to pass the counter by
value, then do the increment in generic code.  This aligns better with
the x86_64 and arm64 assembly code for XCTR, which takes the counter by
value and thus has to be paired with an increment in C code anyway.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/aes.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index f1549839b3de..22f096c50242 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -1094,7 +1094,7 @@ static bool aes_ctr_arch(u8 *dst, const u8 *src, size_t len,
 }
 #endif
 #ifndef aes_xctr_arch
-static bool aes_xctr_arch(u8 *dst, const u8 *src, size_t len, u64 *ctr,
+static bool aes_xctr_arch(u8 *dst, const u8 *src, size_t len, u64 ctr,
 			  const u8 iv[AES_BLOCK_SIZE],
 			  const struct aes_enckey *key)
 {
@@ -1150,8 +1150,10 @@ void aes_xctr(u8 *dst, const u8 *src, size_t len, u64 *ctr,
 	__le64 aes_input[2];
 	u8 keystream[AES_BLOCK_SIZE] __aligned(__alignof__(long));
 
-	if (likely(aes_xctr_arch(dst, src, len, ctr, iv, key.enc_key)))
+	if (likely(aes_xctr_arch(dst, src, len, *ctr, iv, key.enc_key))) {
+		*ctr += DIV_ROUND_UP(len, AES_BLOCK_SIZE);
 		return;
+	}
 
 	aes_input[1] = get_unaligned((const __le64 *)&iv[8]);
 	/* Handle the full blocks. */
-- 
2.55.0

