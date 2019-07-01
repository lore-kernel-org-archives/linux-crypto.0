Return-Path: <SRS0=UDVD=U6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A4BC0650E
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jul 2019 13:08:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2866820881
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jul 2019 13:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfGANIU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Jul 2019 09:08:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46844 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGANIU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Jul 2019 09:08:20 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hhw2Y-0002cB-On; Mon, 01 Jul 2019 13:08:14 +0000
From:   Colin King <colin.king@canonical.com>
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] crypto: ccree - fix spelling mistake "configration" -> "configuration"
Date:   Mon,  1 Jul 2019 14:08:14 +0100
Message-Id: <20190701130814.14251-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a dev_err message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/ccree/cc_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 980aa04b655b..eeb803f40623 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -421,7 +421,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 			}
 			break;
 		default:
-			dev_err(dev, "Unsupported engines configration.\n");
+			dev_err(dev, "Unsupported engines configuration.\n");
 			rc = -EINVAL;
 			goto post_clk_err;
 		}
-- 
2.20.1

