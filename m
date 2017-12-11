From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] crypto: chacha20poly1305 - validate the digest size
Date: Mon, 11 Dec 2017 12:15:17 -0800
Message-ID: <20171211201517.46407-1-ebiggers3@gmail.com>
References: <94eb2c05a380bd8f2a055ffc6de5@google.com>
Cc: Martin Willi <martin@strongswan.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        davem@davemloft.net, Eric Biggers <ebiggers@google.com>,
        stable@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:35622 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750886AbdLKURJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Dec 2017 15:17:09 -0500
In-Reply-To: <94eb2c05a380bd8f2a055ffc6de5@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

If the rfc7539 template was instantiated with a hash algorithm with
digest size larger than 16 bytes (POLY1305_DIGEST_SIZE), then the digest
overran the 'tag' buffer in 'struct chachapoly_req_ctx', corrupting the
subsequent memory, including 'cryptlen'.  This caused a crash during
crypto_skcipher_decrypt().

Fix it by, when instantiating the template, requiring that the
underlying hash algorithm has the digest size expected for Poly1305.

Reproducer:

    #include <linux/if_alg.h>
    #include <sys/socket.h>
    #include <unistd.h>

    int main()
    {
            int algfd, reqfd;
            struct sockaddr_alg addr = {
                    .salg_type = "aead",
                    .salg_name = "rfc7539(chacha20,sha256)",
            };
            unsigned char buf[32] = { 0 };

            algfd = socket(AF_ALG, SOCK_SEQPACKET, 0);
            bind(algfd, (void *)&addr, sizeof(addr));
            setsockopt(algfd, SOL_ALG, ALG_SET_KEY, buf, sizeof(buf));
            reqfd = accept(algfd, 0, 0);
            write(reqfd, buf, 16);
            read(reqfd, buf, 16);
    }

Reported-by: syzbot <syzkaller@googlegroups.com>
Fixes: 71ebc4d1b27d ("crypto: chacha20poly1305 - Add a ChaCha20-Poly1305 AEAD construction, RFC7539")
Cc: <stable@vger.kernel.org> # v4.2+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/chacha20poly1305.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index db1bc3147bc4..600afa99941f 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -610,6 +610,11 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 						    algt->mask));
 	if (IS_ERR(poly))
 		return PTR_ERR(poly);
+	poly_hash = __crypto_hash_alg_common(poly);
+
+	err = -EINVAL;
+	if (poly_hash->digestsize != POLY1305_DIGEST_SIZE)
+		goto out_put_poly;
 
 	err = -ENOMEM;
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
@@ -618,7 +623,6 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 
 	ctx = aead_instance_ctx(inst);
 	ctx->saltlen = CHACHAPOLY_IV_SIZE - ivsize;
-	poly_hash = __crypto_hash_alg_common(poly);
 	err = crypto_init_ahash_spawn(&ctx->poly, poly_hash,
 				      aead_crypto_instance(inst));
 	if (err)
-- 
2.15.1.424.g9478a66081-goog
