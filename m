From: Megha Dey <megha.dey@intel.com>
Subject: [PATCH 7/7] crypto: sha1-mb - rename sha-mb to sha1-mb
Date: Thu, 23 Jun 2016 18:40:48 -0700
Message-ID: <1466732448-27856-8-git-send-email-megha.dey@intel.com>
References: <1466732448-27856-1-git-send-email-megha.dey@intel.com>
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	megha.dey@intel.com, fenghua.yu@intel.com,
	Megha Dey <megha.dey@linux.intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1466732448-27856-1-git-send-email-megha.dey@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Megha Dey <megha.dey@linux.intel.com>

Until now, there was only support for the SHA1 multibuffer algorithm.
Hence, there was just one sha-mb folder. Now, with the introduction of
the SHA256 multi-buffer algorithm , it is logical to name the existing
folder as sha1-mb.

Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 arch/x86/crypto/Makefile                                       | 2 +-
 arch/x86/crypto/{sha-mb => sha1-mb}/Makefile                   | 0
 arch/x86/crypto/{sha-mb => sha1-mb}/sha1_mb.c                  | 2 +-
 arch/x86/crypto/{sha-mb/sha_mb_ctx.h => sha1-mb/sha1_mb_ctx.h} | 2 +-
 arch/x86/crypto/{sha-mb/sha_mb_mgr.h => sha1-mb/sha1_mb_mgr.h} | 0
 arch/x86/crypto/{sha-mb => sha1-mb}/sha1_mb_mgr_datastruct.S   | 0
 arch/x86/crypto/{sha-mb => sha1-mb}/sha1_mb_mgr_flush_avx2.S   | 0
 arch/x86/crypto/{sha-mb => sha1-mb}/sha1_mb_mgr_init_avx2.c    | 2 +-
 arch/x86/crypto/{sha-mb => sha1-mb}/sha1_mb_mgr_submit_avx2.S  | 0
 arch/x86/crypto/{sha-mb => sha1-mb}/sha1_x8_avx2.S             | 0
 10 files changed, 4 insertions(+), 4 deletions(-)
 rename arch/x86/crypto/{sha-mb => sha1-mb}/Makefile (100%)
 rename arch/x86/crypto/{sha-mb => sha1-mb}/sha1_mb.c (99%)
 rename arch/x86/crypto/{sha-mb/sha_mb_ctx.h => sha1-mb/sha1_mb_ctx.h} (99%)
 rename arch/x86/crypto/{sha-mb/sha_mb_mgr.h => sha1-mb/sha1_mb_mgr.h} (100%)
 rename arch/x86/crypto/{sha-mb => sha1-mb}/sha1_mb_mgr_datastruct.S (100%)
 rename arch/x86/crypto/{sha-mb => sha1-mb}/sha1_mb_mgr_flush_avx2.S (100%)
 rename arch/x86/crypto/{sha-mb => sha1-mb}/sha1_mb_mgr_init_avx2.c (99%)
 rename arch/x86/crypto/{sha-mb => sha1-mb}/sha1_mb_mgr_submit_avx2.S (100%)
 rename arch/x86/crypto/{sha-mb => sha1-mb}/sha1_x8_avx2.S (100%)

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index aafff22..52c8685 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -49,7 +49,7 @@ endif
 ifeq ($(avx2_supported),yes)
 	obj-$(CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64) += camellia-aesni-avx2.o
 	obj-$(CONFIG_CRYPTO_SERPENT_AVX2_X86_64) += serpent-avx2.o
-	obj-$(CONFIG_CRYPTO_SHA1_MB) += sha-mb/
+	obj-$(CONFIG_CRYPTO_SHA1_MB) += sha1-mb/
 	obj-$(CONFIG_CRYPTO_SHA256_MB) += sha256-mb/
 endif
 
