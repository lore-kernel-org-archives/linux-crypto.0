Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65287416860
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 08:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228252; cv=none; b=lIzBSg95K+LPQhT3X8JLHpS1M3QakcoLIBD/5qpOdwJYU3MAFa7niHwnLbyuHCTpTIItDQUDTG6HH/US1v8Ve9aOIIiA7abYmRr4EUO6avYTCyaEQJaNuJ764BICp0nLeu2ku93zGmm/HjibbBwLIReduy8AVTj/RgwFj7+ZiUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228252; c=relaxed/simple;
	bh=Mo47RP5Nunq+zgjsS08d1AFuu3ZoMjkz2YSMJlpM7OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YX2ffv+QyV85qsV6VwSvOB+GTFrIK3J/KbWm+bSK7DNnXQg00OYBux+YSx7kDtrSwHIMO4rW5RTv8zBPxN1MZhq1k1w+QbgUMdGk9HSKu3kM5HlnsxSyxlt4fxCsQL2YyckIsX9qNy3APKxNbI/3WEGFUSbVSJgNlMJkJnvzYHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TpAJlwwv; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TpAJlwwv"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cf452def93so6059275ad.1
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 01:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785228250; x=1785833050; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M/xBEn0SooZNIhdCzDeHx+x4rQIN7vz34+nk+P1SHE8=;
        b=TpAJlwwvb207yU0cvAsKMoKOuxRew6LWij6PBgYhrn3dDdqspJnUmnSmncDfgUouEx
         cart59N/NnHkat+d+3MQsIWQrI4UdMJ0S9gU2sxMlnQPlmZAQ692sbgYzNsyQr/LY8Tp
         AwGx+uPlXPYjLs25ryGJ0Zyr8x1w2bxrGu0k9mEyozuiMigBTPYzbHDpGsjRBXRfAMuR
         TY2Nnotp3V/fcjp3u3Zyc0Zdyg6x8dESIafoBwbpm9gpq6/5SVMc0qX5HdpefiwqhBSA
         WTE0asg0sZqgf2U5ZJJs0A277+wS8ComYs7dQhFjAhaPYaisErd2xdTfKfQ3jpM3PeB1
         t/6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785228250; x=1785833050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M/xBEn0SooZNIhdCzDeHx+x4rQIN7vz34+nk+P1SHE8=;
        b=oZmsUMT0sxMLjfz/ZGBJ2JKvHP+tw5IJDmKo0incN6px88AhmFll1W4tZJD8R/5GUN
         T4ABEnEvmbpaNHwzTgeR7+RZF4LKNzcLb0ZOQnJutMdLs0qhlitlEf6hCcD7Il8i43Rs
         1NeJKKVYjBhA6aVXGtv/W7TBIcktjmK0OY1SNqmLK03tUW5dbn0SgRxp2N9Ya++8Miov
         sFTh+mbF0QNvq/1AxRLpUmGGB3RxSUXc96uG9Sa+UcCSBBxu68oCCw4a88Jo7Z+wozoz
         w9H3OAdz2quPpAg2x9yn17TG0mgJsDVVG4yNsuzgMvQOJqUZKyBEPHR82iI6zSLs7m4W
         5FzA==
X-Forwarded-Encrypted: i=1; AHgh+Rqd1SttQpvhYq8ZOHC8uVI4LhDizl2i55MUbUTLMVNL6jtTG12Fl0L2nXOQzjAbSovHmqJHaEgHQ0OD8o4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzS6447R1o+uN/AjhP9SdIYhKSLJpz+MrIkIYCf+BBlkGaPJOMU
	opDABgRciqg5ASMi7oUOSc4ntvKbMg47BxWTlRsZfKmUVG6MPm+v/0jC
