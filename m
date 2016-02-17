From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: fix compile errors of XTS
Date: Wed, 17 Feb 2016 07:00:01 +0100
Message-ID: <17540790.vcykgraQyO@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	Linux-Next <linux-next@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	kbuild test robot <fengguang.wu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Commit 28856a9e52c7 missed the addition of the crypto/xts.h include file
for different architecture-specific AES implementations.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 arch/arm/crypto/aes-ce-glue.c      | 1 +
 arch/arm/crypto/aesbs-glue.c       | 1 +
 arch/arm64/crypto/aes-glue.c       | 1 +
 arch/powerpc/crypto/aes-spe-glue.c | 1 +
 arch/s390/crypto/aes_s390.c        | 1 +
 5 files changed, 5 insertions(+)

diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index 85ff69b..b6961a2 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -15,6 +15,7 @@
 #include <crypto/ablk_helper.h>
 #include <crypto/algapi.h>
 #include <linux/module.h>
+#include <crypto/xts.h>
 
 MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
diff --git a/arch/arm/crypto/aesbs-glue.c b/arch/arm/crypto/aesbs-glue.c
index d004bd1..0511a6c 100644
--- a/arch/arm/crypto/aesbs-glue.c
+++ b/arch/arm/crypto/aesbs-glue.c
@@ -13,6 +13,7 @@
 #include <crypto/ablk_helper.h>
 #include <crypto/algapi.h>
 #include <linux/module.h>
+#include <crypto/xts.h>
 
 #include "aes_glue.h"
 
diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index c963d75..897ad14 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -15,6 +15,7 @@
 #include <crypto/algapi.h>
 #include <linux/module.h>
 #include <linux/cpufeature.h>
+#include <crypto/xts.h>
 
 #include "aes-ce-setkey.h"
 
diff --git a/arch/powerpc/crypto/aes-spe-glue.c b/arch/powerpc/crypto/aes-spe-glue.c
index 1608079..ab11319 100644
--- a/arch/powerpc/crypto/aes-spe-glue.c
+++ b/arch/powerpc/crypto/aes-spe-glue.c
@@ -22,6 +22,7 @@
 #include <asm/byteorder.h>
 #include <asm/switch_to.h>
 #include <crypto/algapi.h>
+#include <crypto/xts.h>
 
 /*
  * MAX_BYTES defines the number of bytes that are allowed to be processed
diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 3f1a1a4..48e1a2d 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -27,6 +27,7 @@
 #include <linux/cpufeature.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
+#include <crypto/xts.h>
 #include "crypt_s390.h"
 
 #define AES_KEYLEN_128		1
-- 
2.5.0
