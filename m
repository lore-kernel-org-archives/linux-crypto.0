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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BBBC07E9A
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Jul 2021 02:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C031E6120A
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Jul 2021 02:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhGMClY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Jul 2021 22:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbhGMClY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Jul 2021 22:41:24 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A4CC0613DD;
        Mon, 12 Jul 2021 19:38:34 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id h2so31003771edt.3;
        Mon, 12 Jul 2021 19:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=BM24k6H9LcY/dUUeA4LE+RhfS6GQmXK+4XERxfAvlv0=;
        b=oR2mglMxlqz8UVA4bDS/Vy20tMYeUdc0P45H4Di/KhCpwZEd0TIR4lhe1TtNTEnHYr
         Tm0C56cv0awj95FPRIVu7se2mMU/rSAEHmqocxvlyh5syHrXTEfLeWjeZgkb81XTlM85
         f9rK5ozXdDb/YJ6gh6HfN7xzzeAA+YYi6unlpvTknjVk034tFMpmtX4ZWbpLf8QcoJw3
         pt8YKgfC9IKMqQ3P545piuKy4BMbP3JrBaUmx1Ux4xkhqoDm9A6LnhKRNXyAMhfti6Wd
         2krhkIlXRR7oF9S6NvNlWrnxLRDJ/ncZLkLv+te0RSFmKSjEa4iwTLGdi/FAIKaayeRb
         9HHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=BM24k6H9LcY/dUUeA4LE+RhfS6GQmXK+4XERxfAvlv0=;
        b=cTnTmGy1oneZSLTbTcNjYhmf0O09By//+jwkdRZcIBSHdYAY49gSg9uB8XfxiCeGwf
         u8hDWFDtKKLk7BjuZGHXTImwF302F1LIEahRtIClY8CzWU5pAlrz1x4YJBiBzLDSb5Ra
         YjuNm0UOyb5fjPy2+19gRJsRrsW8VxgbB7YcbOwu6S2RPt0Z9+/tmW8PAaYZrqAVlq5O
         npqq4NucDsC8af5qZRNABWVWVDvagkcMsclkpjgYNPgPW6/uiL1fjbzzlZ1S/Txnj12S
         EBtmeJmd2wc7fc52nD0znpO420Zi06XsXmk/tP+n+9K7aGH29oM46clRq2EP7DoHW7Ws
         qPAA==
X-Gm-Message-State: AOAM533r4XzuxqahcDtja7myXGwTZJJSLnqkrFlUSNWjCCQ3X+JDBxmJ
        hFv4FRl8xL8GljAh82oym7U=
X-Google-Smtp-Source: ABdhPJyCdykS1tWU3nj+DHJ5VwHSHwsHr4XmdUj4TDsu6OHxOsPDqU8UBeD7gj48Jq6TkH36zDLUzw==
X-Received: by 2002:a05:6402:90a:: with SMTP id g10mr2427996edz.365.1626143913168;
        Mon, 12 Jul 2021 19:38:33 -0700 (PDT)
Received: from pc ([196.235.212.194])
        by smtp.gmail.com with ESMTPSA id n13sm7300744ejk.97.2021.07.12.19.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 19:38:32 -0700 (PDT)
Date:   Tue, 13 Jul 2021 03:38:28 +0100
From:   Salah Triki <salah.triki@gmail.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
        ludovic.desroches@microchip.com
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] use swap()
Message-ID: <20210713023828.GA1841817@pc>
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

