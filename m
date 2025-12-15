Received: from purple.birch.relay.mailchannels.net (purple.birch.relay.mailchannels.net [23.83.209.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14473321BC;
	Mon, 15 Dec 2025 08:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.209.150
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765788508; cv=pass; b=fu0hxsa+IObdszHLi35fOnzGpXh0gGUjYSAPgwJ884XdjUK1uTg/PGlVWhgilzzi12JgUOmn1g4kKIyN4DKwjT/FB5HmZq5Jux562svHK33Lv3UQO5tWIcuSR18s21L7hn62uSnVw2Gj2h1AhQ26IUNQwKsQ068rqzyZlE8CVh8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765788508; c=relaxed/simple;
	bh=5hRQ+6Xjj7Ub1HlBqBP+GF+RQzaO8L1L3sPQtWmATXc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hsJA3ZlQQyfB8HeuSkl8UvSIHiSlgFelK92cQHdpCoNECXPLGvHr2DrvPp4RL+oRVwZB3toxLYY58XGxVOic24F4SF3x/tHyAZp340pag9ZxvxjJjSfiWNVA1Hnb0jxjdK7VArgm0gEge3+07zT/aTLsfUrCCKzFQf2fWAw3wnA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kriptograf.id; spf=pass smtp.mailfrom=kriptograf.id; dkim=pass (2048-bit key) header.d=kriptograf.id header.i=@kriptograf.id header.b=sC8snx2b; arc=pass smtp.client-ip=23.83.209.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kriptograf.id
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kriptograf.id
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kriptograf.id header.i=@kriptograf.id header.b="sC8snx2b"
X-Sender-Id: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 90141460E08;
	Mon, 15 Dec 2025 07:54:14 +0000 (UTC)
Received: from vittoria.id.domainesia.com (trex-green-4.trex.outbound.svc.cluster.local [100.103.186.183])
	(Authenticated sender: nlkw2k8yjw)
	by relay.mailchannels.net (Postfix) with ESMTPA id E31DC461597;
	Mon, 15 Dec 2025 07:54:11 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1765785254;
	b=ckOAwivJ51q7ciMcRHULuptuv/zwNLCBn9erXEXem+e+cGFsKHBaQkf3u4sfeh0XWRqnej
	LNRhfwivJnJvAtzILYzEw2bXw7HK/cb5jJ0nHm3byaeCLPrYLAMNFGpIgrgeg1r+TxcykJ
	4JfRJJ+2DbZIQlqS/WyUILI0wG7vMz7CkzJSKZsS92LoUW3VElyoyK2kTa2e0ipWDVvu2z
	431m1Is9OQrwJ4p3Nj78l+3dxlPZpBC5gO0Io1QZHz6pnCHh9hKxyYseWt1rKzr7vc1Uw1
	FCOfElFLzR+VBhzN4uJ5KK3vohNs22MOBuCDqwRjNYLOHMCYFGiTrG8XO4UZ2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1765785254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KUKfIFqcekPBdjqhL8GJz6t56c2cLGnaAFlYfu7gY0w=;
	b=wVTA57dLdDMe/YQntU9QmO6wa3nvud04M9Fq4lKfnZNMbXkZpGtj5ygDwa1DcrabKcWIzV
	brikrmLbUGEY1Y67hZVWmlKx8xCuLDCJjf4/O/1aWAzWw++crsa4MMc58v14fiDxPFsssv
	1SoYecS47K8Oq5PiGrdWFHT0MBgvqI2VJk8b1Qmj7p15PAXgRYdo9Ve4yjm5H4VUxCLWZW
	GNE6EDAyvkDwPKRcVZm3JNK1owJKSlVPrCPruy5kF9KljZ3b2ZQzH7EJJhdPRQHM9MY/Iz
	a/vRFya4C03Az+ZHbdI/NuFVr9APx32V/qciEwXM9eq8FJSVAmT3ZETRGWFxvg==
ARC-Authentication-Results: i=1;
	rspamd-659888d77d-l96jv;
	auth=pass smtp.auth=nlkw2k8yjw smtp.mailfrom=rusydi.makarim@kriptograf.id
X-Sender-Id: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
X-MC-Relay: Neutral
X-MailChannels-SenderId: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
X-MailChannels-Auth-Id: nlkw2k8yjw
X-Company-Illegal: 63fb58e818c0df34_1765785254496_468568549
X-MC-Loop-Signature: 1765785254495:2230306666
X-MC-Ingress-Time: 1765785254495
Received: from vittoria.id.domainesia.com (vittoria.id.domainesia.com
 [36.50.77.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.103.186.183 (trex/7.1.3);
	Mon, 15 Dec 2025 07:54:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=kriptograf.id; s=default; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=KUKfIFqcekPBdjqhL8GJz6t56c2cLGnaAFlYfu7gY0w=; b=sC8snx2blrGL6lzS0TTOUvsKgt
	/PFgYJyuGrdaqVQcBqL2LrcNUAub9zmabWKPGCYddTOXV+MosEtp1gQIvvS3H482M807e8kwc7DFJ
	9UpfF4gy4JK7l6MIlzTzvCink8S4ZSdi+CcL9gktysj1vp4srwFrvHpCPB4HEF8igKKPXgt4y/fiJ
	sNFikSI1fDyIRZm0OZPkQaTPWYBsyeq2Bvfu9ngSUQ8VNb8e/AMUHXDFnVKqH4qHnMGButaoF36wm
	I5O7gP345TBuYho5u+1AYBhcFpO/xvKc2/CL4ge3ge4WRpOGWE3yeRcrKZ4s/nAONQXI5vZN5FeDT
	Cwa97WWw==;
Received: from [182.253.89.89] (port=19977 helo=Rusydis-MacBook-Air.local)
	by vittoria.id.domainesia.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99)
	(envelope-from <rusydi.makarim@kriptograf.id>)
	id 1vV3PF-0000000FQZW-3Tjg;
	Mon, 15 Dec 2025 14:54:09 +0700
From: "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
Date: Mon, 15 Dec 2025 14:54:36 +0700
Subject: [PATCH 3/3] crypto: Crypto API implementation of Ascon-Hash256
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251215-ascon_hash256-v1-3-24ae735e571e@kriptograf.id>
References: <20251215-ascon_hash256-v1-0-24ae735e571e@kriptograf.id>
In-Reply-To: <20251215-ascon_hash256-v1-0-24ae735e571e@kriptograf.id>
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

