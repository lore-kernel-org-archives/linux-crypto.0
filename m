From: <Libo.Wang@arm.com>
Subject: [PATCH] crypto: Fix next IV issue for CTS template
Date: Fri, 17 Feb 2017 11:47:42 +0800
Message-ID: <1487303262-5602-1-git-send-email-Libo.Wang@arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Cc: <ard.biesheuvel@linaro.org>, <Ofir.Drang@arm.com>,
        Libo Wang <libo.wang@arm.com>,
        Dennis Chen <dennis.chen@arm.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0081.outbound.protection.outlook.com ([104.47.2.81]:17584
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754684AbdBQDsH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2017 22:48:07 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Libo Wang <Libo Wang@arm.com>

CTS template assumes underlying CBC algorithm will carry out next IV for
further process.But some implementations of CBC algorithm in kernel break
this assumption, for example, some hardware crypto drivers ignore next IV
for performance consider, inthis case, tcry cts(cbc(aes)) test case will
fail. This patch is trying to fix it by getting next IV information ready
before last two blocks processed.

Signed-off-by: Libo Wang <libo.wang@arm.com>
Signed-off-by: Dennis Chen <dennis.chen@arm.com>
---
 crypto/cts.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/crypto/cts.c b/crypto/cts.c
index a1335d6..712164b 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -154,6 +154,7 @@ static int crypto_cts_encrypt(struct skcipher_request *=
req)
        unsigned int nbytes =3D req->cryptlen;
        int cbc_blocks =3D (nbytes + bsize - 1) / bsize - 1;
        unsigned int offset;
+       int ret =3D 0;

        skcipher_request_set_tfm(subreq, ctx->child);

@@ -174,8 +175,17 @@ static int crypto_cts_encrypt(struct skcipher_request =
*req)
        skcipher_request_set_crypt(subreq, req->src, req->dst,
                                   offset, req->iv);

-       return crypto_skcipher_encrypt(subreq) ?:
-              cts_cbc_encrypt(req);
+       /* process CBC blocks */
+       ret =3D crypto_skcipher_encrypt(subreq);
+       /* process last two blocks */
+       if (!ret) {
+               /* Get IVn-1 back */
+               scatterwalk_map_and_copy(req->iv, req->dst, (offset - bsize=
), bsize, 0);
+               /* Continue last two blocks */
+               return cts_cbc_encrypt(req);
+       }
+
+       return ret;
 }

 static int cts_cbc_decrypt(struct skcipher_request *req)
@@ -248,6 +258,8 @@ static int crypto_cts_decrypt(struct skcipher_request *=
req)
        int cbc_blocks =3D (nbytes + bsize - 1) / bsize - 1;
        unsigned int offset;
        u8 *space;
+       int ret =3D 0;
+       u8 iv_next[bsize];

        skcipher_request_set_tfm(subreq, ctx->child);

@@ -277,8 +289,17 @@ static int crypto_cts_decrypt(struct skcipher_request =
*req)
        skcipher_request_set_crypt(subreq, req->src, req->dst,
                                   offset, req->iv);

-       return crypto_skcipher_decrypt(subreq) ?:
-              cts_cbc_decrypt(req);
+       /* process last two blocks */
+       scatterwalk_map_and_copy(iv_next, req->src, (offset - bsize), bsize=
, 0);
+       ret =3D crypto_skcipher_decrypt(subreq);
+       if (!ret) {
+               /* Set Next IV */
+               subreq->iv =3D iv_next;
+               /* process last two blocks */
+               return cts_cbc_decrypt(req);
+       }
+
+       return ret;
 }

 static int crypto_cts_init_tfm(struct crypto_skcipher *tfm)
