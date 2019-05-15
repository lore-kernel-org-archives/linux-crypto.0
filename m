Return-Path: <SRS0=YWhG=TP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B3EC04E53
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 13:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77ABA20843
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 13:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbfEONN2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 May 2019 09:13:28 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:37751 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbfEONN2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 May 2019 09:13:28 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <sha@pengutronix.de>)
        id 1hQtio-0003ZP-W7; Wed, 15 May 2019 15:13:26 +0200
Received: from sha by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1hQtin-0005xZ-QQ; Wed, 15 May 2019 15:13:25 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-crypto@vger.kernel.org
Cc:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH] crypto: caam: print debugging hex dumps after unmapping
Date:   Wed, 15 May 2019 15:13:24 +0200
Message-Id: <20190515131324.22793-1-s.hauer@pengutronix.de>
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

The debugging hex dumps in skcipher_encrypt_done() and
skcipher_decrypt_done() are printed while the request is still DMA
mapped. This results in bogus hex dumps with things like mixtures
between plain text and cipher text. Unmap first before printing.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/crypto/caam/caamalg.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 3e23d4b2cce2..a992ff56fd15 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1009,15 +1009,6 @@ static void skcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
-#ifdef DEBUG
-	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, req->iv,
-		       edesc->src_nents > 1 ? 100 : ivsize, 1);
-#endif
-	caam_dump_sg(KERN_ERR, "dst    @" __stringify(__LINE__)": ",
-		     DUMP_PREFIX_ADDRESS, 16, 4, req->dst,
-		     edesc->dst_nents > 1 ? 100 : req->cryptlen, 1);
-
 	skcipher_unmap(jrdev, edesc, req);
 
 	/*
@@ -1028,6 +1019,15 @@ static void skcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 		scatterwalk_map_and_copy(req->iv, req->dst, req->cryptlen -
 					 ivsize, ivsize, 0);
 
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, req->iv,
+		       edesc->src_nents > 1 ? 100 : ivsize, 1);
+#endif
+	caam_dump_sg(KERN_ERR, "dst    @" __stringify(__LINE__)": ",
+		     DUMP_PREFIX_ADDRESS, 16, 4, req->dst,
+		     edesc->dst_nents > 1 ? 100 : req->cryptlen, 1);
+
 	kfree(edesc);
 
 	skcipher_request_complete(req, err);
@@ -1049,6 +1049,8 @@ static void skcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
+	skcipher_unmap(jrdev, edesc, req);
+
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, req->iv, ivsize, 1);
@@ -1057,7 +1059,6 @@ static void skcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 		     DUMP_PREFIX_ADDRESS, 16, 4, req->dst,
 		     edesc->dst_nents > 1 ? 100 : req->cryptlen, 1);
 
-	skcipher_unmap(jrdev, edesc, req);
 	kfree(edesc);
 
 	skcipher_request_complete(req, err);
-- 
2.20.1

