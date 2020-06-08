Return-Path: <SRS0=xc0K=7W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99537C433E1
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jun 2020 00:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79AD2207ED
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Jun 2020 00:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591663705;
	bh=ulf2SztqD35ITArIHACtWdmO6AcDVM1Uqldkqoc+rQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hCTpyVIbnJs1SOdkIlkVnVvP54RQocjPsPunL6CrCThN9A3A98pNyebC/llAdkfIH
	 m1KQMh4MUtEqfglbnr5CuMe0AVD51mzlEu2/mQ7sV75eLnO49r+BcIy8RL0fkyjF2j
	 nxmplC1lkHe9T27WmYkgLscgUPs3RfGBCDmH0zl0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgFHXK7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Jun 2020 19:10:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728795AbgFHXK6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Jun 2020 19:10:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DC3020CC7;
        Mon,  8 Jun 2020 23:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657858;
        bh=ulf2SztqD35ITArIHACtWdmO6AcDVM1Uqldkqoc+rQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=De+4KpYGNwnXl/FdJsiQZUsI4wC686zjANFRFDfRkOO1SkcbUGc2QBzqfVjmkeC6u
         JEhRlqDuz2MWW1rWE3teUJrMNrByx38Cfncn5Sl9ux3kw6AEM6S18uR5P410LtuXfX
         xNzZol4PgvAWHb9muN396RV9Bn40AFkm5wKtkC2Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Toromanoff <nicolas.toromanoff@st.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 221/274] crypto: stm32/crc32 - fix run-time self test issue.
Date:   Mon,  8 Jun 2020 19:05:14 -0400
Message-Id: <20200608230607.3361041-221-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Nicolas Toromanoff <nicolas.toromanoff@st.com>

[ Upstream commit a8cc3128bf2c01c4d448fe17149e87132113b445 ]

Fix wrong crc32 initialisation value:
"alg: shash: stm32_crc32 test failed (wrong result) on test vector 0,
cfg="init+update+final aligned buffer"
cra_name="crc32c" expects an init value of 0XFFFFFFFF,
cra_name="crc32" expects an init value of 0.

Fixes: b51dbe90912a ("crypto: stm32 - Support for STM32 CRC32 crypto module")

Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@st.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/stm32/stm32-crc32.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-crc32.c b/drivers/crypto/stm32/stm32-crc32.c
index c6156bf6c603..1c3e411b7acb 100644
--- a/drivers/crypto/stm32/stm32-crc32.c
+++ b/drivers/crypto/stm32/stm32-crc32.c
@@ -28,10 +28,10 @@
 
 /* Registers values */
 #define CRC_CR_RESET            BIT(0)
-#define CRC_INIT_DEFAULT        0xFFFFFFFF
 #define CRC_CR_REV_IN_WORD      (BIT(6) | BIT(5))
 #define CRC_CR_REV_IN_BYTE      BIT(5)
 #define CRC_CR_REV_OUT          BIT(7)
+#define CRC32C_INIT_DEFAULT     0xFFFFFFFF
 
 #define CRC_AUTOSUSPEND_DELAY	50
 
@@ -65,7 +65,7 @@ static int stm32_crc32_cra_init(struct crypto_tfm *tfm)
 {
 	struct stm32_crc_ctx *mctx = crypto_tfm_ctx(tfm);
 
-	mctx->key = CRC_INIT_DEFAULT;
+	mctx->key = 0;
 	mctx->poly = CRC32_POLY_LE;
 	return 0;
 }
@@ -74,7 +74,7 @@ static int stm32_crc32c_cra_init(struct crypto_tfm *tfm)
 {
 	struct stm32_crc_ctx *mctx = crypto_tfm_ctx(tfm);
 
-	mctx->key = CRC_INIT_DEFAULT;
+	mctx->key = CRC32C_INIT_DEFAULT;
 	mctx->poly = CRC32C_POLY_LE;
 	return 0;
 }
-- 
2.25.1

