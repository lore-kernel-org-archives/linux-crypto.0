Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CBF4414;
	Thu, 12 Feb 2026 03:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.1.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865457; cv=none; b=pnye6uBoyIUnWsDX0iYckHq7v+Py24EuEdzNvSyZkeDyAbL1tZSgVam8GFapQUGFy0Bc42MVwvCJAccV2WjjiG5HfYcuaZXirQFD2ax9JH/BeF2l8Z+/Jhdwym7oaBol5B5O2G5V7m9WBY65jeKm2ZLc4u7DEFBP+nDTQLqPlO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865457; c=relaxed/simple;
	bh=cbQxqyepFcK64B+JoYsB+WVWuji+kKvBh9o+Gesy6xs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=komp+vMDE0WzPF7a+yfllfR9lv2erT588tW2a37r9YJOdik1+EiKCxcUTgu+nMiO27uuEFMr8DoXRtttnfnEUJkyC9cAfbIA/pMNufZqaBtjqo0hbR5XBxYDvJD+ISzkzzjrrINUNVMr9thAy3xeJrVsfL+CNCH0fK20kordKbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=IFCmjIIy; arc=none smtp.client-ip=44.246.1.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="IFCmjIIy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865456; x=1802401456;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EINF0r05fCGdozwxSs69xlxZRcrWOWG5viZG7pISjz8=;
  b=IFCmjIIyk3PPCT36dsXvjwPTd2VM1nU5D5si/6U8LC1UHU2AU+X9zgwM
   L6sWMIoqwbB/WvP7cI1tgAPuat+lPoMfhzzjEieUv2F7LMKRnwyWwzPGi
   O3HHmWs7qw3WTNjPB0OByK2ILEJ2LX5tiqlnMhaeOgUUXi3pujcktQfme
   ulZqlObfH1TzmWNMc3053dQnXXH3EENNlfz/LPZ+CDZ4im1mrwflIZM/R
   ee9d1y1f7AjQ1NrwRbDbc0i83j9IhKINp7ZdZo7LbEZyUJVrLEo14PHU7
   tk2J4Czys4r/bE251YWNIs0XEt6Kr6tvqUUhw9Jw4lmLDctOauHPzCnba
   g==;
X-CSE-ConnectionGUID: EkBT6euZSVe2RipQC++zSA==
X-CSE-MsgGUID: bpCS/gvoRQiibzFiuMZiyA==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12919372"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:04:16 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.51:5587]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.39.165:2525] with esmtp (Farcaster)
 id 9ec3b2db-7f8f-4dc3-8c1c-6ee7ffdafc15; Thu, 12 Feb 2026 03:04:16 +0000 (UTC)
X-Farcaster-Flow-ID: 9ec3b2db-7f8f-4dc3-8c1c-6ee7ffdafc15
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:04:15 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:04:15 +0000
From: Jay Wang <wanjay@amazon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
	<davem@davemloft.net>, <linux-crypto@vger.kernel.org>
CC: Jay Wang <jay.wang.upstream@gmail.com>, Vegard Nossum
	<vegard.nossum@oracle.com>, Nicolai Stange <nstange@suse.de>, Ilia Okomin
	<ilya.okomin@oracle.com>, Catalin Marinas <catalin.marinas@arm.com>, "Will
 Deacon" <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Luis Chamberlain
	<mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, Nathan Chancellor
	<nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <x86@kernel.org>,
	<linux-kbuild@vger.kernel.org>, <linux-modules@vger.kernel.org>
