Received: from mail.nfschina.com (unknown [42.101.60.213])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 4DC701C860A;
	Mon, 21 Apr 2025 08:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=42.101.60.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745224306; cv=none; b=tZgQdomel+cmO4oMhm8fZ/YsKNqEbNk+3eIk4SXodgGXuc3Js2rKLkbJIKBIUkeJRoqLMUXsvSuSUq2q5NQAntm9MZpIb+3Lib6brzFFlSwXTDe48T4tdtlu0HeGKA/Tn+Wf/pb5xUaVMGYhDvoJ+JzOYgolmIh15VcVloT2py0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745224306; c=relaxed/simple;
	bh=USPnlJzzzQKBRxXZbuZz2e+0nUzQcDbQjf6E9cWfZcY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version; b=L2XOC8uqGEgSz7ybAPaL3U7HVPr9aI7UfPrg2s73rsMH47EDWTm2VLBYmUrR7xHI/FjWiT5LWKVCWNKw2qGYKILZqnXeHldnXoOQJCbbuXd5p1TZMfP++BT7YV88j1PDYGniLZQC26bH0vhd0WBJkZ4tUOxKT9Aq3pHv1giRv28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com; spf=pass smtp.mailfrom=nfschina.com; arc=none smtp.client-ip=42.101.60.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nfschina.com
Received: from longsh.shanghai.nfschina.local (unknown [180.167.10.98])
	by mail.nfschina.com (MailData Gateway V2.8.8) with ESMTPSA id CC9C260260748;
	Mon, 21 Apr 2025 16:31:38 +0800 (CST)
X-MD-Sfrom: suhui@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: Su Hui <suhui@nfschina.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	steffen.klassert@secunet.com,
	christophe.jaillet@wanadoo.fr
Cc: Su Hui <suhui@nfschina.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH v2 2/2] crypto: remove some redundant include headers
Date: Mon, 21 Apr 2025 16:31:17 +0800
Message-Id: <20250421083116.1161805-3-suhui@nfschina.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250421083116.1161805-1-suhui@nfschina.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are some redundant headers, the include relation is:

linux/{list,refcount,slab,types}.h <<== linux/crypto.h
linux/container_of.h <<== linux/list.h
linux/atomic.h <<== linux/refcount.h
linux/cached.h <<== linux/slab.h

So it's no need to include
<linux/{list,slab,types,container_of,atomic,cached}.h> when already
included <linux/crypto.h>.
Remove these redundant headers to save some code space. Also remove
<linux/crypto.h> when already included <crypto/aead.h>.

Signed-off-by: Su Hui <suhui@nfschina.com>
---
 include/crypto/acompress.h    | 4 ----
 include/crypto/aead.h         | 4 ----
 include/crypto/aes.h          | 1 -
 include/crypto/akcipher.h     | 1 -
 include/crypto/algapi.h       | 3 ---
 include/crypto/blowfish.h     | 1 -
 include/crypto/cast5.h        | 1 -
 include/crypto/cast6.h        | 1 -
 include/crypto/drbg.h         | 2 --
 include/crypto/hash.h         | 2 --
 include/crypto/internal/des.h | 1 -
 include/crypto/kpp.h          | 3 ---
 include/crypto/krb5.h         | 1 -
 include/crypto/pcrypt.h       | 1 -
 include/crypto/poly1305.h     | 1 -
 include/crypto/polyval.h      | 1 -
 include/crypto/rng.h          | 2 --
 include/crypto/serpent.h      | 1 -
 include/crypto/skcipher.h     | 4 ----
 include/crypto/sm4.h          | 1 -
 20 files changed, 36 deletions(-)

diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index c497c73baf13..ac94fa297b90 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -9,16 +9,12 @@
 #ifndef _CRYPTO_ACOMP_H
 #define _CRYPTO_ACOMP_H
 
-#include <linux/atomic.h>
 #include <linux/args.h>
 #include <linux/compiler_types.h>
-#include <linux/container_of.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
 #include <linux/scatterlist.h>
-#include <linux/slab.h>
 #include <linux/spinlock_types.h>
-#include <linux/types.h>
 
 /* Set this bit if source is virtual address instead of SG list. */
 #define CRYPTO_ACOMP_REQ_SRC_VIRT	0x00000002
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 8df3d112bf6a..77bfebccd735 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -8,11 +8,7 @@
 #ifndef _CRYPTO_AEAD_H
 #define _CRYPTO_AEAD_H
 
