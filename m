Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794488080;
	b=PnZE91cX73IccczVXIw5f4q8iTr/amv4e1ZW4Haxj2H6xjLdNILDzjq5POpYjO0+hPzS
	 4HScuf9XByOIZtI0msjt3T6SA6V8JSWmF2qOgrG21kvoDtQ8IGJeLUQ/ybtjXuwaba5Dz
	 NSgRioY2vqUQvEjaBzvoJwUnT0YgTbopARulHj/S204pNHrlV51NNpovxDAC/8RIWey9G
	 HEgEXyi4v0Vu4BgBaHVObIIgcfGTIoA9JuXLbe8NE3G3S130ft5nL04ZgQQJ/RmebBgDs
	 gVcJjy8EvbYMXIYUQXt8xsGHZiToJwL1eUhk2lONYWLHk1sGG3uOSSbeSlj3B6GX5CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794488080;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ZqrL3YSK7/J5CHlbjaub2kbNXPRwgKnhW7SKdiAfIyw=;
	b=JRrkwUSm+IVUez752s8hwU3Z5HlE8l+a0QWo7eolqZhmP0OagzKXyEpi4W4pwI/aRBpG
	 3WEqOsIkkkDQfaEf3qALDgvFDie7Fh/ZZoj9U2NCLVbmo03Po+aEHEazo5W1rhJfeJVSL
	 cJuSq+ygU2sLoDtxd9JlXofSvsHSRGfpTNMHCitBL3JMD+F0KH6R1JXNdM6tYL4OiK14a
	 Z/Ow/pYFDrIoJDZ/DGn0XrLgPZBytvFK96+y0DSpbRpvQfvllxVwgSnNglIgEz3chD5/+
	 WYD3S2QFUmmGsA2sl3nUR/w4JcJuaLIQI3p/y3YMkbyawhEAevIH+d62Vjqy2PKwn2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openvpn.net;
	spf=pass smtp.mailfrom=openvpn.com;
	dkim=pass header.d=openvpn.net header.i=@openvpn.net header.a=rsa-sha256 header.s=google header.b=Mbn74vAi;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665D7606A32D
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 12:54:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 665D7606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=openvpn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openvpn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=openvpn.net header.i=@openvpn.net header.a=rsa-sha256 header.s=google header.b=Mbn74vAi
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so32595985e9.3
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 04:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvpn.net; s=google; t=1794488078; x=1795092878; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZqrL3YSK7/J5CHlbjaub2kbNXPRwgKnhW7SKdiAfIyw=;
        b=Mbn74vAiNa7SgOoOFxziLl1RY8o53epGuKlLc4V6lTNvrKFnlUcB+j0z/UvJ+M2vLL
         lYm8vLLWQ29khnzrrfZMgwz6X74yWx0opuXVAaHbVHO66Gs1AbVcFNFPQ5bGkagqKY+W
         UkpI+koGtxTOCu5mS8fD/QYtMJTI74rmil5gOAej5GslgmwRdrMhZ6MaCcKs8LmnQjuF
         arhXg2wAScEB4DKFjChmfWYblixFQPVKrmsjHVE9zGaamxg9dt1rq7kST4/2nH7HJwXM
         vMx5QiG19KvtXtaDXSuNClsPN0OeZbi4V+SD7pf8EGgc9JaSzkDkCpFr8hh/ijr+sbUr
         gmnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794488078; x=1795092878;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZqrL3YSK7/J5CHlbjaub2kbNXPRwgKnhW7SKdiAfIyw=;
        b=1kaAfHnuiVm6boLtQj4Bv6E82dqGRgybN4G1xBSYeJ/fwnzA3FxksvEwO2rbyOnAAy
         YJAqBhAcRLakN7BDKzw5LJC0l4Bt2vPd2FBB9XEpy8EWzji+H8EV5s29XHrpyDR2JDdc
         EdKOofzDGIytQQaUPpEgrFIuYIBGRVeVEV5/ie3pl/qkF5NNB728pEgqJa/xiWE9GhFr
         u8HcQK9McAtp46UCZu8RqUMsWTYfkl1gcerKD0zzaRzpKAmg5Ara6tcq6qxRLqL5Hg0h
         C39qelrz4LhJMgwWUfzhecgFD1Nhx/cx2QDtW+ohtbb6Si0j/CjS/lqwOF9+t5W49HD4
         L26w==
X-Gm-Message-State: APuU4Z/EeOtKB0Cn15ofJBjBsWO+ih5lEx0iQc2FsD3jfL9pvH/ZltaY
	SgsuIU4AXYwAiPG3O+FpY17yRAPLPxjEiyPbQ0k0XgE2c8XuWGSCapbknFmKQNzNgabEP0MvAf4
	i5aJq98m+wH68DUI8j5jb4pqwroKtJ/v6yQ1OreWK8wz0HjI0yojkIb89Nzg6zS52o1UXuGBw
