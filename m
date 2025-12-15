Received: from shrimp.cherry.relay.mailchannels.net (shrimp.cherry.relay.mailchannels.net [23.83.223.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E682192FA;
	Mon, 15 Dec 2025 07:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.164
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765785263; cv=pass; b=XdTkX1IQ4VG5WbVH6rcIqZ4aPSu3qtNOw25x2El1lAS0gQ0Vkl4vCySC9QM+M9yZrNBGm4x18b6m/7fMjP1OcQD6v1uib2R+KMqeYTpO/odVIRA2snpqV7P29Ms1JFmClGwD5rOO3Rbg2GgH0oOYAaf9sxdbbcPoNexbH2Xv2FU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765785263; c=relaxed/simple;
	bh=cM0BsJnqjjsyjtg+ingidQDSEIkIM66/KPIrKRlR7WI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fZfiiv2cOw3pVodmBqN7jCclcbwAcyqNYzac+dCDNGG1UPr1YBYzz0sQ4hsLefe/oROEgQuTXrn0ZHGoJbuEjadeo23Rgn0ilfAuXa4BeHCmWVnw+nSsEKaWSAIGtrq0ABZIwgrhvIucVuMLs4cHhP9UMw/Eb9xoaWajji75tDQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kriptograf.id; spf=pass smtp.mailfrom=kriptograf.id; dkim=pass (2048-bit key) header.d=kriptograf.id header.i=@kriptograf.id header.b=OLZPeoN9; arc=pass smtp.client-ip=23.83.223.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kriptograf.id
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kriptograf.id
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kriptograf.id header.i=@kriptograf.id header.b="OLZPeoN9"
X-Sender-Id: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id C205958163F;
	Mon, 15 Dec 2025 07:54:13 +0000 (UTC)
Received: from vittoria.id.domainesia.com (trex-green-7.trex.outbound.svc.cluster.local [100.103.182.69])
	(Authenticated sender: nlkw2k8yjw)
	by relay.mailchannels.net (Postfix) with ESMTPA id 8A751581ADE;
	Mon, 15 Dec 2025 07:54:11 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1765785253;
	b=p0YOedyr8E7NnMXmRIYopBaeRshuKScLvX2sdzALcgePtlCbznUA4CEy3mLHRpy+9lhV0J
	iZQvSqqu9HjhLCbmrdQs6kN14K6RYf1zgDMIwAYFYElRzLYJEZnyyouq6Ylwazeni1DL1L
	GiL0GqlQ4N5UOft7YruyEY6DQSGcS5XEeepyIkCYMRZFhS3mBIKmCvSsG4ltpG5AhVyGgq
	U2B0/WoyHs99R1PG7XoG5UYx//FieoiUEFK5hAQKyC6UPGX16+tOoaODKwWaB+a9FO6nIj
	yPOQdDm0Md+cf3msFfK9mE215SWICNt2Wt3/sVfIPI81iRvp/vuNRfR+98Xxcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1765785253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GyXXtIsElCQM2HeNKvn4EkzNkPWkma7bfMXtQs5tlUc=;
	b=QtCGi2jKDkevcQGBVW7jbOlib4RURNeXKX+mJwQDynBDWxZUvt7FMIeeFkf9NH3vBZlSsK
	0GVZZnlzizvkP4VW1I89s6/Y3PjuiH0KvrS6ybkIfMFFIb8bgo835StxoMeO6O2rvxGyz4
	0FGgdM+/ZMy1LGQhSWD8LGeWuqUrvOSAj7xBN09RjPNDRWmUJTMzmpqxNcB9l8ACQ2Lx54
	TyfxEaOgd/gFJ0dBePXDuRbtZp11BaUtsMlNQvQBGrlYYKfc5bbG5OsITd843x/77Rz2QA
	jZgjQTPEMshxMLoMWF5A5Z87/qqcU20JdnANar0hb5XYAzssGWu6bukZmDhTsA==
ARC-Authentication-Results: i=1;
	rspamd-659888d77d-xv5gs;
	auth=pass smtp.auth=nlkw2k8yjw smtp.mailfrom=rusydi.makarim@kriptograf.id
X-Sender-Id: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
X-MC-Relay: Neutral
X-MailChannels-SenderId: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
X-MailChannels-Auth-Id: nlkw2k8yjw
X-Trail-Madly: 22e50ed52746eda7_1765785253697_1903247113
X-MC-Loop-Signature: 1765785253697:1628576377
X-MC-Ingress-Time: 1765785253696
Received: from vittoria.id.domainesia.com (vittoria.id.domainesia.com
 [36.50.77.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.103.182.69 (trex/7.1.3);
	Mon, 15 Dec 2025 07:54:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=kriptograf.id; s=default; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=GyXXtIsElCQM2HeNKvn4EkzNkPWkma7bfMXtQs5tlUc=; b=OLZPeoN9vNk/MvQ+u8Psp/F/N9
	qB5pFdLD9bGre3ys2UQ115fJoefODHvunjUIG2wvgGvgU8Yv7T7Y0apB4LuMjlhqNv1d6y01+wIs9
	lVpMPcPrS/0Ni02n7GdBeoeWPq0LLQjOLa4xvBRQizfeyRT1bNIRpHKApSJH7kHRDcaRFfLA7ZjZ1
	EdBaRjex4OQAsnbyE86TpHerprnXubE2xYpVfsG3kWBZ/hJdfeW5/9/lQKnUGQ6FyfDQ/7ReTe+Js
	vpC6Js8AvGmMa6AiE/C1wV/BQWchJwVxm0oxvvphDF5cVUO61NqLmO4nmNltu7MQ0WEoAP2ANxSvG
	57GBwKOA==;
Received: from [182.253.89.89] (port=19977 helo=Rusydis-MacBook-Air.local)
	by vittoria.id.domainesia.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99)
	(envelope-from <rusydi.makarim@kriptograf.id>)
	id 1vV3PF-0000000FQZW-2GcM;
	Mon, 15 Dec 2025 14:54:08 +0700
From: "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
Date: Mon, 15 Dec 2025 14:54:35 +0700
Subject: [PATCH 2/3] lib/crypto: Initial implementation of Ascon-Hash256
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251215-ascon_hash256-v1-2-24ae735e571e@kriptograf.id>
References: <20251215-ascon_hash256-v1-0-24ae735e571e@kriptograf.id>
In-Reply-To: <20251215-ascon_hash256-v1-0-24ae735e571e@kriptograf.id>
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
 include/crypto/ascon_hash.h |   2 +-
 lib/crypto/Kconfig          |   8 +++
 lib/crypto/Makefile         |   5 ++
 lib/crypto/ascon_hash.c     | 154 ++++++++++++++++++++++++++++++++++++++++++++
 lib/crypto/hash_info.c      |   2 +
 5 files changed, 170 insertions(+), 1 deletion(-)

diff --git a/include/crypto/ascon_hash.h b/include/crypto/ascon_hash.h
index bb3561a745a9..c03a1414eec9 100644
--- a/include/crypto/ascon_hash.h
+++ b/include/crypto/ascon_hash.h
@@ -18,7 +18,7 @@
 
 /*
  * The standard of Ascon permutation in NIST SP 800-232 specifies 16 round
- * constants to accomodate potential functionality extensions in the future
+ * constants to accommodate potential functionality extensions in the future
  * (see page 2).
  */
 static const u64 ascon_p_rndc[] = {
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
index 000000000000..e435a0e72195
--- /dev/null
+++ b/lib/crypto/ascon_hash.c
@@ -0,0 +1,154 @@
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

