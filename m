Return-Path: <SRS0=oWw0=3Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3898C33CA1
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Feb 2020 10:20:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 845D320674
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Feb 2020 10:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgBEKUK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Feb 2020 05:20:10 -0500
Received: from inva021.nxp.com ([92.121.34.21]:41106 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728244AbgBEKUK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Feb 2020 05:20:10 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 491632450B7;
        Wed,  5 Feb 2020 11:20:08 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 3AF352450B6;
        Wed,  5 Feb 2020 11:20:08 +0100 (CET)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id F0628205BF;
        Wed,  5 Feb 2020 11:20:07 +0100 (CET)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH] crypto: tcrypt - fix printed skcipher [a]sync mode
Date:   Wed,  5 Feb 2020 12:19:58 +0200
Message-Id: <20200205101958.29879-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When running tcrypt skcipher speed tests, logs contain things like:
testing speed of async ecb(des3_ede) (ecb(des3_ede-generic)) encryption
or:
testing speed of async ecb(aes) (ecb(aes-ce)) encryption

The algorithm implementations are sync, not async.
Fix this inaccuracy.

Fixes: 7166e589da5b6 ("7166e589da5b crypto: tcrypt - Use skcipher")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 crypto/tcrypt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index f42f486e90e8..ba0b7702f2e9 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1514,8 +1514,8 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 		return;
 	}
 
-	pr_info("\ntesting speed of async %s (%s) %s\n", algo,
-			get_driver_name(crypto_skcipher, tfm), e);
+	pr_info("\ntesting speed of %s %s (%s) %s\n", async ? "async" : "sync",
+		algo, get_driver_name(crypto_skcipher, tfm), e);
 
 	req = skcipher_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
-- 
2.17.1

