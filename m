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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C291C63797
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Jul 2021 17:01:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03B63610CC
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Jul 2021 17:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236391AbhGVQUg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Jul 2021 12:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbhGVQTK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jul 2021 12:19:10 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFEEC061796;
        Thu, 22 Jul 2021 09:59:42 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id k12-20020a05600c1c8cb02901f259f3a250so30356wms.2;
        Thu, 22 Jul 2021 09:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=BM24k6H9LcY/dUUeA4LE+RhfS6GQmXK+4XERxfAvlv0=;
        b=qgqjaOiR5GDdZTa15bTl9JTnbzB07s9U9I9cEwDWRuN5S2mke859hy+UUqa9AvmPFs
         QnFQcBfyQYO2hoq+QCnMeAzFQrJjuhZwNSk8lKxsoQut82+gNyGeae8CX2fdtJ6AsPUJ
         sIFDuSM228csEcVbnMRcDLNmkw37EjzdGSBxe/+i5FutmwIEz61FJPGoXcNnt7LdzFmq
         7HMiDuUAhpP0zT8ZvB+6hGaL+M+s14GjFJ8edGsNTcFdoBf+Bjtotk6/Fz1gTx1H1MVo
         lOn17fh/knU+cY7LH09yds5UE/7MbJXAnTDAQROY/7yRFOTdLDSVwG26C7HozDiY6WdQ
         5ySA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=BM24k6H9LcY/dUUeA4LE+RhfS6GQmXK+4XERxfAvlv0=;
        b=mvhuGWJ60aPNmMVb+Vx2YbfZpN/kpuEPadJQVEat+zTFdcs+MC5HbqnibKZTadFS8+
         MfL4pMUoIaivvE26TF7Thn3SzgEhQuSwl9cL5WhK6kZKCHFni6aU0a2DJMgDxec1O2To
         pwpriEU+4GWhAh83i7sCoiRB2frobrrSU0m5Gv/+XKSXSuq/XLx8xXF7zm6no/d1zB/N
         gpmJqiVv32uosDzC2RQbGtqZ6pXdUtm7+CNYTOCknqL6jk/5Qe0UgE3TUx5DNiIcpKKe
         Y5dYfEylkwUskiekkkSkEbDSGv8q1ZgliY/eV9C2Wz0/P5KDc2CRmZW8QgQHFLIXvrCT
         HxvA==
X-Gm-Message-State: AOAM532wXJlU4DfUb0HYG1kysebJ7QpYjgeTcoliOVaBiFbu4kAphem6
        myO78AcT7fBo9mDDRwVjjf1qhKXYa58=
X-Google-Smtp-Source: ABdhPJyg8BQJejnjRRm1BTEU8FOHujUxCDxVRnY3wBbr0UdKdyaOqBiZbD58vEBD+v7h6w/GM/G4Tw==
X-Received: by 2002:a7b:ca50:: with SMTP id m16mr10037592wml.140.1626973181475;
        Thu, 22 Jul 2021 09:59:41 -0700 (PDT)
Received: from pc ([196.235.233.206])
        by smtp.gmail.com with ESMTPSA id n23sm24009425wms.4.2021.07.22.09.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 09:59:40 -0700 (PDT)
Date:   Thu, 22 Jul 2021 17:59:38 +0100
From:   Salah Triki <salah.triki@gmail.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
        ludovic.desroches@microchip.com, gregkh@linuxfoundation.org
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND] gpu: ipu-v3: use swap()
Message-ID: <20210722165938.GA4116@pc>
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