X-Gm-Gg: AR+sD105DOf+1y6Ym/yVavIMxn5VkPyrhHBDM06TtOBZoN3VbxRxFe2bLFhy+bDVeZq
	sq/2BfZ4qt+/S30LfiH3PajPr/a9u4GgOwRy8GFrE75sQDJpGfV2egnOOWj8m3JuFvPqjbEpOjM
	WPZlkrRhrOdGBq7p5o/4Ji/sTS3PwqQgHD3/vgpg897m4sVLJIB3J3fBYbUsZBv9YJAW6vZu0uE
	5R1h6VpGjOxInE1q/j8ZTFrqOs1CdoOilSHd/CsO67rB/cLVqL7S5NrZoa2TfBPWBIMIWAAHRAM
	ii22irfD4hmz2GWNEDo1PdAHgW9XI6i32ssbs126pXQr28LDOGJUav47ehph24A536BjobMm0XT
	bRZGPj0U//hNVyIH+3rrN/VdqTKyBFqBqMWeVpwpAMS1yGkv9sDc/mMCk1C9s1h1+meWGxeYB+g
	yp
X-Received: by 2002:a17:902:da81:b0:2ca:eff:ff58 with SMTP id d9443c01a7336-2d015d34aa3mr15851415ad.15.1785228249600;
        Tue, 28 Jul 2026 01:44:09 -0700 (PDT)
Received: from mincom1 ([175.235.236.1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde7bc585sm48168505ad.51.2026.07.28.01.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 01:44:08 -0700 (PDT)
From: Jihong Min <hurryman2212@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Christian Marangi <ansuelsmth@gmail.com>,
	linux-crypto@vger.kernel.org
Cc: Jihong Min <hurryman2212@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Antoine Tenart <atenart@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] crypto: eip93 - add dynamic software fallback support
Date: Tue, 28 Jul 2026 17:43:31 +0900
Message-ID: <f54609013874a375334b93f0f901ded3d09c408d.1785226804.git.hurryman2212@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1785226804.git.hurryman2212@gmail.com>
References: <cover.1785226804.git.hurryman2212@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Group EIP93 skcipher, ahash, and authenc implementations by their
request-size performance trends. Register generic fallback proxies that
use one representative benchmark per group and dispatch each request to
EIP93 or software according to the per-device threshold.

Expose the fallback controls through the EIP93 device sysfs hierarchy
and add the software algorithm dependencies required for benchmarking.

Unregister the fallback proxies before removing the hardware providers.

Signed-off-by: Jihong Min <hurryman2212@gmail.com>
---
 drivers/crypto/inside-secure/eip93/Kconfig    |   7 +
 drivers/crypto/inside-secure/eip93/Makefile   |   1 +
 .../inside-secure/eip93/eip93-fallback.c      | 164 ++++++++++++++++++
 .../inside-secure/eip93/eip93-fallback.h      |  10 ++
 .../crypto/inside-secure/eip93/eip93-main.c   |  19 +-
 5 files changed, 197 insertions(+), 4 deletions(-)
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-fallback.c
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-fallback.h

diff --git a/drivers/crypto/inside-secure/eip93/Kconfig b/drivers/crypto/inside-secure/eip93/Kconfig
index 29523f6927dd..ea8c417653d4 100644
--- a/drivers/crypto/inside-secure/eip93/Kconfig
+++ b/drivers/crypto/inside-secure/eip93/Kconfig
@@ -10,6 +10,13 @@ config CRYPTO_DEV_EIP93
 	select CRYPTO_MD5
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
+	select CRYPTO_DYNAMIC_FALLBACK
+	select CRYPTO_AES
+	select CRYPTO_CBC
+	select CRYPTO_CTR
+	select CRYPTO_DES
+	select CRYPTO_ECB
+	select CRYPTO_HMAC
 	help
 	  EIP93 have various crypto HW accelerators. Select this if
 	  you want to use the EIP93 modules for any of the crypto algorithms.
diff --git a/drivers/crypto/inside-secure/eip93/Makefile b/drivers/crypto/inside-secure/eip93/Makefile
index a3d3d3677cdc..b408d509bdd7 100644
--- a/drivers/crypto/inside-secure/eip93/Makefile
+++ b/drivers/crypto/inside-secure/eip93/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_CRYPTO_DEV_EIP93) += crypto-hw-eip93.o
 crypto-hw-eip93-y += eip93-main.o eip93-common.o
 crypto-hw-eip93-y += eip93-cipher.o eip93-aead.o
 crypto-hw-eip93-y += eip93-hash.o
