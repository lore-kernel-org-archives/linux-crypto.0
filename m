Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610B82853F8;
	Sun, 26 Oct 2025 05:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761457988; cv=none; b=tBubLI08uqpvoyHD6fGbbS95MVaeJ0TrnyP8MNU2H3pBmSA2K7rhC8N0UfUST5dVOzE+51CopynLfIXM20CN9kjvLF39bo2VqNDPnhY58P+xfMU++jEIYRFqTh0vSNOtx3SvULYKG0F3FxEvdpnvkiIkIIZugrqKuwptTW8O6GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761457988; c=relaxed/simple;
	bh=TbVLbaUPq3TI8tu/I7Jnha1NiyG1jt55JtZfnYEOEf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eduzcf99I37nF2j4sxaJfyu42JBq/bPkOTmsvGIb6WDi7BLUuv1nhf6isGg1T+/uX7O+U0BeRqnnRCOWqHIHcMsi8JKCPbIYFa2xDiEk0i5CRUpsN9zMrw2eGxlSR9rHi34mRZHwyf35+wdYOPbAcPOv2mh/BhqZYWAJUOdiCAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VzIzVp/9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VzIzVp/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E41C4AF0B;
	Sun, 26 Oct 2025 05:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761457988;
	bh=TbVLbaUPq3TI8tu/I7Jnha1NiyG1jt55JtZfnYEOEf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VzIzVp/98BzPaqHpgDXy9lQcQUD53jo9sL7ZNoHHIu2yiWxxWDvWMQohZSuBT20il
	 oICPtpc0wRBUgfldpYr23cY5Xg2JLjRi7z+yy4c/RKLNyPIfGtqZQq1JNBPe8OMKVJ
	 XYBZFFXliuGCsJykRNPn/Mzv5W4Sodla4EOmohhJ2ZTJgsUWDFPm5CT+EzWfNYqIFG
	 prh6Qdqz/COR2oh6fY0Jff+Hdo71h74/WNC+VBmSzyfGJA5joMC+Ws0fcgaJAjg9ck
	 0w4fSYweNEqoud+Kb/BiVCKP9p5Ql4cEDmZO4gpjTijkIa8FCdgsafazfWPToHUg/7
	 IEzljMhGNvZwg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 11/15] lib/crypto: sha3: Support arch overrides of one-shot digest functions
Date: Sat, 25 Oct 2025 22:50:28 -0700
Message-ID: <20251026055032.1413733-12-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251026055032.1413733-1-ebiggers@kernel.org>
References: <20251026055032.1413733-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for architecture-specific overrides of sha3_224(),
sha3_256(), sha3_384(), and sha3_512().  This will be used to implement
these functions more efficiently on s390 than is possible via the usual
init + update + final flow.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/sha3.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/lib/crypto/sha3.c b/lib/crypto/sha3.c
index 6c94b4ebd0fd1..a598138d47a59 100644
--- a/lib/crypto/sha3.c
+++ b/lib/crypto/sha3.c
@@ -278,44 +278,81 @@ void shake_squeeze(struct shake_ctx *shake_ctx, u8 *out, size_t out_len)
 	}
 	ctx->squeeze_offset = squeeze_offset;
 }
 EXPORT_SYMBOL_GPL(shake_squeeze);
 
+#ifndef sha3_224_arch
+static inline bool sha3_224_arch(const u8 *in, size_t in_len,
+				 u8 out[SHA3_224_DIGEST_SIZE])
+{
+	return false;
+}
+#endif
+#ifndef sha3_256_arch
+static inline bool sha3_256_arch(const u8 *in, size_t in_len,
+				 u8 out[SHA3_256_DIGEST_SIZE])
+{
+	return false;
+}
+#endif
+#ifndef sha3_384_arch
+static inline bool sha3_384_arch(const u8 *in, size_t in_len,
+				 u8 out[SHA3_384_DIGEST_SIZE])
+{
+	return false;
+}
+#endif
+#ifndef sha3_512_arch
+static inline bool sha3_512_arch(const u8 *in, size_t in_len,
+				 u8 out[SHA3_512_DIGEST_SIZE])
+{
+	return false;
+}
+#endif
+
 void sha3_224(const u8 *in, size_t in_len, u8 out[SHA3_224_DIGEST_SIZE])
 {
 	struct sha3_ctx ctx;
 
+	if (sha3_224_arch(in, in_len, out))
+		return;
 	sha3_224_init(&ctx);
 	sha3_update(&ctx, in, in_len);
 	sha3_final(&ctx, out);
 }
 EXPORT_SYMBOL_GPL(sha3_224);
 
 void sha3_256(const u8 *in, size_t in_len, u8 out[SHA3_256_DIGEST_SIZE])
 {
 	struct sha3_ctx ctx;
 
+	if (sha3_256_arch(in, in_len, out))
+		return;
 	sha3_256_init(&ctx);
 	sha3_update(&ctx, in, in_len);
 	sha3_final(&ctx, out);
 }
 EXPORT_SYMBOL_GPL(sha3_256);
 
 void sha3_384(const u8 *in, size_t in_len, u8 out[SHA3_384_DIGEST_SIZE])
 {
 	struct sha3_ctx ctx;
 
+	if (sha3_384_arch(in, in_len, out))
+		return;
 	sha3_384_init(&ctx);
 	sha3_update(&ctx, in, in_len);
 	sha3_final(&ctx, out);
 }
 EXPORT_SYMBOL_GPL(sha3_384);
 
 void sha3_512(const u8 *in, size_t in_len, u8 out[SHA3_512_DIGEST_SIZE])
 {
 	struct sha3_ctx ctx;
 
+	if (sha3_512_arch(in, in_len, out))
+		return;
 	sha3_512_init(&ctx);
 	sha3_update(&ctx, in, in_len);
 	sha3_final(&ctx, out);
 }
 EXPORT_SYMBOL_GPL(sha3_512);
-- 
2.51.1.dirty

