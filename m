Return-Path: <SRS0=2CiZ=QS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A996DC282CE
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 11:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 839A92070B
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 11:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfBKLqc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Feb 2019 06:46:32 -0500
Received: from inva020.nxp.com ([92.121.34.13]:46456 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbfBKLqc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Feb 2019 06:46:32 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 2B5201A034B;
        Mon, 11 Feb 2019 12:46:31 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 1F3841A01B7;
        Mon, 11 Feb 2019 12:46:31 +0100 (CET)
Received: from enigma.ea.freescale.net (enigma.ea.freescale.net [10.171.81.110])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id B7E43205FA;
        Mon, 11 Feb 2019 12:46:30 +0100 (CET)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, Leo Li <leoyang.li@nxp.com>,
        Roy Pledge <roy.pledge@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH 3/3] crypto: caam/qi2 - relax busy polling while enqueuing FDs
Date:   Mon, 11 Feb 2019 13:46:14 +0200
Message-Id: <20190211114614.24748-4-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.16.2
In-Reply-To: <20190211114614.24748-1-horia.geanta@nxp.com>
References: <20190211114614.24748-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add cpu_relax() in the loop that tries to enqueue the FDs.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg_qi2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 6a6a508f5fd2..c2c1abc68f81 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -5277,6 +5277,8 @@ int dpaa2_caam_enqueue(struct device *dev, struct caam_request *req)
 						  &fd);
 		if (err != -EBUSY)
 			break;
+
+		cpu_relax();
 	}
 
 	if (unlikely(err)) {
-- 
2.16.2