-#include <linux/atomic.h>
-#include <linux/container_of.h>
 #include <linux/crypto.h>
-#include <linux/slab.h>
-#include <linux/types.h>
 
 /**
  * DOC: Authenticated Encryption With Associated Data (AEAD) Cipher API
diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index 9339da7c20a8..1d749887851f 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -6,7 +6,6 @@
 #ifndef _CRYPTO_AES_H
 #define _CRYPTO_AES_H
 
-#include <linux/types.h>
 #include <linux/crypto.h>
 
 #define AES_MIN_KEY_SIZE	16
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index 6927664bc3d7..c665773b95af 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -8,7 +8,6 @@
 #ifndef _CRYPTO_AKCIPHER_H
 #define _CRYPTO_AKCIPHER_H
 
-#include <linux/atomic.h>
 #include <linux/crypto.h>
 
 /**
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 6e07bbc04089..8a009d8ce9d6 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -9,10 +9,7 @@
 
 #include <crypto/utils.h>
 #include <linux/align.h>
-#include <linux/cache.h>
 #include <linux/crypto.h>
-#include <linux/list.h>
-#include <linux/types.h>
 #include <linux/workqueue.h>
 
 /*
diff --git a/include/crypto/blowfish.h b/include/crypto/blowfish.h
index 9b384670b356..075713fb8b00 100644
--- a/include/crypto/blowfish.h
+++ b/include/crypto/blowfish.h
@@ -6,7 +6,6 @@
 #ifndef _CRYPTO_BLOWFISH_H
 #define _CRYPTO_BLOWFISH_H
 
-#include <linux/types.h>
 #include <linux/crypto.h>
 
 #define BF_BLOCK_SIZE 8
diff --git a/include/crypto/cast5.h b/include/crypto/cast5.h
index 3d4ed4ea9c3b..36f6801acc73 100644
--- a/include/crypto/cast5.h
+++ b/include/crypto/cast5.h
@@ -2,7 +2,6 @@
 #ifndef _CRYPTO_CAST5_H
 #define _CRYPTO_CAST5_H
 
-#include <linux/types.h>
 #include <linux/crypto.h>
 #include <crypto/cast_common.h>
 
diff --git a/include/crypto/cast6.h b/include/crypto/cast6.h
index 38f490cd50a8..7fd06967b5ae 100644
--- a/include/crypto/cast6.h
+++ b/include/crypto/cast6.h
@@ -2,7 +2,6 @@
 #ifndef _CRYPTO_CAST6_H
 #define _CRYPTO_CAST6_H
 
-#include <linux/types.h>
 #include <linux/crypto.h>
 #include <crypto/cast_common.h>
 
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index af5ad51d3eef..19dfffc04dcb 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -46,12 +46,10 @@
 #include <crypto/skcipher.h>
 #include <linux/module.h>
 #include <linux/crypto.h>
-#include <linux/slab.h>
 #include <crypto/internal/rng.h>
 #include <crypto/rng.h>
 #include <linux/fips.h>
 #include <linux/mutex.h>
-#include <linux/list.h>
 #include <linux/workqueue.h>
 
 /*
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index a67988316d06..6b44a657c58c 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -8,9 +8,7 @@
 #ifndef _CRYPTO_HASH_H
 #define _CRYPTO_HASH_H
 
-#include <linux/atomic.h>
 #include <linux/crypto.h>
-#include <linux/slab.h>
 #include <linux/string.h>
 
 /* Set this bit for virtual address instead of SG list. */
diff --git a/include/crypto/internal/des.h b/include/crypto/internal/des.h
index 723fe5bf16da..0c8266474b7b 100644
--- a/include/crypto/internal/des.h
+++ b/include/crypto/internal/des.h
@@ -6,7 +6,6 @@
 #ifndef __CRYPTO_INTERNAL_DES_H
 #define __CRYPTO_INTERNAL_DES_H
 
-#include <linux/crypto.h>
 #include <linux/fips.h>
 #include <crypto/des.h>
 #include <crypto/aead.h>
