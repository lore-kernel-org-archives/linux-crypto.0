Return-Path: <SRS0=EtZ3=SR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2794C10F0E
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 12:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AB2E20693
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 12:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbfDOMk1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Apr 2019 08:40:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53609 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfDOMk1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Apr 2019 08:40:27 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hG0uM-0006FP-6d; Mon, 15 Apr 2019 12:40:22 +0000
From:   Colin King <colin.king@canonical.com>
To:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: caam: fix spelling mistake "cannote" -> "cannot"
Date:   Mon, 15 Apr 2019 13:40:21 +0100
Message-Id: <20190415124021.4659-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in an error message in the qi_error_list
array. Fix this.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/caam/error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 21a70fd32f5d..a4129a35a330 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -138,7 +138,7 @@ static const struct {
 	{ 0x46, "Annotation length exceeds offset (reuse mode)"},
 	{ 0x48, "Annotation output enabled but ASA limited by ASAR (reuse mode)"},
 	{ 0x49, "Data offset correction exceeds input frame data length (reuse mode)"},
-	{ 0x4B, "Annotation output enabled but ASA cannote be expanded (frame list)"},
+	{ 0x4B, "Annotation output enabled but ASA cannot be expanded (frame list)"},
 	{ 0x51, "Unsupported IF reuse mode"},
 	{ 0x52, "Unsupported FL use mode"},
 	{ 0x53, "Unsupported RJD use mode"},
-- 
2.20.1

