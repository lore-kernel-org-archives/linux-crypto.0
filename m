Return-Path: <SRS0=KizA=RR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5FC8C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Mar 2019 09:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C10F2085A
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Mar 2019 09:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfCNJKV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Mar 2019 05:10:21 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:36675 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbfCNJKV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Mar 2019 05:10:21 -0400
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1M2fHt-1h2ynU0CvH-0049NE; Thu, 14 Mar 2019 10:09:55 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ccree - reduce kernel stack usage with clang
Date:   Thu, 14 Mar 2019 10:09:44 +0100
Message-Id: <20190314090951.840339-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:dC2/9ebq8Fl87hFsAGo8uXPuzKOIpvo5VAfANriH0gumyH5BOTy
 z/B8RkJxqYPeuEf2Usa/7AfuMd6ADIfBgjmf6BHXuBg8D7Xz+JcCGlbEdAjfX/pNUSrv5JO
 kSCI+5Z3j7U2zDbIRE15lP+xOYp6wXIm540MO9MUcgC90d2xQtHYMhov0Bs7U3n/yn4uaVj
 MPCytK7jL6ymKPkKwiZhg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:2hnnBTrxZqQ=:4s80T4F2tNNIaYm7AxA+Cv
 aSGxZJQ2YlUVfDbLMo696alA+z6wMIR0X8XmruAKbJctlCTJuW9rWtC+qj2f4xJbbXEUgDneX
 1i305sLyEaqi3uegdTD9wYpj7vCdXW1BaugAW4IK1FhOGpQeLRlOqQQMHk83UogADm4lM/slB
 5Pb6+EbQemIZG7M5rZ2Zwmn+camQ/HTvxuESWHriJMOIVGsrDftysDJW2Vwv7vf18GMlBcrCC
 b8UKk2p2ShHylSNUo8Fu20e1aBEbQLOG49PJ16/zaD/GthYh1AHUsz+RmrGF/P7SsaheOLUVp
 RyA/GbERaeuFeXWuWym7JKXt69gahnCz8CEH/zZX2f1Hp7BKn6KeL+6wcZHfbMtR//N4kgvI/
 +sL+JbfBG1EEhVNLGrCuyKeGtn1zFW1Gj3ArqZZ03ccWszC/phEvoCZR1wKfPzpiacZ+osF1K
 mB8LvHhN4XtdBUwp2WuAViTWAQIMhd/qhDdVQW/2oEEFag82qwMPL1A50k5ze+Q4OFrax+j3v
 m4CSQrN3mfZqw6hIxnUYG6mtUm1Opfgf/mfs9WhPWLEGusoGmKNkfl0wAue6FbA+5MANSszcX
 W8Awiz17WgMRsf4TsjR1SmdwK4U94pkRLOmjMQrCuC6GBSrqf+mIB3HtUEwxp4uJhWo5Hswls
 waFVJDO6SoGYnItivaxnH544Kr0mj7RTc2AU71WcpdR2hjzL6zMi4ivH4WRAfj+fcnDpr72Tg
 aNcTV5dnx0dOUiwSzFr7PGyVZgcACcqCUloIvw==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Building with clang for a 32-bit architecture runs over the stack
frame limit in the setkey function:

drivers/crypto/ccree/cc_cipher.c:318:12: error: stack frame size of 1152 bytes in function 'cc_cipher_setkey' [-Werror,-Wframe-larger-than=]

The problem is that there are two large variables: the temporary
'tmp' array and the SHASH_DESC_ON_STACK() declaration. Moving
the first into the block in which it is used reduces the
total frame size to 768 bytes, which seems more reasonable
and is under the warning limit.

Fixes: 63ee04c8b491 ("crypto: ccree - add skcipher support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/ccree/cc_cipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index d9c17078517b..0abcdc224ab0 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -321,7 +321,6 @@ static int cc_cipher_setkey(struct crypto_skcipher *sktfm, const u8 *key,
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(sktfm);
 	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
-	u32 tmp[DES3_EDE_EXPKEY_WORDS];
 	struct cc_crypto_alg *cc_alg =
 			container_of(tfm->__crt_alg, struct cc_crypto_alg,
 				     skcipher_alg.base);
@@ -347,6 +346,7 @@ static int cc_cipher_setkey(struct crypto_skcipher *sktfm, const u8 *key,
 	 * HW does the expansion on its own.
 	 */
 	if (ctx_p->flow_mode == S_DIN_to_DES) {
+		u32 tmp[DES3_EDE_EXPKEY_WORDS];
 		if (keylen == DES3_EDE_KEY_SIZE &&
 		    __des3_ede_setkey(tmp, &tfm->crt_flags, key,
 				      DES3_EDE_KEY_SIZE)) {
-- 
2.20.0

