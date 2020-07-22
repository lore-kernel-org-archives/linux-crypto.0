Return-Path: <SRS0=N13L=BB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7914C433F7
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jul 2020 12:15:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DD4820787
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jul 2020 12:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732279AbgGVMPR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jul 2020 08:15:17 -0400
Received: from inva021.nxp.com ([92.121.34.21]:51484 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732246AbgGVMPO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jul 2020 08:15:14 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id CCC3F200903;
        Wed, 22 Jul 2020 14:15:12 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id CA4A2200926;
        Wed, 22 Jul 2020 14:15:12 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 67AC1202AC;
        Wed, 22 Jul 2020 14:15:12 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH 5/7] crypto: caam/jr - remove incorrect reference to caam_jr_register()
Date:   Wed, 22 Jul 2020 15:14:56 +0300
Message-Id: <20200722121458.8478-6-horia.geanta@nxp.com>
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

From: Dan Douglass <dan.douglass@nxp.com>

caam_jr_register() function is no longer part of the driver since
commit 6dad41158db6 ("crypto: caam - Remove unused functions from Job Ring")

This patch removes a comment referencing the function.

Signed-off-by: Dan Douglass <dan.douglass@nxp.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/jr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 4af22e7ceb4f..bf6b03b17251 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -339,8 +339,7 @@ EXPORT_SYMBOL(caam_jr_free);
  * caam_jr_enqueue() - Enqueue a job descriptor head. Returns -EINPROGRESS
  * if OK, -ENOSPC if the queue is full, -EIO if it cannot map the caller's
  * descriptor.
- * @dev:  device of the job ring to be used. This device should have
- *        been assigned prior by caam_jr_register().
+ * @dev:  struct device of the job ring to be used
  * @desc: points to a job descriptor that execute our request. All
  *        descriptors (and all referenced data) must be in a DMAable
  *        region, and all data references must be physical addresses
-- 
2.17.1

