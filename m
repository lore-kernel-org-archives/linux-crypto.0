Return-Path: <SRS0=p+N9=OH=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-oi1-f195.google.com ([209.85.167.195]:38952 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbeK2Gjq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Nov 2018 01:39:46 -0500
MIME-Version: 1.0
From: David CARLIER <devnexen@gmail.com>
Date: Wed, 28 Nov 2018 19:36:50 +0000
Message-ID: <CA+XhMqz7ZaGVNpkrRM-t4h2f9UZVQPjLVB5Txco4bKGRm8k=mA@mail.gmail.com>
Subject: [PATCH] crypto: use memzero_explicit instead of memset to clear contexts.
To: linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There might be a little performance drop but to make sure it stands
by it comments, we really wipe the whole context after usage.
---
 crypto/chacha20poly1305.c | 3 ++-
 crypto/md5.c              | 2 +-
 crypto/rmd128.c           | 3 ++-
 crypto/rmd160.c           | 3 ++-
 crypto/rmd256.c           | 3 ++-
 crypto/rmd320.c           | 3 ++-
 crypto/sha3_generic.c     | 3 ++-
 7 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index 600afa99941f..6e93d998109e 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/string.h>

 #include "internal.h"

@@ -388,7 +389,7 @@ static int poly_genkey(struct aead_request *req)
        }

        sg_init_table(creq->src, 1);
-       memset(rctx->key, 0, sizeof(rctx->key));
+       memzero_explicit(rctx->key, sizeof(rctx->key));
        sg_set_buf(creq->src, rctx->key, sizeof(rctx->key));

        chacha_iv(creq->iv, req, 0);
diff --git a/crypto/md5.c b/crypto/md5.c
index 94dd78144ba3..00d384e8784c 100644
--- a/crypto/md5.c
+++ b/crypto/md5.c
@@ -197,7 +197,7 @@ static int md5_final(struct shash_desc *desc, u8 *out)
        md5_transform(mctx->hash, mctx->block);
        cpu_to_le32_array(mctx->hash, sizeof(mctx->hash) / sizeof(u32));
        memcpy(out, mctx->hash, sizeof(mctx->hash));
-       memset(mctx, 0, sizeof(*mctx));
+       memzero_explicit(mctx, sizeof(*mctx));

        return 0;
 }
diff --git a/crypto/rmd128.c b/crypto/rmd128.c
index 5f4472256e27..5e01cd7130c7 100644
--- a/crypto/rmd128.c
+++ b/crypto/rmd128.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/string.h>
 #include <linux/types.h>
 #include <asm/byteorder.h>

@@ -290,7 +291,7 @@ static int rmd128_final(struct shash_desc *desc, u8 *out)
                dst[i] = cpu_to_le32p(&rctx->state[i]);

        /* Wipe context */
-       memset(rctx, 0, sizeof(*rctx));
+       memzero_explicit(rctx, sizeof(*rctx));

        return 0;
 }
diff --git a/crypto/rmd160.c b/crypto/rmd160.c
index 737645344d1c..2381d134443c 100644
--- a/crypto/rmd160.c
+++ b/crypto/rmd160.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/string.h>
 #include <linux/types.h>
 #include <asm/byteorder.h>

@@ -334,7 +335,7 @@ static int rmd160_final(struct shash_desc *desc, u8 *out)
                dst[i] = cpu_to_le32p(&rctx->state[i]);

        /* Wipe context */
-       memset(rctx, 0, sizeof(*rctx));
+       memzero_explicit(rctx, sizeof(*rctx));

        return 0;
 }
diff --git a/crypto/rmd256.c b/crypto/rmd256.c
index 0e9d30676a01..3db0f6653607 100644
--- a/crypto/rmd256.c
+++ b/crypto/rmd256.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/string.h>
 #include <linux/types.h>
 #include <asm/byteorder.h>

@@ -309,7 +310,7 @@ static int rmd256_final(struct shash_desc *desc, u8 *out)
                dst[i] = cpu_to_le32p(&rctx->state[i]);

        /* Wipe context */
-       memset(rctx, 0, sizeof(*rctx));
+       memzero_explicit(rctx, sizeof(*rctx));

        return 0;
 }
diff --git a/crypto/rmd320.c b/crypto/rmd320.c
index 3ae1df5bb48c..e0e1a71d0144 100644
--- a/crypto/rmd320.c
+++ b/crypto/rmd320.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/string.h>
 #include <linux/types.h>
 #include <asm/byteorder.h>

@@ -358,7 +359,7 @@ static int rmd320_final(struct shash_desc *desc, u8 *out)
                dst[i] = cpu_to_le32p(&rctx->state[i]);

        /* Wipe context */
-       memset(rctx, 0, sizeof(*rctx));
+       memzero_explicit(rctx, sizeof(*rctx));

        return 0;
 }
diff --git a/crypto/sha3_generic.c b/crypto/sha3_generic.c
index 7ed98367d4fb..ae30a035d371 100644
--- a/crypto/sha3_generic.c
+++ b/crypto/sha3_generic.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/string.h>
 #include <crypto/sha3.h>
 #include <asm/unaligned.h>

@@ -237,7 +238,7 @@ int crypto_sha3_final(struct shash_desc *desc, u8 *out)
        if (digest_size & 4)
                put_unaligned_le32(sctx->st[i], (__le32 *)digest);

-       memset(sctx, 0, sizeof(*sctx));
+       memzero_explicit(sctx, sizeof(*sctx));
        return 0;
 }
 EXPORT_SYMBOL(crypto_sha3_final);
