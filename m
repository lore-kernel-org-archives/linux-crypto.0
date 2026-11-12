Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794488082;
	b=dWAknviQtKXpjHh/kTGnj2rp8e8h8cMIgBCHMooRLOeJMGag6j34CsQ+G3mQbNwWm+c/
	 fOU+KJLMS0IZHpRtxY5K07+jJaA0IXs+/Qh3fYsZCroWuivfAEYNgABwkg9E1YlPgPn6N
	 3bBn2Fy2o+r3LG6qN+c7eKE2wiycZyQKBC84Q7dQRXG7ZdGwsZaKFA1YGLqZlMqS0Widz
	 w08DXnvUcHC5R7mk207qcbJMBLyJi+SmX/QLgAsA/tGk2l+/ofEFunxh26Xbooz1cIF+g
	 yJdoGiDYeNGxl2AdJzs2BEXYQdF40u2dUNazoChOoHaNzldDkZ/TPUhV2qRwPmzT1Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794488082;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=5l72XypY0Nz7Y6X/vNEmrfHoJrBJqJ0KdX4CuH9TG1M=;
	b=NgzyK8WK4FIJUU8oW+6S2K/4cDbPJJyJq4uh43NxGpQEAjemsZtkf3dPfkcirFe4i8y+
	 bzSt1uS9Cm1vMg4fuqSKDZEVbn4FriE1Ur6UAOJ7K9jgpOfOhsLyZGSWQ7L51wLyWyKDe
	 7f5Qkz0FyF3eTSGwonR/MGE51WCTu7jr0qqJ/kgsKWz5Y+3G8BUVrPBgX2ujsCoGHRbem
	 WciTUX8XtksXjrdXvG+zTzQc0cuFfNojkLPqw8X/tTNeDLRFui2LJkp2ClfXvLa479tiy
	 BFK13VDcFNfYfWi0Y0XM/fl5Dx4EmJ3eThi55GuDjbtOw2YLnNWMWZtXj3rbn84xBLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openvpn.net;
	spf=pass smtp.mailfrom=openvpn.com;
	dkim=pass header.d=openvpn.net header.i=@openvpn.net header.a=rsa-sha256 header.s=google header.b=SwWFPWaK;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA42E606A334
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 12:54:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA42E606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=openvpn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openvpn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=openvpn.net header.i=@openvpn.net header.a=rsa-sha256 header.s=google header.b=SwWFPWaK
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-491aaed7565so2503151f8f.2
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 04:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvpn.net; s=google; t=1794488080; x=1795092880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5l72XypY0Nz7Y6X/vNEmrfHoJrBJqJ0KdX4CuH9TG1M=;
        b=SwWFPWaKbylpQU/vg8SweZPqHHWjmIkoHFvlmFYAAwdJUVFSWi63XatkwHPivUHIsZ
         9f9e6Lpal1A9v/qCaC8f9MjG34oiUhMw9t9cdax7+eVhi4M5UwvypY9AQPqaypZ7Ag6S
         nK/MAugNiDeIMEZNKSSdrXbeevrzOS0/Mode+WYj+8vVZp7lMF2PvTP8d14w8UipwH96
         o/vGrHzpUzd5tEQdecX+wmROyOQFExg+heihxkbU04Sf4pBlYand5/A408pNe2UgLLME
         ra5Tl2mF3rU9DbHqMMSMqU47AcOJ4hf3Y2s0gPNpQPJfK1zqMx1yApsarRhL17FkAaBK
         6vnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794488080; x=1795092880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5l72XypY0Nz7Y6X/vNEmrfHoJrBJqJ0KdX4CuH9TG1M=;
        b=op37BC4ZVpc33bDhXS+Vnyz4LQh4NC3l7g0a2jOG0XA8QiEB6yFRSYbaLrdq470140
         MnwEdv50MFCs79PEdrYCFsKwSFV2T6PyrgChoqRGOgXF/1dLEyJQZ8boO8lv1QYlpRwc
         5phe8jQCh0GCfrvqsItOvuyIYYQa6HzoeajU5YRyJe7ed6uV4BUxGkKOoTVyshsqIz5H
         Xwoxv9yfTPR4Lyvs9jVznzDY1AgOOTQqYD5uPkO7z8fm5cCAWTZjmwvaT+HVeO8UeSbv
         FB2bKjvf6+86Ss7Dt9o7N3GsofYKdezAqn2igbc1xzfIdN/T0U2KGvoH2BSd8Nds0gt7
         Ohag==
