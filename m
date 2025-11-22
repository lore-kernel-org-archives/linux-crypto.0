Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB90D2C21FB;
	Sat, 22 Nov 2025 19:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763840566; cv=none; b=b3TeKtpywP1TWdpHwG9xoxVqtePgOeOxKz07roqoI6h0gYDmvC3lmhicFyE/dY42iC5hEBhy6QOVPIs8FL53Sf3iyaQxcn3YOoNh8vK3XlxN6KHiO1emECUN91MnsATdPb+7tNimG7DpcKZFDNBe0xlbsLDxdNL+03cCZZjD6Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763840566; c=relaxed/simple;
	bh=Vpv+tZscN2l9bt6vPiXuRUfDMu1WW0qW9PfdekwXokc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=reYuZdgfFWGomJh7tIzcPuzprfJyHGr9WMu8I6jj5Y0EkJZkXUBsWTAocnIpLB03idYRvNPpdUUTUXFQzqJPVH0PBupjyYsfb/sma5kmyRtMIOOLQ7B6KVsj0xRyu3bvSqS00ibqI3hvhnSUCv7h4RkwQOZwVT1Obaa/eGTAOps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MM74jTXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MM74jTXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC97EC4CEF5;
	Sat, 22 Nov 2025 19:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763840566;
	bh=Vpv+tZscN2l9bt6vPiXuRUfDMu1WW0qW9PfdekwXokc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MM74jTXRmc4CXrYu51xd7NPgkvyY2uCtaB98PufyxKjIO9AMqpvmO/MNWzn36v3Vp
	 o8G4ahMH0RWzUaT7sndAv5Iqm0WRoZ/wpl/j6D1/sIzcJc7aAQRyctmnHDm5kRW4vH
	 fTVMK0wt7gHskk0vVZF3pB5lkWsF6v/gd1Seb6EIT4HwOlaQE0E8MIuQDvj5yg2JJj
	 12tDWXma/1Bo5UdLR2oO4rR+/EwXCuDTyafFP14gmMVGYtTtx16Wv2XTT1eJIdXpre
	 J/pET1qo/JIx6FzHLLtWPa/S9oqcmafx5WXg+i7akBoxPBZVJxtHwJlgH7m7sLQUAz
	 8mEg+HY3+Ti1g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/6] lib/crypto: md5: Add at_least decoration to fixed-size array params
Date: Sat, 22 Nov 2025 11:42:03 -0800
Message-ID: <20251122194206.31822-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251122194206.31822-1-ebiggers@kernel.org>
References: <20251122194206.31822-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the at_least (i.e. 'static') decoration to the fixed-size array
parameters of the md5 library functions.  This causes clang to warn when
a too-small array of known size is passed.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/md5.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/crypto/md5.h b/include/crypto/md5.h
index c9aa5c3abc53..c47aedfe67ec 100644
--- a/include/crypto/md5.h
+++ b/include/crypto/md5.h
@@ -74,21 +74,21 @@ void md5_update(struct md5_ctx *ctx, const u8 *data, size_t len);
  *
  * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
  *
  * Context: Any context.
  */
-void md5_final(struct md5_ctx *ctx, u8 out[MD5_DIGEST_SIZE]);
+void md5_final(struct md5_ctx *ctx, u8 out[at_least MD5_DIGEST_SIZE]);
 
 /**
  * md5() - Compute MD5 message digest in one shot
  * @data: the message data
  * @len: the data length in bytes
  * @out: (output) the resulting MD5 message digest
  *
  * Context: Any context.
  */
-void md5(const u8 *data, size_t len, u8 out[MD5_DIGEST_SIZE]);
+void md5(const u8 *data, size_t len, u8 out[at_least MD5_DIGEST_SIZE]);
 
 /**
  * struct hmac_md5_key - Prepared key for HMAC-MD5
  * @istate: private
  * @ostate: private
@@ -171,11 +171,11 @@ static inline void hmac_md5_update(struct hmac_md5_ctx *ctx,
  *
  * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
  *
  * Context: Any context.
  */
-void hmac_md5_final(struct hmac_md5_ctx *ctx, u8 out[MD5_DIGEST_SIZE]);
+void hmac_md5_final(struct hmac_md5_ctx *ctx, u8 out[at_least MD5_DIGEST_SIZE]);
 
 /**
  * hmac_md5() - Compute HMAC-MD5 in one shot, using a prepared key
  * @key: the prepared HMAC key
  * @data: the message data
@@ -185,11 +185,12 @@ void hmac_md5_final(struct hmac_md5_ctx *ctx, u8 out[MD5_DIGEST_SIZE]);
  * If you're using the key only once, consider using hmac_md5_usingrawkey().
  *
  * Context: Any context.
  */
 void hmac_md5(const struct hmac_md5_key *key,
-	      const u8 *data, size_t data_len, u8 out[MD5_DIGEST_SIZE]);
+	      const u8 *data, size_t data_len,
+	      u8 out[at_least MD5_DIGEST_SIZE]);
 
 /**
  * hmac_md5_usingrawkey() - Compute HMAC-MD5 in one shot, using a raw key
  * @raw_key: the raw HMAC-MD5 key
  * @raw_key_len: the key length in bytes.  All key lengths are supported.
@@ -202,8 +203,8 @@ void hmac_md5(const struct hmac_md5_key *key,
  *
  * Context: Any context.
  */
 void hmac_md5_usingrawkey(const u8 *raw_key, size_t raw_key_len,
 			  const u8 *data, size_t data_len,
-			  u8 out[MD5_DIGEST_SIZE]);
+			  u8 out[at_least MD5_DIGEST_SIZE]);
 
 #endif /* _CRYPTO_MD5_H */
-- 
2.51.2

