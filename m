Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4933F15530C;
	Sun, 23 Nov 2025 05:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763876967; cv=none; b=W6NmdmYUoYShaLXkeGggDSTm1jMPY4No0RvtftCt3oXV79iphVNBqWEBd0GDa9zwi976A9OhpLuYfMjBaksM46Gv60RewdG38mpjHQjYCh0ZVpZd5YfOiIRPgpeaRr0R+SVxIYSive8MsNUs3tAR+pCLh66inD01nYkT/pTlfzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763876967; c=relaxed/simple;
	bh=g/XCQ9h2+QtHpRYxMGAbLmC1eL2BZeeiu9XiN1M06L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d267DtEXTQyd7l2uK+v3ju156nse2DDMJcgATX2tnw/oTw0YNoAUGxfQVJhHgs/lSTaCyDPzsRZFfHB0Gk/JoRQTEl6uzjZUjjHCRndpys0AdUX8e/3SgfD7yNS57tpJByXJ5F7JrOSSsH5iRwXyd9Ius8l8jrRwXlskDkJdCqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=gTjCKyCZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="gTjCKyCZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B823C16AAE;
	Sun, 23 Nov 2025 05:49:26 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="gTjCKyCZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1763876965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=anZ6A0umaXfxY2xtyZOZhZmaXi2QPZEIVFwjFskrg08=;
	b=gTjCKyCZtpUcdfRc/MelSsG/3DdUkGCbeoP4oW4Z7uFxcW5zbfun3w2Ku/wP4WuaBSki+d
	AI+CVDuk8Ucbg2KhbT0Rbb4J3sH6mM2DkfhCNvBs3zy2ooeFHo7V81KeLcdys2M6FFBHQG
	pmOuWSUfB9wRAHk8zXZjsriYq6r/g8Q=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5144e2de (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sun, 23 Nov 2025 05:49:25 +0000 (UTC)
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Kees Cook <kees@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH libcrypto v4 3/3] crypto: chacha20poly1305: statically check fixed array lengths
Date: Sun, 23 Nov 2025 06:48:20 +0100
Message-ID: <20251123054819.2371989-4-Jason@zx2c4.com>
In-Reply-To: <20251123054819.2371989-1-Jason@zx2c4.com>
References: <20251123054819.2371989-1-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Several parameters of the chacha20poly1305 functions require arrays of
an exact length. Use the new at_least keyword to instruct gcc and
clang to statically check that the caller is passing an object of at
least that length.

Here it is in action, with this faulty patch to wireguard's cookie.h:

     struct cookie_checker {
     	u8 secret[NOISE_HASH_LEN];
    -	u8 cookie_encryption_key[NOISE_SYMMETRIC_KEY_LEN];
    +	u8 cookie_encryption_key[NOISE_SYMMETRIC_KEY_LEN - 1];
     	u8 message_mac1_key[NOISE_SYMMETRIC_KEY_LEN];

If I try compiling this code, I get this helpful warning:

  CC      drivers/net/wireguard/cookie.o
drivers/net/wireguard/cookie.c: In function ‘wg_cookie_message_create’:
drivers/net/wireguard/cookie.c:193:9: warning: ‘xchacha20poly1305_encrypt’ reading 32 bytes from a region of size 31 [-Wstringop-overread]
  193 |         xchacha20poly1305_encrypt(dst->encrypted_cookie, cookie, COOKIE_LEN,
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  194 |                                   macs->mac1, COOKIE_LEN, dst->nonce,
      |                                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  195 |                                   checker->cookie_encryption_key);
      |                                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireguard/cookie.c:193:9: note: referencing argument 7 of type ‘const u8 *’ {aka ‘const unsigned char *’}
In file included from drivers/net/wireguard/messages.h:10,
                 from drivers/net/wireguard/cookie.h:9,
                 from drivers/net/wireguard/cookie.c:6:
include/crypto/chacha20poly1305.h:28:6: note: in a call to function ‘xchacha20poly1305_encrypt’
   28 | void xchacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 include/crypto/chacha20poly1305.h | 16 ++++++++--------
 lib/crypto/chacha20poly1305.c     | 18 +++++++++---------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/crypto/chacha20poly1305.h b/include/crypto/chacha20poly1305.h
index d2ac3ff7dc1e..7617366f8218 100644
--- a/include/crypto/chacha20poly1305.h
+++ b/include/crypto/chacha20poly1305.h
@@ -18,32 +18,32 @@ enum chacha20poly1305_lengths {
 void chacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
 			      const u8 *ad, const size_t ad_len,
 			      const u64 nonce,
-			      const u8 key[CHACHA20POLY1305_KEY_SIZE]);
+			      const u8 key[at_least CHACHA20POLY1305_KEY_SIZE]);
 
 bool __must_check
 chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
 			 const u8 *ad, const size_t ad_len, const u64 nonce,
-			 const u8 key[CHACHA20POLY1305_KEY_SIZE]);
+			 const u8 key[at_least CHACHA20POLY1305_KEY_SIZE]);
 
 void xchacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
 			       const u8 *ad, const size_t ad_len,