+crypto-hw-eip93-y += eip93-fallback.o
diff --git a/drivers/crypto/inside-secure/eip93/eip93-fallback.c b/drivers/crypto/inside-secure/eip93/eip93-fallback.c
new file mode 100644
index 000000000000..78e4394b7e9e
--- /dev/null
+++ b/drivers/crypto/inside-secure/eip93/eip93-fallback.c
@@ -0,0 +1,164 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2026 Jihong Min <hurryman2212@gmail.com>
+ */
+
+#include <crypto/fallback.h>
+#include <crypto/md5.h>
+#include <linux/err.h>
+#include <linux/module.h>
+
+#include "eip93-fallback.h"
+#include "eip93-main.h"
+
+/*
+ * Fixed, non-secret keys used only for benchmark setup. The RFC 3686 key
+ * contains a 16-byte AES-128 key followed by its required 4-byte nonce.
+ */
+
+static const u8 eip93_fallback_aes_key[] = {
+	0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7,
+	0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c, 0x00, 0x00, 0x00, 0x01,
+};
+
+static const u8 eip93_fallback_des_key[] = {
+	0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef,
+};
+
+static const u8 eip93_fallback_3des_key[] = {
+	0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef, 0x23, 0x45, 0x67, 0x89,
+	0xab, 0xcd, 0xef, 0x01, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef, 0x01, 0x23,
+};
+
+static const u8 eip93_fallback_auth_key[] = {
+	0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b,
+	0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b,
+};
+
+/* Group EIP93 algorithms by their observed request-size performance trends. */
+
+static const char *const eip93_fallback_raw_aes[] = {
+	"ecb(aes-eip93)",
+	"cbc(aes-eip93)",
+	"ctr(aes-eip93)",
+	"rfc3686(ctr(aes-eip93))",
+};
+
+static const char *const eip93_fallback_raw_des[] = {
+	"ecb(des-eip93)",
+	"cbc(des-eip93)",
+};
+
+static const char *const eip93_fallback_raw_3des[] = {
+	"ecb(des3_ede-eip93)",
+	"cbc(des3_ede-eip93)",
+};
+
+static const char *const eip93_fallback_hash_md5[] = {
+	"md5-eip93",
+	"hmac(md5-eip93)",
+};
+
+static const char *const eip93_fallback_hash_sha1[] = {
+	"sha1-eip93",
+	"hmac(sha1-eip93)",
+};
+
+static const char *const eip93_fallback_hash_sha2[] = {
+	"sha224-eip93",
+	"sha256-eip93",
+	"hmac(sha224-eip93)",
+	"hmac(sha256-eip93)",
+};
+
+static const char *const eip93_fallback_authenc_aes[] = {
+	"authenc(hmac(md5-eip93), cbc(aes-eip93))",
+	"authenc(hmac(sha1-eip93),cbc(aes-eip93))",
+	"authenc(hmac(sha224-eip93),cbc(aes-eip93))",
+	"authenc(hmac(sha256-eip93),cbc(aes-eip93))",
+	"authenc(hmac(md5-eip93),rfc3686(ctr(aes-eip93)))",
+	"authenc(hmac(sha1-eip93),rfc3686(ctr(aes-eip93)))",
+	"authenc(hmac(sha224-eip93),rfc3686(ctr(aes-eip93)))",
+	"authenc(hmac(sha256-eip93),rfc3686(ctr(aes-eip93)))",
+};
+
+static const char *const eip93_fallback_authenc_des[] = {
+	"authenc(hmac(md5-eip93),cbc(des-eip93))",
+	"authenc(hmac(sha1-eip93),cbc(des-eip93))",
+	"authenc(hmac(sha224-eip93),cbc(des-eip93))",
+	"authenc(hmac(sha256-eip93),cbc(des-eip93))",
+};
+
+static const char *const eip93_fallback_authenc_3des[] = {
+	"authenc(hmac(md5-eip93),cbc(des3_ede-eip93))",
+	"authenc(hmac(sha1-eip93),cbc(des3_ede-eip93))",
+	"authenc(hmac(sha224-eip93),cbc(des3_ede-eip93))",
+	"authenc(hmac(sha256-eip93),cbc(des3_ede-eip93))",
+};
+
+static const struct crypto_fallback_group eip93_fallback_groups[] = {
+	CRYPTO_FALLBACK_GROUP("raw_aes", CRYPTO_FALLBACK_SKCIPHER,
+			      "rfc3686(ctr(aes))", "rfc3686(ctr(aes-eip93))",
+			      eip93_fallback_aes_key, eip93_fallback_raw_aes,
+			      ARRAY_SIZE(eip93_fallback_raw_aes)),
+	CRYPTO_FALLBACK_GROUP("raw_des", CRYPTO_FALLBACK_SKCIPHER, "ecb(des)",
+			      "ecb(des-eip93)", eip93_fallback_des_key,
+			      eip93_fallback_raw_des,
+			      ARRAY_SIZE(eip93_fallback_raw_des)),
+	CRYPTO_FALLBACK_GROUP("raw_3des", CRYPTO_FALLBACK_SKCIPHER,
+			      "cbc(des3_ede)", "cbc(des3_ede-eip93)",
+			      eip93_fallback_3des_key, eip93_fallback_raw_3des,
+			      ARRAY_SIZE(eip93_fallback_raw_3des)),
+	CRYPTO_FALLBACK_GROUP("hash_md5", CRYPTO_FALLBACK_AHASH, "hmac(md5)",
+			      "hmac(md5-eip93)", eip93_fallback_auth_key,
+			      eip93_fallback_hash_md5,
+			      ARRAY_SIZE(eip93_fallback_hash_md5)),
+	CRYPTO_FALLBACK_GROUP("hash_sha1", CRYPTO_FALLBACK_AHASH, "hmac(sha1)",
+			      "hmac(sha1-eip93)", eip93_fallback_auth_key,
+			      eip93_fallback_hash_sha1,
+			      ARRAY_SIZE(eip93_fallback_hash_sha1)),
+	CRYPTO_FALLBACK_GROUP("hash_sha2", CRYPTO_FALLBACK_AHASH,
+			      "hmac(sha256)", "hmac(sha256-eip93)",
+			      eip93_fallback_auth_key, eip93_fallback_hash_sha2,
+			      ARRAY_SIZE(eip93_fallback_hash_sha2)),
+	CRYPTO_FALLBACK_GROUP_AUTHENC("authenc_aes",
+				      "authenc(hmac(md5),rfc3686(ctr(aes)))",
+				      "authenc(hmac(md5-eip93),rfc3686(ctr(aes-eip93)))",
+				      eip93_fallback_aes_key,
+				      eip93_fallback_auth_key, MD5_DIGEST_SIZE,
+				      eip93_fallback_authenc_aes,
+				      ARRAY_SIZE(eip93_fallback_authenc_aes)),
+	CRYPTO_FALLBACK_GROUP_AUTHENC("authenc_des",
+				      "authenc(hmac(md5),cbc(des))",
+				      "authenc(hmac(md5-eip93),cbc(des-eip93))",
+				      eip93_fallback_des_key,
+				      eip93_fallback_auth_key, MD5_DIGEST_SIZE,
+				      eip93_fallback_authenc_des,
+				      ARRAY_SIZE(eip93_fallback_authenc_des)),
+	CRYPTO_FALLBACK_GROUP_AUTHENC("authenc_3des",
+				      "authenc(hmac(md5),cbc(des3_ede))",
+				      "authenc(hmac(md5-eip93),cbc(des3_ede-eip93))",
+				      eip93_fallback_3des_key,
+				      eip93_fallback_auth_key, MD5_DIGEST_SIZE,
+				      eip93_fallback_authenc_3des,
+				      ARRAY_SIZE(eip93_fallback_authenc_3des)),
+};
+
+static struct crypto_fallback *eip93_fallback;
+
+int eip93_fallback_register(struct eip93_device *eip93)
+{
+	eip93_fallback =
+		crypto_fallback_register(THIS_MODULE, eip93->dev,
+					 eip93_fallback_groups,
+					 ARRAY_SIZE(eip93_fallback_groups));
+
+	return PTR_ERR_OR_ZERO(eip93_fallback);
+}
+
+void eip93_fallback_unregister(void)
+{
+	crypto_fallback_unregister(eip93_fallback);
+
+	eip93_fallback = NULL;
+}
diff --git a/drivers/crypto/inside-secure/eip93/eip93-fallback.h b/drivers/crypto/inside-secure/eip93/eip93-fallback.h
new file mode 100644
index 000000000000..e3ba9a66abc7
--- /dev/null
+++ b/drivers/crypto/inside-secure/eip93/eip93-fallback.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _EIP93_FALLBACK_H_
+#define _EIP93_FALLBACK_H_
+
+struct eip93_device;
+
+int eip93_fallback_register(struct eip93_device *eip93);
+void eip93_fallback_unregister(void);
+
+#endif /* _EIP93_FALLBACK_H_ */
diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
index 1a8dabc4ada4..96ecffeb75df 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-main.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
@@ -25,6 +25,7 @@
 #include "eip93-aes.h"
 #include "eip93-des.h"
 #include "eip93-aead.h"
