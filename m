Return-Path: <SRS0=1Zye=TW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48356C282DD
	for <linux-crypto@archiver.kernel.org>; Wed, 22 May 2019 19:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 103752081C
	for <linux-crypto@archiver.kernel.org>; Wed, 22 May 2019 19:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558553935;
	bh=pO38k8VhxEzdquYnHIYEk/3gJ31kyCzgKZhOtvkygOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=fWH1jszy5CeoGssKbt/P8TsdhS3Vs/fOOFMd4Y7nicoYdnOgLBlxhy7hDUxmS0kqa
	 +bQTTBg3L9g4xG4uhS6FIb0cCsqcjZF8twChdbVi1Y4cR9i77a/rhYn7+mV48PI1NV
	 CuFMNZpg+NuHSXAdfdH4mOxAa/SEQ7237jrUQteE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731620AbfEVT3p (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 May 2019 15:29:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732968AbfEVT3p (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 May 2019 15:29:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 183B32173C;
        Wed, 22 May 2019 19:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553384;
        bh=pO38k8VhxEzdquYnHIYEk/3gJ31kyCzgKZhOtvkygOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TfpDmu3R6WnpY+z31+Ic4evLB87SYo97+W4hac9nzU33BA7bAZ6K7zEOm5/M6H6xP
         UMncA6QHNEZk7f3LI4AwamzjiLUKw8kxNOnPDr+ufhVnf6eRPaWyViudt3GPNy/t0i
         uESzKFiuBTN8vQRfjzHuPZDcZKuleSQmqjzsKOwg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 042/167] crypto: sun4i-ss - Fix invalid calculation of hash end
Date:   Wed, 22 May 2019 15:26:37 -0400
Message-Id: <20190522192842.25858-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192842.25858-1-sashal@kernel.org>
References: <20190522192842.25858-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Corentin Labbe <clabbe.montjoie@gmail.com>

[ Upstream commit f87391558acf816b48f325a493d81d45dec40da0 ]

When nbytes < 4, end is wronlgy set to a negative value which, due to
uint, is then interpreted to a large value leading to a deadlock in the
following code.

This patch fix this problem.

Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
index a4b5ff2b72f87..f6936bb3b7be4 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
@@ -240,7 +240,10 @@ static int sun4i_hash(struct ahash_request *areq)
 		}
 	} else {
 		/* Since we have the flag final, we can go up to modulo 4 */
-		end = ((areq->nbytes + op->len) / 4) * 4 - op->len;
+		if (areq->nbytes < 4)
+			end = 0;
+		else
+			end = ((areq->nbytes + op->len) / 4) * 4 - op->len;
 	}
 
 	/* TODO if SGlen % 4 and !op->len then DMA */
-- 
2.20.1

