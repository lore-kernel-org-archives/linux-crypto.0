Return-Path: <SRS0=tkOt=CC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C765BC433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 14:01:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A15802065F
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 14:01:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GhFho+Wh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgHXOBQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Aug 2020 10:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgHXOBM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Aug 2020 10:01:12 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7275C061573
        for <linux-crypto@vger.kernel.org>; Mon, 24 Aug 2020 07:01:11 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id o22so6153451qtt.13
        for <linux-crypto@vger.kernel.org>; Mon, 24 Aug 2020 07:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=XdATegxPLjRZ1S4FVShTFf9GHc/aayt9pgohmSeXGf4=;
        b=GhFho+Whb925lK0QvwZZEgD0KL8uGJe1twqMwtHZtWQaDfE8W0VNo+ipvLaU7nryjW
         UZM7kB4GEZQ2Bsq/EtYNhpYtIhVGwiwNnQLVpIBzsE0WUBn+1E+KwkeVGJhya/AtjDnp
         bHaEGkoLh5rJCO0r2U7UtOIELog4bKxkYvJWo8pBec2B50/3Gx2V/WIEYOljIhbcQwVu
         VRf/zGfsRgoC0v9MadZLvNdExBejZ6zT8a1JpJnl1an7fnEno2ftEMSWuUOSLe6ZHC0Y
         b8pjkNzxJZJIFWk2XtHzP9tDKe31O4MRj1RQyR3RPXDkn0Obd/psbCMq0TOz1NjCGk2H
         KLow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XdATegxPLjRZ1S4FVShTFf9GHc/aayt9pgohmSeXGf4=;
        b=WiJD/r2ya3SBkhdUyETaRaEmQyQISLUnGFwmCaJVsgbXv/abdhSEFXUbsOHOJ9TrT/
         keg//JpSUj0niN4OppG4B/dLrOJbq+WIrkQoobbFbsXb/jPHR1xAr+aPaDkGKAv8tpoZ
         /cVOUOrfYfxJH4FoYBq0C9empALeJ1mpNuDUGS+NPpTTomjGOjUPr0I6fbDt2lNmKcNm
         hTfRDFN+4hG61Qi8l1byEa2zI2o3d5Y1T7Psathe4oVsq82nat7gF6vGZdXYcpyLjGFS
         giLsuaH4HhAmG3wPSNCsmsCuY2mmbIcnKCuHhKNJBOJ7AFjAX2+IH0QW9nEM8b4yJAYw
         DSMg==
X-Gm-Message-State: AOAM532cTwUa4Os1ppbwfkqsElkvl4jxeieyQoCkS/3AunZKuP7Y1qv5
        xUVeeZ/rihlXeop8KjmNs79KLzhGKcc=
X-Google-Smtp-Source: ABdhPJy3v6o9XZ+hI2AtpPbRiWrP20uHMzFlskDAgpOiz2CxRlsxZqrx8wKYr4u2FNcM2Pfv/5rkog==
X-Received: by 2002:ac8:22e2:: with SMTP id g31mr4681700qta.214.1598277669675;
        Mon, 24 Aug 2020 07:01:09 -0700 (PDT)
Received: from localhost.localdomain ([177.194.72.74])
        by smtp.gmail.com with ESMTPSA id r20sm3244459qtc.87.2020.08.24.07.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 07:01:08 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        mcoquelin.stm32@gmail.com, Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 1/2] crypto: stm32/crc32 - include <linux/io.h>
Date:   Mon, 24 Aug 2020 10:58:39 -0300
Message-Id: <20200824135840.3716-1-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Building ARM allmodconfig leads to the following warnings:

drivers/crypto/stm32/stm32-crc32.c:128:2: error: implicit declaration of function 'writel_relaxed' [-Werror=implicit-function-declaration]
drivers/crypto/stm32/stm32-crc32.c:134:17: error: implicit declaration of function 'readl_relaxed' [-Werror=implicit-function-declaration]
drivers/crypto/stm32/stm32-crc32.c:176:4: error: implicit declaration of function 'writeb_relaxed' [-Werror=implicit-function-declaration]

Include <linux/io.h> to fix such warnings.

Reported-by: Olof's autobuilder <build@lixom.net>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 drivers/crypto/stm32/stm32-crc32.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/stm32/stm32-crc32.c b/drivers/crypto/stm32/stm32-crc32.c
index 3ba41148c2a4..2994549beba3 100644
--- a/drivers/crypto/stm32/stm32-crc32.c
+++ b/drivers/crypto/stm32/stm32-crc32.c
@@ -7,6 +7,7 @@
 #include <linux/bitrev.h>
 #include <linux/clk.h>
 #include <linux/crc32poly.h>
+#include <linux/io.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
-- 
2.17.1

