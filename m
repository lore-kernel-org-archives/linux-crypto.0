From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v5 1/9] crypto: shrink hash down to two types
Date: Thu,  2 Jun 2016 13:28:55 +0100
Message-ID: <1464870543-5988-2-git-send-email-giovanni.cabiddu@intel.com>
References: <1464870543-5988-1-git-send-email-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:64179 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbcFBM3K (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jun 2016 08:29:10 -0400
In-Reply-To: <1464870543-5988-1-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Move hash to 0xe to free up the space for acomp/scomp

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 include/linux/crypto.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 6e28c89..d844cbc 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -48,15 +48,15 @@
 #define CRYPTO_ALG_TYPE_BLKCIPHER	0x00000004
 #define CRYPTO_ALG_TYPE_ABLKCIPHER	0x00000005
 #define CRYPTO_ALG_TYPE_GIVCIPHER	0x00000006
-#define CRYPTO_ALG_TYPE_DIGEST		0x00000008
-#define CRYPTO_ALG_TYPE_HASH		0x00000008
-#define CRYPTO_ALG_TYPE_SHASH		0x00000009
-#define CRYPTO_ALG_TYPE_AHASH		0x0000000a
 #define CRYPTO_ALG_TYPE_RNG		0x0000000c
 #define CRYPTO_ALG_TYPE_AKCIPHER	0x0000000d
+#define CRYPTO_ALG_TYPE_DIGEST		0x0000000e
+#define CRYPTO_ALG_TYPE_HASH		0x0000000e
+#define CRYPTO_ALG_TYPE_SHASH		0x0000000e
+#define CRYPTO_ALG_TYPE_AHASH		0x0000000f
 
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
-#define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000c
+#define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000e
 #define CRYPTO_ALG_TYPE_BLKCIPHER_MASK	0x0000000c
 
 #define CRYPTO_ALG_LARVAL		0x00000010
-- 
1.7.4.1