-			       const u8 nonce[XCHACHA20POLY1305_NONCE_SIZE],
-			       const u8 key[CHACHA20POLY1305_KEY_SIZE]);
+			       const u8 nonce[at_least XCHACHA20POLY1305_NONCE_SIZE],
+			       const u8 key[at_least CHACHA20POLY1305_KEY_SIZE]);
 
 bool __must_check xchacha20poly1305_decrypt(
 	u8 *dst, const u8 *src, const size_t src_len, const u8 *ad,
-	const size_t ad_len, const u8 nonce[XCHACHA20POLY1305_NONCE_SIZE],
-	const u8 key[CHACHA20POLY1305_KEY_SIZE]);
+	const size_t ad_len, const u8 nonce[at_least XCHACHA20POLY1305_NONCE_SIZE],
+	const u8 key[at_least CHACHA20POLY1305_KEY_SIZE]);
 
 bool chacha20poly1305_encrypt_sg_inplace(struct scatterlist *src, size_t src_len,
 					 const u8 *ad, const size_t ad_len,
 					 const u64 nonce,
-					 const u8 key[CHACHA20POLY1305_KEY_SIZE]);
+					 const u8 key[at_least CHACHA20POLY1305_KEY_SIZE]);
 
 bool chacha20poly1305_decrypt_sg_inplace(struct scatterlist *src, size_t src_len,
 					 const u8 *ad, const size_t ad_len,
 					 const u64 nonce,
-					 const u8 key[CHACHA20POLY1305_KEY_SIZE]);
+					 const u8 key[at_least CHACHA20POLY1305_KEY_SIZE]);
 
 bool chacha20poly1305_selftest(void);
 
diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
index 0b49d6aedefd..212ce33562af 100644
--- a/lib/crypto/chacha20poly1305.c
+++ b/lib/crypto/chacha20poly1305.c
@@ -89,7 +89,7 @@ __chacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
 void chacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
 			      const u8 *ad, const size_t ad_len,
 			      const u64 nonce,
-			      const u8 key[CHACHA20POLY1305_KEY_SIZE])
+			      const u8 key[at_least CHACHA20POLY1305_KEY_SIZE])
 {
 	struct chacha_state chacha_state;
 	u32 k[CHACHA_KEY_WORDS];
@@ -111,8 +111,8 @@ EXPORT_SYMBOL(chacha20poly1305_encrypt);
 
 void xchacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
 			       const u8 *ad, const size_t ad_len,
-			       const u8 nonce[XCHACHA20POLY1305_NONCE_SIZE],
-			       const u8 key[CHACHA20POLY1305_KEY_SIZE])
+			       const u8 nonce[at_least XCHACHA20POLY1305_NONCE_SIZE],
+			       const u8 key[at_least CHACHA20POLY1305_KEY_SIZE])
 {
 	struct chacha_state chacha_state;
 
@@ -170,7 +170,7 @@ __chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
 bool chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
 			      const u8 *ad, const size_t ad_len,
 			      const u64 nonce,
-			      const u8 key[CHACHA20POLY1305_KEY_SIZE])
+			      const u8 key[at_least CHACHA20POLY1305_KEY_SIZE])
 {
 	struct chacha_state chacha_state;
 	u32 k[CHACHA_KEY_WORDS];
@@ -195,8 +195,8 @@ EXPORT_SYMBOL(chacha20poly1305_decrypt);
 
 bool xchacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
 			       const u8 *ad, const size_t ad_len,
-			       const u8 nonce[XCHACHA20POLY1305_NONCE_SIZE],
-			       const u8 key[CHACHA20POLY1305_KEY_SIZE])
+			       const u8 nonce[at_least XCHACHA20POLY1305_NONCE_SIZE],
+			       const u8 key[at_least CHACHA20POLY1305_KEY_SIZE])
 {
 	struct chacha_state chacha_state;
 
@@ -211,7 +211,7 @@ bool chacha20poly1305_crypt_sg_inplace(struct scatterlist *src,
 				       const size_t src_len,
 				       const u8 *ad, const size_t ad_len,
 				       const u64 nonce,
-				       const u8 key[CHACHA20POLY1305_KEY_SIZE],
+				       const u8 key[at_least CHACHA20POLY1305_KEY_SIZE],
 				       int encrypt)
 {
 	const u8 *pad0 = page_address(ZERO_PAGE(0));
@@ -335,7 +335,7 @@ bool chacha20poly1305_crypt_sg_inplace(struct scatterlist *src,
 bool chacha20poly1305_encrypt_sg_inplace(struct scatterlist *src, size_t src_len,
 					 const u8 *ad, const size_t ad_len,
 					 const u64 nonce,
-					 const u8 key[CHACHA20POLY1305_KEY_SIZE])
+					 const u8 key[at_least CHACHA20POLY1305_KEY_SIZE])
 {
 	return chacha20poly1305_crypt_sg_inplace(src, src_len, ad, ad_len,
 						 nonce, key, 1);
@@ -345,7 +345,7 @@ EXPORT_SYMBOL(chacha20poly1305_encrypt_sg_inplace);
 bool chacha20poly1305_decrypt_sg_inplace(struct scatterlist *src, size_t src_len,
 					 const u8 *ad, const size_t ad_len,
 					 const u64 nonce,
-					 const u8 key[CHACHA20POLY1305_KEY_SIZE])
+					 const u8 key[at_least CHACHA20POLY1305_KEY_SIZE])
 {
 	if (unlikely(src_len < POLY1305_DIGEST_SIZE))
 		return false;
-- 
2.52.0

