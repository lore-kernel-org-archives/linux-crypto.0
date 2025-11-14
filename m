Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70AA21D3E4
	for <linux-crypto@vger.kernel.org>; Fri, 14 Nov 2025 18:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763143639; cv=none; b=HY2RAmz+iZzkNmZYcsVRbrRi5AcqT2Ssu5jIfusWfZOcfY6PkBKjms9SHaLwjShomlv49XdTzXyiH7yNwpxrGmG+BTfkZXF1GhMf0C4uaWDIdmbjx23IT4b6KErxcwp1jJq6ZI9/IekjWlXLuhrCUe+Gqx2zBtJgMr57rEhonuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763143639; c=relaxed/simple;
	bh=hTu1/WQ+28TiFImW6GRlwL2wPHub15rZc9OtNmfK2JQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=JCqczJKIomMm1BL4AD6dxpAVAjGDMqjzmojyZKpTmHGZwWuJIWp9aHPSGVsvbZFrT5BeJKTHH8scND9dO9eQ74hz3L41CzPwRn9KxnmDaU7YiLWej+Ft7Pz+s2UiuiwuKFsoVAuv0x+fqSd3pCHeYSjbXONhNsVQpb/W2ipwcmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BA0dwHu4; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BA0dwHu4"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-429cceeeb96so954831f8f.1
        for <linux-crypto@vger.kernel.org>; Fri, 14 Nov 2025 10:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763143636; x=1763748436; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=70La2at0aBhGjVKVAQXm26whTjSUNtWh3smGEz2qZ5c=;
        b=BA0dwHu4aCymFlrv6utSameMBEFaP99xPh6aby3rccNMpCn6CaaPy1BPjClNZuxSFD
         55jPAv7SGXRrjhOPMnLNSzheNxn59jopJv4gHG/WhLQnCZJdUldxM/1p27UaXDOJmehH
         ZrRs5QMP97J2WSWGCR/1PQLgkp0Yagc08XdJ8ceTKKcMMG5abE72Iuh1ixBzg+iv1Pdw
         BShuaiE0nNulwJn0M2kEAfkLenDyUvjJlYLPrREy1MmDDSgRfE7/RT5huq47arligvHG
         BNyqOFJ1lKI+hFxM01VO9GjiwvQuSuhOam1NQ+JQmxzeDMKaXkGnGs6a7AoXaOgHQ8Q2
         +q6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763143636; x=1763748436;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=70La2at0aBhGjVKVAQXm26whTjSUNtWh3smGEz2qZ5c=;
        b=nCZhcQY1N3uJR7sbuvSy5VaCI1P3YEXUYw5gd5w90fZPtyDuFUnnRwh8cDeWoBmVh3
         xvWzYG+SoLY8JMdP0F0o0d0bHHdsdpYPFGCbP+8CibNIgwQOyloa0Ev79zViraL2thny
         2+ueVwkJWitkQNEFI0JPRlSXUaSk8tRSLGpswoLpyhDzfcnCLLWHofRAHuWF7OaP0YIJ
         6sr7/XhNzLAso36+mdz932Cikyzho0deXX4JCqXYD+z3gqI+lqYp6152zrWTUkkJOaYB
         Ip2g/f10yCS6D9OgU3NKpjmauuvDQksmDWomlhyDnlhVBtWJgyzaHgR/k0UNhsyM30wA
         AUBQ==
X-Gm-Message-State: AOJu0YymkOy3kSdHxNY1ZhE3C3wOY2oPgwa/bpY2mOtl3BvdJpyISR1z
	JS6AoAy5+e4TbwJnjb+oUyGNnvBCxT4Tt0cCYamw6BH4BBNauAaCRXmSItsMMqwxKvLIshzOdjR
	Q0WC8GAN8s3u+v/mWN7Ttbx6T/JyLEQoB79G2Atu3Gh0qH9FeDLy1eD6sQZ9YRZAKqJZvGwKpnk
	TOzTj2myYTQtqHfPY98v94VQky9IWTnlZDzg==
X-Google-Smtp-Source: AGHT+IHrssAIl5QgOTBhVvC3FX8N1w2fmbDT7vQZV5nc4o6s8ltYVfLjTSMcgaL5kqMiXppGL0YKb/ka
X-Received: from wrbei2.prod.google.com ([2002:a05:6000:4182:b0:42b:367f:bbfe])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2912:b0:42b:31a5:f065
 with SMTP id ffacd0b85a97d-42b5934e90bmr4327625f8f.28.1763143635930; Fri, 14
 Nov 2025 10:07:15 -0800 (PST)
