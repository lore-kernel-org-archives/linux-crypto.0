Return-Path: <SRS0=2+RY=QU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E553C282C2
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Feb 2019 14:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA1682081B
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Feb 2019 14:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbfBMOtN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Feb 2019 09:49:13 -0500
Received: from mx1.emlix.com ([46.4.235.150]:56340 "EHLO mx1.emlix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbfBMOtN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Feb 2019 09:49:13 -0500
Received: from mailer.emlix.com (unknown [81.20.119.6])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.emlix.com (Postfix) with ESMTPS id 57A6325F533;
        Wed, 13 Feb 2019 15:49:11 +0100 (CET)
From:   Philipp Puschmann <philipp.puschmann@emlix.com>
To:     horia.geanta@nxp.com
Cc:     aymen.sghaier@nxp.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, o.rempel@pengutronix.de,
        Philipp Puschmann <philipp.puschmann@emlix.com>
Subject: [PATCH] crypto: caam: set hwrng quality level
Date:   Wed, 13 Feb 2019 15:49:07 +0100
Message-Id: <20190213144907.5696-1-philipp.puschmann@emlix.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When quality is set to 0 this driver is not used as randomness source by
HWRNG framework at all. So set the quality and finally make this driver
work. The value of the quality was discussed before
( see https://patchwork.kernel.org/patch/9850669/ ) and it is still a rough
value.

Signed-off-by: Philipp Puschmann <philipp.puschmann@emlix.com>
---
 drivers/crypto/caam/caamrng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index a387c8d49a62..b6fd60f7638e 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -294,6 +294,7 @@ static struct hwrng caam_rng = {
 	.name		= "rng-caam",
 	.cleanup	= caam_cleanup,
 	.read		= caam_read,
+	.quality	= 990,
 };
 
 static void __exit caam_rng_exit(void)
-- 
2.20.1

