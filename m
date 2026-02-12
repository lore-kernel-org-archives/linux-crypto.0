Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED114414;
	Thu, 12 Feb 2026 03:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865381; cv=none; b=agrYLCP0T/a0eWkRbLmGANpNZq5AJgjRgl8ei8+snv+KgFZlxm/NMNhBl1HsUCQ36kvi9QPxg+yCVKDWMmJRWqeP7U9lU5NvQxndsGZTNGScCQitnLgU7P0nLEqtHhUQIsbsV+GmhPIocNib+ikHzzjMsrZSAohDS7dMVNFUxvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865381; c=relaxed/simple;
	bh=tsiCOdg766J4yaRRqt/mxMW4xpGKAAeAQj4MncoXIdU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NTNIMsc5Hg+JExYRRGfc93rJSPgjN1Cn1SflulaE+2c0AZXcGJwZRlU532tfwAR6/gkyum5cyi7lARcdu9hN4/95bgpy6u8auY3b7sGLehr3J8sKbbZgkjIV7anMWiuNM7c4KmZn6hQ1z7FYEFKV/cfAb5U/PMz1yIQYade8F+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=Ra9zaU9Z; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="Ra9zaU9Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865379; x=1802401379;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CXhuhgn4LhG1nenObyftggQvuPDsBve5odR969siNLw=;
  b=Ra9zaU9Z0KmrXCrbmEWQcbTB8HLItAd2bC7v7ZdUlcBkHT6GLhPOZzpS
   rkUBnXAbFeSBCC3cwXLBCmcQ+LuukbvZ9vH64e3Ncs4/4a57CZLcLhi3O
   ux/qjz4L5cJzh1bVmypWbSvRdbg67EFNQlqBBE3TfX57OUDa5PoIkumrO
   DCXEBMW99b0Fz4yJwR4ZE41Yf6onJH4jQ3rfGHqwQ7qe/jeSy1Zs0Hdjj
   HkoOOLvNFVY6lZJ/19JK80pw6xbB7kNyZyii2z5pzGb7tMzJlquEmgFfc
   raUx2j66tS/rIVCm12BbaPmYsDjziVrzXFCxAkUY7X5eVTe0g8tqrJNuz
   A==;
X-CSE-ConnectionGUID: zYZMISnLR2yYuApwrcj1zQ==
X-CSE-MsgGUID: SVWKBc4xQheaXLf7zDrCPg==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12913756"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:02:59 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:31552]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.20.103:2525] with esmtp (Farcaster)
 id da137e97-4179-46b9-b2c0-f964e01be049; Thu, 12 Feb 2026 03:02:58 +0000 (UTC)
X-Farcaster-Flow-ID: da137e97-4179-46b9-b2c0-f964e01be049
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:02:58 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:02:57 +0000
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
Subject: [PATCH 060/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_CRYPTD crypto
Date: Thu, 12 Feb 2026 02:46:36 +0000
Message-ID: <20260212024725.11264-61-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D044UWB002.ant.amazon.com (10.13.139.188) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_CRYPTD-related crypto to convert them into pluggable
interface.

This patch is partially based on work by Vegard Nossum, with
modifications. Unlike the original, we do not include
DEFINE_CRYPTO_API since only one copy of the crypto symbols is
kept, either in the crypto module or in the main kernel, and we ensure
such wrapper do not have impact on crypto already chosen built as
module.

Co-developed-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile              |  2 +-
 crypto/cryptd.c              |  4 +--
 crypto/fips140/fips140-api.c | 22 ++++++++++++++
 include/crypto/cryptd.h      | 56 +++++++++++++++++++++++++-----------
 4 files changed, 65 insertions(+), 19 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index b371a8788d39..f029e0decaa1 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -125,7 +125,7 @@ endif
 CFLAGS_aegis128-neon-inner.o += -isystem $(shell $(CC) -print-file-name=include)
 
 crypto-objs-$(CONFIG_CRYPTO_PCRYPT) += pcrypt.o
-obj-$(CONFIG_CRYPTO_CRYPTD) += cryptd.o
+crypto-objs-$(CONFIG_CRYPTO_CRYPTD) += cryptd.o
 obj-$(CONFIG_CRYPTO_DES) += des_generic.o
 obj-$(CONFIG_CRYPTO_FCRYPT) += fcrypt.o
 obj-$(CONFIG_CRYPTO_BLOWFISH) += blowfish_generic.o
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index cd38f4676176..8b1ba67d752c 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -1145,8 +1145,8 @@ static void __exit cryptd_exit(void)
 	crypto_unregister_template(&cryptd_tmpl);
 }
 
