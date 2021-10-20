Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53638C433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Oct 2021 10:04:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35393610D0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Oct 2021 10:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhJTKGR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Oct 2021 06:06:17 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:62584 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbhJTKGL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Oct 2021 06:06:11 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.7]) by rmmx-syy-dmz-app03-12003 (RichMail) with SMTP id 2ee3616fe975509-08a42; Wed, 20 Oct 2021 18:03:34 +0800 (CST)
X-RM-TRANSID: 2ee3616fe975509-08a42
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.112.105.130])
        by rmsmtp-syy-appsvr04-12004 (RichMail) with SMTP id 2ee4616fe97249c-189fd;
        Wed, 20 Oct 2021 18:03:34 +0800 (CST)
X-RM-TRANSID: 2ee4616fe97249c-189fd
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     krzysztof.kozlowski@canonical.com, vz@mleia.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>
Subject: [PATCH] crypto: s5p-sss - Add error handling in s5p_aes_probe()
Date:   Wed, 20 Oct 2021 18:03:48 +0800
Message-Id: <20211020100348.42896-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The function s5p_aes_probe() does not perform sufficient error
checking after executing platform_get_resource(), thus fix it.

Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
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



