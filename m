Return-Path: <SRS0=Egg7=5V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A277C2D0F4
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Apr 2020 11:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 266EA206C3
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Apr 2020 11:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgDELul (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 5 Apr 2020 07:50:41 -0400
Received: from inva021.nxp.com ([92.121.34.21]:38552 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbgDELul (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Apr 2020 07:50:41 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 20CA92008F5;
        Sun,  5 Apr 2020 13:50:39 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 142012008F4;
        Sun,  5 Apr 2020 13:50:39 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id A249120466;
        Sun,  5 Apr 2020 13:50:38 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH 1/4] crypto: caam - fix use-after-free KASAN issue for SKCIPHER algorithms
Date:   Sun,  5 Apr 2020 14:50:08 +0300
Message-Id: <1586087411-8505-2-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1586087411-8505-1-git-send-email-iuliana.prodan@nxp.com>
References: <1586087411-8505-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Here's the KASAN report:
BUG: KASAN: use-after-free in skcipher_crypt_done+0xe8/0x1a8
Read of size 1 at addr ffff00002304001c by task swapper/0/0

CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.6.0-rc1-00162-gfcb90d5 #9
Hardware name: LS1046A RDB Board (DT)
Call trace:
 dump_backtrace+0x0/0x260
 show_stack+0x14/0x20
 dump_stack+0xe8/0x144
 print_address_description.isra.11+0x64/0x348
 __kasan_report+0x11c/0x230
 kasan_report+0xc/0x18
 __asan_load1+0x5c/0x68
 skcipher_crypt_done+0xe8/0x1a8
 caam_jr_dequeue+0x390/0x608
 tasklet_action_common.isra.13+0x1ec/0x230
 ...

Fixes: ee38767f152a ("crypto: caam - support crypto_engine framework for SKCIPHER algorithms")
Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index b7bb7c3..5538539 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1022,8 +1022,6 @@ static void skcipher_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 		     DUMP_PREFIX_ADDRESS, 16, 4, req->dst,
 		     edesc->dst_nents > 1 ? 100 : req->cryptlen, 1);
 
-	kfree(edesc);
-
 	/*
 	 * If no backlog flag, the completion of the request is done
 	 * by CAAM, not crypto engine.
@@ -1032,6 +1030,8 @@ static void skcipher_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 		skcipher_request_complete(req, ecode);
 	else
 		crypto_finalize_skcipher_request(jrp->engine, req, ecode);
+
+	kfree(edesc);
 }
 
 /*
-- 
2.1.0

