Return-Path: <SRS0=KYaN=WN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9967AC3A59E
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Aug 2019 14:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 701E420880
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Aug 2019 14:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbfHQOY5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Aug 2019 10:24:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42116 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbfHQOY4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Aug 2019 10:24:56 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DD7A08D5BAA;
        Sat, 17 Aug 2019 14:24:55 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-22.ams2.redhat.com [10.36.116.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CB434E;
        Sat, 17 Aug 2019 14:24:52 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/7] crypto: sha256 - Make lib/crypto/sha256.c suitable for generic use
Date:   Sat, 17 Aug 2019 16:24:33 +0200
Message-Id: <20190817142435.8532-6-hdegoede@redhat.com>
In-Reply-To: <20190817142435.8532-1-hdegoede@redhat.com>
References: <20190817142435.8532-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Sat, 17 Aug 2019 14:24:56 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Before this commit lib/crypto/sha256.c has only been used in the s390 and
x86 purgatory code, make it suitable for generic use:

* Export interesting symbols
* Add  -D__DISABLE_EXPORTS to CFLAGS_sha256.o for purgatory builds to
  avoid the exports for the purgatory builds
* Add to lib/crypto/Makefile and crypto/Kconfig

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
- Add a comment to include/crypto/sha256.h explaining that these functions
  now may be used outside of the purgatory too (and that using the crypto
  API instead is preferred)
---
 arch/s390/purgatory/Makefile | 2 ++
 arch/x86/purgatory/Makefile  | 2 ++
 crypto/Kconfig               | 3 +++
 include/crypto/sha256.h      | 5 +++--
 lib/crypto/Makefile          | 3 +++
 lib/crypto/sha256.c          | 4 ++++
 6 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/s390/purgatory/Makefile b/arch/s390/purgatory/Makefile
index 85b05c9e40f5..bc0d7a0d0394 100644
--- a/arch/s390/purgatory/Makefile
+++ b/arch/s390/purgatory/Makefile
@@ -10,6 +10,8 @@ PURGATORY_OBJS = $(addprefix $(obj)/,$(purgatory-y))
 $(obj)/sha256.o: $(srctree)/lib/crypto/sha256.c FORCE
 	$(call if_changed_rule,cc_o_c)
 
+CFLAGS_sha256.o := -D__DISABLE_EXPORTS
+
 $(obj)/mem.o: $(srctree)/arch/s390/lib/mem.S FORCE
 	$(call if_changed_rule,as_o_S)
 
diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 6ebd0739106e..a455083512c1 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -12,6 +12,8 @@ $(obj)/string.o: $(srctree)/arch/x86/boot/compressed/string.c FORCE
 $(obj)/sha256.o: $(srctree)/lib/crypto/sha256.c FORCE
 	$(call if_changed_rule,cc_o_c)
 
+CFLAGS_sha256.o := -D__DISABLE_EXPORTS
+
 LDFLAGS_purgatory.ro := -e purgatory_start -r --no-undefined -nostdlib -z nodefaultlib
 targets += purgatory.ro
 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index e801450bcb1c..3dc3f13dfcad 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -929,6 +929,9 @@ config CRYPTO_SHA1_PPC_SPE
 	  SHA-1 secure hash standard (DFIPS 180-4) implemented
 	  using powerpc SPE SIMD instruction set.
 
+config CRYPTO_LIB_SHA256
+	tristate
+
 config CRYPTO_SHA256
 	tristate "SHA224 and SHA256 digest algorithm"
 	select CRYPTO_HASH
diff --git a/include/crypto/sha256.h b/include/crypto/sha256.h
index b1f9c6781082..9cbb3589b8b3 100644
--- a/include/crypto/sha256.h
+++ b/include/crypto/sha256.h
@@ -14,8 +14,9 @@
 /*
  * Stand-alone implementation of the SHA256 algorithm. It is designed to
  * have as little dependencies as possible so it can be used in the
- * kexec_file purgatory. In other cases you should use the implementation in
- * crypto/.
+ * kexec_file purgatory. In other cases you should generally use the
+ * hash APIs from include/crypto/hash.h. Especially when hashing large
+ * amounts of data as those APIs may be hw-accelerated.
  *
  * For details see lib/crypto/sha256.c
  */
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 42a91c62d96d..5423482c1efd 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -5,3 +5,6 @@ libaes-y := aes.o
 
 obj-$(CONFIG_CRYPTO_LIB_ARC4) += libarc4.o
 libarc4-y := arc4.o
+
+obj-$(CONFIG_CRYPTO_LIB_SHA256) += libsha256.o
+libsha256-y := sha256.o
diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index 1458a20d53a5..f2ed75ae6910 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/bitops.h>
+#include <linux/export.h>
 #include <linux/string.h>
 #include <crypto/sha256.h>
 #include <asm/unaligned.h>
@@ -218,6 +219,7 @@ int sha256_init(struct sha256_state *sctx)
 
 	return 0;
 }
+EXPORT_SYMBOL(sha256_init);
 
 int sha256_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
 {
@@ -248,6 +250,7 @@ int sha256_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
 
 	return 0;
 }
+EXPORT_SYMBOL(sha256_update);
 
 int sha256_final(struct sha256_state *sctx, u8 *out)
 {
@@ -277,3 +280,4 @@ int sha256_final(struct sha256_state *sctx, u8 *out)
 
 	return 0;
 }
+EXPORT_SYMBOL(sha256_final);
-- 
2.23.0.rc2

