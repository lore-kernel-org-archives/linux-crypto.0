Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8F12D4B6D;
	Sat, 22 Nov 2025 19:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763840569; cv=none; b=Qg8WGNnu7INrIo0/Cw9WJFnOzK6QvahEWSDlUixfc2stjtfnQ3lxDaeu7rJUK4Fm9/fwx/jYcOaJc/1OyCehWyTLrIVBcoGC1Z3FIVy6J0nqNSDBP9PzQeYiHJfEM16LEhKrWX4kTulTsy7x8i/TsTl4ywMlenHuIMRQRfnmuw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763840569; c=relaxed/simple;
	bh=zgj3M8vJge94HO4DBRv9OVOwZeOA9IcTQkcwta1ZQfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bO2DfSTHQHCVJcd51y9M6XfaxSLaLNLQ+mr8gMm7cagihnCGp14SjhTfRihY+TSasMvMOiFC0M/Xa4xyAXOKK+EnfQ90WW3Q37jjmN7RG1l52XK5PsohiGxyPDDaGUYJDzesXY6Fdv3+MZtwUN3G6H3N7IPfit7UN7PnQaJspuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CkOkwksV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CkOkwksV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2EEC4CEF5;
	Sat, 22 Nov 2025 19:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763840567;
	bh=zgj3M8vJge94HO4DBRv9OVOwZeOA9IcTQkcwta1ZQfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CkOkwksV0WikU1KrNtA+odNX2Rhg3f3V+zQ8Mc0ASic/PgJuD8PPG7I76DogTD9Mj
	 G9JJF2DEZcsSGAdYHSD2hN5SKuIdbUEk7YYDFVnb1vLkvSvWPq2HNP7hzQzMUuhFB3
	 ZtMxrKfan9FBdyh1qmxU2DtN9ogQybz4J5O4bTQA0wf+L8C7g5fFzgomwqz9j6J/lx
	 ijczKh2AaIimEnZ36A8Ya1mCAHkLUS7UYaWpaelBSytmlW3H8m4cVJ666OSCLdoHVX
	 Dgp4WlFS6hdL+aKuJpkkErG1NY/HNpfVrDFhcV956apF1wtyLjalwTv2fp6MDnxcfJ
	 2Xv8Ys1x8pDGw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5/6] lib/crypto: sha1: Add at_least decoration to fixed-size array params
Date: Sat, 22 Nov 2025 11:42:05 -0800
Message-ID: <20251122194206.31822-6-ebiggers@kernel.org>
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
parameters of the sha1 library functions.  This causes clang to warn
when a too-small array of known size is passed.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/sha1.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/crypto/sha1.h b/include/crypto/sha1.h
index 162a529ec841..27f08b972931 100644
--- a/include/crypto/sha1.h
+++ b/include/crypto/sha1.h
@@ -82,21 +82,21 @@ void sha1_update(struct sha1_ctx *ctx, const u8 *data, size_t len);
  *
  * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
  *
  * Context: Any context.
  */
-void sha1_final(struct sha1_ctx *ctx, u8 out[SHA1_DIGEST_SIZE]);
+void sha1_final(struct sha1_ctx *ctx, u8 out[at_least SHA1_DIGEST_SIZE]);
 
 /**
  * sha1() - Compute SHA-1 message digest in one shot
  * @data: the message data
  * @len: the data length in bytes
  * @out: (output) the resulting SHA-1 message digest
  *
  * Context: Any context.
  */
-void sha1(const u8 *data, size_t len, u8 out[SHA1_DIGEST_SIZE]);
+void sha1(const u8 *data, size_t len, u8 out[at_least SHA1_DIGEST_SIZE]);
 
 /**
  * struct hmac_sha1_key - Prepared key for HMAC-SHA1
  * @istate: private
  * @ostate: private
@@ -179,11 +179,12 @@ static inline void hmac_sha1_update(struct hmac_sha1_ctx *ctx,
  *
  * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
  *
  * Context: Any context.
  */
-void hmac_sha1_final(struct hmac_sha1_ctx *ctx, u8 out[SHA1_DIGEST_SIZE]);
+void hmac_sha1_final(struct hmac_sha1_ctx *ctx,
+		     u8 out[at_least SHA1_DIGEST_SIZE]);
 
 /**
  * hmac_sha1() - Compute HMAC-SHA1 in one shot, using a prepared key
  * @key: the prepared HMAC key
  * @data: the message data
@@ -193,11 +194,12 @@ void hmac_sha1_final(struct hmac_sha1_ctx *ctx, u8 out[SHA1_DIGEST_SIZE]);
  * If you're using the key only once, consider using hmac_sha1_usingrawkey().
  *
  * Context: Any context.
  */
 void hmac_sha1(const struct hmac_sha1_key *key,
-	       const u8 *data, size_t data_len, u8 out[SHA1_DIGEST_SIZE]);
+	       const u8 *data, size_t data_len,
+	       u8 out[at_least SHA1_DIGEST_SIZE]);
 
 /**
  * hmac_sha1_usingrawkey() - Compute HMAC-SHA1 in one shot, using a raw key
  * @raw_key: the raw HMAC-SHA1 key
  * @raw_key_len: the key length in bytes.  All key lengths are supported.
@@ -210,8 +212,8 @@ void hmac_sha1(const struct hmac_sha1_key *key,
  *
  * Context: Any context.
  */
 void hmac_sha1_usingrawkey(const u8 *raw_key, size_t raw_key_len,
 			   const u8 *data, size_t data_len,
-			   u8 out[SHA1_DIGEST_SIZE]);
+			   u8 out[at_least SHA1_DIGEST_SIZE]);
 
 #endif /* _CRYPTO_SHA1_H */
-- 
2.51.2

