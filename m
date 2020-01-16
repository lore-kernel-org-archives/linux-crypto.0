Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B41C33CAF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 17:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E03722470D
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 17:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579196354;
	bh=SyGVpspHwVPxiQSr1Xp7q/vO0Wawnakxrt5Zj7aU2fE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=KMlmevjO9RRUjbTPr2l6h/b6hUG2TTC5YLTQurSPlaVQdoElYyUocjPMoKQhfpFMR
	 BVqtgn63M6KiGGL8Gk7Xy3yL9LnTYfjOwOchuk+3xsM6KYLUU3nfud/ZeK6f12ryQj
	 Cnl7JDdi/DvsnqcrCAHsrcSQJJh36PWWCrhwbFTc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393444AbgAPRjN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 12:39:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:55356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732879AbgAPRjM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 12:39:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D133F246EF;
        Thu, 16 Jan 2020 17:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196351;
        bh=SyGVpspHwVPxiQSr1Xp7q/vO0Wawnakxrt5Zj7aU2fE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mvaRdii8NLDkHExvGe9YGt5pWm5gKNf26UOLO5NYry//pX3Rg2qPav3p9gr3V3lVk
         qPI2U6OiNsPqvg2w7adGeL+j5ArzgBaY2o2pgxGOlQLhRp3g9e6Hegom4Rr30AklIl
         ykSIVz5R8FAtmnlJLU05W0nms76/rWJm0XXhcn0M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Hook, Gary" <Gary.Hook@amd.com>, Gary R Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 145/251] crypto: ccp - fix AES CFB error exposed by new test vectors
Date:   Thu, 16 Jan 2020 12:34:54 -0500
Message-Id: <20200116173641.22137-105-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: "Hook, Gary" <Gary.Hook@amd.com>

[ Upstream commit c3b359d6567c0b8f413e924feb37cf025067d55a ]

Updated testmgr will exhibit this error message when loading the
ccp-crypto module:

alg: skcipher: cfb-aes-ccp encryption failed with err -22 on test vector 3, cfg="in-place"

Update the CCP crypto driver to correctly treat CFB as a streaming mode
cipher (instead of block mode). Update the configuration for CFB to
specify the block size as a single byte;

Fixes: 2b789435d7f3 ('crypto: ccp - CCP AES crypto API support')

Signed-off-by: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/ccp-crypto-aes.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes.c b/drivers/crypto/ccp/ccp-crypto-aes.c
index 89291c15015c..3f768699332b 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes.c
@@ -1,7 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * AMD Cryptographic Coprocessor (CCP) AES crypto API support
  *
- * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
+ * Copyright (C) 2013-2019 Advanced Micro Devices, Inc.
  *
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  *
@@ -79,8 +80,7 @@ static int ccp_aes_crypt(struct ablkcipher_request *req, bool encrypt)
 		return -EINVAL;
 
 	if (((ctx->u.aes.mode == CCP_AES_MODE_ECB) ||
-	     (ctx->u.aes.mode == CCP_AES_MODE_CBC) ||
-	     (ctx->u.aes.mode == CCP_AES_MODE_CFB)) &&
+	     (ctx->u.aes.mode == CCP_AES_MODE_CBC)) &&
 	    (req->nbytes & (AES_BLOCK_SIZE - 1)))
 		return -EINVAL;
 
@@ -291,7 +291,7 @@ static struct ccp_aes_def aes_algs[] = {
 		.version	= CCP_VERSION(3, 0),
 		.name		= "cfb(aes)",
 		.driver_name	= "cfb-aes-ccp",
-		.blocksize	= AES_BLOCK_SIZE,
+		.blocksize	= 1,
 		.ivsize		= AES_BLOCK_SIZE,
 		.alg_defaults	= &ccp_aes_defaults,
 	},
-- 
2.20.1