X-Gm-Gg: AYBFou1A2Cyy14Qz+m/Fy6GiOJb/z6Ms74LmTf1yfIkCFZxwdfCJRHPIyPUqS0XUivq
	g+45zsmGcD0ZL8QVZqnlgSCm1R0PFmCcIe2CTydt2Z8t1kFkjEtanHfRyfYNZgn8GHgIthSB8KB
	KGp1cbFskXIot0KuA9+I2N8m5/Xumrm0aT8tfWOHqkiXgB0gSOq82LWDmaNEBdcKVcM7T57Fdrj
	XZ4sbGSELxa0geP+IQNv8kpSVsW5hroTz/u/l0LlVUHd2qtIu2bAbWlslyi0PJOlhkCeAi1d6ai
	w7SVhPdL+h7VLnXZe33wJBOmChNCgx8yT8I+NlwHgMNHXN5W5hFhLHLXxq6nFmOfwF4DHOtkyg7
	6aXtJzqStv1kQXUg9QZp1od0F8Rb8uzxt4CTdgmhudV4+XHPEh4y3S7h0VvehXOpoUdsj3AV7bv
	FLrZQzO+VT5Jl3RlJiiMlj61khmhc+dhSaUY3Ak67+PkUycJ9oHhYenbRyW9SSXDAZWbhK050p5
	ItrffLZ0J56fXoTGyPz6EDFwwj7cOZm1nH/vg/kUJa3RuqLgjvHKwAM9EOBLIZAHIEBv/bfojE1
	vdinhiL52Qumamh9a+dbNsFBgmHS+IZzAxV3U/vPc29GU78pa6eY
X-Received: by 2002:a05:600c:3b83:b0:4a1:f377:5c6c with SMTP id 5b1f17b1804b1-4ba0935dbfcmr110642915e9.10.1794488077227;
        Thu, 12 Nov 2026 04:54:37 -0800 (PST)
Received: from inifinity.homelan.mandelbit.com ([2001:67c:2fbc:1:56b9:769a:f836:6390])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49835858f26sm17202726f8f.18.2026.11.12.04.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:54:36 -0800 (PST)
From: Antonio Quartulli <antonio@openvpn.net>
To: linux-crypto@vger.kernel.org
Cc: Antonio Quartulli <antonio@mandelbit.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [RFC PATCH 2/5] lib/crypto: aegis128x4: Add AEGIS-128X4 library
Date: Thu, 12 Nov 2026 13:54:27 +0100
Message-ID: <20261112125432.3064939-3-antonio@openvpn.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112125432.3064939-1-antonio@openvpn.net>
References: <20261112125432.3064939-1-antonio@openvpn.net>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Antonio Quartulli <antonio@mandelbit.com>

Add a library implementation of AEGIS-128X4, the 4-way parallel variant
of AEGIS-128L specified in RFC 10032.  The API mirrors the AES-GCM one:
one-shot encryption and decryption, plus an incremental API for callers
with nonlinear data.

The state keeps the four AEGIS-128L instances interleaved by 16-byte
block, the layout of a 512-bit vector implementation, so that
architecture-optimized code can take over between any two calls.

Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
---
 include/crypto/aegis128x4.h | 275 +++++++++++++++++++
 lib/crypto/Kconfig          |   9 +
 lib/crypto/Makefile         |   5 +
 lib/crypto/aegis128x4.c     | 509 ++++++++++++++++++++++++++++++++++++
 4 files changed, 798 insertions(+)
 create mode 100644 include/crypto/aegis128x4.h
 create mode 100644 lib/crypto/aegis128x4.c

