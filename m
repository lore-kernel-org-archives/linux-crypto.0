Return-Path: <SRS0=A/Go=3G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52211C33CB1
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jan 2020 09:45:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DEB120730
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jan 2020 09:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbgAQJpK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Jan 2020 04:45:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39873 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbgAQJpK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Jan 2020 04:45:10 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1isNvP-0005lD-Gc; Fri, 17 Jan 2020 09:28:19 +0000
From:   Colin King <colin.king@canonical.com>
To:     Zaibo Xu <xuzaibo@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] crypto: hisilicon: fix spelling mistake "disgest" -> "digest"
Date:   Fri, 17 Jan 2020 09:28:19 +0000
Message-Id: <20200117092819.97640-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in an error message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index a0a35685e838..a2cfcc9ccd94 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -690,7 +690,7 @@ static int sec_aead_auth_set_key(struct sec_auth_ctx *ctx,
 		ret = crypto_shash_digest(shash, keys->authkey,
 					  keys->authkeylen, ctx->a_key);
 		if (ret) {
-			pr_err("hisi_sec2: aead auth disgest error!\n");
+			pr_err("hisi_sec2: aead auth digest error!\n");
 			return -EINVAL;
 		}
 		ctx->a_key_len = blocksize;
-- 
2.24.0