diff --git a/arch/x86/crypto/sha-mb/Makefile b/arch/x86/crypto/sha1-mb/Makefile
similarity index 100%
rename from arch/x86/crypto/sha-mb/Makefile
rename to arch/x86/crypto/sha1-mb/Makefile
diff --git a/arch/x86/crypto/sha-mb/sha1_mb.c b/arch/x86/crypto/sha1-mb/sha1_mb.c
similarity index 99%
rename from arch/x86/crypto/sha-mb/sha1_mb.c
rename to arch/x86/crypto/sha1-mb/sha1_mb.c
index 669cc37..561b286 100644
--- a/arch/x86/crypto/sha-mb/sha1_mb.c
+++ b/arch/x86/crypto/sha1-mb/sha1_mb.c
@@ -67,7 +67,7 @@
 #include <asm/byteorder.h>
 #include <linux/hardirq.h>
 #include <asm/fpu/api.h>
-#include "sha_mb_ctx.h"
+#include "sha1_mb_ctx.h"
 
 #define FLUSH_INTERVAL 1000 /* in usec */
 
diff --git a/arch/x86/crypto/sha-mb/sha_mb_ctx.h b/arch/x86/crypto/sha1-mb/sha1_mb_ctx.h
similarity index 99%
rename from arch/x86/crypto/sha-mb/sha_mb_ctx.h
rename to arch/x86/crypto/sha1-mb/sha1_mb_ctx.h
index e36069d..98a35bc 100644
--- a/arch/x86/crypto/sha-mb/sha_mb_ctx.h
+++ b/arch/x86/crypto/sha1-mb/sha1_mb_ctx.h
@@ -54,7 +54,7 @@
 #ifndef _SHA_MB_CTX_INTERNAL_H
 #define _SHA_MB_CTX_INTERNAL_H
 
-#include "sha_mb_mgr.h"
+#include "sha1_mb_mgr.h"
 
 #define HASH_UPDATE          0x00
 #define HASH_FIRST           0x01
diff --git a/arch/x86/crypto/sha-mb/sha_mb_mgr.h b/arch/x86/crypto/sha1-mb/sha1_mb_mgr.h
similarity index 100%
rename from arch/x86/crypto/sha-mb/sha_mb_mgr.h
rename to arch/x86/crypto/sha1-mb/sha1_mb_mgr.h
diff --git a/arch/x86/crypto/sha-mb/sha1_mb_mgr_datastruct.S b/arch/x86/crypto/sha1-mb/sha1_mb_mgr_datastruct.S
similarity index 100%
rename from arch/x86/crypto/sha-mb/sha1_mb_mgr_datastruct.S
rename to arch/x86/crypto/sha1-mb/sha1_mb_mgr_datastruct.S
diff --git a/arch/x86/crypto/sha-mb/sha1_mb_mgr_flush_avx2.S b/arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S
similarity index 100%
rename from arch/x86/crypto/sha-mb/sha1_mb_mgr_flush_avx2.S
rename to arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S
diff --git a/arch/x86/crypto/sha-mb/sha1_mb_mgr_init_avx2.c b/arch/x86/crypto/sha1-mb/sha1_mb_mgr_init_avx2.c
similarity index 99%
rename from arch/x86/crypto/sha-mb/sha1_mb_mgr_init_avx2.c
rename to arch/x86/crypto/sha1-mb/sha1_mb_mgr_init_avx2.c
index 822acb5..d2add0d 100644
--- a/arch/x86/crypto/sha-mb/sha1_mb_mgr_init_avx2.c
+++ b/arch/x86/crypto/sha1-mb/sha1_mb_mgr_init_avx2.c
@@ -51,7 +51,7 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
-#include "sha_mb_mgr.h"
+#include "sha1_mb_mgr.h"
 
 void sha1_mb_mgr_init_avx2(struct sha1_mb_mgr *state)
 {
diff --git a/arch/x86/crypto/sha-mb/sha1_mb_mgr_submit_avx2.S b/arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.S
similarity index 100%
rename from arch/x86/crypto/sha-mb/sha1_mb_mgr_submit_avx2.S
rename to arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.S
diff --git a/arch/x86/crypto/sha-mb/sha1_x8_avx2.S b/arch/x86/crypto/sha1-mb/sha1_x8_avx2.S
similarity index 100%
rename from arch/x86/crypto/sha-mb/sha1_x8_avx2.S
rename to arch/x86/crypto/sha1-mb/sha1_x8_avx2.S
-- 
1.9.1
