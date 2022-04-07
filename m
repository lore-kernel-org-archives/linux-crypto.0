Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 330F3C433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Apr 2022 01:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbiDGBQU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Apr 2022 21:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237162AbiDGBPz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Apr 2022 21:15:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E3F1903CE;
        Wed,  6 Apr 2022 18:12:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A955CB8268A;
        Thu,  7 Apr 2022 01:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC1DC385A3;
        Thu,  7 Apr 2022 01:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649293930;
        bh=kyCpt+kxit9oAreUT89imPW8qUa5FVx/lcfqw+8Zcqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CGwNednNr36mVUMbpzqSj+Wo53yzmW9gVE9KU1OQ8HTP/VrVmCqu66tv7YFnmLn/p
         4ggbTah6yPNj+0zduqQLEqe0oC79m4ZuBC4PkxodSRD8/gwe2H3WNzEcr4nAPc0qBZ
         3kNom6F8Ddx7tfQkq2fPET9nvUZySblY7zbY/3Skot3N5BUQCAP2mLBjOmKvuGJK3G
         arbgYC8KXggJmxMrbkzy8KZiQjgOfdRcvt3qhqjaOmVjo7AFTzBOGOBH1ssEuFddR9
         vhzLkaKVF6ZcxhkwWTGdoefOFhmqcYL1etEzJlSDmT734MMA7S3i3j6GIn/waOh6Fa
         kI4cJ6oBvqRVg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        nicolas.toromanoff@foss.st.com, marex@denx.de,
        linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 14/30] crypto: stm32 - fix reference leak in stm32_crc_remove
Date:   Wed,  6 Apr 2022 21:11:24 -0400
Message-Id: <20220407011140.113856-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011140.113856-1-sashal@kernel.org>
References: <20220407011140.113856-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit e9a36feecee0ee5845f2e0656f50f9942dd0bed3 ]

pm_runtime_get_sync() will increment pm usage counter even it
failed. Forgetting to call pm_runtime_put_noidle will result
in reference leak in stm32_crc_remove, so we should fix it.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/stm32/stm32-crc32.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/stm32/stm32-crc32.c b/drivers/crypto/stm32/stm32-crc32.c
index be1bf39a317d..90a920e7f664 100644
--- a/drivers/crypto/stm32/stm32-crc32.c
+++ b/drivers/crypto/stm32/stm32-crc32.c
@@ -384,8 +384,10 @@ static int stm32_crc_remove(struct platform_device *pdev)
 	struct stm32_crc *crc = platform_get_drvdata(pdev);
 	int ret = pm_runtime_get_sync(crc->dev);
 
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(crc->dev);
 		return ret;
+	}
 
 	spin_lock(&crc_list.lock);
 	list_del(&crc->list);
-- 
2.35.1

