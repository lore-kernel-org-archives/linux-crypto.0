Return-Path: <SRS0=Egg7=5V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D09D5C2BA2B
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Apr 2020 11:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B18EA20709
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Apr 2020 11:50:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgDELuv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 5 Apr 2020 07:50:51 -0400
Received: from inva020.nxp.com ([92.121.34.13]:57866 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726754AbgDELut (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Apr 2020 07:50:49 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id CCBC61A08FF;
        Sun,  5 Apr 2020 13:50:47 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C06B71A08FE;
        Sun,  5 Apr 2020 13:50:47 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 5AD8820466;
        Sun,  5 Apr 2020 13:50:47 +0200 (CEST)
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
Subject: [PATCH 4/4] crypto: caam - fix use-after-free KASAN issue for RSA algorithms
Date:   Sun,  5 Apr 2020 14:50:11 +0300
Message-Id: <1586087411-8505-5-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1586087411-8505-1-git-send-email-iuliana.prodan@nxp.com>
References: <1586087411-8505-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Here's the KASAN report:
BUG: KASAN: use-after-free in rsa_pub_done+0x70/0xe8
Read of size 1 at addr ffff00002267b614 by task swapper/0/0

CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.6.0-rc1-00165-ga85dda9-dirty #21
Hardware name: LS1046A RDB Board (DT)
Call trace:
 dump_backtrace+0x0/0x260
 show_stack+0x14/0x20
 dump_stack+0xe8/0x144
 print_address_description.isra.11+0x64/0x348
 __kasan_report+0x11c/0x230
 kasan_report+0xc/0x18
 __asan_load1+0x5c/0x68
 rsa_pub_done+0x70/0xe8
 caam_jr_dequeue+0x390/0x608
 tasklet_action_common.isra.13+0x1ec/0x230
...

Fixes: bf53795025a2 ("crypto: caam - add crypto_engine support for RSA algorithms")
Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/caampkc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 4fcae37..59cc7116 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -129,7 +129,6 @@ static void rsa_pub_done(struct device *dev, u32 *desc, u32 err, void *context)
 
 	rsa_pub_unmap(dev, edesc, req);
 	rsa_io_unmap(dev, edesc, req);
-	kfree(edesc);
 
 	/*
 	 * If no backlog flag, the completion of the request is done
@@ -139,6 +138,8 @@ static void rsa_pub_done(struct device *dev, u32 *desc, u32 err, void *context)
 		akcipher_request_complete(req, ecode);
 	else
 		crypto_finalize_akcipher_request(jrp->engine, req, ecode);
+
+	kfree(edesc);
 }
 
 static void rsa_priv_f_done(struct device *dev, u32 *desc, u32 err,
@@ -170,7 +171,6 @@ static void rsa_priv_f_done(struct device *dev, u32 *desc, u32 err,
 	}
 
 	rsa_io_unmap(dev, edesc, req);
-	kfree(edesc);
 
 	/*
 	 * If no backlog flag, the completion of the request is done
@@ -180,6 +180,8 @@ static void rsa_priv_f_done(struct device *dev, u32 *desc, u32 err,
 		akcipher_request_complete(req, ecode);
 	else
 		crypto_finalize_akcipher_request(jrp->engine, req, ecode);
+
+	kfree(edesc);
 }
 
 /**
-- 
2.1.0

