Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08851C63697
	for <linux-crypto@archiver.kernel.org>; Sat, 14 Nov 2020 12:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8DF12224B
	for <linux-crypto@archiver.kernel.org>; Sat, 14 Nov 2020 12:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgKNMMh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 14 Nov 2020 07:12:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32953 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbgKNMMd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 14 Nov 2020 07:12:33 -0500
Received: from cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net ([80.193.200.194] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kduPr-0002ya-Gy; Sat, 14 Nov 2020 12:12:27 +0000
From:   Colin King <colin.king@canonical.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        linux-crypto@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto: fix a couple of spelling mistakes in Kconfig files
Date:   Sat, 14 Nov 2020 12:12:27 +0000
Message-Id: <20201114121227.416572-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are a couple of spelling mistakes in two crypto Kconfig files.
Fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/Kconfig           | 2 +-
 drivers/crypto/allwinner/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 37da0c070a88..129bbdc4993b 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -648,7 +648,7 @@ choice
 	default CRYPTO_DEV_QCE_ENABLE_ALL
 	depends on CRYPTO_DEV_QCE
 	help
-	  This option allows to choose whether to build support for all algorihtms
+	  This option allows to choose whether to build support for all algorithms
 	  (default), hashes-only, or skciphers-only.
 
 	  The QCE engine does not appear to scale as well as the CPU to handle
diff --git a/drivers/crypto/allwinner/Kconfig b/drivers/crypto/allwinner/Kconfig
index 0cdfe0e8cc66..180c8a9db819 100644
--- a/drivers/crypto/allwinner/Kconfig
+++ b/drivers/crypto/allwinner/Kconfig
@@ -43,7 +43,7 @@ config CRYPTO_DEV_SUN8I_CE
 	depends on CRYPTO_DEV_ALLWINNER
 	depends on PM
 	help
-	  Select y here to have support for the crypto Engine availlable on
+	  Select y here to have support for the crypto Engine available on
 	  Allwinner SoC H2+, H3, H5, H6, R40 and A64.
 	  The Crypto Engine handle AES/3DES ciphers in ECB/CBC mode.
 
-- 
2.28.0

