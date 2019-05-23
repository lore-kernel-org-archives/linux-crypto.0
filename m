Return-Path: <SRS0=BTb3=TX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B53C04AAC
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 08:50:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 442B220675
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 08:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfEWIuq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 May 2019 04:50:46 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54601 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbfEWIuq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 May 2019 04:50:46 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <sha@pengutronix.de>)
        id 1hTjQq-0002ww-Rp; Thu, 23 May 2019 10:50:36 +0200
Received: from sha by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1hTjQq-0001fI-5b; Thu, 23 May 2019 10:50:36 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-crypto@vger.kernel.org
Cc:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 1/4] crypto: caam: print IV only when non NULL
Date:   Thu, 23 May 2019 10:50:27 +0200
Message-Id: <20190523085030.4969-2-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190523085030.4969-1-s.hauer@pengutronix.de>
References: <20190523085030.4969-1-s.hauer@pengutronix.de>
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

Since eaed71a44ad9 ("crypto: caam - add ecb(*) support") the IV can be
NULL, so only dump it when it's non NULL as designated by the ivsize
variable.

Fixes: eaed71a44ad9 ("crypto: caam - add ecb(*) support")
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/crypto/caam/caamalg.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index c0ece44f303b..bffff5415c74 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1011,9 +1011,10 @@ static void skcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 		caam_jr_strstatus(jrdev, err);
 
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, req->iv,
-		       edesc->src_nents > 1 ? 100 : ivsize, 1);
+	if (ivsize)
+		print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
+			       DUMP_PREFIX_ADDRESS, 16, 4, req->iv,
+			       edesc->src_nents > 1 ? 100 : ivsize, 1);
 #endif
 	caam_dump_sg(KERN_ERR, "dst    @" __stringify(__LINE__)": ",
 		     DUMP_PREFIX_ADDRESS, 16, 4, req->dst,
-- 
2.20.1