X-Gm-Message-State: APuU4Z8gq3OBCyxQaKy3Jc2uQxhF6U7wkigDqn8FdDHwl3pdGy0wIPBS
	7H4DfhQQFgUGW38zSRbN8oWVWjjJ6nFkKJR7I7hguSvk8OnksWMnPn3TNaBeuwjiGkTrpcWcYUA
	sUG2vC0zE8AqRWjlt/MVWXXCWa29c0gl3E2h8xF9cT+VZObfh2f0yTVvQ7rZocvvg9JI0KC1o
X-Gm-Gg: AYBFou0cGZNtDZR9HIHj6Hd+A/IUZHBV+0lVCKhKDKkHGHDLx25EnIHQB7/p+kxJ+H4
	y/VOHyNd4qFq4hsZq0pc59f5B5MQS0kIxlmVUlAN4Ke5ruAE8fl1Gzjukf9eeJuL7fed0KRLpXN
	uORGitLOn1r7/ocZX3FmidPY6gADDyc/oHOmMQ96oy3Y7GBftoumX/XlXO7ndWvfj7LJ4Duy8qC
	n5IBrfV7zBqJN6mlyBSXGdxx9RH44/M0+hSBNIYZwKkvqULa44pufkt/hFyqsh+J/bE5cqoJPmA
	/wzv+MlDJE3NmCL5L25Srw8G4bCYjQdgjFY5cJ33peGSBiUcBZBUYa2S5e2DbS1Is+7bTwMzaXu
	qNFuxoJckWGKnu1FDUcwk4KQy/5sBn99yv51ObImlMyfHZeYBA7oZKf0ijYvLOUYpxN39zEe8bl
	j737eefKFONTDWVHJBWhxS+rOZ8ZprAGvrmlwfYHxgmnbcTMKzn775MSebq++5csCws2jcTPRY0
	Hu+ZCJe/FSzRcGBGEIsZsLy+UiVVRlF2jrnTe5Xg9QVy+YH4Bt4eU2lqK6vDa1RuHTXJkJJpXbC
	tZq9S3tyRvUlHNLn2Yv5AiHKTVCOIuFEhWfpdwEMHfh0gMnxbm1s6w==
X-Received: by 2002:a05:6000:250c:b0:498:be72:6370 with SMTP id ffacd0b85a97d-499c7270eaamr10736910f8f.10.1794488080161;
        Thu, 12 Nov 2026 04:54:40 -0800 (PST)
Received: from inifinity.homelan.mandelbit.com ([2001:67c:2fbc:1:56b9:769a:f836:6390])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49835858f26sm17202726f8f.18.2026.11.12.04.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:54:39 -0800 (PST)
From: Antonio Quartulli <antonio@openvpn.net>
To: linux-crypto@vger.kernel.org
Cc: Antonio Quartulli <antonio@mandelbit.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [RFC PATCH 5/5] crypto: aegis128x4 - Add AEGIS-128X4 AEAD algorithm
Date: Thu, 12 Nov 2026 13:54:30 +0100
Message-ID: <20261112125432.3064939-6-antonio@openvpn.net>
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

