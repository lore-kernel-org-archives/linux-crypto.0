Received: from bisque.cedar.relay.mailchannels.net (bisque.cedar.relay.mailchannels.net [23.83.210.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475302E1C7C;
	Wed, 31 Dec 2025 09:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.210.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767173121; cv=pass; b=gYTJ16tDjGr/D0hjPPTBYzx/BlwQ1e3dOOICJUCOoUsb1y5Vn/rQhiIBsE8OXEh6//jxKTxfagqm5FtLiJhmYIKrT3wuqrftsZLai9AtK+dum4VsuG2GaUzNdB+4MvA7XYOovFYlXgKJNNm2/1yx/jW5J9NJB8NmzEYpjhf6vAM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767173121; c=relaxed/simple;
	bh=1/Rx+EK9X6i9KbLV0DE4Dr2vAlNvc08IJ594/pDcJ5I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hoaz9L/4e/dUGWd+hIOpLG0rKktc5NepNaglb2lIExmgODH05UqWijHpnIYOvYB06n73aiUG2/+eajpfFV/NYjBIf1xtpNks5pvxZ3UKxxc7xjkHlGk+YoskbPrWaZ19X9kdr+aiklChNQIAzJv+UrkfNgobnAOMA4jOgENr/Nc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kriptograf.id; spf=pass smtp.mailfrom=kriptograf.id; dkim=pass (2048-bit key) header.d=kriptograf.id header.i=@kriptograf.id header.b=HZDTgxk1; arc=pass smtp.client-ip=23.83.210.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kriptograf.id
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kriptograf.id
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kriptograf.id header.i=@kriptograf.id header.b="HZDTgxk1"
X-Sender-Id: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 85D991609B3;
	Wed, 31 Dec 2025 09:25:18 +0000 (UTC)
Received: from vittoria.id.domainesia.com (trex-green-0.trex.outbound.svc.cluster.local [100.106.231.39])
	(Authenticated sender: nlkw2k8yjw)
	by relay.mailchannels.net (Postfix) with ESMTPA id E67DD160F17;
	Wed, 31 Dec 2025 09:25:15 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1767173117;
	b=DV2lnkmv2hW2st/3i/B6KgS/sx106H4YIYcnJWOJPOjp4JFXbki5PaOeVsFakcar54I/yd
	wIhT/dHmQyNEhHwDm80b20WiiAYJZla9GTtA80CkH1mzQE4/O+t4YkmYo1mArGqEpOa4W6
	JgdO/oA0ESgzmN8KIi2cgVazr0XxLsMETsXf0gqsZrtrnfTAqE1Fv4EZM9H2xa1nSdtTWE
	pAymEE7E/VmWQ3lI7GCoFzU1/+5Ss1ti0QQ7KudUgjZRcUIhoo0oYEh+Xqoiri+V5Vsa8m
	lT4+QfHj+KsoyAEgtViDhuD6G4rG34R60ssB9kX02YieiRL9m6911/hzMPBosg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1767173117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TJbzvSqUCKfx22CKDG0lZkeCcWbDX9bs/BnTfz1BNVw=;
	b=c/rdnv2vE07z+LP8sYsJ19zqf9ZLqSZSaEtjd8IskPaTekcFgENIT8YfQtKVzq3p3oQDs2
	Px9R3DncfIL7AXijxbzeAIFNBHcyL18cftS2/1Osq/TUi3QOGQqLC7z2icCWQ+1G1BxyNG
	Ie7PzTvrInOLnf8NUljkLhCrBxPTvB7ra0YHj98fHbaAPo4h+heys540F+NXFfsv7DKyzQ
	NPYD826/wgX8UH8x9s2rs4ZY3IKQITHWNNDlfN3utqZLH7P/5VkLSvzvno4y+sjlTNIbl5
	DWUgWv4qcEmjRWvs02pMycoYWLUqCucQHxh9invRnYMHQaZuCg5acidJJS8iSg==
ARC-Authentication-Results: i=1;
	rspamd-69599c6f48-klbvj;
	auth=pass smtp.auth=nlkw2k8yjw smtp.mailfrom=rusydi.makarim@kriptograf.id
X-Sender-Id: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
X-MC-Relay: Junk
X-MailChannels-SenderId: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
X-MailChannels-Auth-Id: nlkw2k8yjw
X-Whispering-Language: 36252d4338baa83c_1767173118069_3930190636
X-MC-Loop-Signature: 1767173118069:630459088
X-MC-Ingress-Time: 1767173118069
Received: from vittoria.id.domainesia.com (vittoria.id.domainesia.com
 [36.50.77.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.106.231.39 (trex/7.1.3);
	Wed, 31 Dec 2025 09:25:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=kriptograf.id; s=default; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=TJbzvSqUCKfx22CKDG0lZkeCcWbDX9bs/BnTfz1BNVw=; b=HZDTgxk1lrYyvjICZup0soXO/O
	kLmmpKayHWIwmirzPApCXqn3+KhPsahNvAomFdhI3lB1O7diRyNCLn32pk9SF8Hcp1Fwz8sjcE+qL
	7QTMUBCr8JD3QESDhhuVNjRhyiNX4aQD1BAg1lTeOGV7asJZ8TAwAWyVjlZWnpyY+nXJIfdo1t0Gp
	H27EuakwmmF08dhtGiLQP+kA5BM+9aKZ4ZT+XzqC/qPRkWYmPYTrZzasiU4BecHWYS8pt1Z7WwimO
	VB5oEBRyIanP7F/0iJ2cE/498gtTwm6usRImMu7SF0lc62qpDUur6iWPTSHGPg78Lky2G8HEohZpS
	RZdiDxdQ==;
Received: from [182.253.89.89] (port=29807 helo=Rusydis-MacBook-Air.local)
	by vittoria.id.domainesia.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99)
	(envelope-from <rusydi.makarim@kriptograf.id>)
	id 1vasSA-0000000B53Y-1JGA;
	Wed, 31 Dec 2025 16:25:13 +0700
From: "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
Date: Wed, 31 Dec 2025 16:25:36 +0700
Subject: [PATCH v2 2/3] lib/crypto: Initial implementation of Ascon-Hash256
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251231-ascon_hash256-v2-2-ffc88a0bab4d@kriptograf.id>
References: <20251231-ascon_hash256-v2-0-ffc88a0bab4d@kriptograf.id>
In-Reply-To: <20251231-ascon_hash256-v2-0-ffc88a0bab4d@kriptograf.id>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Eric Biggers <ebiggers@kernel.org>, 
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
 "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
X-Mailer: b4 0.14.3
X-AuthUser: rusydi.makarim@kriptograf.id

initial implementation of Ascon-Hash256

Signed-off-by: Rusydi H. Makarim <rusydi.makarim@kriptograf.id>
---
 include/crypto/ascon_hash.h    |   1 -
 include/crypto/hash_info.h     |   1 +
 include/uapi/linux/hash_info.h |   1 +
 lib/crypto/Kconfig             |   8 ++
 lib/crypto/Makefile            |   5 ++
 lib/crypto/ascon_hash.c        | 169 +++++++++++++++++++++++++++++++++++++++++
 lib/crypto/hash_info.c         |   2 +
 7 files changed, 186 insertions(+), 1 deletion(-)

diff --git a/include/crypto/ascon_hash.h b/include/crypto/ascon_hash.h
index a99ea458a9cc..7fbe345b6ed1 100644
--- a/include/crypto/ascon_hash.h
+++ b/include/crypto/ascon_hash.h
@@ -16,7 +16,6 @@
 #define ASCON_HASH256_RATE		8
 #define ASCON_HASH256_IV		0x0000080100CC0002ULL
 
-
 /*
  * State for Ascon-p[320] permutation: 5 64-bit words
  */
diff --git a/include/crypto/hash_info.h b/include/crypto/hash_info.h
index d6927739f8b2..ccbaabca3e7b 100644
--- a/include/crypto/hash_info.h
+++ b/include/crypto/hash_info.h
@@ -13,6 +13,7 @@
 #include <crypto/sha3.h>
 #include <crypto/md5.h>
 #include <crypto/streebog.h>
+#include <crypto/ascon_hash.h>
 
 #include <uapi/linux/hash_info.h>
 
diff --git a/include/uapi/linux/hash_info.h b/include/uapi/linux/hash_info.h
index 0af23ec196d8..d39b5d48f14a 100644
--- a/include/uapi/linux/hash_info.h
+++ b/include/uapi/linux/hash_info.h
@@ -38,6 +38,7 @@ enum hash_algo {
 	HASH_ALGO_SHA3_256,
 	HASH_ALGO_SHA3_384,
 	HASH_ALGO_SHA3_512,
+	HASH_ALGO_ASCON_HASH256,
 	HASH_ALGO__LAST
 };
 
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 6871a41e5069..5f39ed6746de 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -223,6 +223,14 @@ config CRYPTO_LIB_SHA3_ARCH
 	default y if ARM64 && KERNEL_MODE_NEON
 	default y if S390
 
+config CRYPTO_LIB_ASCON_HASH
+	tristate
+	select CRYPTO_LIB_UTILS
+	help
+	  The Ascon-Hash library functions. Select this if your module uses any of
+	  the functions from <crypto/ascon_hash.h>
+
+
 config CRYPTO_LIB_SM3
 	tristate
 
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 330ab65b29c4..6657ea3d8771 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -297,6 +297,11 @@ endif # CONFIG_CRYPTO_LIB_SHA3_ARCH
 
 ################################################################################
 
+obj-$(CONFIG_CRYPTO_LIB_ASCON_HASH) += libascon_hash.o
+libascon_hash-y := ascon_hash.o
+
+################################################################################
+
 obj-$(CONFIG_MPILIB) += mpi/
 
 obj-$(CONFIG_CRYPTO_SELFTESTS_FULL)		+= simd.o
diff --git a/lib/crypto/ascon_hash.c b/lib/crypto/ascon_hash.c
new file mode 100644
index 000000000000..6b88499b8f11
--- /dev/null
+++ b/lib/crypto/ascon_hash.c
@@ -0,0 +1,169 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Ascon-Hash library functions
+ *
+ * Copyright (c) 2025 Rusydi H. Makarim <rusydi.makarim@kriptograf.id>
+ */
+
+#include <linux/module.h>
+#include <crypto/ascon_hash.h>
+#include <crypto/utils.h>
+
+
+/*
+ * The standard of Ascon permutation in NIST SP 800-232 specifies 16 round
+ * constants to accomodate potential functionality extensions in the future
+ * (see page 2).
+ */
+static const u64 ascon_p_rndc[] = {
+	0x000000000000003cULL, 0x000000000000002dULL, 0x000000000000001eULL,
+	0x000000000000000fULL, 0x00000000000000f0ULL, 0x00000000000000e1ULL,
+	0x00000000000000d2ULL, 0x00000000000000c3ULL, 0x00000000000000b4ULL,
+	0x00000000000000a5ULL, 0x0000000000000096ULL, 0x0000000000000087ULL,
+	0x0000000000000078ULL, 0x0000000000000069ULL, 0x000000000000005aULL,
+	0x000000000000004bULL,
+};
+
+
+static inline void ascon_round(u64 s[ASCON_STATE_WORDS], u64 C)
+{
+	u64 t[ASCON_STATE_WORDS];
+
+	// pC
+	s[2] ^= C;
+
+	// pS
+	s[0] ^= s[4];
+	s[4] ^= s[3];
+	s[2] ^= s[1];
+	t[0] = s[0] ^ (~s[1] & s[2]);
+	t[1] = s[1] ^ (~s[2] & s[3]);
+	t[2] = s[2] ^ (~s[3] & s[4]);
+	t[3] = s[3] ^ (~s[4] & s[0]);
+	t[4] = s[4] ^ (~s[0] & s[1]);
+	t[1] ^= t[0];
+	t[0] ^= t[4];
+	t[3] ^= t[2];
+	t[2] = ~t[2];
+
+	// pL
+	s[0] = t[0] ^ ror64(t[0], 19) ^ ror64(t[0], 28);
+	s[1] = t[1] ^ ror64(t[1], 61) ^ ror64(t[1], 39);
+	s[2] = t[2] ^ ror64(t[2],  1) ^ ror64(t[2], 6);
+	s[3] = t[3] ^ ror64(t[3], 10) ^ ror64(t[3], 17);
+	s[4] = t[4] ^ ror64(t[4],  7) ^ ror64(t[4], 41);
+}
+
+static inline void ascon_p12_generic(struct ascon_state *state)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(state->words); ++i)
+		state->native_words[i] = le64_to_cpu(state->words[i]);
+
+	for (i = 0; i < 12; ++i)
+		ascon_round(state->native_words, ascon_p_rndc[16 - 12 + i]);
+
+	for (i = 0; i < ARRAY_SIZE(state->words); ++i)
+		state->words[i] = cpu_to_le64(state->native_words[i]);
+}
+
+static void __maybe_unused ascon_hash256_absorb_blocks_generic(
+	struct ascon_state *state, const u8 *in, size_t nblocks)
+{
+	do {
+		for (size_t i = 0; i < ASCON_HASH256_BLOCK_SIZE; i += 8)
+			state->words[i / 8] ^= get_unaligned((__le64 *)&in[i]);
+		ascon_p12_generic(state);
+		in += ASCON_HASH256_BLOCK_SIZE;
+	} while (--nblocks);
+}
+
+#define ascon_p12 ascon_p12_generic
+#define ascon_hash256_absorb_blocks ascon_hash256_absorb_blocks_generic
+
+void ascon_hash256_init(struct ascon_hash256_ctx *asc_hash256_ctx)
+{
+	struct __ascon_hash_ctx *ctx = &asc_hash256_ctx->ctx;
+
+	ctx->state.words[0] = ASCON_HASH256_IV;
+	ctx->state.words[1] = 0;
+	ctx->state.words[2] = 0;
+	ctx->state.words[3] = 0;
+	ctx->state.words[4] = 0;
+	ctx->absorb_offset = 0;
+	ascon_p12(&ctx->state);
+}
+EXPORT_SYMBOL_GPL(ascon_hash256_init);
+
+void ascon_hash256_update(struct ascon_hash256_ctx *asc_hash256_ctx, const u8 *in,
+			    size_t in_len)
+{
+	struct __ascon_hash_ctx *ctx = &asc_hash256_ctx->ctx;
+	u8 absorb_offset = ctx->absorb_offset;
+
+	WARN_ON_ONCE(absorb_offset >= ASCON_HASH256_BLOCK_SIZE);
+
+	if (absorb_offset && absorb_offset + in_len >= ASCON_HASH256_BLOCK_SIZE) {
+		crypto_xor(&ctx->state.bytes[absorb_offset], in,
+			   ASCON_HASH256_BLOCK_SIZE - absorb_offset);
+		in += ASCON_HASH256_BLOCK_SIZE - absorb_offset;
+		in_len -= ASCON_HASH256_BLOCK_SIZE - absorb_offset;
+		ascon_p12(&ctx->state);
+		absorb_offset = 0;
+	}
+
+	if (in_len >= ASCON_HASH256_BLOCK_SIZE) {
+		size_t nblocks = in_len / ASCON_HASH256_BLOCK_SIZE;
+
+		ascon_hash256_absorb_blocks(&ctx->state, in, nblocks);
+		in += nblocks * ASCON_HASH256_BLOCK_SIZE;
+		in_len -= nblocks * ASCON_HASH256_BLOCK_SIZE;
+	}
+
+	if (in_len) {
+		crypto_xor(&ctx->state.bytes[absorb_offset], in, in_len);
+		absorb_offset += in_len;
+
+	}
+	ctx->absorb_offset = absorb_offset;
+}
+EXPORT_SYMBOL_GPL(ascon_hash256_update);
+
+void ascon_hash256_final(struct ascon_hash256_ctx *asc_hash256_ctx,
+			   u8 out[ASCON_HASH256_DIGEST_SIZE])
+{
+	struct __ascon_hash_ctx *ctx = &asc_hash256_ctx->ctx;
+
+	// padding
+	ctx->state.bytes[ctx->absorb_offset] ^= 0x01;
+	ascon_p12(&ctx->state);
+
+	// squeezing
+	size_t len = ASCON_HASH256_DIGEST_SIZE;
+
+	while (len > ASCON_HASH256_RATE) {
+		memcpy(out, ctx->state.bytes, ASCON_HASH256_RATE);
+		ascon_p12(&ctx->state);
+		out += ASCON_HASH256_RATE;
+		len -= ASCON_HASH256_RATE;
+	}
+	memcpy(out, ctx->state.bytes, ASCON_HASH256_RATE);
+	memzero_explicit(asc_hash256_ctx, sizeof(*asc_hash256_ctx));
+}
+EXPORT_SYMBOL_GPL(ascon_hash256_final);
+
+
+void ascon_hash256(const u8 *in, size_t in_len,
+		   u8 out[ASCON_HASH256_DIGEST_SIZE])
+{
+	struct ascon_hash256_ctx ctx;
+
+	ascon_hash256_init(&ctx);
+	ascon_hash256_update(&ctx, in, in_len);
+	ascon_hash256_final(&ctx, out);
+}
+EXPORT_SYMBOL_GPL(ascon_hash256);
+
+MODULE_DESCRIPTION("Ascon-Hash256 library functions");
+MODULE_LICENSE("GPL");
diff --git a/lib/crypto/hash_info.c b/lib/crypto/hash_info.c
index 9a467638c971..49ce182c6d08 100644
--- a/lib/crypto/hash_info.c
+++ b/lib/crypto/hash_info.c
@@ -32,6 +32,7 @@ const char *const hash_algo_name[HASH_ALGO__LAST] = {
 	[HASH_ALGO_SHA3_256]    = "sha3-256",
 	[HASH_ALGO_SHA3_384]    = "sha3-384",
 	[HASH_ALGO_SHA3_512]    = "sha3-512",
+	[HASH_ALGO_ASCON_HASH256] = "ascon-hash256",
 };
 EXPORT_SYMBOL_GPL(hash_algo_name);
 
@@ -59,5 +60,6 @@ const int hash_digest_size[HASH_ALGO__LAST] = {
 	[HASH_ALGO_SHA3_256]    = SHA3_256_DIGEST_SIZE,
 	[HASH_ALGO_SHA3_384]    = SHA3_384_DIGEST_SIZE,
 	[HASH_ALGO_SHA3_512]    = SHA3_512_DIGEST_SIZE,
+	[HASH_ALGO_ASCON_HASH256] = ASCON_HASH256_DIGEST_SIZE,
 };
 EXPORT_SYMBOL_GPL(hash_digest_size);

-- 
2.52.0

