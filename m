Return-Path: <SRS0=6JMd=BC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89072C433E8
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 08:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E56720888
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 08:28:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=foundries-io.20150623.gappssmtp.com header.i=@foundries-io.20150623.gappssmtp.com header.b="0xDSj1eC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgGWI21 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jul 2020 04:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbgGWI21 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jul 2020 04:28:27 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52AEC0619DC
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2020 01:28:26 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id f7so4308543wrw.1
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2020 01:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=foundries-io.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=QHOcU/AHWfp7cpU6Aga751e/Kq9YnV85ILpM7tybMLY=;
        b=0xDSj1eCfkewU6SxDvs0V2R8p+CgnZDqvbz6mIc6P+gvyltTYobal9eWmYyUKMu3m9
         1oTEWl86BtIkIvVFp5x0rwMtn0/MQEwJIDONcotfp0x1UNOAQ0xg8BXtAFmfIA8xMb7F
         2J0uLIp9I/efzRWmoinDUuwWfl43ehWghPbAbh16vy1XaQDSAs24Uvnc1LX7I0Yhcb8Q
         oyBd6w2cvv7oNRlpKzd+b+XGpiNzAqsOZEYmZ7fPxKs+zTx4HylrNScZAVKDpL1KkYg4
         NvLEvdVF7/ALg8x4DCLxKjy5u4j9ZiyvBpar3AkahGUvKWp8CppQ7O+H5FZzt2rhnAp9
         PLEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QHOcU/AHWfp7cpU6Aga751e/Kq9YnV85ILpM7tybMLY=;
        b=ghsiDBj64gC48Qqj5nd//eETAb8K/Kl4o4oAnPnFY721MPGRhqevcV9MhSvlDC0XMG
         SQKozNb09deXBJjvWkY/4PZqFjocwen3xOJsi7Rn8nWbDHmjArN1XqCdpbyie92JSzJ4
         ctYKALDd8QABE8jHNwvlAAjVrbXXWPKPxSwXOEpGtqIxAO2jnDb2cybRJfqVW1gS+AXP
         5bRvD27DViERFFYvZccgAD3RwdcLuLlEodiQ5FfzLeC+Wr67z5DSrRSYQpccIVuNt6yx
         bvSSa8k5OAgo3M1qCnDn99BaKd40awj7lbm7Jj2AJLjJ+QA/OfqcroSVXvsvfrzwr4Hy
         CwZQ==
X-Gm-Message-State: AOAM530ZFCEPXLy83u6tvh9il8m5RPCFMZb3g2BAQwO09SQNGWzLB9ts
        ueRHpJCPjT+R0MATMaSbeDR9DA==
X-Google-Smtp-Source: ABdhPJxQ6EXvNVYCUYUekIzn3nYIzcWFPnO6PxCXC08mJeZNJ1Bi7LUTh5YCgrCQkmfKOYEoArZzsQ==
X-Received: by 2002:adf:edd0:: with SMTP id v16mr3229599wro.271.1595492905282;
        Thu, 23 Jul 2020 01:28:25 -0700 (PDT)
Received: from localhost.localdomain (126.red-83-36-179.dynamicip.rima-tde.net. [83.36.179.126])
        by smtp.gmail.com with ESMTPSA id o2sm2879094wrj.21.2020.07.23.01.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 01:28:24 -0700 (PDT)
From:   Jorge Ramirez-Ortiz <jorge@foundries.io>
To:     jorge@foundries.io, sumit.garg@linaro.org, mpm@selenic.com,
        herbert@gondor.apana.org.au
Cc:     jens.wiklander@linaro.org, arnd@arndb.de, ricardo@foundries.io,
        mike@foundries.io, gregkh@linuxfoundation.org,
        op-tee@lists.trustedfirmware.org, linux-crypto@vger.kernel.org
Subject: [PATCH 1/2] hwrng: optee: handle unlimited data rates
Date:   Thu, 23 Jul 2020 10:28:20 +0200
Message-Id: <20200723082821.26237-1-jorge@foundries.io>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Data rates of MAX_UINT32 will schedule an unnecessary one jiffy
timeout on the call to msleep. Avoid this scenario by using 0 as the
unlimited data rate.

Signed-off-by: Jorge Ramirez-Ortiz <jorge@foundries.io>
---
 drivers/char/hw_random/optee-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
index 49b2e02537dd..5bc4700c4dae 100644
--- a/drivers/char/hw_random/optee-rng.c
+++ b/drivers/char/hw_random/optee-rng.c
@@ -128,7 +128,7 @@ static int optee_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 		data += rng_size;
 		read += rng_size;
 
-		if (wait) {
+		if (wait && pvt_data->data_rate) {
 			if (timeout-- == 0)
 				return read;
 			msleep((1000 * (max - read)) / pvt_data->data_rate);
-- 
2.17.1

