Return-Path: <SRS0=Egg7=5V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D755C2BA2B
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Apr 2020 11:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C11E206C3
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Apr 2020 11:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgDELur (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 5 Apr 2020 07:50:47 -0400
Received: from inva021.nxp.com ([92.121.34.21]:38628 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbgDELur (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Apr 2020 07:50:47 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 9D49A200900;
        Sun,  5 Apr 2020 13:50:45 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 90E292008E7;
        Sun,  5 Apr 2020 13:50:45 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 3159920466;
        Sun,  5 Apr 2020 13:50:45 +0200 (CEST)
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
Subject: [PATCH 3/4] crypto: caam - fix use-after-free KASAN issue for HASH algorithms
Date:   Sun,  5 Apr 2020 14:50:10 +0300
Message-Id: <1586087411-8505-4-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1586087411-8505-1-git-send-email-iuliana.prodan@nxp.com>
References: <1586087411-8505-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Here's the KASAN report:
BUG: KASAN: use-after-free in ahash_done+0xdc/0x3b8
Read of size 1 at addr ffff000022e75510 by task swapper/0/0

CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.6.0-rc1-00164-gcb59d59-dirty #20
Hardware name: LS1046A RDB Board (DT)
Call trace:
 dump_backtrace+0x0/0x260
 show_stack+0x14/0x20
 dump_stack+0xe8/0x144
 print_address_description.isra.11+0x64/0x348
 __kasan_report+0x11c/0x230
 kasan_report+0xc/0x18
 __asan_load1+0x5c/0x68
 ahash_done+0xdc/0x3b8
 caam_jr_dequeue+0x390/0x608
 tasklet_action_common.isra.13+0x1ec/0x230

Fixes: 21b014f038d3 ("crypto: caam - add crypto_engine support for HASH algorithms")
Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/caamhash.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 943bc02..3c63fe0 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -593,7 +593,6 @@ static inline void ahash_done_cpy(struct device *jrdev, u32 *desc, u32 err,
 
 	ahash_unmap_ctx(jrdev, edesc, req, digestsize, dir);
 	memcpy(req->result, state->caam_ctx, digestsize);
-	kfree(edesc);
 
 	print_hex_dump_debug("ctx@"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, state->caam_ctx,
@@ -607,6 +606,8 @@ static inline void ahash_done_cpy(struct device *jrdev, u32 *desc, u32 err,
 		req->base.complete(&req->base, ecode);
 	else
 		crypto_finalize_hash_request(jrp->engine, req, ecode);
+
+	kfree(edesc);
 }
 
 static void ahash_done(struct device *jrdev, u32 *desc, u32 err,
@@ -640,7 +641,6 @@ static inline void ahash_done_switch(struct device *jrdev, u32 *desc, u32 err,
 		ecode = caam_jr_strstatus(jrdev, err);
 
 	ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len, dir);
-	kfree(edesc);
 
 	scatterwalk_map_and_copy(state->buf, req->src,
 				 req->nbytes - state->next_buflen,
@@ -668,6 +668,7 @@ static inline void ahash_done_switch(struct device *jrdev, u32 *desc, u32 err,
 	else
 		crypto_finalize_hash_request(jrp->engine, req, ecode);
 
+	kfree(edesc);
 }
 
 static void ahash_done_bi(struct device *jrdev, u32 *desc, u32 err,
-- 
2.1.0

