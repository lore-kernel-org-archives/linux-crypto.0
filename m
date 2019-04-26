Return-Path: <SRS0=Wqm9=S4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02283C43219
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Apr 2019 13:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D223C214AE
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Apr 2019 13:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfDZNSk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Apr 2019 09:18:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42721 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbfDZNSk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Apr 2019 09:18:40 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hK0kN-0003cl-CA; Fri, 26 Apr 2019 13:18:35 +0000
From:   Colin King <colin.king@canonical.com>
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ccree: fix spelling mistake "protedcted" -> "protected"
Date:   Fri, 26 Apr 2019 14:18:35 +0100
Message-Id: <20190426131835.27258-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a dev_dbg message, fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/ccree/cc_cipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index d9f8cd543ee3..c9a40bc39698 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -368,7 +368,7 @@ static int cc_cipher_sethkey(struct crypto_skcipher *sktfm, const u8 *key,
 		else /* Must be SM4 since due to sethkey registration */
 			ctx_p->cpp.alg = CC_CPP_SM4;
 		ctx_p->key_type = CC_POLICY_PROTECTED_KEY;
-		dev_dbg(dev, "policy protedcted key alg: %d slot: %d.\n",
+		dev_dbg(dev, "policy protected key alg: %d slot: %d.\n",
 			ctx_p->cpp.alg, ctx_p->cpp.slot);
 		break;
 
-- 
2.20.1

