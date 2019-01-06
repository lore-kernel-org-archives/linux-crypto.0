Return-Path: <SRS0=Z4qA=PO=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbfAFUtY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Jan 2019 15:49:24 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/2] crypto: adiantum - initialize crypto_spawn::inst
Date: Sun,  6 Jan 2019 12:46:05 -0800
Message-Id: <20190106204606.11412-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

crypto_grab_*() doesn't set crypto_spawn::inst, so templates must set it
beforehand.  Otherwise it will be left NULL, which causes a crash in
certain cases where algorithms are dynamically loaded/unloaded.  E.g.
with CONFIG_CRYPTO_CHACHA20_X86_64=m, the following caused a crash:

    insmod chacha-x86_64.ko
    python -c 'import socket; socket.socket(socket.AF_ALG, 5, 0).bind(("skcipher", "adiantum(xchacha12,aes)"))'
    rmmod chacha-x86_64.ko
    python -c 'import socket; socket.socket(socket.AF_ALG, 5, 0).bind(("skcipher", "adiantum(xchacha12,aes)"))'

Fixes: 059c2a4d8e16 ("crypto: adiantum - add Adiantum support")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/adiantum.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index 6651e713c45d6..5564e73266a6a 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -539,6 +539,8 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	ictx = skcipher_instance_ctx(inst);
 
 	/* Stream cipher, e.g. "xchacha12" */
+	crypto_set_skcipher_spawn(&ictx->streamcipher_spawn,
+				  skcipher_crypto_instance(inst));
 	err = crypto_grab_skcipher(&ictx->streamcipher_spawn, streamcipher_name,
 				   0, crypto_requires_sync(algt->type,
 							   algt->mask));
@@ -547,6 +549,8 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	streamcipher_alg = crypto_spawn_skcipher_alg(&ictx->streamcipher_spawn);
 
 	/* Block cipher, e.g. "aes" */
+	crypto_set_spawn(&ictx->blockcipher_spawn,
+			 skcipher_crypto_instance(inst));
 	err = crypto_grab_spawn(&ictx->blockcipher_spawn, blockcipher_name,
 				CRYPTO_ALG_TYPE_CIPHER, CRYPTO_ALG_TYPE_MASK);
 	if (err)
-- 
2.20.1
