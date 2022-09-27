Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35610C07E9D
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Sep 2022 08:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbiI0I4K (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Sep 2022 04:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbiI0I4H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Sep 2022 04:56:07 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90F120349
        for <linux-crypto@vger.kernel.org>; Tue, 27 Sep 2022 01:56:05 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id z13-20020a7bc7cd000000b003b5054c6f9bso8469334wmk.2
        for <linux-crypto@vger.kernel.org>; Tue, 27 Sep 2022 01:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=bEQ+cO4PtSvPHzqNY25Rk57cl8sc42zs+u1n/Vf8KZg=;
        b=XOIvxDxpY8g1tcDM9f3ZfJNAfiXKalsyBRMkO6YU1eeQ2kIfWL9DQ/j4zmvwazNZXd
         UNhVd6jnOgv6MD0rqH548Mf7l5ZwaPA+gZcqeoo11t+0ZSW48HUgNQCUqLYNXP4D3ApU
         rK5ZKovFnxJcUiwkzVx5J3oyBaGbsA/tY8pIDSvvHhtye8mlL0iQCBEocGUALy5WNhLF
         81ZbVXHb6EHFRL6r56Xw204S7+CQghY04kYmyHf4Xku82mUumsYbb/Vgq75I3NSA7/D+
         FFGBUbdvbGmUgZPuvD2FNKg2Z2sXHjsrYEmgiudPo0+Vp/mQU8D/Xs57iktslVuXYj/n
         AmvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=bEQ+cO4PtSvPHzqNY25Rk57cl8sc42zs+u1n/Vf8KZg=;
        b=NWce/Z73fbxQ/uDzUO01G9xAfzyXZgTD4tRT9zaFkw3vaTkLdhlbGnAmCko793WX5K
         qNXqgAjzGMhh4NMBCzcvAzcSLNDfZ4QmmkjdPXG7zTL5KBfEhMF9vjDjG55WzfUWmQN2
         OwleLlJ6KUzaB8pPI9SG1Vl1jZ/zOnqKQ4fFmM/eQunDXeVZ9XIlO4H5tbQguImPueyj
         C5ISnexu8PySgB+FUInrHHFUtRRN7TPdE7iiwF1UWb5OVxF8lehDY25+fwX9ELBFqTQN
         IiJapwuft22Xs39IUreP6xvLC8/GPl5IPB+nkzZEFdAFmoVOWEc+6m8nh5zcWXqrpMRa
         LJ4w==
X-Gm-Message-State: ACrzQf3QEL5N42g0D7jSJQVElKkmXgXpWs/zMgJRCOwYoRzxdhbvboD4
        lEMrVAPgNhWXzoHkSfrzdljYMQ==
X-Google-Smtp-Source: AMsMyM6dnWsD/C8sFek13thSn84HTvLHGHHhfLDclUX5OEqJ+U7Jyg5vYkgBcr7E1Hl6m25sd9Tbcw==
X-Received: by 2002:a05:600c:310b:b0:3b4:c618:180d with SMTP id g11-20020a05600c310b00b003b4c618180dmr1773755wmo.25.1664268964293;
        Tue, 27 Sep 2022 01:56:04 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id t126-20020a1c4684000000b003b505d26776sm13183734wma.5.2022.09.27.01.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 01:56:03 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     dan.carpenter@oracle.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, jernej.skrabec@gmail.com,
        samuel@sholland.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        linux-sunxi@googlegroups.com, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] crypto: allwinner: sun8i-ss: use dma_addr instead u32
Date:   Tue, 27 Sep 2022 08:55:55 +0000
Message-Id: <20220927085555.3196257-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The DMA address need to be stored in a dma_addr_t

Fixes: 359e893e8af4 ("crypto: sun8i-ss - rework handling of IV")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
index 910d6751644c..902f6be057ec 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -124,7 +124,7 @@ static int sun8i_ss_setup_ivs(struct skcipher_request *areq)
 	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
 	struct sun8i_ss_flow *sf = &ss->flows[rctx->flow];
 	int i = 0;
-	u32 a;
+	dma_addr_t a;
 	int err;
 
 	rctx->ivlen = ivsize;
-- 
2.35.1

