Received: from mistyrose.cherry.relay.mailchannels.net (mistyrose.cherry.relay.mailchannels.net [23.83.223.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD5C16EB42;
	Wed, 31 Dec 2025 09:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.121
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767173674; cv=pass; b=CZcP7XQ4wAKULH9T+FFLMPPbbTWfg0oTZgoRgbvycZgHto6IlDxeKIUV4ABsSqwbgrpdO2OXEStaylYqGkJf46/ZrBTp5pBEAm7gcDe5xddVmw63UQg9iaCIGHcuU+Y5uTFqfG/qyGY/Y4uYhv0NkZhR6lZt3K5FpJidIb9cLMM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767173674; c=relaxed/simple;
	bh=kPPUJ+cqjClWMAxV0R7r5VQvviTHQeABLvERa3yuvhY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IVCSj/Gz/ZeSuyKT5kpvrQH83VvNMF9UKCBs9DMCsQwhD60p9cfeDWFltpJmnrAKQxIwQJJ98CoCK6VkTYp2YTfFZNZ5CWGQIpVNBBire5rXgx7FycXrUiG3XMhdopCNl/tumkY1X3JvFmXRuNk7JmzsBNxD660VhO2snnPXqis=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kriptograf.id; spf=pass smtp.mailfrom=kriptograf.id; dkim=pass (2048-bit key) header.d=kriptograf.id header.i=@kriptograf.id header.b=TZvtkQFR; arc=pass smtp.client-ip=23.83.223.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kriptograf.id
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kriptograf.id
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kriptograf.id header.i=@kriptograf.id header.b="TZvtkQFR"
X-Sender-Id: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 85E977412DA;
	Wed, 31 Dec 2025 09:25:18 +0000 (UTC)
Received: from vittoria.id.domainesia.com (trex-green-8.trex.outbound.svc.cluster.local [100.105.72.72])
	(Authenticated sender: nlkw2k8yjw)
	by relay.mailchannels.net (Postfix) with ESMTPA id B9B3974121B;
	Wed, 31 Dec 2025 09:25:15 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1767173117;
	b=jvw68y2Kfc81KZdBrkZjqYrJS/B40ez7xMmvbBxAdn+XaMMCwdX3iOsg/VCN9k46+hBmfA
	JtMuGND1o2PttRMKYx+GSJNFx0mHLCrA0jklynsNWsk170pIm2BbgXqzuefS+/xfaNsk1D
	XsMVqFuFzLUnmb9zfyYNQlrEMxdF/c0D0PLUp8LWUlB1lfRGOYzyoJGLN3KbjPpHMUMnOT
	9U77pxHMv3K1ltcRZTh4H6gM97cDpvAE0UHc9ZIYAgQ0p8AgKPR9lxGPa+JnAdD0751OYM
	RoRGDgzvdjjzjfkUgd/zi766saertfdBrDo7+GoaMuUkuGXYA+LCnEB+d9/WNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1767173117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QW97PjJBrkA2EKQOCRqnHZDdmpNJ/eB9tI5pbcNEAWA=;
	b=i3J6jGOkfGk5ZoqjwOBdwbIPbOzbU4J2lWnN6aLwXga9AQsR0tP3loEYjMI3DGPcLOkDU4
	YsK5ZQOagjpoxdSkpDRLT540L9T/nSMtmwm5msJ/HMuCUOqEOvR3NvOevbd2+RtRjn41Rr
	KeNVcuDAYJwPxBUDKi+B0uS2/qSCSH9uvxjS6DL81EkjS9y2NKF2elQ9x+BMDrdrw2P9VC
	idbU0yLziH6Hl35iDtsHKuwvmdBSGJqKnGoYMOOG+LHGYwNRCvS5EqRUP/IyusWJoC26dg
	/D3d22TnQczCClqb5v1cdTI34NXNj47SC+afCnDrm+Dy83/J5XiV4FfMMayctA==
ARC-Authentication-Results: i=1;
	rspamd-69599c6f48-klbvj;
	auth=pass smtp.auth=nlkw2k8yjw smtp.mailfrom=rusydi.makarim@kriptograf.id
X-Sender-Id: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
X-MC-Relay: Junk
X-MailChannels-SenderId: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
X-MailChannels-Auth-Id: nlkw2k8yjw
X-Shoe-Trouble: 4ae519731d110a46_1767173117855_1544193225
X-MC-Loop-Signature: 1767173117855:619337112
X-MC-Ingress-Time: 1767173117855
Received: from vittoria.id.domainesia.com (vittoria.id.domainesia.com
 [36.50.77.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.105.72.72 (trex/7.1.3);
	Wed, 31 Dec 2025 09:25:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=kriptograf.id; s=default; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=QW97PjJBrkA2EKQOCRqnHZDdmpNJ/eB9tI5pbcNEAWA=; b=TZvtkQFR0m/d0jaQppnIbBVB8c
	cHPoXmCGND7JojH4Yt8EkjcMXKqDCmeyA89tJVPn2B+KbNq0ji9hXwdIsxWQ2Gp1uj5FSP5Vw9fzw
	Iei3UoiFF1bWCl9PgG0YhrrEKglTVnJuG0/+Rf/l2YTAB/KHNQKG50gCvCkswhUT2ygoZi0COGpuz
	WDL3JCJfmKuBBI97p0svOUxzc9DU7dbMFDW0y7NSRTf4iRkLft0n5P+gWNkocnkY/6uuMkkvPFRIa
	HRleLxzhFAq2TTQ0mFke4uVWXrsgx1bE9SOBP0n2q/WjyeWQT70+gdnakzb3ukZJB5VggsvkPBTBV
	71/RvYZA==;
Received: from [182.253.89.89] (port=29807 helo=Rusydis-MacBook-Air.local)
	by vittoria.id.domainesia.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99)
	(envelope-from <rusydi.makarim@kriptograf.id>)
	id 1vasSA-0000000B53Y-2GVX;
	Wed, 31 Dec 2025 16:25:13 +0700
From: "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
Date: Wed, 31 Dec 2025 16:25:37 +0700
Subject: [PATCH v2 3/3] crypto: Crypto API implementation of Ascon-Hash256
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251231-ascon_hash256-v2-3-ffc88a0bab4d@kriptograf.id>
References: <20251231-ascon_hash256-v2-0-ffc88a0bab4d@kriptograf.id>
In-Reply-To: <20251231-ascon_hash256-v2-0-ffc88a0bab4d@kriptograf.id>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Eric Biggers <ebiggers@kernel.org>, 
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
 "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
X-Mailer: b4 0.14.3
X-AuthUser: rusydi.makarim@kriptograf.id

This commit implements Ascon-Hash256 for Crypto API

Signed-off-by: Rusydi H. Makarim <rusydi.makarim@kriptograf.id>
---
 crypto/Kconfig      |  7 +++++
 crypto/Makefile     |  1 +
 crypto/ascon_hash.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 2e5b195b1b06..e671b5575535 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1000,6 +1000,13 @@ config CRYPTO_SHA3
 	help
 	  SHA-3 secure hash algorithms (FIPS 202, ISO/IEC 10118-3)
 
+config CRYPTO_ASCON_HASH
+	tristate "Ascon-Hash"
+	select CRYPTO_HASH
+	select CRYPTO_LIB_ASCON_HASH
+	help
+	  Ascon-Hash secure hash algorithms (NIST SP 800-232)
+
 config CRYPTO_SM3_GENERIC
 	tristate "SM3 (ShangMi 3)"
 	select CRYPTO_HASH
diff --git a/crypto/Makefile b/crypto/Makefile
index 16a35649dd91..a697a92d2092 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -82,6 +82,7 @@ obj-$(CONFIG_CRYPTO_SHA3) += sha3.o
 obj-$(CONFIG_CRYPTO_SM3_GENERIC) += sm3_generic.o
 obj-$(CONFIG_CRYPTO_STREEBOG) += streebog_generic.o
 obj-$(CONFIG_CRYPTO_WP512) += wp512.o
+obj-$(CONFIG_CRYPTO_ASCON_HASH) += ascon_hash.o
 CFLAGS_wp512.o := $(call cc-option,-fno-schedule-insns)  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79149
 obj-$(CONFIG_CRYPTO_BLAKE2B) += blake2b.o
 obj-$(CONFIG_CRYPTO_ECB) += ecb.o
diff --git a/crypto/ascon_hash.c b/crypto/ascon_hash.c
new file mode 100644
index 000000000000..2fa5e762fbc1
--- /dev/null
+++ b/crypto/ascon_hash.c
@@ -0,0 +1,86 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Crypto API support for Ascon-Hash256
+ * (https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-232.pdf)
+ *
+ * Copyright (C) Rusydi H. Makarim <rusydi.makarim@kriptograf.id>
+ */
+
+#include <crypto/internal/hash.h>
+#include <crypto/ascon_hash.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#define ASCON_HASH256_CTX(desc) ((struct ascon_hash256_ctx *)shash_desc_ctx(desc))
+
+static int crypto_ascon_hash256_init(struct shash_desc *desc)
+{
+	ascon_hash256_init(ASCON_HASH256_CTX(desc));
+	return 0;
+}
+
+static int crypto_ascon_hash256_update(struct shash_desc *desc, const u8 *data,
+				       unsigned int len)
+{
+	ascon_hash256_update(ASCON_HASH256_CTX(desc), data, len);
+	return 0;
+}
+
+static int crypto_ascon_hash256_final(struct shash_desc *desc, u8 *out)
+{
+	ascon_hash256_final(ASCON_HASH256_CTX(desc), out);
+	return 0;
+}
+
+static int crypto_ascon_hash256_digest(struct shash_desc *desc, const u8 *data,
+				       unsigned int len, u8 *out)
+{
+	ascon_hash256(data, len, out);
+	return 0;
+}
+
+static int crypto_ascon_hash256_export_core(struct shash_desc *desc, void *out)
+{
+	memcpy(out, ASCON_HASH256_CTX(desc), sizeof(struct ascon_hash256_ctx));
+	return 0;
+}
+
+static int crypto_ascon_hash256_import_core(struct shash_desc *desc,
+					    const void *in)
+{
+	memcpy(ASCON_HASH256_CTX(desc), in, sizeof(struct ascon_hash256_ctx));
+	return 0;
+}
+
+static struct shash_alg algs[] = { {
+	.digestsize = ASCON_HASH256_DIGEST_SIZE,
+	.init = crypto_ascon_hash256_init,
+	.update = crypto_ascon_hash256_update,
+	.final = crypto_ascon_hash256_final,
+	.digest = crypto_ascon_hash256_digest,
+	.export_core = crypto_ascon_hash256_export_core,
+	.import_core = crypto_ascon_hash256_import_core,
+	.descsize = sizeof(struct ascon_hash256_ctx),
+	.base.cra_name = "ascon-hash256",
+	.base.cra_driver_name = "ascon-hash256-lib",
+	.base.cra_blocksize = ASCON_HASH256_BLOCK_SIZE,
+	.base.cra_module = THIS_MODULE,
+} };
+
+static int __init crypto_ascon_hash256_mod_init(void)
+{
+	return crypto_register_shashes(algs, ARRAY_SIZE(algs));
+}
+module_init(crypto_ascon_hash256_mod_init);
+
+static void __exit crypto_ascon_hash256_mod_exit(void)
+{
+	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
+}
+module_exit(crypto_ascon_hash256_mod_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Crypto API support for Ascon-Hash256");
+
+MODULE_ALIAS_CRYPTO("ascon-hash256");
+MODULE_ALIAS_CRYPTO("ascon-hash256-lib");

-- 
2.52.0

