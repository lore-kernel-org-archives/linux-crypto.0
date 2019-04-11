Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F3DC10F13
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA7F72184B
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfDKIvH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 04:51:07 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:41224 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbfDKIvH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 04:51:07 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hEVQH-0003LU-Q6
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 16:51:05 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hEVQH-0006mg-Hc; Thu, 11 Apr 2019 16:51:05 +0800
Subject: [PATCH 9/24] crypto: ccp - Forbid 2-key 3DES in FIPS mode
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1hEVQH-0006mg-Hc@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu, 11 Apr 2019 16:51:05 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch forbids the use of 2-key 3DES (K1 == K3) in FIPS mode.
   
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/ccp/ccp-crypto-des3.c |   21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-des3.c b/drivers/crypto/ccp/ccp-crypto-des3.c
index c2ff551d215b..91482ffcac59 100644
--- a/drivers/crypto/ccp/ccp-crypto-des3.c
+++ b/drivers/crypto/ccp/ccp-crypto-des3.c
@@ -43,24 +43,11 @@ static int ccp_des3_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	struct ccp_crypto_ablkcipher_alg *alg =
 		ccp_crypto_ablkcipher_alg(crypto_ablkcipher_tfm(tfm));
 	u32 *flags = &tfm->base.crt_flags;
+	int err;
 
-
-	/* From des_generic.c:
-	 *
-	 * RFC2451:
-	 *   If the first two or last two independent 64-bit keys are
-	 *   equal (k1 == k2 or k2 == k3), then the DES3 operation is simply the
-	 *   same as DES.  Implementers MUST reject keys that exhibit this
-	 *   property.
-	 */
-	const u32 *K = (const u32 *)key;
-
-	if (unlikely(!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
-		     !((K[2] ^ K[4]) | (K[3] ^ K[5]))) &&
-		     (*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	err = __des3_verify_key(flags, key);
+	if (unlikely(err))
+		return err;
 
 	/* It's not clear that there is any support for a keysize of 112.
 	 * If needed, the caller should make K1 == K3
