Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0685BC4167B
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Oct 2021 11:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF6CB613A0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Oct 2021 11:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhJTLIj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Oct 2021 07:08:39 -0400
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:25964 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbhJTLIi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Oct 2021 07:08:38 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.9]) by rmmx-syy-dmz-app08-12008 (RichMail) with SMTP id 2ee8616ff822b7d-09242; Wed, 20 Oct 2021 19:06:10 +0800 (CST)
X-RM-TRANSID: 2ee8616ff822b7d-09242
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.112.105.130])
        by rmsmtp-syy-appsvr05-12005 (RichMail) with SMTP id 2ee5616ff81f86e-1d843;
        Wed, 20 Oct 2021 19:06:10 +0800 (CST)
X-RM-TRANSID: 2ee5616ff81f86e-1d843
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     krzysztof.kozlowski@canonical.com, vz@mleia.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>
Subject: [PATCH v2] crypto: s5p-sss - Add error handling in s5p_aes_probe()
Date:   Wed, 20 Oct 2021 19:06:24 +0800
Message-Id: <20211020110624.47696-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The function s5p_aes_probe() does not perform sufficient error
checking after executing platform_get_resource(), thus fix it.

Fixes: c2afad6c6105 ("crypto: s5p-sss - Add HASH support for Exynos")
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
Changes from v1
 - add fixed title
---
 drivers/crypto/s5p-sss.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 55aa3a711..7717e9e59 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -2171,6 +2171,8 @@ static int s5p_aes_probe(struct platform_device *pdev)
 
 	variant = find_s5p_sss_version(pdev);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
 
 	/*
 	 * Note: HASH and PRNG uses the same registers in secss, avoid
-- 
2.20.1.windows.1