Date: Fri, 14 Nov 2025 19:07:07 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=14505; i=ardb@kernel.org;
 h=from:subject; bh=1z4sw6a8RgdKmiCnM4RterECB1hYo/FGLr4nXeE1W+g=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIVM8/7SMbv++Q8VaisJXm6P+3nhizO1nlCvBZO/wpu3b5
 Z+9e192lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgIms9mX4n/P0Vq3men9NabsI
 lZCT8rWNM0xLalfvZtXKrLy67XusICPDbbaEvsMOL/7v6j2X2/TpTf7a7SH+rPtnW5/l7n8QqF/ KDwA=
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114180706.318152-2-ardb+git@google.com>
Subject: [RFC PATCH] libcrypto/chachapoly: Use strict typing for fixed size
 array arguments
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>, 
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The C routines in libcrypto take in/outputs of arbitrary size on the one
hand (plaintext, ciphertext, etc) and in/outputs of fixed size on the
other (keys, nonces, digests).

In many cases, we pass these fixed size in/outputs as array of u8, with
the dimension in square brackets. However, this dimension only serves as
a human readable annotation, and is completely ignored by the compiler.

For example, mixing up any of the const u8[]/const u8* arguments in the
prototype below will not trigger a compiler diagnostic:

void xchacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
                               const u8 *ad, const size_t ad_len,
                               const u8 nonce[XCHACHA20POLY1305_NONCE_SIZE],
                               const u8 key[CHACHA20POLY1305_KEY_SIZE])

If we change this to the below, the codegen is identical, given that the
actual value passed as the argument is the address of the entire array,
which is equal to the address of its first element,

void xchacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
                               const u8 *ad, const size_t ad_len,
                               const u8 (*nonce)[XCHACHA20POLY1305_NONCE_SIZE],
                               const u8 (*key)[CHACHA20POLY1305_KEY_SIZE])

However, this variant is checked more strictly by the compiler, and only
arrays of the correct size are accepted as plain arguments (using the &
operator), and so inadvertent mixing up of arguments or passing buffers
of an incorrect size will trigger an error at build time.

So let's switch to this for the ChaCha20Poly1305 library used by
WireGuard.

Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---

Sending this RFC as an example, as a starting point for a discussion
whether or not we want to go down this route for all library crypto.

 drivers/net/wireguard/cookie.c    |  8 ++--
 drivers/net/wireguard/noise.c     | 16 ++++----
 drivers/net/wireguard/receive.c   |  2 +-
 drivers/net/wireguard/send.c      |  2 +-
 include/crypto/chacha20poly1305.h | 16 ++++----
 lib/crypto/chacha20poly1305.c     | 41 ++++++++++----------
 6 files changed, 43 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireguard/cookie.c b/drivers/net/wireguard/cookie.c
