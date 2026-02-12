Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A7819006B;
	Thu, 12 Feb 2026 03:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.1.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770865444; cv=none; b=k8eQza5jOg+ZsNO8PLxL++e8uZ7h7Xj5s0mODN2sBc5g3m2bVocR0Vea75MpBtgxx/+cUvQuKIHa/+xVMlgPWHDz6OmcfWtRgfC2IlkEMZ9jchetLbdBiB7EnVypchx9ypDiX+35S1+ODsdNXUyLAMblcE0ozYll9q1xvu6daxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770865444; c=relaxed/simple;
	bh=w1d9fxSgNSM/WSwemhZxBrbxokTQR5y1jIqRAxwj31w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mjlCKpJRL4vsLvEYZhm+ns0V3q3gckpjX5DBf94KP3HHrU3umVYEua8R2xQZuVdgoqsYgwtdth7tTV6OixePvsaA1G6edMUHFa6gdfmuyda80mtM4In5vBRPfcuzi4emqV+ck/Jw9nBd0Z+xKq1OSpvJ++kuA2nJVYGoc1bwxVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=gV6uApSp; arc=none smtp.client-ip=44.246.1.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="gV6uApSp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1770865442; x=1802401442;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5rlSwtRN3//9bGbY8pLd6FsunXhmy/i2ZD1cSmdvPns=;
  b=gV6uApSpkEU+ZTKObxJS8rz1m1peBzBFC81cmAgdit0YODZEF3aOB+Em
   eaHAGAbw06Dzt5tPu2evPDzFc/nnsit5Nx/CygWmfAbQEZoHeUI7BlXfm
   7yd4DyJgfEiqwL0JUl07+ZwCIO/LhdN+UOTyU57/UJ23JmKjuwHJBzV7u
   gL6QrYBuk8emPz3/+9bCnAm1AUCP8Wts08k9LKlubDjcASuD74nOqYpTM
   56eVE6vq1e7vg8IyXwd2a9u9Nw45OObSbKPrXJ5OL82NcqZpnxOn/J+ER
   TfdNnjGAjUfaekTHDLYxj3RSQLt7bGYXwYOTG+e93yKPrj73G1ZXrrVMo
   Q==;
X-CSE-ConnectionGUID: 1Acg/V4aT/69pD1RDORiDQ==
X-CSE-MsgGUID: hEWWcQueSNuaUMDSpjlhNg==
X-IronPort-AV: E=Sophos;i="6.21,285,1763424000"; 
   d="scan'208";a="12919339"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 03:04:02 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:30733]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.3.19:2525] with esmtp (Farcaster)
 id da222334-da56-4877-aa78-33be49e59f70; Thu, 12 Feb 2026 03:04:02 +0000 (UTC)
X-Farcaster-Flow-ID: da222334-da56-4877-aa78-33be49e59f70
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:04:00 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 12 Feb 2026 03:03:59 +0000
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
Subject: [PATCH 064/106] crypto: convert exported crypto symbol into pluggable interface for CONFIG_CRYPTO_SM4 and CONFIG_CRYPTO_SM4_GENERIC crypto
Date: Thu, 12 Feb 2026 02:46:40 +0000
Message-ID: <20260212024725.11264-65-wanjay@amazon.com>
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
X-ClientProxiedBy: EX19D044UWA003.ant.amazon.com (10.13.139.43) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Apply Crypto API wrappers to the exported crypto symbol in
CONFIG_CRYPTO_SM4- and CONFIG_CRYPTO_SM4_GENERIC-related crypto to
convert them into pluggable interface.

Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/Makefile              |  4 ++--
 crypto/fips140/fips140-api.c | 18 ++++++++++++++++++
 crypto/sm4_generic.c         |  4 ++--
 include/crypto/sm4.h         | 22 ++++++++++++++++------
 4 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 795c76357bff..326b37002e3d 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -135,8 +135,8 @@ obj-$(CONFIG_CRYPTO_TWOFISH_COMMON) += twofish_common.o
 obj-$(CONFIG_CRYPTO_SERPENT) += serpent_generic.o
 CFLAGS_serpent_generic.o := $(call cc-option,-fsched-pressure)  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79149
 crypto-objs-$(CONFIG_CRYPTO_AES) += aes.o
-obj-$(CONFIG_CRYPTO_SM4) += sm4.o
-obj-$(CONFIG_CRYPTO_SM4_GENERIC) += sm4_generic.o
+crypto-objs-$(CONFIG_CRYPTO_SM4) += sm4.o
+crypto-objs-$(CONFIG_CRYPTO_SM4_GENERIC) += sm4_generic.o
 obj-$(CONFIG_CRYPTO_CAMELLIA) += camellia_generic.o
 obj-$(CONFIG_CRYPTO_CAST_COMMON) += cast_common.o
 obj-$(CONFIG_CRYPTO_CAST5) += cast5_generic.o
