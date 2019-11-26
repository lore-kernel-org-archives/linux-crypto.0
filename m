Return-Path: <SRS0=6oT7=ZS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D3D9C432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Nov 2019 22:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEFE72068E
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Nov 2019 22:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfKZWyt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Nov 2019 17:54:49 -0500
Received: from inva021.nxp.com ([92.121.34.21]:36506 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbfKZWyt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Nov 2019 17:54:49 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 2E30720092F;
        Tue, 26 Nov 2019 23:54:47 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 20BF6200645;
        Tue, 26 Nov 2019 23:54:47 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 8221B20507;
        Tue, 26 Nov 2019 23:54:46 +0100 (CET)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Alison Wang <alison.wang@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH v3] crypto: caam - do not reset pointer size from MCFGR register
Date:   Wed, 27 Nov 2019 00:54:26 +0200
Message-Id: <1574808866-16764-1-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In commit 'a1cf573ee95 ("crypto: caam - select DMA address size at runtime")'
CAAM pointer size (caam_ptr_size) is changed from
sizeof(dma_addr_t) to runtime value computed from MCFGR register.
Therefore, do not reset MCFGR[PS].

Fixes: a1cf573ee95 ("crypto: caam - select DMA address size at runtime")
Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: <stable@vger.kernel.org>
Cc: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Alison Wang <alison.wang@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
---
Changes since v2:
- update description so the referred commit is not split on 2 lines;
- added Reviewed-by.

 drivers/crypto/caam/ctrl.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index d7c3c38..3e811fc 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -671,11 +671,9 @@ static int caam_probe(struct platform_device *pdev)
 	of_node_put(np);
 
 	if (!ctrlpriv->mc_en)
-		clrsetbits_32(&ctrl->mcr, MCFGR_AWCACHE_MASK | MCFGR_LONG_PTR,
+		clrsetbits_32(&ctrl->mcr, MCFGR_AWCACHE_MASK,
 			      MCFGR_AWCACHE_CACH | MCFGR_AWCACHE_BUFF |
-			      MCFGR_WDENABLE | MCFGR_LARGE_BURST |
-			      (sizeof(dma_addr_t) == sizeof(u64) ?
-			       MCFGR_LONG_PTR : 0));
+			      MCFGR_WDENABLE | MCFGR_LARGE_BURST);
 
 	handle_imx6_err005766(&ctrl->mcr);
 
-- 
2.1.0

