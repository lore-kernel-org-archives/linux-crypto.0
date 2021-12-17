Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5008C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Dec 2021 09:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbhLQJWr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Dec 2021 04:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234088AbhLQJWq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Dec 2021 04:22:46 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794E1C061574
        for <linux-crypto@vger.kernel.org>; Fri, 17 Dec 2021 01:22:46 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id a18so2812425wrn.6
        for <linux-crypto@vger.kernel.org>; Fri, 17 Dec 2021 01:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:from:to:cc
         :subject:content-transfer-encoding;
        bh=1yfNCo8VRhdwK/7VGC16YL9MFDVWcjraEVxKJN7nxPM=;
        b=U1k+UuMfGPjj5ihhGsVe7t8IWQ91SiXkRwaQk8avDprb4IJR8WgyT3z8tm4EoTl6UF
         lniK9xvQhtJ/S5zKxTWpXCcUDJHfSZpoe9permN0WmQNWINQN6VWJooK628lzD7uC9++
         E+UYXxIHM8pTI4i1w5vWjYPlAdqmrcMJshKhbihOlucqhZHnI9y48yFcfOfr2s8RzbQg
         FHumWrVUku5+7C9ydRDnYoAg+fqNBlVyRk6/kMAamnobE/QVkbTAh1dZYXnJz1j4MWsY
         25FnC6ojBbA5n+Cmwjj8OCUN9jtenSrF2fXjWPQs9PZmJYeNctl1wRMgQud/JNUQSSrK
         Mz8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:from:to:cc:subject:content-transfer-encoding;
        bh=1yfNCo8VRhdwK/7VGC16YL9MFDVWcjraEVxKJN7nxPM=;
        b=LnpTtpOKBn1GnFPkA3thB5S7/4pM01m8AY0/oO9+zHB7t94FIcEktB2e2sjzhia7vC
         1YdcImNVrCITjxXPrf0Ct+9DfY/5yVUDOHy976JUC2RdWXQWcSfWxyGGE1KHrqFno8i8
         Bo1JjBtTAZ1LHMTeamuPpiHVk6+xuCjtYSwe8WmPbxVcmMJaTK0GHHcRhAhFZ2Q8OND2
         v0wA8X8g1Hs74cpjk2rHS9UhFhDMl9yyWAHZrzhMJo4ixRrFt0h6DWJnNMGM/c+7pyll
         YX//YxyNvV48WcF2ALtJLMC0IakcSnS4L6E3JfZ7U2uZoHPUawDuyvSb3cyZ8ACb/OwF
         TM9A==
X-Gm-Message-State: AOAM530EmSwlwCk8+gyIPMswF7ArnpMK9Q+5EblF6yYrB7Fa4pLfZ7bz
        EtJ0ziFAf1KtFcfO+t3k4JUhDlCGCRs=
X-Google-Smtp-Source: ABdhPJxB/qMkQeO73a4E0Nr979wj/740Iq9suuCSF4Ri020SCDqIlOxy1kWYzfPG8w53rfj9uYvQ/g==
X-Received: by 2002:a05:6000:1564:: with SMTP id 4mr1709823wrz.9.1639732965050;
        Fri, 17 Dec 2021 01:22:45 -0800 (PST)
Received: from ?IPV6:2003:ea:8f24:fd00:5c04:3253:ca5d:176d? (p200300ea8f24fd005c043253ca5d176d.dip0.t-ipconnect.de. [2003:ea:8f24:fd00:5c04:3253:ca5d:176d])
        by smtp.googlemail.com with ESMTPSA id j85sm11729447wmj.3.2021.12.17.01.22.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Dec 2021 01:22:44 -0800 (PST)
Message-ID: <ed1ac2f8-5259-684d-42c8-effdf2920e78@gmail.com>
Date:   Fri, 17 Dec 2021 10:03:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: omap-aes: Fix broken pm_runtime_and_get() usage
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This fix is basically the same as 3d6b661330a7 ("crypto: stm32 -
Revert broken pm_runtime_resume_and_get changes"), just for the omap
driver. If the return value isn't used, then pm_runtime_get_sync()
has to be used for ensuring that the usage count is balanced.

Fixes: 1f34cc4a8da3 ("crypto: omap-aes - Fix PM reference leak on omap-aes.c")
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/crypto/omap-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 9b968ac4e..a196bb8b1 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1302,7 +1302,7 @@ static int omap_aes_suspend(struct device *dev)
 
 static int omap_aes_resume(struct device *dev)
 {
-	pm_runtime_resume_and_get(dev);
+	pm_runtime_get_sync(dev);
 	return 0;
 }
 #endif
-- 
2.34.1

