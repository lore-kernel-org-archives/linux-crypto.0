Return-Path: <SRS0=uwZS=4S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7928FC3F2CD
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Mar 2020 14:52:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26DAD21D56
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Mar 2020 14:52:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="2Ael3FZ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgCAOwz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Mar 2020 09:52:55 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:35313 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbgCAOwz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Mar 2020 09:52:55 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id e0528505;
        Sun, 1 Mar 2020 14:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=wLcqUGQXqShOJNdo97Rm5CfUy5E=; b=2Ael3FZ0jCv0Ra5iNkGk
        /KYafOfRU6b1oz10/1FyOItP13MFoyiZx2GdywGdqz731e9OmLboGK1+ytIQFncz
        ub2IorhlZYceBhGyEizuZamVN43G2eDycy3HrdybUIFtYuPkhM5WJ7zaq3/VPOGu
        buAP7zNkUYf9mCGA60IM8d33W1wj1dwp6OZpDs7PF3ma4J9ndwJAgwXT+may+MW3
        /M56Rl+44R2eQh1xAg7W6CFL2ABTM2cJhStpoF2stxvb+J50ecJzKkJX8mvtA7ML
        65EUv74f7PMLn9B31I97XuSMedil6Hx9fgUMyPg7cX4sBEdfWquYEBi3w+GxuBKO
        fQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 637d5650 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Sun, 1 Mar 2020 14:48:42 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH crypto 5.6] crypto: x86/curve25519 - support assemblers with no adx support
Date:   Sun,  1 Mar 2020 22:52:35 +0800
Message-Id: <20200301145235.200032-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some older version of GAS do not support the ADX instructions, similarly
to how they also don't support AVX and such. This commit adds the same
build-time detection mechanisms we use for AVX and others for ADX, and
then makes sure that the curve25519 library dispatcher calls the right
functions.

Reported-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
This patch is meant for 5.6-rcX.

 arch/x86/Makefile           | 5 +++--
 arch/x86/crypto/Makefile    | 7 ++++++-
 include/crypto/curve25519.h | 6 ++++--
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 94df0868804b..513a55562d75 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -194,9 +194,10 @@ avx2_instr :=$(call as-instr,vpbroadcastb %xmm0$(comma)%ymm1,-DCONFIG_AS_AVX2=1)
 avx512_instr :=$(call as-instr,vpmovm2b %k1$(comma)%zmm5,-DCONFIG_AS_AVX512=1)
 sha1_ni_instr :=$(call as-instr,sha1msg1 %xmm0$(comma)%xmm1,-DCONFIG_AS_SHA1_NI=1)
 sha256_ni_instr :=$(call as-instr,sha256msg1 %xmm0$(comma)%xmm1,-DCONFIG_AS_SHA256_NI=1)
+adx_instr := $(call as-instr,adox %r10$(comma)%r10,-DCONFIG_AS_ADX=1)
 
-KBUILD_AFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections) $(asinstr) $(avx_instr) $(avx2_instr) $(avx512_instr) $(sha1_ni_instr) $(sha256_ni_instr)
-KBUILD_CFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections) $(asinstr) $(avx_instr) $(avx2_instr) $(avx512_instr) $(sha1_ni_instr) $(sha256_ni_instr)
+KBUILD_AFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections) $(asinstr) $(avx_instr) $(avx2_instr) $(avx512_instr) $(sha1_ni_instr) $(sha256_ni_instr) $(adx_instr)
+KBUILD_CFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections) $(asinstr) $(avx_instr) $(avx2_instr) $(avx512_instr) $(sha1_ni_instr) $(sha256_ni_instr) $(adx_instr)
 
 KBUILD_LDFLAGS := -m elf_$(UTS_MACHINE)
 
diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index b69e00bf20b8..8c2e9eadee8a 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -11,6 +11,7 @@ avx2_supported := $(call as-instr,vpgatherdd %ymm0$(comma)(%eax$(comma)%ymm1\
 avx512_supported :=$(call as-instr,vpmovm2b %k1$(comma)%zmm5,yes,no)
 sha1_ni_supported :=$(call as-instr,sha1msg1 %xmm0$(comma)%xmm1,yes,no)
 sha256_ni_supported :=$(call as-instr,sha256msg1 %xmm0$(comma)%xmm1,yes,no)
+adx_supported := $(call as-instr,adox %r10$(comma)%r10,yes,no)
 
 obj-$(CONFIG_CRYPTO_GLUE_HELPER_X86) += glue_helper.o
 
@@ -39,7 +40,11 @@ obj-$(CONFIG_CRYPTO_AEGIS128_AESNI_SSE2) += aegis128-aesni.o
 
 obj-$(CONFIG_CRYPTO_NHPOLY1305_SSE2) += nhpoly1305-sse2.o
 obj-$(CONFIG_CRYPTO_NHPOLY1305_AVX2) += nhpoly1305-avx2.o
-obj-$(CONFIG_CRYPTO_CURVE25519_X86) += curve25519-x86_64.o
+
+# These modules require the assembler to support ADX.
+ifeq ($(adx_supported),yes)
+	obj-$(CONFIG_CRYPTO_CURVE25519_X86) += curve25519-x86_64.o
+endif
 
 # These modules require assembler to support AVX.
 ifeq ($(avx_supported),yes)
diff --git a/include/crypto/curve25519.h b/include/crypto/curve25519.h
index 4e6dc840b159..9ecb3c1f0f15 100644
--- a/include/crypto/curve25519.h
+++ b/include/crypto/curve25519.h
@@ -33,7 +33,8 @@ bool __must_check curve25519(u8 mypublic[CURVE25519_KEY_SIZE],
 			     const u8 secret[CURVE25519_KEY_SIZE],
 			     const u8 basepoint[CURVE25519_KEY_SIZE])
 {
-	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_CURVE25519))
+	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_CURVE25519) &&
+	    (!IS_ENABLED(CONFIG_CRYPTO_CURVE25519_X86) || IS_ENABLED(CONFIG_AS_ADX)))
 		curve25519_arch(mypublic, secret, basepoint);
 	else
 		curve25519_generic(mypublic, secret, basepoint);
@@ -49,7 +50,8 @@ __must_check curve25519_generate_public(u8 pub[CURVE25519_KEY_SIZE],
 				    CURVE25519_KEY_SIZE)))
 		return false;
 
-	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_CURVE25519))
+	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_CURVE25519) &&
+	    (!IS_ENABLED(CONFIG_CRYPTO_CURVE25519_X86) || IS_ENABLED(CONFIG_AS_ADX)))
 		curve25519_base_arch(pub, secret);
 	else
 		curve25519_generic(pub, secret, curve25519_base_point);
-- 
2.25.1

