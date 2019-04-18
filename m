Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D9E1C10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 08:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B962214DA
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 08:17:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i/W+vQnM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfDRIRw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 04:17:52 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45247 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388219AbfDRIRv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 04:17:51 -0400
Received: by mail-wr1-f68.google.com with SMTP id s15so1783623wra.12;
        Thu, 18 Apr 2019 01:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lbhj8bDRlGdjkw0r97iacsqSjh2r3SUzy01sQ+arMeo=;
        b=i/W+vQnMNWVRXvSrVDeiwlrhl2QeYwQKlLnhehk28cSRDI5UC48p5HU4zSVczDl/dt
         hhBlKFMsr6c2h37TdvN3cOvYv+hI9zcIBQugK5oWfr/1R+AxnghN0pXNgSh15aGngAvk
         uuhKu9VWyA79Yv9fX8x2qITn8jlt0j+MhL/J5Ac81WENb2JphmXnEQq2QXGbajuiTtGS
         SdB9WGNi59R1qVnjrkbj53M2bCvxczYwC2I9VoNAu1IXagQzIP/KpeyJHCLp57m3Hykk
         ajim3OiK30xZ+P08Xnd4iDQ2q0BjCxqHAT3sMLpmNDIanPRpIaZbdyObPdoKJ0CetVOH
         Un4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lbhj8bDRlGdjkw0r97iacsqSjh2r3SUzy01sQ+arMeo=;
        b=jbacYlhfLWwAsjgeq8RNhOxqXpOZfuGfYcQW+mfcSqPfqeD4FzhO5CNv3M2v48xfLp
         Eo/z5D8B29rCtUEeP1e7l+mfBzIUU7u2JxbhyrkztRn+yni7yEwuxgL0VcDBzT2DLV/t
         alP3ajXsiZzJpbDnb+DZai6QCrEDMwEgN/xCliBz78KhYAR99GZubXVzeKCmA1fKuA1c
         PLfXXNVEasKHD+ue5ey2l5YxJs6/IWte9I0zdoa1lpsoPP0aTuMVcnjj4xDiYhR/RWtC
         DfO+h4QetGX3W3qoARuhff8oLz5tHFQCWXyT9KeyUAT9wbOeZZgtVVJisBuGaHUrvOXv
         rYSQ==
X-Gm-Message-State: APjAAAVOQIn4edTkIhADKKRHc/7PF7fuUyq/2UECLYWUjhF9Z0XlC9lX
        4DxI/wNqZvZQKvKowsNwCtQ=
X-Google-Smtp-Source: APXvYqzAW90VmJAKDpYvoaxELb5UbsycuFAN3B6Bj3RDyGebZWwlAj7x8SGMwYPSG0l8/HNd+7BVBQ==
X-Received: by 2002:adf:b68d:: with SMTP id j13mr63110093wre.50.1555575469910;
        Thu, 18 Apr 2019 01:17:49 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id w11sm2350619wre.15.2019.04.18.01.17.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Apr 2019 01:17:49 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        maxime.ripard@bootlin.com, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        ebiggers@kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 1/4] crypto: sun4i-ss: Handle better absence/presence of IV
Date:   Thu, 18 Apr 2019 10:17:32 +0200
Message-Id: <20190418081735.19002-2-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418081735.19002-1-clabbe.montjoie@gmail.com>
References: <20190418081735.19002-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch remove the test against areq->info since sun4i-ss could work
without it (ECB).

Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
index 06df336488fb..4b60f8fdd1c8 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -41,11 +41,6 @@ static int sun4i_ss_opti_poll(struct skcipher_request *areq)
 	if (!areq->cryptlen)
 		return 0;
 
-	if (!areq->iv) {
-		dev_err_ratelimited(ss->dev, "ERROR: Empty IV\n");
-		return -EINVAL;
-	}
-
 	if (!areq->src || !areq->dst) {
 		dev_err_ratelimited(ss->dev, "ERROR: Some SGs are NULL\n");
 		return -EINVAL;
@@ -157,11 +152,6 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	if (!areq->cryptlen)
 		return 0;
 
-	if (!areq->iv) {
-		dev_err_ratelimited(ss->dev, "ERROR: Empty IV\n");
-		return -EINVAL;
-	}
-
 	if (!areq->src || !areq->dst) {
 		dev_err_ratelimited(ss->dev, "ERROR: Some SGs are NULL\n");
 		return -EINVAL;
-- 
2.21.0