-module_init(cryptd_init);
-module_exit(cryptd_exit);
+crypto_module_init(cryptd_init);
+crypto_module_exit(cryptd_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Software async crypto daemon");
diff --git a/crypto/fips140/fips140-api.c b/crypto/fips140/fips140-api.c
index 3c6dfcac5db5..1452439319cc 100644
--- a/crypto/fips140/fips140-api.c
+++ b/crypto/fips140/fips140-api.c
@@ -622,3 +622,25 @@ DEFINE_CRYPTO_API_STUB(ecc_point_is_zero);
 DEFINE_CRYPTO_API_STUB(ecc_point_mult_shamir);
 
 #endif
+/*
+ * crypto/cryptd.c
+ */
+#if IS_BUILTIN(CONFIG_CRYPTO_CRYPTD)
+
+#include <crypto/cryptd.h>
+
+DEFINE_CRYPTO_API_STUB(cryptd_alloc_skcipher);
+DEFINE_CRYPTO_API_STUB(cryptd_skcipher_child);
+DEFINE_CRYPTO_API_STUB(cryptd_skcipher_queued);
+DEFINE_CRYPTO_API_STUB(cryptd_free_skcipher);
+DEFINE_CRYPTO_API_STUB(cryptd_alloc_ahash);
+DEFINE_CRYPTO_API_STUB(cryptd_ahash_child);
+DEFINE_CRYPTO_API_STUB(cryptd_shash_desc);
+DEFINE_CRYPTO_API_STUB(cryptd_ahash_queued);
+DEFINE_CRYPTO_API_STUB(cryptd_free_ahash);
+DEFINE_CRYPTO_API_STUB(cryptd_alloc_aead);
+DEFINE_CRYPTO_API_STUB(cryptd_aead_child);
+DEFINE_CRYPTO_API_STUB(cryptd_aead_queued);
+DEFINE_CRYPTO_API_STUB(cryptd_free_aead);
+
+#endif
diff --git a/include/crypto/cryptd.h b/include/crypto/cryptd.h
index 796d986e58e1..35b4d06e41f5 100644
--- a/include/crypto/cryptd.h
+++ b/include/crypto/cryptd.h
@@ -13,6 +13,7 @@
 #ifndef _CRYPTO_CRYPT_H
 #define _CRYPTO_CRYPT_H
 
+#include <crypto/api.h>
 #include <linux/types.h>
 
 #include <crypto/aead.h>
@@ -24,12 +25,19 @@ struct cryptd_skcipher {
 };
 
 /* alg_name should be algorithm to be cryptd-ed */
-struct cryptd_skcipher *cryptd_alloc_skcipher(const char *alg_name,
-					      u32 type, u32 mask);
-struct crypto_skcipher *cryptd_skcipher_child(struct cryptd_skcipher *tfm);
+DECLARE_CRYPTO_API(CONFIG_CRYPTO_CRYPTD, cryptd_alloc_skcipher, struct cryptd_skcipher *,
+	(const char *alg_name, u32 type, u32 mask),
+	(alg_name, type, mask));
+DECLARE_CRYPTO_API(CONFIG_CRYPTO_CRYPTD, cryptd_skcipher_child, struct crypto_skcipher *,
+	(struct cryptd_skcipher *tfm),
+	(tfm));
 /* Must be called without moving CPUs. */
-bool cryptd_skcipher_queued(struct cryptd_skcipher *tfm);
-void cryptd_free_skcipher(struct cryptd_skcipher *tfm);
+DECLARE_CRYPTO_API(CONFIG_CRYPTO_CRYPTD, cryptd_skcipher_queued, bool,
+	(struct cryptd_skcipher *tfm),
+	(tfm));
+DECLARE_CRYPTO_API(CONFIG_CRYPTO_CRYPTD, cryptd_free_skcipher, void,
+	(struct cryptd_skcipher *tfm),
+	(tfm));
 
 struct cryptd_ahash {
 	struct crypto_ahash base;
@@ -42,13 +50,22 @@ static inline struct cryptd_ahash *__cryptd_ahash_cast(
 }
 
 /* alg_name should be algorithm to be cryptd-ed */
-struct cryptd_ahash *cryptd_alloc_ahash(const char *alg_name,
-					u32 type, u32 mask);
-struct crypto_shash *cryptd_ahash_child(struct cryptd_ahash *tfm);
-struct shash_desc *cryptd_shash_desc(struct ahash_request *req);
+DECLARE_CRYPTO_API(CONFIG_CRYPTO_CRYPTD, cryptd_alloc_ahash, struct cryptd_ahash *,
+	(const char *alg_name, u32 type, u32 mask),
+	(alg_name, type, mask));
+DECLARE_CRYPTO_API(CONFIG_CRYPTO_CRYPTD, cryptd_ahash_child, struct crypto_shash *,
+	(struct cryptd_ahash *tfm),
+	(tfm));
+DECLARE_CRYPTO_API(CONFIG_CRYPTO_CRYPTD, cryptd_shash_desc, struct shash_desc *,
+	(struct ahash_request *req),
+	(req));
 /* Must be called without moving CPUs. */
-bool cryptd_ahash_queued(struct cryptd_ahash *tfm);
-void cryptd_free_ahash(struct cryptd_ahash *tfm);
+DECLARE_CRYPTO_API(CONFIG_CRYPTO_CRYPTD, cryptd_ahash_queued, bool,
+	(struct cryptd_ahash *tfm),
+	(tfm));
+DECLARE_CRYPTO_API(CONFIG_CRYPTO_CRYPTD, cryptd_free_ahash, void,
+	(struct cryptd_ahash *tfm),
+	(tfm));
 
 struct cryptd_aead {
 	struct crypto_aead base;
@@ -60,13 +77,20 @@ static inline struct cryptd_aead *__cryptd_aead_cast(
 	return (struct cryptd_aead *)tfm;
 }
 
-struct cryptd_aead *cryptd_alloc_aead(const char *alg_name,
-					  u32 type, u32 mask);
+DECLARE_CRYPTO_API(CONFIG_CRYPTO_CRYPTD, cryptd_alloc_aead, struct cryptd_aead *,
+	(const char *alg_name, u32 type, u32 mask),
+	(alg_name, type, mask));
 
-struct crypto_aead *cryptd_aead_child(struct cryptd_aead *tfm);
+DECLARE_CRYPTO_API(CONFIG_CRYPTO_CRYPTD, cryptd_aead_child, struct crypto_aead *,
+	(struct cryptd_aead *tfm),
+	(tfm));
 /* Must be called without moving CPUs. */
-bool cryptd_aead_queued(struct cryptd_aead *tfm);
+DECLARE_CRYPTO_API(CONFIG_CRYPTO_CRYPTD, cryptd_aead_queued, bool,
+	(struct cryptd_aead *tfm),
+	(tfm));
 
-void cryptd_free_aead(struct cryptd_aead *tfm);
+DECLARE_CRYPTO_API(CONFIG_CRYPTO_CRYPTD, cryptd_free_aead, void,
+	(struct cryptd_aead *tfm),
+	(tfm));
 
 #endif
-- 
2.47.3

