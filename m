Return-Path: <SRS0=N13L=BB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74DC3C433EA
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jul 2020 12:15:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AB2E20771
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jul 2020 12:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732273AbgGVMPR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jul 2020 08:15:17 -0400
Received: from inva020.nxp.com ([92.121.34.13]:55480 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732245AbgGVMPO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jul 2020 08:15:14 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 657F11A0A7F;
        Wed, 22 Jul 2020 14:15:12 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 58D1A1A0A79;
        Wed, 22 Jul 2020 14:15:12 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 026C4202AC;
        Wed, 22 Jul 2020 14:15:11 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH 4/7] crypto: caam - silence .setkey in case of bad key length
Date:   Wed, 22 Jul 2020 15:14:55 +0300
Message-Id: <20200722121458.8478-5-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200722121458.8478-1-horia.geanta@nxp.com>
References: <20200722121458.8478-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In case of bad key length, driver emits "key size mismatch" messages,
but only for xts(aes) algorithms.

Reduce verbosity by making them visible only when debugging.
This way crypto fuzz testing log cleans up a bit.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c     | 2 +-
 drivers/crypto/caam/caamalg_qi.c  | 2 +-
 drivers/crypto/caam/caamalg_qi2.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index e94e7f27f1d0..91feda5b63f6 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -832,7 +832,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	u32 *desc;
 
 	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
-		dev_err(jrdev, "key size mismatch\n");
+		dev_dbg(jrdev, "key size mismatch\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index efe8f15a4a51..bb1c0106a95c 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -728,7 +728,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	int ret = 0;
 
 	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
-		dev_err(jrdev, "key size mismatch\n");
+		dev_dbg(jrdev, "key size mismatch\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 1e901344db67..700e1d50211f 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -1058,7 +1058,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	u32 *desc;
 
 	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
-		dev_err(dev, "key size mismatch\n");
+		dev_dbg(dev, "key size mismatch\n");
 		return -EINVAL;
 	}
 
-- 
2.17.1