index 08731b3fa32b..b0ebbd2f8af4 100644
--- a/drivers/net/wireguard/cookie.c
+++ b/drivers/net/wireguard/cookie.c
@@ -191,8 +191,8 @@ void wg_cookie_message_create(struct message_handshake_cookie *dst,
 
 	make_cookie(cookie, skb, checker);
 	xchacha20poly1305_encrypt(dst->encrypted_cookie, cookie, COOKIE_LEN,
-				  macs->mac1, COOKIE_LEN, dst->nonce,
-				  checker->cookie_encryption_key);
+				  macs->mac1, COOKIE_LEN, &dst->nonce,
+				  &checker->cookie_encryption_key);
 }
 
 void wg_cookie_message_consume(struct message_handshake_cookie *src,
@@ -215,8 +215,8 @@ void wg_cookie_message_consume(struct message_handshake_cookie *src,
 	}
 	ret = xchacha20poly1305_decrypt(
 		cookie, src->encrypted_cookie, sizeof(src->encrypted_cookie),
-		peer->latest_cookie.last_mac1_sent, COOKIE_LEN, src->nonce,
-		peer->latest_cookie.cookie_decryption_key);
+		peer->latest_cookie.last_mac1_sent, COOKIE_LEN, &src->nonce,
+		&peer->latest_cookie.cookie_decryption_key);
 	up_read(&peer->latest_cookie.lock);
 
 	if (ret) {
diff --git a/drivers/net/wireguard/noise.c b/drivers/net/wireguard/noise.c
index 1fe8468f0bef..e4f560df5f03 100644
--- a/drivers/net/wireguard/noise.c
+++ b/drivers/net/wireguard/noise.c
@@ -461,7 +461,7 @@ static void handshake_init(u8 chaining_key[NOISE_HASH_LEN],
 }
 
 static void message_encrypt(u8 *dst_ciphertext, const u8 *src_plaintext,
-			    size_t src_len, u8 key[NOISE_SYMMETRIC_KEY_LEN],
+			    size_t src_len, u8 (*key)[NOISE_SYMMETRIC_KEY_LEN],
 			    u8 hash[NOISE_HASH_LEN])
 {
 	chacha20poly1305_encrypt(dst_ciphertext, src_plaintext, src_len, hash,
@@ -471,7 +471,7 @@ static void message_encrypt(u8 *dst_ciphertext, const u8 *src_plaintext,
 }
 
 static bool message_decrypt(u8 *dst_plaintext, const u8 *src_ciphertext,
-			    size_t src_len, u8 key[NOISE_SYMMETRIC_KEY_LEN],
+			    size_t src_len, u8 (*key)[NOISE_SYMMETRIC_KEY_LEN],
 			    u8 hash[NOISE_HASH_LEN])
 {
 	if (!chacha20poly1305_decrypt(dst_plaintext, src_ciphertext, src_len,
@@ -554,7 +554,7 @@ wg_noise_handshake_create_initiation(struct message_handshake_initiation *dst,
 	/* s */
 	message_encrypt(dst->encrypted_static,
 			handshake->static_identity->static_public,
-			NOISE_PUBLIC_KEY_LEN, key, handshake->hash);
+			NOISE_PUBLIC_KEY_LEN, &key, handshake->hash);
 
 	/* ss */
 	if (!mix_precomputed_dh(handshake->chaining_key, key,
@@ -564,7 +564,7 @@ wg_noise_handshake_create_initiation(struct message_handshake_initiation *dst,
 	/* {t} */
 	tai64n_now(timestamp);
 	message_encrypt(dst->encrypted_timestamp, timestamp,
-			NOISE_TIMESTAMP_LEN, key, handshake->hash);
+			NOISE_TIMESTAMP_LEN, &key, handshake->hash);
 
 	dst->sender_index = wg_index_hashtable_insert(
 		handshake->entry.peer->device->index_hashtable,
@@ -610,7 +610,7 @@ wg_noise_handshake_consume_initiation(struct message_handshake_initiation *src,
 
 	/* s */
 	if (!message_decrypt(s, src->encrypted_static,
-			     sizeof(src->encrypted_static), key, hash))
+			     sizeof(src->encrypted_static), &key, hash))
 		goto out;
 
 	/* Lookup which peer we're actually talking to */
@@ -626,7 +626,7 @@ wg_noise_handshake_consume_initiation(struct message_handshake_initiation *src,
 
 	/* {t} */
 	if (!message_decrypt(t, src->encrypted_timestamp,
-			     sizeof(src->encrypted_timestamp), key, hash))
+			     sizeof(src->encrypted_timestamp), &key, hash))
 		goto out;
 
 	down_read(&handshake->lock);
@@ -708,7 +708,7 @@ bool wg_noise_handshake_create_response(struct message_handshake_response *dst,
 		handshake->preshared_key);
 
 	/* {} */
-	message_encrypt(dst->encrypted_nothing, NULL, 0, key, handshake->hash);
+	message_encrypt(dst->encrypted_nothing, NULL, 0, &key, handshake->hash);
 
 	dst->sender_index = wg_index_hashtable_insert(
 		handshake->entry.peer->device->index_hashtable,
@@ -779,7 +779,7 @@ wg_noise_handshake_consume_response(struct message_handshake_response *src,
 
 	/* {} */
 	if (!message_decrypt(NULL, src->encrypted_nothing,
-			     sizeof(src->encrypted_nothing), key, hash))
+			     sizeof(src->encrypted_nothing), &key, hash))
 		goto fail;
 
 	/* Success! Copy everything to peer */
diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index eb8851113654..21b4d825e9f7 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -277,7 +277,7 @@ static bool decrypt_packet(struct sk_buff *skb, struct noise_keypair *keypair)
 
 	if (!chacha20poly1305_decrypt_sg_inplace(sg, skb->len, NULL, 0,
 					         PACKET_CB(skb)->nonce,
-						 keypair->receiving.key))
+						 &keypair->receiving.key))
 		return false;
 
 	/* Another ugly situation of pushing and pulling the header so as to
diff --git a/drivers/net/wireguard/send.c b/drivers/net/wireguard/send.c
index 26e09c30d596..a0d8c541b72c 100644
--- a/drivers/net/wireguard/send.c
+++ b/drivers/net/wireguard/send.c
@@ -215,7 +215,7 @@ static bool encrypt_packet(struct sk_buff *skb, struct noise_keypair *keypair)
 		return false;
 	return chacha20poly1305_encrypt_sg_inplace(sg, plaintext_len, NULL, 0,
 						   PACKET_CB(skb)->nonce,
-						   keypair->sending.key);
+						   &keypair->sending.key);
 }
 
 void wg_packet_send_keepalive(struct wg_peer *peer)
diff --git a/include/crypto/chacha20poly1305.h b/include/crypto/chacha20poly1305.h
index d2ac3ff7dc1e..4b49b229eb77 100644
--- a/include/crypto/chacha20poly1305.h
+++ b/include/crypto/chacha20poly1305.h
@@ -18,32 +18,32 @@ enum chacha20poly1305_lengths {
 void chacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
 			      const u8 *ad, const size_t ad_len,
 			      const u64 nonce,
-			      const u8 key[CHACHA20POLY1305_KEY_SIZE]);
+			      const u8 (*key)[CHACHA20POLY1305_KEY_SIZE]);
 
 bool __must_check
 chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
 			 const u8 *ad, const size_t ad_len, const u64 nonce,
-			 const u8 key[CHACHA20POLY1305_KEY_SIZE]);
+			 const u8 (*key)[CHACHA20POLY1305_KEY_SIZE]);
 
 void xchacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
 			       const u8 *ad, const size_t ad_len,
-			       const u8 nonce[XCHACHA20POLY1305_NONCE_SIZE],
-			       const u8 key[CHACHA20POLY1305_KEY_SIZE]);
+			       const u8 (*nonce)[XCHACHA20POLY1305_NONCE_SIZE],
+			       const u8 (*key)[CHACHA20POLY1305_KEY_SIZE]);
 
 bool __must_check xchacha20poly1305_decrypt(
 	u8 *dst, const u8 *src, const size_t src_len, const u8 *ad,
-	const size_t ad_len, const u8 nonce[XCHACHA20POLY1305_NONCE_SIZE],
-	const u8 key[CHACHA20POLY1305_KEY_SIZE]);
+	const size_t ad_len, const u8 (*nonce)[XCHACHA20POLY1305_NONCE_SIZE],
+	const u8 (*key)[CHACHA20POLY1305_KEY_SIZE]);
 
 bool chacha20poly1305_encrypt_sg_inplace(struct scatterlist *src, size_t src_len,
 					 const u8 *ad, const size_t ad_len,
 					 const u64 nonce,
-					 const u8 key[CHACHA20POLY1305_KEY_SIZE]);
+					 const u8 (*key)[CHACHA20POLY1305_KEY_SIZE]);
 
 bool chacha20poly1305_decrypt_sg_inplace(struct scatterlist *src, size_t src_len,
 					 const u8 *ad, const size_t ad_len,
 					 const u64 nonce,
-					 const u8 key[CHACHA20POLY1305_KEY_SIZE]);
+					 const u8 (*key)[CHACHA20POLY1305_KEY_SIZE]);
 
 bool chacha20poly1305_selftest(void);
 
diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
index 0b49d6aedefd..413e06eb1da0 100644
--- a/lib/crypto/chacha20poly1305.c
+++ b/lib/crypto/chacha20poly1305.c
@@ -18,20 +18,21 @@
 #include <linux/module.h>
 #include <linux/unaligned.h>
 
-static void chacha_load_key(u32 *k, const u8 *in)
+static void chacha_load_key(u32 *k, const u8 (*in)[CHACHA20POLY1305_KEY_SIZE])
 {
-	k[0] = get_unaligned_le32(in);
-	k[1] = get_unaligned_le32(in + 4);
-	k[2] = get_unaligned_le32(in + 8);
-	k[3] = get_unaligned_le32(in + 12);
-	k[4] = get_unaligned_le32(in + 16);
-	k[5] = get_unaligned_le32(in + 20);
-	k[6] = get_unaligned_le32(in + 24);
-	k[7] = get_unaligned_le32(in + 28);
+	k[0] = get_unaligned_le32((u8 *)in);
+	k[1] = get_unaligned_le32((u8 *)in + 4);
+	k[2] = get_unaligned_le32((u8 *)in + 8);
+	k[3] = get_unaligned_le32((u8 *)in + 12);
+	k[4] = get_unaligned_le32((u8 *)in + 16);
+	k[5] = get_unaligned_le32((u8 *)in + 20);
+	k[6] = get_unaligned_le32((u8 *)in + 24);
+	k[7] = get_unaligned_le32((u8 *)in + 28);
 }
 
 static void xchacha_init(struct chacha_state *chacha_state,
-			 const u8 *key, const u8 *nonce)
+			 const u8 (*key)[CHACHA20POLY1305_KEY_SIZE],
+			 const u8 (*nonce)[XCHACHA20POLY1305_NONCE_SIZE])
 {
 	u32 k[CHACHA_KEY_WORDS];
 	u8 iv[CHACHA_IV_SIZE];
@@ -42,7 +43,7 @@ static void xchacha_init(struct chacha_state *chacha_state,
 	chacha_load_key(k, key);
 
 	/* Compute the subkey given the original key and first 128 nonce bits */
-	chacha_init(chacha_state, k, nonce);
+	chacha_init(chacha_state, k, (u8 *)nonce);
 	hchacha_block(chacha_state, k, 20);
 
 	chacha_init(chacha_state, k, iv);
@@ -89,7 +90,7 @@ __chacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
 void chacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
 			      const u8 *ad, const size_t ad_len,
 			      const u64 nonce,
-			      const u8 key[CHACHA20POLY1305_KEY_SIZE])
+			      const u8 (*key)[CHACHA20POLY1305_KEY_SIZE])
 {
 	struct chacha_state chacha_state;
 	u32 k[CHACHA_KEY_WORDS];
@@ -111,8 +112,8 @@ EXPORT_SYMBOL(chacha20poly1305_encrypt);
 
 void xchacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
 			       const u8 *ad, const size_t ad_len,
-			       const u8 nonce[XCHACHA20POLY1305_NONCE_SIZE],
-			       const u8 key[CHACHA20POLY1305_KEY_SIZE])
+			       const u8 (*nonce)[XCHACHA20POLY1305_NONCE_SIZE],
+			       const u8 (*key)[CHACHA20POLY1305_KEY_SIZE])
 {
 	struct chacha_state chacha_state;
 
@@ -170,7 +171,7 @@ __chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
 bool chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
 			      const u8 *ad, const size_t ad_len,
 			      const u64 nonce,
-			      const u8 key[CHACHA20POLY1305_KEY_SIZE])
+			      const u8 (*key)[CHACHA20POLY1305_KEY_SIZE])
 {
 	struct chacha_state chacha_state;
 	u32 k[CHACHA_KEY_WORDS];
@@ -195,8 +196,8 @@ EXPORT_SYMBOL(chacha20poly1305_decrypt);
 
 bool xchacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
 			       const u8 *ad, const size_t ad_len,
-			       const u8 nonce[XCHACHA20POLY1305_NONCE_SIZE],
-			       const u8 key[CHACHA20POLY1305_KEY_SIZE])
+			       const u8 (*nonce)[XCHACHA20POLY1305_NONCE_SIZE],
+			       const u8 (*key)[CHACHA20POLY1305_KEY_SIZE])
 {
 	struct chacha_state chacha_state;
 
@@ -211,7 +212,7 @@ bool chacha20poly1305_crypt_sg_inplace(struct scatterlist *src,
 				       const size_t src_len,
 				       const u8 *ad, const size_t ad_len,
 				       const u64 nonce,
-				       const u8 key[CHACHA20POLY1305_KEY_SIZE],
+				       const u8 (*key)[CHACHA20POLY1305_KEY_SIZE],
 				       int encrypt)
 {
 	const u8 *pad0 = page_address(ZERO_PAGE(0));
@@ -335,7 +336,7 @@ bool chacha20poly1305_crypt_sg_inplace(struct scatterlist *src,
 bool chacha20poly1305_encrypt_sg_inplace(struct scatterlist *src, size_t src_len,
 					 const u8 *ad, const size_t ad_len,
 					 const u64 nonce,
-					 const u8 key[CHACHA20POLY1305_KEY_SIZE])
+					 const u8 (*key)[CHACHA20POLY1305_KEY_SIZE])
 {
 	return chacha20poly1305_crypt_sg_inplace(src, src_len, ad, ad_len,
 						 nonce, key, 1);
@@ -345,7 +346,7 @@ EXPORT_SYMBOL(chacha20poly1305_encrypt_sg_inplace);
 bool chacha20poly1305_decrypt_sg_inplace(struct scatterlist *src, size_t src_len,
 					 const u8 *ad, const size_t ad_len,
 					 const u64 nonce,
-					 const u8 key[CHACHA20POLY1305_KEY_SIZE])
+					 const u8 (*key)[CHACHA20POLY1305_KEY_SIZE])
 {
 	if (unlikely(src_len < POLY1305_DIGEST_SIZE))
 		return false;
-- 
2.52.0.rc1.455.g30608eb744-goog