Add the "aegis128x4" AEAD algorithm, as a wrapper around the AEGIS-128X4
library, together with the RFC 10032 test vectors for the self-tests.

Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
---
 crypto/Kconfig      |  11 +++
 crypto/Makefile     |   1 +
 crypto/aegis128x4.c | 173 ++++++++++++++++++++++++++++++++++++++++++++
 crypto/testmgr.c    |   7 ++
 crypto/testmgr.h    | 119 ++++++++++++++++++++++++++++++
 5 files changed, 311 insertions(+)
 create mode 100644 crypto/aegis128x4.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 981d5dc422d4..d97f049ac54b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -760,6 +760,17 @@ config CRYPTO_AEGIS128_SIMD
 	  Architecture: arm or arm64 using:
 	  - NEON (Advanced SIMD) extension
 
+config CRYPTO_AEGIS128X4
+	tristate "AEGIS-128X4"
+	select CRYPTO_AEAD
+	select CRYPTO_LIB_AEGIS128X4
+	help
+	  AEGIS-128X4 AEAD algorithm (RFC 10032), the 4-way parallel variant of
+	  AEGIS-128L.
+
+	  This is a wrapper around the AEGIS-128X4 library, which has an
+	  optimized implementation for x86_64 CPUs with VAES and AVX-512.
+
 config CRYPTO_CHACHA20POLY1305
 	tristate "ChaCha20-Poly1305"
 	select CRYPTO_CHACHA20
diff --git a/crypto/Makefile b/crypto/Makefile
index 33bb5ad595e8..cc4a41719221 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -116,6 +116,7 @@ aegis128-cflags-$(CONFIG_CC_IS_GCC) += -ffixed-q16 -ffixed-q17 -ffixed-q18 \
 CFLAGS_aegis128-neon-inner.o += $(aegis128-cflags-y)
 aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
 endif
+obj-$(CONFIG_CRYPTO_AEGIS128X4) += aegis128x4.o
 
 obj-$(CONFIG_CRYPTO_PCRYPT) += pcrypt.o
 obj-$(CONFIG_CRYPTO_CRYPTD) += cryptd.o
