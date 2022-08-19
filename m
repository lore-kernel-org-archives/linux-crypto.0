Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B5BAC25B0E
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Aug 2022 06:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346182AbiHSGIR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Aug 2022 02:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345238AbiHSGIQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Aug 2022 02:08:16 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914DC6342
        for <linux-crypto@vger.kernel.org>; Thu, 18 Aug 2022 23:08:14 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id y13so6941077ejp.13
        for <linux-crypto@vger.kernel.org>; Thu, 18 Aug 2022 23:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Af+4xj435h7tYd148SgfWr1zA59+PnWfK6elz89ZgLM=;
        b=Xd8NAKNiubTfxSsUtmJumEPpCI6vYOF5EL7eEqsASLzToqEfPk6XzX5naT+z+HYz8I
         1w53N+2KRQhMMbNho1wRRAHnHctpEyn+ZAZ+My+y94GnQ5BUud/SCly6Wqagaak6riGw
         VJXb180ImFH4mR4mo9owoXe/iiPOaEVE/QR7+wSIyjKVsRC6G/DI8OyjSBRW5Ayh2bkn
         O1tiHylgbNmwwQh68r5Aw8twy4PJFSp+KXlV8SJ/KXety+QEl+w1NfyMTG+JMF9b+oyx
         jE0UjBp39Rp78xg0g9guNVRyW5aG3Fb4qMhoEcrZPddQOIZtkz1omaYtCVqpw/Z4oEwE
         JWUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Af+4xj435h7tYd148SgfWr1zA59+PnWfK6elz89ZgLM=;
        b=35bnIjknL5hymvOZVgEqaSj60R4z5ikTdiTO7soe6pvOjVWjXKcq/v3Jrw7DroPZ5E
         R326tfraHskRinuaZfi1JOx4lIHKtuWiBrg7xcZhb7ZDEXdTpmnev5eNZ2OpPzO0uw7h
         JdiRf2Fa5fHVhEmc3qb4mamwHY66aKV2aZ70tLR/Q6yg/eh1gLPXN4wf8oXJzkeFQxCt
         OaeJkzIXmkJW76YRi/3a1yQz2OMQY6EI5ERCS3u5SGe1FayRIa4ReLd73FIeWlfdDp7s
         bKak4542nDOMyKv3FtGFsc8gtSiwbYzbcWkijjNg1FWYoaHzrdofjK313DXw+kzx4zNW
         04jg==
X-Gm-Message-State: ACgBeo0JZLc3Wgd4KJkq6SsyuvQwB/UaTlQDJEi+cpJqV4JpK0lhpGbO
        y34h+9Mc86iehA7tB3EIUJt0/Q==
X-Google-Smtp-Source: AA6agR6s6z8H4PJAO2ZxVq5Iz7zKjhRBNrkLvhyCmREGjaDozeybRofTqZW61aHl+9y+8xWxNaWEhw==
X-Received: by 2002:a17:907:da2:b0:731:60e4:2261 with SMTP id go34-20020a1709070da200b0073160e42261mr3844241ejc.679.1660889292785;
        Thu, 18 Aug 2022 23:08:12 -0700 (PDT)
Received: from lb02065.fritz.box ([2001:9e8:143b:fd00:5207:8c7f:747a:b80d])
        by smtp.gmail.com with ESMTPSA id y14-20020a1709063a8e00b0073a644ef803sm1809660ejd.101.2022.08.18.23.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 23:08:11 -0700 (PDT)
From:   Jack Wang <jinpu.wang@ionos.com>
To:     linux-kernel@vger.kernel.org
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v1 07/19] crypto: gemin: Fix error check for dma_map_sg
Date:   Fri, 19 Aug 2022 08:07:49 +0200
Message-Id: <20220819060801.10443-8-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220819060801.10443-1-jinpu.wang@ionos.com>
References: <20220819060801.10443-1-jinpu.wang@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

dma_map_sg return 0 on error.

Cc: Corentin Labbe <clabbe@baylibre.com>
Cc: Hans Ulli Kroll <ulli.kroll@googlemail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/crypto/gemini/sl3516-ce-cipher.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/gemini/sl3516-ce-cipher.c b/drivers/crypto/gemini/sl3516-ce-cipher.c
index 14d0d83d388d..34fea8aa91b6 100644
--- a/drivers/crypto/gemini/sl3516-ce-cipher.c
+++ b/drivers/crypto/gemini/sl3516-ce-cipher.c
@@ -149,7 +149,7 @@ static int sl3516_ce_cipher(struct skcipher_request *areq)
 	if (areq->src == areq->dst) {
 		nr_sgs = dma_map_sg(ce->dev, areq->src, sg_nents(areq->src),
 				    DMA_BIDIRECTIONAL);
-		if (nr_sgs <= 0 || nr_sgs > MAXDESC / 2) {
+		if (!nr_sgs || nr_sgs > MAXDESC / 2) {
 			dev_err(ce->dev, "Invalid sg number %d\n", nr_sgs);
 			err = -EINVAL;
 			goto theend;
@@ -158,14 +158,14 @@ static int sl3516_ce_cipher(struct skcipher_request *areq)
 	} else {
 		nr_sgs = dma_map_sg(ce->dev, areq->src, sg_nents(areq->src),
 				    DMA_TO_DEVICE);
-		if (nr_sgs <= 0 || nr_sgs > MAXDESC / 2) {
+		if (!nr_sgs || nr_sgs > MAXDESC / 2) {
 			dev_err(ce->dev, "Invalid sg number %d\n", nr_sgs);
 			err = -EINVAL;
 			goto theend;
 		}
 		nr_sgd = dma_map_sg(ce->dev, areq->dst, sg_nents(areq->dst),
 				    DMA_FROM_DEVICE);
-		if (nr_sgd <= 0 || nr_sgd > MAXDESC) {
+		if (!nr_sgd || nr_sgd > MAXDESC) {
 			dev_err(ce->dev, "Invalid sg number %d\n", nr_sgd);
 			err = -EINVAL;
 			goto theend_sgs;
-- 
2.34.1

