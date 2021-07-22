Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78862C63793
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Jul 2021 17:08:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ECD5610CC
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Jul 2021 17:08:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbhGVQ16 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Jul 2021 12:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233071AbhGVQ15 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jul 2021 12:27:57 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E48C061575;
        Thu, 22 Jul 2021 10:08:31 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id h24-20020a1ccc180000b029022e0571d1a0so16539wmb.5;
        Thu, 22 Jul 2021 10:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=BM24k6H9LcY/dUUeA4LE+RhfS6GQmXK+4XERxfAvlv0=;
        b=EGJzKVW/kRPjNGPb3PpWvJp0lL9sDmOkyFaIWjQOFlnDL3jl44Mx6wQfAyNRu1guxz
         wV1u73JJHMVl7EYbQOUcVLRVUPztU9PnIN3GXofRe7W6hfiBQMxPlW6d16YH80OBJ3rg
         pmmt5MsFbbbujjtLZPN6UDNOfOnWbg8+gttPgueZw7XILapxG4uCF/EV71qBnLXvQZBO
         Yqd1XHBsi1IjWqQbrGSDFuWtunt6ZUfRafXcAd55XGVZZcxId9f/bSjwwBd54cTec8rf
         cj0wCX2BjGPE6t26cKZmHhsg/ZQhY1CAEgd2h7J+/p2NTOO+YBzt9Ng68SwsfrwaqvcT
         gN2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=BM24k6H9LcY/dUUeA4LE+RhfS6GQmXK+4XERxfAvlv0=;
        b=Fg48gkxz5vCxM8XuBmeeDdaAiZ/zV5o/jEJzegrYbFGtTog5YV+FYtpvRQOG82Yz3v
         t8tSup4hwrkDbJFWHTvAyZZegc3oJ6rKKlHiXCCgbxyBhTopNyj8G96/0PMGap7DpQ6n
         9oAaGD4/tc/paYFQkXUj6bGt+mhQkGZPCfbnSLezHLQR/fZ3+lrokxRW0Ig1Ddmjb29u
         cC8Tr86rQPzfy6dyqQZqFySBFqBlujZZ0kS5KmcdFL5FxMh4k45Tui7D6I+vr9LDBbLP
         CdIzv+VCSUzGvGmUdowmqCoDv95i0RZCeFHivY/ab813xBj3E9fji9LibK7zuq7fW3YE
         qmjA==
X-Gm-Message-State: AOAM530+a7W7NiPiqOLJ1G6kdRzuPtVeL0bnHADshu+99ji83kFYSgeq
        hahyk7EtoOX5vZ/NlKIpCUw=
X-Google-Smtp-Source: ABdhPJzDPSdBP2ulFJJaYkQ7EQ6LuTTGOgv1xIdTUYvQSiWPfuJf+HKhIuywvRz36Xfjg8BIhdAn7g==
X-Received: by 2002:a7b:cd15:: with SMTP id f21mr601085wmj.148.1626973710339;
        Thu, 22 Jul 2021 10:08:30 -0700 (PDT)
Received: from pc ([196.235.233.206])
        by smtp.gmail.com with ESMTPSA id w18sm8513884wrs.44.2021.07.22.10.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 10:08:29 -0700 (PDT)
Date:   Thu, 22 Jul 2021 18:08:27 +0100
From:   Salah Triki <salah.triki@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        gregkh@linuxfoundation.org
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND] crypto: atmel-aes: use swap()
Message-ID: <20210722170827.GA4362@pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use swap() instead of implementing it in order to make code more clean.

Signed-off-by: Salah Triki <salah.triki@gmail.com>
---
 drivers/crypto/atmel-aes.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index b1d286004295..60041022c4f5 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1819,12 +1819,8 @@ static int atmel_aes_xts_process_data(struct atmel_aes_dev *dd)
 	 * the order of the ciphered tweak bytes need to be reversed before
 	 * writing them into the ODATARx registers.
 	 */
-	for (i = 0; i < AES_BLOCK_SIZE/2; ++i) {
-		u8 tmp = tweak_bytes[AES_BLOCK_SIZE - 1 - i];
-
-		tweak_bytes[AES_BLOCK_SIZE - 1 - i] = tweak_bytes[i];
-		tweak_bytes[i] = tmp;
-	}
+	for (i = 0; i < AES_BLOCK_SIZE/2; ++i)
+		swap(tweak_bytes[i], tweak_bytes[AES_BLOCK_SIZE - 1 - i]);
 
 	/* Process the data. */
 	atmel_aes_write_ctrl(dd, use_dma, NULL);
-- 
2.25.1