diff --git a/crypto/fips140/fips140-api.c b/crypto/fips140/fips140-api.c
index 61f7884d0f34..5b0ae8476ce7 100644
--- a/crypto/fips140/fips140-api.c
+++ b/crypto/fips140/fips140-api.c
@@ -654,3 +654,21 @@ DEFINE_CRYPTO_API_STUB(cryptd_free_aead);
 DEFINE_CRYPTO_API_STUB(blowfish_setkey);
 
 #endif
+/*
+ * crypto/sm4.c
+ */
+#if IS_BUILTIN(CONFIG_CRYPTO_SM4)
+
+#include <crypto/sm4.h>
+
+#undef crypto_sm4_fk
+#undef crypto_sm4_ck
+#undef crypto_sm4_sbox
+DEFINE_CRYPTO_VAR_STUB(crypto_sm4_fk);
+DEFINE_CRYPTO_VAR_STUB(crypto_sm4_ck);
+DEFINE_CRYPTO_VAR_STUB(crypto_sm4_sbox);
+
+DEFINE_CRYPTO_API_STUB(sm4_expandkey);
+DEFINE_CRYPTO_API_STUB(sm4_crypt_block);
+
+#endif
diff --git a/crypto/sm4_generic.c b/crypto/sm4_generic.c
index d57444e8428c..aba3e3271d37 100644
--- a/crypto/sm4_generic.c
+++ b/crypto/sm4_generic.c
@@ -83,8 +83,8 @@ static void __exit sm4_fini(void)
 	crypto_unregister_alg(&sm4_alg);
 }
 
-module_init(sm4_init);
-module_exit(sm4_fini);
+crypto_module_init(sm4_init);
+crypto_module_exit(sm4_fini);
 
 MODULE_DESCRIPTION("SM4 Cipher Algorithm");
 MODULE_LICENSE("GPL v2");
diff --git a/include/crypto/sm4.h b/include/crypto/sm4.h
index 9656a9a40326..10cb9c379357 100644
--- a/include/crypto/sm4.h
+++ b/include/crypto/sm4.h
@@ -9,6 +9,7 @@
 #ifndef _CRYPTO_SM4_H
 #define _CRYPTO_SM4_H
 
+#include <crypto/api.h>
 #include <linux/types.h>
 #include <linux/crypto.h>
 
@@ -21,9 +22,15 @@ struct sm4_ctx {
 	u32 rkey_dec[SM4_RKEY_WORDS];
 };
 
-extern const u32 crypto_sm4_fk[];
-extern const u32 crypto_sm4_ck[];
-extern const u8 crypto_sm4_sbox[];
+DECLARE_CRYPTO_VAR(CONFIG_CRYPTO_SM4, crypto_sm4_fk, const u32, [4]);
+DECLARE_CRYPTO_VAR(CONFIG_CRYPTO_SM4, crypto_sm4_ck, const u32, [32]);
+DECLARE_CRYPTO_VAR(CONFIG_CRYPTO_SM4, crypto_sm4_sbox, const u8, [256]);
+
+#if defined(CONFIG_CRYPTO_FIPS140_EXTMOD) && !defined(FIPS_MODULE) && IS_BUILTIN(CONFIG_CRYPTO_SM4)
+#define crypto_sm4_fk (((const u32*)CRYPTO_VAR_NAME(crypto_sm4_fk)))
+#define crypto_sm4_ck (((const u32*)CRYPTO_VAR_NAME(crypto_sm4_ck)))
+#define crypto_sm4_sbox (((const u8*)CRYPTO_VAR_NAME(crypto_sm4_sbox)))
+#endif
 
 /**
  * sm4_expandkey - Expands the SM4 key as described in GB/T 32907-2016
@@ -34,8 +41,9 @@ extern const u8 crypto_sm4_sbox[];
  * Returns 0 on success. The function fails only if an invalid key size (or
  * pointer) is supplied.
  */
-int sm4_expandkey(struct sm4_ctx *ctx, const u8 *in_key,
-			  unsigned int key_len);
+DECLARE_CRYPTO_API(CONFIG_CRYPTO_SM4, sm4_expandkey, int,
+	(struct sm4_ctx *ctx, const u8 *in_key, unsigned int key_len),
+	(ctx, in_key, key_len));
 
 /**
  * sm4_crypt_block - Encrypt or decrypt a single SM4 block
@@ -43,6 +51,8 @@ int sm4_expandkey(struct sm4_ctx *ctx, const u8 *in_key,
  * @out:	Buffer to store output data
  * @in: 	Buffer containing the input data
  */
-void sm4_crypt_block(const u32 *rk, u8 *out, const u8 *in);
+DECLARE_CRYPTO_API(CONFIG_CRYPTO_SM4, sm4_crypt_block, void,
+	(const u32 *rk, u8 *out, const u8 *in),
+	(rk, out, in));
 
 #endif
-- 
2.47.3