diff --git a/include/crypto/kpp.h b/include/crypto/kpp.h
index ad120bbc8b7c..e56abfcf3fd5 100644
--- a/include/crypto/kpp.h
+++ b/include/crypto/kpp.h
@@ -9,10 +9,7 @@
 #ifndef _CRYPTO_KPP_
 #define _CRYPTO_KPP_
 
-#include <linux/atomic.h>
-#include <linux/container_of.h>
 #include <linux/crypto.h>
-#include <linux/slab.h>
 
 /**
  * struct kpp_request
diff --git a/include/crypto/krb5.h b/include/crypto/krb5.h
index 62d998e62f47..213d00f497f2 100644
--- a/include/crypto/krb5.h
+++ b/include/crypto/krb5.h
@@ -8,7 +8,6 @@
 #ifndef _CRYPTO_KRB5_H
 #define _CRYPTO_KRB5_H
 
-#include <linux/crypto.h>
 #include <crypto/aead.h>
 #include <crypto/hash.h>
 
diff --git a/include/crypto/pcrypt.h b/include/crypto/pcrypt.h
index 234d7cf3cf5e..e6d2187540a9 100644
--- a/include/crypto/pcrypt.h
+++ b/include/crypto/pcrypt.h
@@ -9,7 +9,6 @@
 #ifndef _CRYPTO_PCRYPT_H
 #define _CRYPTO_PCRYPT_H
 
-#include <linux/container_of.h>
 #include <linux/crypto.h>
 #include <linux/padata.h>
 
diff --git a/include/crypto/poly1305.h b/include/crypto/poly1305.h
index 090692ec3bc7..4c6cfe69fad7 100644
--- a/include/crypto/poly1305.h
+++ b/include/crypto/poly1305.h
@@ -6,7 +6,6 @@
 #ifndef _CRYPTO_POLY1305_H
 #define _CRYPTO_POLY1305_H
 
-#include <linux/types.h>
 #include <linux/crypto.h>
 
 #define POLY1305_BLOCK_SIZE	16
diff --git a/include/crypto/polyval.h b/include/crypto/polyval.h
index 1d630f371f77..defeab481ca2 100644
--- a/include/crypto/polyval.h
+++ b/include/crypto/polyval.h
@@ -8,7 +8,6 @@
 #ifndef _CRYPTO_POLYVAL_H
 #define _CRYPTO_POLYVAL_H
 
-#include <linux/types.h>
 #include <linux/crypto.h>
 
 #define POLYVAL_BLOCK_SIZE	16
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index 5ac4388f50e1..5883427eb959 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -9,8 +9,6 @@
 #ifndef _CRYPTO_RNG_H
 #define _CRYPTO_RNG_H
 
-#include <linux/atomic.h>
-#include <linux/container_of.h>
 #include <linux/crypto.h>
 
 struct crypto_rng;
diff --git a/include/crypto/serpent.h b/include/crypto/serpent.h
index 75c7eaa20853..a6efaa9b38f8 100644
--- a/include/crypto/serpent.h
+++ b/include/crypto/serpent.h
@@ -6,7 +6,6 @@
 #ifndef _CRYPTO_SERPENT_H
 #define _CRYPTO_SERPENT_H
 
-#include <linux/types.h>
 #include <linux/crypto.h>
 
 #define SERPENT_MIN_KEY_SIZE		  0
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 9e5853464345..5a4fc2759e7f 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -8,12 +8,8 @@
 #ifndef _CRYPTO_SKCIPHER_H
 #define _CRYPTO_SKCIPHER_H
 
-#include <linux/atomic.h>
-#include <linux/container_of.h>
 #include <linux/crypto.h>
-#include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/types.h>
 
 /* Set this bit if the lskcipher operation is a continuation. */
 #define CRYPTO_LSKCIPHER_FLAG_CONT	0x00000001
diff --git a/include/crypto/sm4.h b/include/crypto/sm4.h
index 9656a9a40326..5db1f2637f94 100644
--- a/include/crypto/sm4.h
+++ b/include/crypto/sm4.h
@@ -9,7 +9,6 @@
 #ifndef _CRYPTO_SM4_H
 #define _CRYPTO_SM4_H
 
-#include <linux/types.h>
 #include <linux/crypto.h>
 
 #define SM4_KEY_SIZE	16
-- 
2.30.2

