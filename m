Return-Path: <SRS0=09LE=QH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB8ECC169C4
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Jan 2019 06:12:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9227B20870
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Jan 2019 06:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbfAaGMa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Jan 2019 01:12:30 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:35499 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbfAaGM3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Jan 2019 01:12:29 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <sha@pengutronix.de>)
        id 1gp5aN-00062B-GQ; Thu, 31 Jan 2019 07:12:27 +0100
Received: from sha by dude.hi.pengutronix.de with local (Exim 4.92-RC4)
        (envelope-from <sha@pengutronix.de>)
        id 1gp5aM-00043o-Qg; Thu, 31 Jan 2019 07:12:26 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-crypto@vger.kernel.org
Cc:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        kernel@pengutronix.de, stable@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH] crypto: caam - Do not overwrite IV
Date:   Thu, 31 Jan 2019 07:12:25 +0100
Message-Id: <20190131061225.15541-1-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In skcipher_decrypt() the IV passed in by the caller is overwritten and
the tcrypt module fails with:

alg: aead: decryption failed on test 1 for gcm_base(ctr-aes-caam,ghash-generic): ret=74
alg: aead: Failed to load transform for gcm(aes): -2

With this patch tcrypt runs without errors.

Fixes: 115957bb3e59 ("crypto: caam - fix IV DMA mapping and updating")

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/crypto/caam/caamalg.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 80ae69f906fb..493fa4169382 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1735,7 +1735,6 @@ static int skcipher_decrypt(struct skcipher_request *req)
 	struct skcipher_edesc *edesc;
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
-	int ivsize = crypto_skcipher_ivsize(skcipher);
 	struct device *jrdev = ctx->jrdev;
 	u32 *desc;
 	int ret = 0;
@@ -1745,13 +1744,6 @@ static int skcipher_decrypt(struct skcipher_request *req)
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
-	/*
-	 * The crypto API expects us to set the IV (req->iv) to the last
-	 * ciphertext block.
-	 */
-	scatterwalk_map_and_copy(req->iv, req->src, req->cryptlen - ivsize,
-				 ivsize, 0);
-
 	/* Create and submit job descriptor*/
 	init_skcipher_job(req, edesc, false);
 	desc = edesc->hw_desc;
-- 
2.20.1