diff --git a/include/crypto/aegis128x4.h b/include/crypto/aegis128x4.h
new file mode 100644
index 000000000000..e89054a24470
--- /dev/null
+++ b/include/crypto/aegis128x4.h
@@ -0,0 +1,275 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * AEGIS-128X4 authenticated encryption and decryption (RFC 10032)
+ *
+ * Copyright 2026 Antonio Quartulli <antonio@mandelbit.com>
+ */
+#ifndef _CRYPTO_AEGIS128X4_H
+#define _CRYPTO_AEGIS128X4_H
+
+#include <linux/string.h>
+#include <linux/types.h>
+
+#define AEGIS128X4_KEY_SIZE	16
+#define AEGIS128X4_NONCE_SIZE	16
+#define AEGIS128X4_MAX_AUTHTAG_SIZE	32
+
+/* Number of parallel AEGIS-128L instances */
+#define AEGIS128X4_LANES	4
+
+/* Bytes absorbed and en/decrypted by each state update */
+#define AEGIS128X4_BLOCK_SIZE	(32 * AEGIS128X4_LANES)
+
+/**
+ * struct aegis128x4_key - A key prepared for AEGIS-128X4
+ */
+struct aegis128x4_key {
+	/* private: */
+	u8 key[AEGIS128X4_KEY_SIZE];
+	size_t authtag_len; /* Length of authentication tags in bytes */
+};
+
+/**
+ * aegis128x4_zeroize_key() - Zeroize an aegis128x4_key structure
+ * @key: The aegis128x4_key to zeroize
+ */
+static inline void aegis128x4_zeroize_key(struct aegis128x4_key *key)
+{
+	memzero_explicit(key, sizeof(*key));
+}
+
+/*
+ * The state: eight words, each holding the corresponding 16-byte block of the
+ * AEGIS-128L instance i at byte offset 16 * i.
+ */
+union aegis128x4_state {
+	u8 b[8][16 * AEGIS128X4_LANES];
+	__le32 w32[8][4 * AEGIS128X4_LANES];
+	u64 w64[8][2 * AEGIS128X4_LANES];
+};
+
+/**
+ * struct aegis128x4_ctx - Context for incrementally en/decrypting a message
+ */
+struct aegis128x4_ctx {
+	/* private: */
+	union aegis128x4_state state;
+	/*
+	 * The associated data or the plaintext of the incomplete block, which
+	 * is absorbed once complete or at the end of its phase
+	 */
+	u8 buf[AEGIS128X4_BLOCK_SIZE] __aligned(__alignof__(u64));
+	/*
+	 * Pointer to the key, which is assumed to live at least as long as this
+	 * struct.
+	 */
+	const struct aegis128x4_key *key;
+	/* Number of associated data bytes processed so far */
+	u64 ad_len;
+	/* Number of en/decrypted bytes processed so far */
+	u64 data_len;
+	/* Whether the associated data was absorbed and en/decryption began */
+	bool data;
+};
+
+/**
+ * aegis128x4_zeroize_ctx() - Zeroize an aegis128x4_ctx structure
+ * @ctx: The aegis128x4_ctx to zeroize
+ */
+static inline void aegis128x4_zeroize_ctx(struct aegis128x4_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
+/**
+ * aegis128x4_preparekey() - Prepare a key for AEGIS-128X4
+ * @key: (output) The key structure to initialize
+ * @in_key: The raw AEGIS-128X4 key
+ * @key_len: Length of the raw key in bytes: 16
+ * @authtag_len: Length of the authentication tag in bytes: 16 or 32
+ *
+ * Users should use aegis128x4_zeroize_key() to zeroize the key struct at the
+ * end of its lifetime.  (But if this function fails, zeroization is
+ * unnecessary.)
+ *
+ * Context: Any context.
+ * Return:
+ * * 0 on success
+ * * -EINVAL if either of the lengths is invalid
+ */
+int __must_check aegis128x4_preparekey(struct aegis128x4_key *key,
+				       const u8 *in_key, size_t key_len,
+				       size_t authtag_len);
+
+/**
+ * aegis128x4_encrypt() - Encrypt a message with AEGIS-128X4
+ * @dst: The destination ciphertext data.  Can be in-place or out-of-place.
+ *	 For other overlaps the behavior is unspecified.
+ * @src: The source plaintext data
+ * @data_len: Length of plaintext in bytes (and ciphertext excluding the tag):
+ *	      less than 2^61
+ * @authtag: The output authentication tag.  Length is the authtag_len that was
+ *	     passed to aegis128x4_preparekey().  Usually protocols put the tag at
+ *	     the end of the ciphertext, in which case this should be set to
+ *	     @dst + @data_len and @dst must have room for the tag.
+ * @ad: The associated data
+ * @ad_len: Length of associated data in bytes: less than 2^61
+ * @nonce: The 16-byte nonce.  All (key, nonce) pairs used MUST be distinct.
+ * @key: The key, already prepared using aegis128x4_preparekey()
+ *
+ * Context: Any context.
+ */
+void aegis128x4_encrypt(u8 *dst, const u8 *src, size_t data_len, u8 *authtag,
+			const u8 *ad, size_t ad_len,
+			const u8 nonce[at_least AEGIS128X4_NONCE_SIZE],
+			const struct aegis128x4_key *key);
+
+/**
+ * aegis128x4_decrypt() - Decrypt a message with AEGIS-128X4
+ * @dst: The destination plaintext data.  Can be in-place or out-of-place.
+ *	 For other overlaps the behavior is unspecified.
+ * @src: The source ciphertext data
+ * @data_len: Length of plaintext in bytes (and ciphertext excluding the tag):
+ *	      less than 2^61
+ * @authtag: The stored authentication tag.  Length is the authtag_len that was
+ *	     passed to aegis128x4_preparekey().  Usually protocols put the tag at
+ *	     the end of the ciphertext, in which case this should be set to
+ *	     @src + @data_len.
+ * @ad: The associated data
+ * @ad_len: Length of associated data in bytes: less than 2^61
+ * @nonce: The 16-byte nonce
+ * @key: The key, already prepared using aegis128x4_preparekey()
+ *
+ * Context: Any context.
+ * Return:
+ * * 0 on success.  This is the only case where any decrypted or associated data
+ *   can be used.
+ * * -EBADMSG if the message is inauthentic
+ */
+int __must_check aegis128x4_decrypt(u8 *dst, const u8 *src, size_t data_len,
+				    const u8 *authtag, const u8 *ad,
+				    size_t ad_len,
+				    const u8 nonce[at_least AEGIS128X4_NONCE_SIZE],
+				    const struct aegis128x4_key *key);
+
+/**
+ * aegis128x4_init() - Initialize context for incremental AEGIS-128X4
+ *		       encryption or decryption
+ * @ctx: The context to initialize
+ * @nonce: The 16-byte nonce.  All (key, nonce) pairs used for encryption MUST
+ *	   be distinct.
+ * @key: The key, already prepared using aegis128x4_preparekey().  Note that a
+ *	 pointer to the key is saved in the context, so the key must live at
+ *	 least as long as the context.
+ *
+ * The context should be zeroized at the end of its lifetime.  Normally that
+ * happens in aegis128x4_encrypt_final() or aegis128x4_decrypt_final(), but
+ * callers that abandon a context without finalizing it should explicitly
+ * zeroize it.
+ *
+ * IMPORTANT: Callers that are decrypting data MUST NOT assume that any
+ * decrypted or associated data is authentic until the authentication tag has
+ * been verified.  This incremental API is provided solely to support callers
+ * that can't efficiently use the one-shot functions due to using a nonlinear
+ * data layout.
+ *
+ * For incremental AEGIS-128X4 encryption, use:
+ *
+ * 1. aegis128x4_init()
+ * 2. aegis128x4_auth_update() (any number of times)
+ * 3. aegis128x4_encrypt_update() (any number of times)
+ * 4. aegis128x4_encrypt_final()
+ *
+ * For incremental AEGIS-128X4 decryption, use:
+ *
+ * 1. aegis128x4_init()
+ * 2. aegis128x4_auth_update() (any number of times)
+ * 3. aegis128x4_decrypt_update() (any number of times)
+ * 4. aegis128x4_decrypt_final()
+ *
+ * Context: Any context.
+ */
+void aegis128x4_init(struct aegis128x4_ctx *ctx,
+		     const u8 nonce[at_least AEGIS128X4_NONCE_SIZE],
+		     const struct aegis128x4_key *key);
+
+/**
+ * aegis128x4_auth_update() - Incrementally process AEGIS-128X4 associated data
+ * @ctx: An AEGIS-128X4 context
+ * @ad: The associated data
+ * @len: Number of bytes provided.  The caller must ensure that the total
+ *	 associated data length stays below 2^61.
+ *
+ * IMPORTANT: Callers MUST NOT assume that any decrypted or associated data is
+ * authentic until the authentication tag has been verified.
+ *
+ * Context: Any context.
+ */
+void aegis128x4_auth_update(struct aegis128x4_ctx *ctx, const u8 *ad,
+			    size_t len);
+
+/**
+ * aegis128x4_encrypt_update() - Incrementally encrypt data with AEGIS-128X4
+ * @ctx: An AEGIS-128X4 context
+ * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
+ *	 overlaps the behavior is unspecified.
+ * @src: The source plaintext data
+ * @len: Number of bytes to encrypt.  The caller must ensure that the total
+ *	 number of bytes encrypted stays below 2^61.
+ *
+ * This can be called only after all associated data has been processed.
+ *
+ * Context: Any context.
+ */
+void aegis128x4_encrypt_update(struct aegis128x4_ctx *ctx, u8 *dst,
+			       const u8 *src, size_t len);
+
+/**
+ * aegis128x4_decrypt_update() - Incrementally decrypt data with AEGIS-128X4
+ * @ctx: An AEGIS-128X4 context
+ * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
+ *	 overlaps the behavior is unspecified.
+ * @src: The source ciphertext data (not including auth tag)
+ * @len: Number of bytes to decrypt.  The caller must ensure that the total
+ *	 number of bytes decrypted stays below 2^61.
+ *
+ * This can be called only after all associated data has been processed.
+ *
+ * IMPORTANT: Callers MUST NOT assume that any decrypted or associated data is
+ * authentic until the authentication tag has been verified.
+ *
+ * Context: Any context.
+ */
+void aegis128x4_decrypt_update(struct aegis128x4_ctx *ctx, u8 *dst,
+			       const u8 *src, size_t len);
+
+/**
+ * aegis128x4_encrypt_final() - Finish encrypting a message with AEGIS-128X4
+ * @ctx: An AEGIS-128X4 context
+ * @authtag: The output authentication tag.  Length is the authtag_len that was
+ *	     passed to aegis128x4_preparekey().
+ *
+ * This also zeroizes @ctx, so the caller doesn't need to do it.
+ *
+ * Context: Any context.
+ */
+void aegis128x4_encrypt_final(struct aegis128x4_ctx *ctx, u8 *authtag);
+
+/**
+ * aegis128x4_decrypt_final() - Finish decrypting a message with AEGIS-128X4
+ * @ctx: An AEGIS-128X4 context
+ * @authtag: The stored authentication tag.  Length is the authtag_len that was
+ *	     passed to aegis128x4_preparekey().
+ *
+ * This also zeroizes @ctx, so the caller doesn't need to do it.
+ *
+ * Context: Any context.
+ * Return:
+ * * 0 on success.  This is the only case where any decrypted or associated data
+ *   can be used.
+ * * -EBADMSG if the message is inauthentic
+ */
+int __must_check aegis128x4_decrypt_final(struct aegis128x4_ctx *ctx,
+					  const u8 *authtag);
+
+#endif /* _CRYPTO_AEGIS128X4_H */
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 4644dee78ae3..3e53dd570b78 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -6,6 +6,15 @@ config CRYPTO_HASH_INFO
 config CRYPTO_LIB_UTILS
 	tristate
 
+config CRYPTO_LIB_AEGIS128X4
+	tristate
+	select CRYPTO_LIB_AES
+	select CRYPTO_LIB_UTILS
+	help
+	  The AEGIS-128X4 authenticated encryption algorithm (RFC 10032).
+	  Select this if your module uses any of the functions from
+	  <crypto/aegis128x4.h>.
+
 config CRYPTO_LIB_AES
 	tristate
 	# Select dependencies of modes that are part of libaes.
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 171b926afc39..be43ab974c0f 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -21,6 +21,11 @@ libcryptoutils-y				:= memneq.o utils.o
 
 ################################################################################
 
+obj-$(CONFIG_CRYPTO_LIB_AEGIS128X4) += libaegis128x4.o
+libaegis128x4-y := aegis128x4.o
+
+################################################################################
+
 obj-$(CONFIG_CRYPTO_LIB_AES) += libaes.o
 libaes-y := aes.o
 ifeq ($(CONFIG_CRYPTO_LIB_AES_ARCH),y)
diff --git a/lib/crypto/aegis128x4.c b/lib/crypto/aegis128x4.c
new file mode 100644
index 000000000000..4d5a46dc97e5
--- /dev/null
+++ b/lib/crypto/aegis128x4.c
@@ -0,0 +1,509 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * AEGIS-128X4 authenticated encryption and decryption (RFC 10032)
+ *
+ * AEGIS-128X4 runs four AEGIS-128L instances in parallel, which differ only
+ * by the context separator mixed in during initialization, and combines their
+ * authentication tags.  It is designed for CPUs that can apply the AES round
+ * function to four blocks at once.
+ *
+ * Copyright 2026 Antonio Quartulli <antonio@mandelbit.com>
+ */
+
+#include <crypto/aegis128x4.h>
+#include <crypto/aes.h>
+#include <crypto/utils.h>
+#include <linux/cache.h>
+#include <linux/export.h>
+#include <linux/module.h>
+#include <linux/unaligned.h>
+
+#define LANES		AEGIS128X4_LANES
+#define BLOCK_SIZE	AEGIS128X4_BLOCK_SIZE
+#define HALF_SIZE	(BLOCK_SIZE / 2)
+
+/* Maximum associated data and en/decrypted data lengths in bytes */
+#define AEGIS128X4_MAX_LEN ((1ULL << 61) - 1)
+
+static const u8 aegis_c0[16] = {
+	0x00, 0x01, 0x01, 0x02, 0x03, 0x05, 0x08, 0x0d,
+	0x15, 0x22, 0x37, 0x59, 0x90, 0xe9, 0x79, 0x62,
+};
+
+static const u8 aegis_c1[16] = {
+	0xdb, 0x3d, 0x18, 0x55, 0x6d, 0xc2, 0x2f, 0xf1,
+	0x20, 0x11, 0x31, 0x42, 0x73, 0xb5, 0x28, 0xdd,
+};
+
+#ifdef CONFIG_CRYPTO_LIB_AEGIS128X4_ARCH
+#include "aegis128x4.h" /* $(SRCARCH)/aegis128x4.h */
+#else
+static bool aegis128x4_init_arch(union aegis128x4_state *st,
+				 const u8 key[AEGIS128X4_KEY_SIZE],
+				 const u8 nonce[AEGIS128X4_NONCE_SIZE])
+{
+	return false;
+}
+
+static bool aegis128x4_absorb_arch(union aegis128x4_state *st, const u8 *src,
+				   size_t nblocks)
+{
+	return false;
+}
+
+static bool aegis128x4_enc_arch(union aegis128x4_state *st, u8 *dst,
+				const u8 *src, size_t nblocks)
+{
+	return false;
+}
+
+static bool aegis128x4_dec_arch(union aegis128x4_state *st, u8 *dst,
+				const u8 *src, size_t nblocks)
+{
+	return false;
+}
+
+static bool aegis128x4_final_arch(union aegis128x4_state *st, u8 *authtag,
+				  u64 ad_len, u64 data_len, size_t authtag_len)
+{
+	return false;
+}
+
+static bool aegis128x4_crypt_arch(u8 *dst, const u8 *src, size_t data_len,
+				  u8 *authtag, const u8 *ad, size_t ad_len,
+				  const u8 nonce[AEGIS128X4_NONCE_SIZE],
+				  const struct aegis128x4_key *key, bool enc)
+{
+	return false;
+}
+#endif
+
+/* Prefetch the AES table to mitigate cache-timing attacks. */
+static __always_inline void aegis128x4_prefetch_tab(void)
+{
+	for (size_t i = 0; i < sizeof(aes_enc_tab); i += L1_CACHE_BYTES)
+		*(volatile const u8 *)((const u8 *)aes_enc_tab + i);
+	barrier();
+}
+
+/*
+ * dst ^= AESRound(src, 0), i.e. dst = AESRound(src, dst), on the 16-byte block
+ * of each lane.  @dst and @src must be different state words.
+ */
+static __always_inline void aegis128x4_aesround(__le32 dst[4 * LANES],
+						const __le32 src[4 * LANES])
+{
+	const u32 *t = aes_enc_tab;
+
+	for (int i = 0; i < LANES; i++) {
+		const u8 *s = (const u8 *)&src[4 * i];
+		__le32 *d = &dst[4 * i];
+
+		d[0] ^= cpu_to_le32(t[s[0]] ^ rol32(t[s[5]], 8) ^
+				    rol32(t[s[10]], 16) ^ rol32(t[s[15]], 24));
+		d[1] ^= cpu_to_le32(t[s[4]] ^ rol32(t[s[9]], 8) ^
+				    rol32(t[s[14]], 16) ^ rol32(t[s[3]], 24));
+		d[2] ^= cpu_to_le32(t[s[8]] ^ rol32(t[s[13]], 8) ^
+				    rol32(t[s[2]], 16) ^ rol32(t[s[7]], 24));
+		d[3] ^= cpu_to_le32(t[s[12]] ^ rol32(t[s[1]], 8) ^
+				    rol32(t[s[6]], 16) ^ rol32(t[s[11]], 24));
+	}
+}
+
+/* The Update function: absorb @m0 and @m1, each HALF_SIZE bytes. */
+static void aegis128x4_update(union aegis128x4_state *st, const u8 *m0,
+			      const u8 *m1)
+{
+	__le32 s7[4 * LANES];
+
+	/*
+	 * Each new word j is AESRound(S[j - 1], S[j]), with the message
+	 * XOR'ed into words 0 and 4.  Compute them from the last one down, so
+	 * that S[j - 1] is still the old value, except for word 0, which needs
+	 * the old word 7.
+	 */
+	memcpy(s7, st->w32[7], sizeof(s7));
+	for (int j = 7; j > 0; j--)
+		aegis128x4_aesround(st->w32[j], st->w32[j - 1]);
+	aegis128x4_aesround(st->w32[0], s7);
+	crypto_xor(st->b[0], m0, HALF_SIZE);
+	crypto_xor(st->b[4], m1, HALF_SIZE);
+	memzero_explicit(s7, sizeof(s7));
+}
+
+/* Compute the keystream of the next block from the current state. */
+static void aegis128x4_keystream(const union aegis128x4_state *st,
+				 u8 z[BLOCK_SIZE])
+{
+	for (int i = 0; i < 2 * LANES; i++) {
+		u64 z0 = st->w64[1][i] ^ st->w64[6][i] ^
+			 (st->w64[2][i] & st->w64[3][i]);
+		u64 z1 = st->w64[2][i] ^ st->w64[5][i] ^
+			 (st->w64[6][i] & st->w64[7][i]);
+
+		memcpy(&z[8 * i], &z0, 8);
+		memcpy(&z[HALF_SIZE + 8 * i], &z1, 8);
+	}
+}
+
+static void aegis128x4_init_generic(union aegis128x4_state *st,
+				    const u8 key[AEGIS128X4_KEY_SIZE],
+				    const u8 nonce[AEGIS128X4_NONCE_SIZE])
+{
+	u8 key_v[HALF_SIZE], nonce_v[HALF_SIZE];
+
+	for (int i = 0; i < LANES; i++) {
+		u8 *k = &key_v[16 * i], *n = &nonce_v[16 * i];
+
+		memcpy(k, key, 16);
+		memcpy(n, nonce, 16);
+		crypto_xor_cpy(&st->b[0][16 * i], k, n, 16);
+		memcpy(&st->b[1][16 * i], aegis_c1, 16);
+		memcpy(&st->b[2][16 * i], aegis_c0, 16);
+		memcpy(&st->b[3][16 * i], aegis_c1, 16);
+		crypto_xor_cpy(&st->b[4][16 * i], k, n, 16);
+		crypto_xor_cpy(&st->b[5][16 * i], k, aegis_c0, 16);
+		crypto_xor_cpy(&st->b[6][16 * i], k, aegis_c1, 16);
+		crypto_xor_cpy(&st->b[7][16 * i], k, aegis_c0, 16);
+	}
+
+	for (int r = 0; r < 10; r++) {
+		/* ctx[i]: the lane index, then the highest lane index */
+		for (int i = 0; i < LANES; i++) {
+			st->b[3][16 * i] ^= i;
+			st->b[3][16 * i + 1] ^= LANES - 1;
+			st->b[7][16 * i] ^= i;
+			st->b[7][16 * i + 1] ^= LANES - 1;
+		}
+		aegis128x4_update(st, nonce_v, key_v);
+	}
+	memzero_explicit(key_v, sizeof(key_v));
+}
+
+static void aegis128x4_init_state(union aegis128x4_state *st,
+				  const u8 key[AEGIS128X4_KEY_SIZE],
+				  const u8 nonce[AEGIS128X4_NONCE_SIZE])
+{
+	if (!aegis128x4_init_arch(st, key, nonce)) {
+		aegis128x4_prefetch_tab();
+		aegis128x4_init_generic(st, key, nonce);
+	}
+}
+
+/* Absorb @nblocks full blocks. */
+static void aegis128x4_absorb(union aegis128x4_state *st, const u8 *src,
+			      size_t nblocks)
+{
+	if (!nblocks || aegis128x4_absorb_arch(st, src, nblocks))
+		return;
+
+	aegis128x4_prefetch_tab();
+	for (; nblocks; nblocks--, src += BLOCK_SIZE)
+		aegis128x4_update(st, src, src + HALF_SIZE);
+}
+
+/* En/decrypt @nblocks full blocks. */
+static void aegis128x4_crypt_blocks(union aegis128x4_state *st, u8 *dst,
+				    const u8 *src, size_t nblocks, bool enc)
+{
+	u8 z[BLOCK_SIZE], p[BLOCK_SIZE];
+
+	if (!nblocks || (enc ? aegis128x4_enc_arch(st, dst, src, nblocks) :
+			       aegis128x4_dec_arch(st, dst, src, nblocks)))
+		return;
+
+	aegis128x4_prefetch_tab();
+	for (; nblocks; nblocks--, src += BLOCK_SIZE, dst += BLOCK_SIZE) {
+		aegis128x4_keystream(st, z);
+		/*
+		 * The state absorbs the plaintext, so read it before writing
+		 * @dst, which may be the same buffer.
+		 */
+		if (enc) {
+			aegis128x4_update(st, src, src + HALF_SIZE);
+			crypto_xor_cpy(dst, src, z, BLOCK_SIZE);
+		} else {
+			crypto_xor_cpy(p, src, z, BLOCK_SIZE);
+			memcpy(dst, p, BLOCK_SIZE);
+			aegis128x4_update(st, p, p + HALF_SIZE);
+		}
+	}
+	memzero_explicit(z, sizeof(z));
+	memzero_explicit(p, sizeof(p));
+}
+
+static void aegis128x4_final_generic(union aegis128x4_state *st, u8 *authtag,
+				     u64 ad_len, u64 data_len,
+				     size_t authtag_len)
+{
+	u8 t[HALF_SIZE], tag[AEGIS128X4_MAX_AUTHTAG_SIZE] = {};
+
+	for (int i = 0; i < LANES; i++) {
+		put_unaligned_le64(ad_len * 8, &t[16 * i]);
+		put_unaligned_le64(data_len * 8, &t[16 * i + 8]);
+	}
+	crypto_xor(t, st->b[2], HALF_SIZE);
+
+	for (int r = 0; r < 7; r++)
+		aegis128x4_update(st, t, t);
+
+	for (int i = 0; i < LANES; i++) {
+		if (authtag_len == 16) {
+			for (int j = 0; j < 7; j++)
+				crypto_xor(tag, &st->b[j][16 * i], 16);
+		} else {
+			for (int j = 0; j < 4; j++)
+				crypto_xor(tag, &st->b[j][16 * i], 16);
+			for (int j = 4; j < 8; j++)
+				crypto_xor(&tag[16], &st->b[j][16 * i], 16);
+		}
+	}
+	memcpy(authtag, tag, authtag_len);
+	memzero_explicit(t, sizeof(t));
+	memzero_explicit(tag, sizeof(tag));
+}
+
+static void aegis128x4_final_state(union aegis128x4_state *st, u8 *authtag,
+				   u64 ad_len, u64 data_len,
+				   size_t authtag_len)
+{
+	if (!aegis128x4_final_arch(st, authtag, ad_len, data_len,
+				   authtag_len)) {
+		aegis128x4_prefetch_tab();
+		aegis128x4_final_generic(st, authtag, ad_len, data_len,
+					 authtag_len);
+	}
+}
+
+int aegis128x4_preparekey(struct aegis128x4_key *key, const u8 *in_key,
+			  size_t key_len, size_t authtag_len)
+{
+	if (key_len != AEGIS128X4_KEY_SIZE ||
+	    (authtag_len != 16 && authtag_len != 32))
+		return -EINVAL;
+	memcpy(key->key, in_key, AEGIS128X4_KEY_SIZE);
+	key->authtag_len = authtag_len;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(aegis128x4_preparekey);
+
+void aegis128x4_init(struct aegis128x4_ctx *ctx,
+		     const u8 nonce[AEGIS128X4_NONCE_SIZE],
+		     const struct aegis128x4_key *key)
+{
+	aegis128x4_init_state(&ctx->state, key->key, nonce);
+	ctx->key = key;
+	ctx->ad_len = 0;
+	ctx->data_len = 0;
+	ctx->data = false;
+}
+EXPORT_SYMBOL_GPL(aegis128x4_init);
+
+void aegis128x4_auth_update(struct aegis128x4_ctx *ctx, const u8 *ad,
+			    size_t len)
+{
+	size_t pos = ctx->ad_len % BLOCK_SIZE;
+
+	WARN_ON_ONCE(ctx->data);
+	ctx->ad_len += len;
+	if (pos) {
+		size_t n = min(len, BLOCK_SIZE - pos);
+
+		memcpy(&ctx->buf[pos], ad, n);
+		if (pos + n < BLOCK_SIZE)
+			return;
+		aegis128x4_absorb(&ctx->state, ctx->buf, 1);
+		ad += n;
+		len -= n;
+	}
+	aegis128x4_absorb(&ctx->state, ad, len / BLOCK_SIZE);
+	memcpy(ctx->buf, ad + round_down(len, BLOCK_SIZE), len % BLOCK_SIZE);
+}
+EXPORT_SYMBOL_GPL(aegis128x4_auth_update);
+
+/* Absorb the zero-padded incomplete block of @len bytes, if any. */
+static void aegis128x4_flush(struct aegis128x4_ctx *ctx, size_t len)
+{
+	size_t pos = len % BLOCK_SIZE;
+
+	if (pos) {
+		memset(&ctx->buf[pos], 0, BLOCK_SIZE - pos);
+		aegis128x4_absorb(&ctx->state, ctx->buf, 1);
+	}
+}
+
+static void aegis128x4_crypt_update(struct aegis128x4_ctx *ctx, u8 *dst,
+				    const u8 *src, size_t len, bool enc)
+{
+	size_t pos = ctx->data_len % BLOCK_SIZE;
+	size_t nblocks, tail;
+	u8 z[BLOCK_SIZE];
+
+	if (!ctx->data) {
+		aegis128x4_flush(ctx, ctx->ad_len);
+		ctx->data = true;
+	}
+	ctx->data_len += len;
+
+	/*
+	 * The incomplete block keeps its plaintext in ctx->buf.  Its keystream
+	 * depends only on the state, which changes once it's complete.
+	 */
+	if (pos) {
+		size_t n = min(len, BLOCK_SIZE - pos);
+
+		aegis128x4_keystream(&ctx->state, z);
+		if (enc) {
+			memcpy(&ctx->buf[pos], src, n);
+			crypto_xor_cpy(dst, &ctx->buf[pos], &z[pos], n);
+		} else {
+			crypto_xor_cpy(&ctx->buf[pos], src, &z[pos], n);
+			memcpy(dst, &ctx->buf[pos], n);
+		}
+		if (pos + n < BLOCK_SIZE)
+			goto out;
+		aegis128x4_absorb(&ctx->state, ctx->buf, 1);
+		src += n;
+		dst += n;
+		len -= n;
+	}
+
+	nblocks = len / BLOCK_SIZE;
+	aegis128x4_crypt_blocks(&ctx->state, dst, src, nblocks, enc);
+	src += nblocks * BLOCK_SIZE;
+	dst += nblocks * BLOCK_SIZE;
+
+	tail = len % BLOCK_SIZE;
+	if (tail) {
+		aegis128x4_keystream(&ctx->state, z);
+		if (enc) {
+			memcpy(ctx->buf, src, tail);
+			crypto_xor_cpy(dst, ctx->buf, z, tail);
+		} else {
+			crypto_xor_cpy(ctx->buf, src, z, tail);
+			memcpy(dst, ctx->buf, tail);
+		}
+	}
+out:
+	memzero_explicit(z, sizeof(z));
+}
+
+void aegis128x4_encrypt_update(struct aegis128x4_ctx *ctx, u8 *dst,
+			       const u8 *src, size_t len)
+{
+	aegis128x4_crypt_update(ctx, dst, src, len, true);
+}
+EXPORT_SYMBOL_GPL(aegis128x4_encrypt_update);
+
+void aegis128x4_decrypt_update(struct aegis128x4_ctx *ctx, u8 *dst,
+			       const u8 *src, size_t len)
+{
+	aegis128x4_crypt_update(ctx, dst, src, len, false);
+}
+EXPORT_SYMBOL_GPL(aegis128x4_decrypt_update);
+
+static void aegis128x4_compute_tag(struct aegis128x4_ctx *ctx, u8 *authtag)
+{
+	if (!ctx->data)
+		aegis128x4_flush(ctx, ctx->ad_len);
+	else
+		aegis128x4_flush(ctx, ctx->data_len);
+	aegis128x4_final_state(&ctx->state, authtag, ctx->ad_len,
+			       ctx->data_len, ctx->key->authtag_len);
+}
+
+void aegis128x4_encrypt_final(struct aegis128x4_ctx *ctx, u8 *authtag)
+{
+	WARN_ON_ONCE(ctx->ad_len > AEGIS128X4_MAX_LEN);
+	WARN_ON_ONCE(ctx->data_len > AEGIS128X4_MAX_LEN);
+
+	aegis128x4_compute_tag(ctx, authtag);
+	aegis128x4_zeroize_ctx(ctx);
+}
+EXPORT_SYMBOL_GPL(aegis128x4_encrypt_final);
+
+int aegis128x4_decrypt_final(struct aegis128x4_ctx *ctx, const u8 *authtag)
+{
+	size_t authtag_len = ctx->key->authtag_len;
+	u8 expected[AEGIS128X4_MAX_AUTHTAG_SIZE];
+	int err;
+
+	if (WARN_ON_ONCE(ctx->ad_len > AEGIS128X4_MAX_LEN) ||
+	    WARN_ON_ONCE(ctx->data_len > AEGIS128X4_MAX_LEN)) {
+		aegis128x4_zeroize_ctx(ctx);
+		return -EBADMSG;
+	}
+
+	aegis128x4_compute_tag(ctx, expected);
+	err = crypto_memneq(expected, authtag, authtag_len) ? -EBADMSG : 0;
+	aegis128x4_zeroize_ctx(ctx);
+	memzero_explicit(expected, sizeof(expected));
+	return err;
+}
+EXPORT_SYMBOL_GPL(aegis128x4_decrypt_final);
+
+void aegis128x4_encrypt(u8 *dst, const u8 *src, size_t data_len, u8 *authtag,
+			const u8 *ad, size_t ad_len,
+			const u8 nonce[AEGIS128X4_NONCE_SIZE],
+			const struct aegis128x4_key *key)
+{
+	struct aegis128x4_ctx ctx;
+
+	if (aegis128x4_crypt_arch(dst, src, data_len, authtag, ad, ad_len,
+				  nonce, key, true))
+		return;
+
+	aegis128x4_init(&ctx, nonce, key);
+	aegis128x4_auth_update(&ctx, ad, ad_len);
+	aegis128x4_encrypt_update(&ctx, dst, src, data_len);
+	aegis128x4_encrypt_final(&ctx, authtag);
+}
+EXPORT_SYMBOL_GPL(aegis128x4_encrypt);
+
+int aegis128x4_decrypt(u8 *dst, const u8 *src, size_t data_len,
+		       const u8 *authtag, const u8 *ad, size_t ad_len,
+		       const u8 nonce[AEGIS128X4_NONCE_SIZE],
+		       const struct aegis128x4_key *key)
+{
+	struct aegis128x4_ctx ctx;
+	u8 expected[AEGIS128X4_MAX_AUTHTAG_SIZE];
+	int err;
+
+	if (aegis128x4_crypt_arch(dst, src, data_len, expected, ad, ad_len,
+				  nonce, key, false)) {
+		err = crypto_memneq(expected, authtag, key->authtag_len) ?
+			      -EBADMSG : 0;
+		memzero_explicit(expected, sizeof(expected));
+	} else {
+		aegis128x4_init(&ctx, nonce, key);
+		aegis128x4_auth_update(&ctx, ad, ad_len);
+		aegis128x4_decrypt_update(&ctx, dst, src, data_len);
+		err = aegis128x4_decrypt_final(&ctx, authtag);
+	}
+	if (unlikely(err) && data_len) {
+		/*
+		 * Clear the inauthentic decrypted data so that callers won't
+		 * receive it even if they fail to correctly handle errors.
+		 */
+		memzero_explicit(dst, data_len);
+	}
+	return err;
+}
+EXPORT_SYMBOL_GPL(aegis128x4_decrypt);
+
+#ifdef aegis128x4_mod_init_arch
+static int __init aegis128x4_mod_init(void)
+{
+	aegis128x4_mod_init_arch();
+	return 0;
+}
+subsys_initcall(aegis128x4_mod_init);
+
+static void __exit aegis128x4_mod_exit(void)
+{
+}
+module_exit(aegis128x4_mod_exit);
+#endif
+
+MODULE_DESCRIPTION("AEGIS-128X4 authenticated encryption algorithm");
+MODULE_LICENSE("GPL");
-- 
2.56.0

