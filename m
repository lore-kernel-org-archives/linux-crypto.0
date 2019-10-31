Return-Path: <SRS0=cgyY=YY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A60BDCA9ECB
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Oct 2019 16:14:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 751A02086D
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Oct 2019 16:14:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ATINM0Yf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbfJaQOs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Oct 2019 12:14:48 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52437 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfJaQOs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Oct 2019 12:14:48 -0400
Received: by mail-wm1-f67.google.com with SMTP id p21so6550755wmg.2
        for <linux-crypto@vger.kernel.org>; Thu, 31 Oct 2019 09:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RqwYOiN2KGqpLlf/ZRc9wSeyek8W+EvrYA8vHyutvuA=;
        b=ATINM0Yf2zbUcYuZGChFzCdl9tiVcNGTXnZN/FdQihGwfv1R1knVJerg3VwNNABN6s
         wT+Eiw0VzFALW2XPHrTIPuB2DbkxcEWDQvT3ZTtL9m3rGvRFhkcgxpJFn9/OfEiB3ml4
         z7YMishQmuZ9e+0xW1ZHVE1BAmqq30yMfbABC/TyUghBKz5V5glA5yAjAefPdmoW4LP6
         xI8qKAbzP6OrQO86hVLXlehsXfiz3fMV7lo0OWNF28/CYlzOrKEkGLSS9bPSX4u+JYbE
         5Hqb82udeyhoWue7tcoBQCmVOEYFxNDici3SYZIlhmc/srMoCe9lK1mBFC9de2sbId7T
         SwsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RqwYOiN2KGqpLlf/ZRc9wSeyek8W+EvrYA8vHyutvuA=;
        b=az6zzSLL5dC4JBvhXBdLsHzAdtn5l4mh8Nq7Iqt9mzbaqCoC8J4bxP6KM4z/+j65T+
         SQjUhoazFCpLik4gYePm5187dNESnxF1mhwSPSSKeOpMP3urQl3Ju5r/Swnc9bO5szH2
         /R8CWsvBMExQ93Shm/JIKoNdv+PatvdFx1mZnU+rJfh2buCfuW/CUD+HfPwvFRAcHgQh
         GOCsv8SHLZSoDu5XcGqYp1r7RtdEc2R5UGtGcivjhxoNWwncwNb4Lkguct66qt4T9oYe
         Klc4UqtLE2qbU/KiZX6E/kBKB1vrTRkJJYHxje6saTppsQ0vj9e6EifmgwXJ+rWSO2s/
         Uh6w==
X-Gm-Message-State: APjAAAWFyks3u6v3ttHfZzORWxD9HnEaAytK/HpGFhrJChcJQD1OWa3O
        eF0vk9hrQWb2E1sMkT6fSxe1TJsE
X-Google-Smtp-Source: APXvYqwQ8LNBLKL+kn9h3cPNBvwnnAlIKu+Agn8yoJbc0r3h9y5RTm4P7EIjYxb6YhfxjUyAcSJOMg==
X-Received: by 2002:a1c:1f03:: with SMTP id f3mr5900613wmf.131.1572538485096;
        Thu, 31 Oct 2019 09:14:45 -0700 (PDT)
Received: from debian64.daheim (p200300D5FF0185FC6CD68BFF00000D54.dip0.t-ipconnect.de. [2003:d5:ff01:85fc:6cd6:8bff:0:d54])
        by smtp.gmail.com with ESMTPSA id b1sm4440305wru.83.2019.10.31.09.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 09:14:44 -0700 (PDT)
Received: from chuck by debian64.daheim with local (Exim 4.92.3)
        (envelope-from <chunkeey@gmail.com>)
        id 1iQD5q-0001HG-7A; Thu, 31 Oct 2019 17:14:38 +0100
From:   Christian Lamparter <chunkeey@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH] crypto: crypto4xx - fix double-free in crypto4xx_destroy_sdr
Date:   Thu, 31 Oct 2019 17:14:38 +0100
Message-Id: <20191031161438.4806-1-chunkeey@gmail.com>
X-Mailer: git-send-email 2.24.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes a crash that can happen during probe
when the available dma memory is not enough (this can
happen if the crypto4xx is built as a module).

The descriptor window mapping would end up being free'd
twice, once in crypto4xx_build_pdr() and the second time
in crypto4xx_destroy_sdr().

Fixes: 5d59ad6eea82 ("crypto: crypto4xx - fix crypto4xx_build_pdr, crypto4xx_build_sdr leak")
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index de5e9352e920..7d6b695c4ab3 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -365,12 +365,8 @@ static u32 crypto4xx_build_sdr(struct crypto4xx_device *dev)
 		dma_alloc_coherent(dev->core_dev->device,
 			PPC4XX_SD_BUFFER_SIZE * PPC4XX_NUM_SD,
 			&dev->scatter_buffer_pa, GFP_ATOMIC);
-	if (!dev->scatter_buffer_va) {
-		dma_free_coherent(dev->core_dev->device,
-				  sizeof(struct ce_sd) * PPC4XX_NUM_SD,
-				  dev->sdr, dev->sdr_pa);
+	if (!dev->scatter_buffer_va)
 		return -ENOMEM;
-	}
 
 	for (i = 0; i < PPC4XX_NUM_SD; i++) {
 		dev->sdr[i].ptr = dev->scatter_buffer_pa +
-- 
2.24.0.rc2

