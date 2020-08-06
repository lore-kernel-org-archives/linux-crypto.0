Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0236C433F1
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 11:14:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13EF822D05
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 11:14:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=foundries-io.20150623.gappssmtp.com header.i=@foundries-io.20150623.gappssmtp.com header.b="blwBIVMk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbgHFKAj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 06:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729277AbgHFKAP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 06:00:15 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EEEC061757
        for <linux-crypto@vger.kernel.org>; Thu,  6 Aug 2020 03:00:15 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id p14so8292865wmg.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 Aug 2020 03:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=foundries-io.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=+V7CqI/htEIIY4PnseQyLNdhHuJMGQr2hPmi29hq7rk=;
        b=blwBIVMkBZZkw+M4KMDSy/63AIjjwVfHw43Oy0ACpSlXffJeTWN3CY93N5DaXkVswb
         3HO9lN0cc7W/frHVpA1yzI+9QdNdtcTSbJ3U12dMbNGAMRnPXC6uourzC0TxP02RMSW0
         2YZhbW77PIM3IWsGrmCnFyar1JiKYi8EC0zZ2eUfUIyLXV4zSaY/Tynm4kxpOKm0x7Tw
         o3yUaWgOxLx0kNiYBdmmp9itGhYWMLYKoPz53xjRL0+3b/ynmuHFvPDpqTtqpDB5wOs+
         //cXcteNIqc1KkQ1WluccIM7NTYAxYVY50qpNsTStA573o5lNYOfDyRXIlEtEwixDkW/
         xYeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+V7CqI/htEIIY4PnseQyLNdhHuJMGQr2hPmi29hq7rk=;
        b=ANd9FLrVdJTdgqHOyTLiRs/IVx8RVnOx5e4V9ZvIPjGUpHLEi4CCJqCBOQiix3W8UQ
         po1rOwxkLBMTsgq9yzPll2UQQ1WLGZMZHpoEBmMpqWepDwnY4jiGd0X9sXWCxhwn7nSD
         q9O511lNgnTz3I7G+luY2nkUdw+i3RXwDkAF/m1iSByTxudwJEgmg6CLlzsu6OdmyWRf
         mTjA47R7nXUfJM+jL+h7bNKJAlVbO+Gf2kM8WnI97CadykTFfvypFvlKWCwP2JDtsWXn
         vZezodiFn/mYmvo6LL9NWYZM8hLTzkLAWKoyIZ9cITMz/x4saVOdjKPMFGBWEMc1sJ1O
         WaDw==
X-Gm-Message-State: AOAM5333MT7JMhoOjrfOCEgaMcYOXob5hkmSTPX5aupghJ0fJiSQPuV+
        lK3VV3tknAJCna6gxI+JjzdrXg==
X-Google-Smtp-Source: ABdhPJwERWrzbPFeEbvwnDFlnCmx/Q90cpWFyXp3nyjuWcAWsrGJT8br/+ZFQznxexxykT9CnEnETA==
X-Received: by 2002:a05:600c:2154:: with SMTP id v20mr7189068wml.186.1596708014190;
        Thu, 06 Aug 2020 03:00:14 -0700 (PDT)
Received: from localhost.localdomain (239.red-83-34-184.dynamicip.rima-tde.net. [83.34.184.239])
        by smtp.gmail.com with ESMTPSA id p3sm5741376wma.44.2020.08.06.03.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 03:00:13 -0700 (PDT)
From:   Jorge Ramirez-Ortiz <jorge@foundries.io>
To:     jorge@foundries.io, sumit.garg@linaro.org,
        jens.wiklander@linaro.org
Cc:     mpm@selenic.com, herbert@gondor.apana.org.au, arnd@arndb.de,
        ricardo@foundries.io, mike@foundries.io,
        gregkh@linuxfoundation.org, op-tee@lists.trustedfirmware.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv3 1/2] hwrng: optee: handle unlimited data rates
Date:   Thu,  6 Aug 2020 12:00:09 +0200
Message-Id: <20200806100010.20509-1-jorge@foundries.io>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Data rates of MAX_UINT32 will schedule an unnecessary one jiffy
timeout on the call to msleep. Avoid this scenario by using 0 as the
unlimited data rate.

Signed-off-by: Jorge Ramirez-Ortiz <jorge@foundries.io>
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
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

