From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: [PATCH 1/3] crypto: ghash-generic - move common definitions to a new header file
Date: Wed, 28 Sep 2016 13:42:09 -0300
Message-ID: <1475080931-7926-2-git-send-email-marcelo.cerri@canonical.com>
References: <1475080931-7926-1-git-send-email-marcelo.cerri@canonical.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        George Wilson <gcwilson@us.ibm.com>,
        Marcelo Cerri <marcelo.cerri@canonical.com>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1475080931-7926-1-git-send-email-marcelo.cerri@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Move common values and types used by ghash-generic to a new header file
so drivers can directly use ghash-generic as a fallback implementation.

Signed-off-by: Marcelo Cerri <marcelo.cerri@canonical.com>
---
 crypto/ghash-generic.c | 13 +------------
 include/crypto/ghash.h | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+), 12 deletions(-)
 create mode 100644 include/crypto/ghash.h

diff --git a/crypto/ghash-generic.c b/crypto/ghash-generic.c
index bac7099..12ad3e3 100644
--- a/crypto/ghash-generic.c
+++ b/crypto/ghash-generic.c
@@ -14,24 +14,13 @@
 
 #include <crypto/algapi.h>
 #include <crypto/gf128mul.h>
+#include <crypto/ghash.h>
 #include <crypto/internal/hash.h>
 #include <linux/crypto.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-#define GHASH_BLOCK_SIZE	16
-#define GHASH_DIGEST_SIZE	16
-
-struct ghash_ctx {
-	struct gf128mul_4k *gf128;
-};
-
-struct ghash_desc_ctx {
-	u8 buffer[GHASH_BLOCK_SIZE];
-	u32 bytes;
-};
-
 static int ghash_init(struct shash_desc *desc)
 {
 	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
diff --git a/include/crypto/ghash.h b/include/crypto/ghash.h
new file mode 100644
index 0000000..2a61c9b
--- /dev/null
+++ b/include/crypto/ghash.h
@@ -0,0 +1,23 @@
+/*
+ * Common values for GHASH algorithms
+ */
+
+#ifndef __CRYPTO_GHASH_H__
+#define __CRYPTO_GHASH_H__
+
+#include <linux/types.h>
+#include <crypto/gf128mul.h>
+
+#define GHASH_BLOCK_SIZE	16
+#define GHASH_DIGEST_SIZE	16
+
+struct ghash_ctx {
+	struct gf128mul_4k *gf128;
+};
+
+struct ghash_desc_ctx {
+	u8 buffer[GHASH_BLOCK_SIZE];
+	u32 bytes;
+};
+
+#endif
-- 
2.7.4