+#include "eip93-fallback.h"
 #include "eip93-hash.h"
 
 static struct eip93_alg_template *eip93_algs[] = {
@@ -460,10 +461,12 @@ static int eip93_crypto_probe(struct platform_device *pdev)
 	eip93_irq_enable(eip93, EIP93_INT_RDR_THRESH);
 
 	ret = eip93_register_algs(eip93, algo_flags);
-	if (ret) {
-		eip93_cleanup(eip93);
-		return ret;
-	}
+	if (ret)
+		goto err_cleanup;
+
+	ret = eip93_fallback_register(eip93);
+	if (ret)
+		goto err_unregister_algs;
 
 	ver = readl(eip93->base + EIP93_REG_PE_REVISION);
 	/* EIP_EIP_NO:MAJOR_HW_REV:MINOR_HW_REV:HW_PATCH,PE(ALGO_FLAGS) */
@@ -476,6 +479,13 @@ static int eip93_crypto_probe(struct platform_device *pdev)
 		 readl(eip93->base + EIP93_REG_PE_OPTION_0));
 
 	return 0;
+
+err_unregister_algs:
+	eip93_unregister_algs(algo_flags, ARRAY_SIZE(eip93_algs));
+err_cleanup:
+	eip93_cleanup(eip93);
+
+	return ret;
 }
 
 static void eip93_crypto_remove(struct platform_device *pdev)
@@ -485,6 +495,7 @@ static void eip93_crypto_remove(struct platform_device *pdev)
 
 	algo_flags = readl(eip93->base + EIP93_REG_PE_OPTION_1);
 
+	eip93_fallback_unregister();
 	eip93_unregister_algs(algo_flags, ARRAY_SIZE(eip93_algs));
 	eip93_cleanup(eip93);
 }
-- 
2.53.0
