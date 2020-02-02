Return-Path: <SRS0=2eH/=3W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 507A6C35249
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Feb 2020 16:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DB4520643
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Feb 2020 16:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgBBQTg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 2 Feb 2020 11:19:36 -0500
Received: from foss.arm.com ([217.140.110.172]:46828 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgBBQTg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Feb 2020 11:19:36 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B9768FEC;
        Sun,  2 Feb 2020 08:19:25 -0800 (PST)
Received: from localhost.localdomain (unknown [10.50.4.146])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 30C793F6CF;
        Sun,  2 Feb 2020 08:19:24 -0800 (PST)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ccree - dec auth tag size from cryptlen map
Date:   Sun,  2 Feb 2020 18:19:14 +0200
Message-Id: <20200202161914.9551-1-gilad@benyossef.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove the auth tag size from cryptlen before mapping the destination
in out-of-place AEAD decryption thus resolving a crash with
extended testmgr tests.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: stable@vger.kernel.org # v4.19+
---
 drivers/crypto/ccree/cc_buffer_mgr.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index 885347b5b372..954f14bddf1d 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -894,8 +894,12 @@ static int cc_aead_chain_data(struct cc_drvdata *drvdata,
 
 	if (req->src != req->dst) {
 		size_for_map = areq_ctx->assoclen + req->cryptlen;
-		size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
-				authsize : 0;
+
+		if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT)
+			size_for_map += authsize;
+		else
+			size_for_map -= authsize;
+
 		if (is_gcm4543)
 			size_for_map += crypto_aead_ivsize(tfm);
 
-- 
2.25.0

