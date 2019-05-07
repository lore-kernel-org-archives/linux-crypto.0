Return-Path: <SRS0=09OG=TH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82494C004C9
	for <linux-crypto@archiver.kernel.org>; Tue,  7 May 2019 13:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F6362053B
	for <linux-crypto@archiver.kernel.org>; Tue,  7 May 2019 13:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfEGNhN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 May 2019 09:37:13 -0400
Received: from inva020.nxp.com ([92.121.34.13]:45300 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbfEGNhN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 May 2019 09:37:13 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 8C0C01A01B0;
        Tue,  7 May 2019 15:37:11 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7FD101A00A4;
        Tue,  7 May 2019 15:37:11 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 2431620601;
        Tue,  7 May 2019 15:37:11 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH] crypto: caam: fix caam_dump_sg that iterates through scatterlist
Date:   Tue,  7 May 2019 16:37:03 +0300
Message-Id: <1557236223-31492-1-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix caam_dump_sg by correctly determining the next scatterlist
entry in the list.

Fixes: 5ecf8ef9103c ("crypto: caam - fix sg dump")
Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 21a70fd..7c9fb63 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -22,7 +22,7 @@ void caam_dump_sg(const char *level, const char *prefix_str, int prefix_type,
 	size_t len;
 	void *buf;
 
-	for (it = sg; it && tlen > 0 ; it = sg_next(sg)) {
+	for (it = sg; it && tlen > 0 ; it = sg_next(it)) {
 		/*
 		 * make sure the scatterlist's page
 		 * has a valid virtual memory mapping
-- 
2.1.0