diff --git a/crypto/aegis128x4.c b/crypto/aegis128x4.c
new file mode 100644
index 000000000000..57410fa71032
--- /dev/null
+++ b/crypto/aegis128x4.c
@@ -0,0 +1,173 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Crypto API support for AEGIS-128X4, using the library
+ *
+ * Copyright 2026 Antonio Quartulli <antonio@mandelbit.com>
+ */
+
+#include <crypto/aegis128x4.h>
+#include <crypto/internal/aead.h>
+#include <crypto/scatterwalk.h>
+#include <linux/module.h>
+
+static_assert(__alignof__(struct aegis128x4_key) <= CRYPTO_MINALIGN);
+
+static int crypto_aegis128x4_setkey(struct crypto_aead *tfm, const u8 *in_key,
+				    unsigned int key_len)
+{
+	struct aegis128x4_key *key = crypto_aead_ctx(tfm);
+
+	return aegis128x4_preparekey(key, in_key, key_len,
+				     crypto_aead_authsize(tfm));
+}
+
+static int crypto_aegis128x4_setauthsize(struct crypto_aead *tfm,
+					 unsigned int authsize)
+{
+	struct aegis128x4_key *key = crypto_aead_ctx(tfm);
+
+	if (authsize != 16 && authsize != 32)
+		return -EINVAL;
+	/* Synchronize the tag length to the struct aegis128x4_key. */
+	key->authtag_len = authsize;
+	return 0;
+}
+
+static void crypto_aegis128x4_process_ad(struct aegis128x4_ctx *ctx,
+					 struct scatterlist *src,
+					 unsigned int assoclen)
+{
+	struct scatter_walk walk;
+
+	scatterwalk_start(&walk, src);
+	while (assoclen) {
+		unsigned int n = scatterwalk_next(&walk, assoclen);
+
+		aegis128x4_auth_update(ctx, walk.addr, n);
+		scatterwalk_done_src(&walk, n);
+		assoclen -= n;
+	}
+}
+
+/*
+ * En/decrypt @len bytes from @src to @dst, starting @pos bytes into both.  The
+ * incremental functions accept any length, so each piece is passed directly.
+ * The scatterlists must describe either entirely different memory or entirely
+ * the same memory.
+ */
+static void crypto_aegis128x4_crypt(struct aegis128x4_ctx *ctx,
+				    struct scatterlist *dst,
+				    struct scatterlist *src, unsigned int pos,
+				    unsigned int len, bool enc)
+{
+	struct scatter_walk dst_walk, src_walk;
+
+	if (!len)
+		return;
+
+	scatterwalk_start_at_pos(&dst_walk, dst, pos);
+	scatterwalk_start_at_pos(&src_walk, src, pos);
+	do {
+		unsigned int n = min(scatterwalk_clamp(&dst_walk, len),
+				     scatterwalk_clamp(&src_walk, len));
+		const u8 *src_virt;
+		u8 *dst_virt;
+
+		scatterwalk_map(&dst_walk);
+		dst_virt = dst_walk.addr;
+		/* map a highmem page only once when in-place */
+		if (IS_ENABLED(CONFIG_HIGHMEM) &&
+		    offset_in_page(src_walk.offset) ==
+			    offset_in_page(dst_walk.offset) &&
+		    sg_page(src_walk.sg) + src_walk.offset / PAGE_SIZE ==
+			    sg_page(dst_walk.sg) + dst_walk.offset / PAGE_SIZE) {
+			src_virt = dst_virt;
+		} else {
+			scatterwalk_map(&src_walk);
+			src_virt = src_walk.addr;
+		}
+		if (enc)
+			aegis128x4_encrypt_update(ctx, dst_virt, src_virt, n);
+		else
+			aegis128x4_decrypt_update(ctx, dst_virt, src_virt, n);
+		if (src_virt != dst_virt)
+			scatterwalk_unmap(&src_walk);
+		scatterwalk_advance(&src_walk, n);
+		scatterwalk_done_dst(&dst_walk, n);
+		len -= n;
+	} while (len);
+}
+
+static int crypto_aegis128x4_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	const struct aegis128x4_key *key = crypto_aead_ctx(tfm);
+	u8 authtag[AEGIS128X4_MAX_AUTHTAG_SIZE];
+	struct aegis128x4_ctx ctx;
+
+	aegis128x4_init(&ctx, req->iv, key);
+	crypto_aegis128x4_process_ad(&ctx, req->src, req->assoclen);
+	crypto_aegis128x4_crypt(&ctx, req->dst, req->src, req->assoclen,
+				req->cryptlen, true);
+	aegis128x4_encrypt_final(&ctx, authtag);
+	memcpy_to_sglist(req->dst, req->assoclen + req->cryptlen, authtag,
+			 key->authtag_len);
+	memzero_explicit(authtag, sizeof(authtag));
+	return 0;
+}
+
+static int crypto_aegis128x4_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	const struct aegis128x4_key *key = crypto_aead_ctx(tfm);
+	u8 authtag[AEGIS128X4_MAX_AUTHTAG_SIZE];
+	struct aegis128x4_ctx ctx;
+	unsigned int data_len;
+	int err;
+
+	/* crypto_aead_decrypt() already checked cryptlen >= authtag_len. */
+	data_len = req->cryptlen - key->authtag_len;
+
+	aegis128x4_init(&ctx, req->iv, key);
+	crypto_aegis128x4_process_ad(&ctx, req->src, req->assoclen);
+	crypto_aegis128x4_crypt(&ctx, req->dst, req->src, req->assoclen,
+				data_len, false);
+	memcpy_from_sglist(authtag, req->src, req->assoclen + data_len,
+			   key->authtag_len);
+	err = aegis128x4_decrypt_final(&ctx, authtag);
+	memzero_explicit(authtag, sizeof(authtag));
+	return err;
+}
+
+static struct aead_alg crypto_aegis128x4_alg = {
+	.base.cra_name = "aegis128x4",
+	.base.cra_driver_name = "aegis128x4-lib",
+	.base.cra_priority = 300,
+	.base.cra_blocksize = 1,
+	.base.cra_ctxsize = sizeof(struct aegis128x4_key),
+	.base.cra_module = THIS_MODULE,
+	.setkey = crypto_aegis128x4_setkey,
+	.setauthsize = crypto_aegis128x4_setauthsize,
+	.encrypt = crypto_aegis128x4_encrypt,
+	.decrypt = crypto_aegis128x4_decrypt,
+	.ivsize = AEGIS128X4_NONCE_SIZE,
+	.maxauthsize = AEGIS128X4_MAX_AUTHTAG_SIZE,
+	.chunksize = AEGIS128X4_BLOCK_SIZE,
+};
+
+static int __init crypto_aegis128x4_mod_init(void)
+{
+	return crypto_register_aead(&crypto_aegis128x4_alg);
+}
+module_init(crypto_aegis128x4_mod_init);
+
+static void __exit crypto_aegis128x4_mod_exit(void)
+{
+	crypto_unregister_aead(&crypto_aegis128x4_alg);
+}
+module_exit(crypto_aegis128x4_mod_exit);
+
+MODULE_DESCRIPTION("AEGIS-128X4 AEAD algorithm");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_CRYPTO("aegis128x4");
+MODULE_ALIAS_CRYPTO("aegis128x4-lib");
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 9419d61d0602..dd6e3c2cabec 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4068,6 +4068,13 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.aead = __VECS(aegis128_tv_template)
 		}