Subject: [PATCH 065/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_TWOFISH and CONFIG_CRYPTO_TWOFISH_COMMON crypto
Date: Thu, 12 Feb 2026 02:46:41 +0000
Message-ID: <20260212024725.11264-66-wanjay@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212024725.11264-1-wanjay@amazon.com>
References: <20260212024725.11264-1-wanjay@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D042UWB002.ant.amazon.com (10.13.139.175) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_TWOFISH- and CONFIG_CRYPTO_TWOFISH_COMMON-related crypto
to convert them into pluggable interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile              |  4 ++--
 crypto/fips140/fips140-api.c | 11 +++++++++++
 crypto/twofish_generic.c     |  4 ++--
 include/crypto/twofish.h     | 11 ++++++++---
 4 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 326b37002e3d..e93edc49840a 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -130,8 +130,8 @@ crypto-objs-$(CONFIG_CRYPTO_DES) += des_generic.o
 crypto-objs-$(CONFIG_CRYPTO_FCRYPT) += fcrypt.o
 crypto-objs-$(CONFIG_CRYPTO_BLOWFISH) += blowfish_generic.o
 crypto-objs-$(CONFIG_CRYPTO_BLOWFISH_COMMON) += blowfish_common.o
-obj-$(CONFIG_CRYPTO_TWOFISH) += twofish_generic.o
-obj-$(CONFIG_CRYPTO_TWOFISH_COMMON) += twofish_common.o
+crypto-objs-$(CONFIG_CRYPTO_TWOFISH) += twofish_generic.o
+crypto-objs-$(CONFIG_CRYPTO_TWOFISH_COMMON) += twofish_common.o
 obj-$(CONFIG_CRYPTO_SERPENT) += serpent_generic.o
 CFLAGS_serpent_generic.o := $(call cc-option,-fsched-pressure)  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79149
 crypto-objs-$(CONFIG_CRYPTO_AES) += aes.o
diff --git a/crypto/fips140/fips140-api.c b/crypto/fips140/fips140-api.c
index 5b0ae8476ce7..9ad530743d1f 100644
--- a/crypto/fips140/fips140-api.c
+++ b/crypto/fips140/fips140-api.c
@@ -672,3 +672,14 @@ DEFINE_CRYPTO_API_STUB(sm4_expandkey);
 DEFINE_CRYPTO_API_STUB(sm4_crypt_block);
 
 #endif
+/*
+ * crypto/twofish_common.c
+ */
+#if IS_BUILTIN(CONFIG_CRYPTO_TWOFISH_COMMON)
+
+#include <crypto/twofish.h>
+
+DEFINE_CRYPTO_API_STUB(__twofish_setkey);
+DEFINE_CRYPTO_API_STUB(twofish_setkey);
+
+#endif
diff --git a/crypto/twofish_generic.c b/crypto/twofish_generic.c
index 368018cfa9bf..0d9cefa3350b 100644
--- a/crypto/twofish_generic.c
+++ b/crypto/twofish_generic.c
@@ -187,8 +187,8 @@ static void __exit twofish_mod_fini(void)
 	crypto_unregister_alg(&alg);
 }
 
-module_init(twofish_mod_init);
-module_exit(twofish_mod_fini);
+crypto_module_init(twofish_mod_init);
+crypto_module_exit(twofish_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION ("Twofish Cipher Algorithm");
diff --git a/include/crypto/twofish.h b/include/crypto/twofish.h
index f6b307a58554..4695480f5d44 100644
--- a/include/crypto/twofish.h
+++ b/include/crypto/twofish.h
@@ -2,6 +2,7 @@
 #ifndef _CRYPTO_TWOFISH_H
 #define _CRYPTO_TWOFISH_H
 
+#include <crypto/api.h>
 #include <linux/types.h>
 
 #define TF_MIN_KEY_SIZE 16
@@ -18,8 +19,12 @@ struct twofish_ctx {
 	u32 s[4][256], w[8], k[32];
 };
 
-int __twofish_setkey(struct twofish_ctx *ctx, const u8 *key,
-		     unsigned int key_len);
-int twofish_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int key_len);
+DECLARE_CRYPTO_API(CONFIG_CRYPTO_TWOFISH_COMMON, __twofish_setkey, int,
+	(struct twofish_ctx *ctx, const u8 *key, unsigned int key_len),
+	(ctx, key, key_len));
+
+DECLARE_CRYPTO_API(CONFIG_CRYPTO_TWOFISH_COMMON, twofish_setkey, int,
+	(struct crypto_tfm *tfm, const u8 *key, unsigned int key_len),
+	(tfm, key, key_len));
 
 #endif
-- 
2.47.3

