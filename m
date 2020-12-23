Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AAE4C4321A
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 03:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16DAE206F6
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 03:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731391AbgLWC7u (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Dec 2020 21:59:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728855AbgLWCUE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AE3A22248;
        Wed, 23 Dec 2020 02:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689987;
        bh=iZ9EnPp4I+VsiV/fkq4x3HqWHGBcJbtlzoXdQQkJY/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tyxqFqurXB1hMqxcqg7JUDnyhCzndFmeOBfRaO4dBR5NQ0+qYvHGNEDwK+qqErCiO
         IDSfy4nPfgn9fJarMWKZJCIpHTwwIdGAC5aCU6BkmT3OrCuDXj/AOxuK4E+BYu9V1Q
         5q3FVtiXvdmHLMBd7PWg9PgD0d7YzxVZJyCuMmCGVcDJHXc6jiWW6bh1extupU2nlP
         UQ/gbY84m+ndWHWEMhCyWwGwGSgxRYqEWP3/E+XxSNlWp0GoZKiKgA1J//JZSpV+bf
         hb6VPu1pV0U8PxunbLpXjcRbfzl7ob3XLd+cyQDfqIgQFmuZlAQwWbHyS2hNL2hWTM
         NVVnPYCBkdveg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 073/130] crypto: qce - Fix SHA result buffer corruption issues
Date:   Tue, 22 Dec 2020 21:17:16 -0500
Message-Id: <20201223021813.2791612-73-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Thara Gopinath <thara.gopinath@linaro.org>

[ Upstream commit 1148a9654b5a69611d33e14719251c6ec20f5f2c ]

Partial hash was being copied into the final result buffer without the
entire message block processed. Depending on how the end user processes
this result buffer, errors vary from result buffer corruption to result
buffer poisoing. Fix this issue by ensuring that only the final hash value
is copied into the result buffer.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qce/sha.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index 0853e74583ade..981957e9db592 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -47,7 +47,7 @@ static void qce_ahash_done(void *data)
 	dma_unmap_sg(qce->dev, &rctx->result_sg, 1, DMA_FROM_DEVICE);
 
 	memcpy(rctx->digest, result->auth_iv, digestsize);
-	if (req->result)
+	if (req->result && rctx->last_blk)
 		memcpy(req->result, result->auth_iv, digestsize);
 
 	rctx->byte_count[0] = cpu_to_be32(result->auth_byte_count[0]);
-- 
2.27.0