+	}, {
+		.alg = "aegis128x4",
+		.generic_driver = "aegis128x4-lib",
+		.test = alg_test_aead,
+		.suite = {
+			.aead = __VECS(aegis128x4_tv_template)
+		}
 	}, {
 		.alg = "authenc(hmac(md5),cbc(aes))",
 		.generic_driver = "authenc(hmac-md5-lib,cbc(aes-lib))",
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 0ee15a8fae27..6bc819bc0c67 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -23755,6 +23755,125 @@ static const struct aead_testvec aegis128_tv_template[] = {
 	},
 };
 
+/* AEGIS-128X4 test vectors from RFC 10032, Appendix A.5 */
+static const struct aead_testvec aegis128x4_tv_template[] = {
+	{
+		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.klen	= 16,
+		.iv	= "\x10\x11\x12\x13\x14\x15\x16\x17"
+			  "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f",
+		.assoc	= "",
+		.alen	= 0,
+		.ptext	= "",
+		.plen	= 0,
+		.ctext	= "\x5b\xef\x76\x2d\x09\x47\xc0\x04"
+			  "\x55\xb9\x7b\xb3\xaf\x30\xdf\xa3",
+		.clen	= 16,
+	}, {
+		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.klen	= 16,
+		.iv	= "\x10\x11\x12\x13\x14\x15\x16\x17"
+			  "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f",
+		.assoc	= "",
+		.alen	= 0,
+		.ptext	= "",
+		.plen	= 0,
+		.ctext	= "\xa4\xb2\x54\x37\xf4\xbe\x93\xcf"
+			  "\xa8\x56\xa2\xf2\x7e\x44\x16\xb4"
+			  "\x2c\xac\x79\xfd\x46\x98\xf2\xcd"
+			  "\xbe\x6a\xf2\x56\x73\xe1\x0a\x68",
+		.clen	= 32,
+	}, {
+		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.klen	= 16,
+		.iv	= "\x10\x11\x12\x13\x14\x15\x16\x17"
+			  "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f",
+		.assoc	= "\x01\x02\x03\x04\x01\x02\x03\x04",
+		.alen	= 8,
+		.ptext	= "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07",
+		.plen	= 120,
+		.ctext	= "\xe8\x36\x11\x85\x62\xf4\x47\x9c"
+			  "\x9d\x35\xc1\x73\x56\xa8\x33\x11"
+			  "\x4c\x21\xf9\xaa\x39\xe4\xdd\xa5"
+			  "\xe5\xc8\x7f\x41\x52\xa0\x0f\xce"
+			  "\x9a\x7c\x38\xf8\x32\xea\xfe\x8b"
+			  "\x1c\x12\xf8\xa7\xcf\x12\xa8\x1a"
+			  "\x1a\xd8\xa9\xc2\x4b\xa9\xde\xdf"
+			  "\xbd\xaa\x58\x6f\xfe\xa6\x7d\xdc"
+			  "\x80\x1e\xa9\x7d\x9a\xb4\xa8\x72"
+			  "\xf4\x2d\x0e\x35\x2e\x27\x13\xda"
+			  "\xcd\x60\x9f\x94\x42\xc1\x75\x17"
+			  "\xc5\xa2\x9d\xaf\x3e\x2a\x3f\xac"
+			  "\x4f\xf6\xb1\x38\x0c\x4e\x46\xdf"
+			  "\x7b\x08\x6a\xf6\xce\x6b\xc1\xed"
+			  "\x59\x4b\x8d\xd6\x4a\xed\x2a\x7e"
+			  "\x0e\x56\xab\x94\xe2\xe8\x5d\xb8"
+			  "\x0f\x9d\x54\x01\x0c\xaa\xbf\xb4",
+		.clen	= 136,
+	}, {
+		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.klen	= 16,
+		.iv	= "\x10\x11\x12\x13\x14\x15\x16\x17"
+			  "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f",
+		.assoc	= "\x01\x02\x03\x04\x01\x02\x03\x04",
+		.alen	= 8,
+		.ptext	= "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07"
+			  "\x04\x05\x06\x07\x04\x05\x06\x07",
+		.plen	= 120,
+		.ctext	= "\xe8\x36\x11\x85\x62\xf4\x47\x9c"
+			  "\x9d\x35\xc1\x73\x56\xa8\x33\x11"
+			  "\x4c\x21\xf9\xaa\x39\xe4\xdd\xa5"
+			  "\xe5\xc8\x7f\x41\x52\xa0\x0f\xce"
+			  "\x9a\x7c\x38\xf8\x32\xea\xfe\x8b"
+			  "\x1c\x12\xf8\xa7\xcf\x12\xa8\x1a"
+			  "\x1a\xd8\xa9\xc2\x4b\xa9\xde\xdf"
+			  "\xbd\xaa\x58\x6f\xfe\xa6\x7d\xdc"
+			  "\x80\x1e\xa9\x7d\x9a\xb4\xa8\x72"
+			  "\xf4\x2d\x0e\x35\x2e\x27\x13\xda"
+			  "\xcd\x60\x9f\x94\x42\xc1\x75\x17"
+			  "\xc5\xa2\x9d\xaf\x3e\x2a\x3f\xac"
+			  "\x4f\xf6\xb1\x38\x0c\x4e\x46\xdf"
+			  "\x7b\x08\x6a\xf6\xce\x6b\xc1\xed"
+			  "\x59\x4b\x8d\xd6\x4a\xed\x2a\x7e"
+			  "\x69\xab\xf0\xf6\x4a\x13\x7d\xd6"
+			  "\xe1\x22\x47\x8d\x77\x7e\x98\xbc"
+			  "\x42\x28\x23\x00\x6c\xf5\x7f\x5e"
+			  "\xe8\x22\xdd\x78\x39\x72\x30\xb2",
+		.clen	= 152,
+	}
+};
+
 static const struct drbg_testvec drbg_nopr_hmac_sha512_tv_template[] = {
 	/*
 	 * Borrowed from the first applicable test vector from ACVP:
-- 
2.56.0

