Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53E65C6FA99
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Mar 2023 22:32:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbjCJWc2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Mar 2023 17:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbjCJWcC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Mar 2023 17:32:02 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE009148B6B
        for <linux-crypto@vger.kernel.org>; Fri, 10 Mar 2023 14:30:39 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id a25so26673882edb.0
        for <linux-crypto@vger.kernel.org>; Fri, 10 Mar 2023 14:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678487430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=268bZ1TBueiybyhkcpErcA+C9yqfqKZytn9F0qROzMs=;
        b=WbmdjplXq98Xewg+y118GdddG0T2GZpR2Lv2/E3ifF6exl4IYQoLFQYyyIwWCZ4GLt
         NTNzbH8KnPh15cZHw6H6IVh5m5DxVU0eX787ZT9b2lCpn7vRtwZDMn/StenHYkx2lhEd
         aA+MSGLK6E8xpijpR590AwNAaT+xiFblPrDnPajvvjz+7yNfYb7YmfKf5p391xtV75iF
         FluPgocmtnvggbxFVGHtgUUeUAuY5jm0BqAymCoYnUMuW+HzzEML7aR2B7AtTzTOwXIx
         WpsN/IX7ihA+QtjwDwgoIkeDLgwFSGGhtqcfAJlhGXn3mz9dfZ/Sl/UVB2h20Qv3HN1y
         fibw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678487430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=268bZ1TBueiybyhkcpErcA+C9yqfqKZytn9F0qROzMs=;
        b=qYRfsU51YsqMAUfkplxk5s2M9eX3o+qXEy6DrzHP6lqFprgwebbWFnsl6ljvL0U8EU
         e4FZwuZn8tOSoYxOGs7ohHxpUl3cBXiL6NkomMu0X2AwnGWglTMEMiqnQDv1eyAVjR7X
         a0i/rGNK96F1rFB/M53SXVXtnaZtwcEDdUS4J1+lbxMcrNLBRitYQ9d0pzmj4XgdONzS
         dPP2us+UEHUA7mu3urMmA3IFOKt/5J7QBv/bTH8c1xewRzM8d+9/0Hdka8FuYlOTiD4R
         gzYej3Gc8UUk4Ev1Z1wyJAELl6YnC7tTCY4vDZkLXYdxx3dNKqITdeCA1qh1RPaiIJ74
         IFGw==
X-Gm-Message-State: AO0yUKURc3MEXMEjWqWbZmEvjUPhTCeR9HXwJLEgrY7UV72VoXSP8cNK
        6QvkwBdqNTBR0w1uDDi1L4wyaA==
X-Google-Smtp-Source: AK7set+39I2qc56oSch7xhdvqbptNHo5xMzdm85sdCUofyZHp7Ij1rQzQcSllFkME3nFWMD70VBWYA==
X-Received: by 2002:a17:907:6ea6:b0:8b1:7dea:cc40 with SMTP id sh38-20020a1709076ea600b008b17deacc40mr33181747ejc.9.1678487430083;
        Fri, 10 Mar 2023 14:30:30 -0800 (PST)
Received: from krzk-bin.. ([2a02:810d:15c0:828:34:52e3:a77e:cac5])
        by smtp.gmail.com with ESMTPSA id l23-20020a170906939700b008c5075f5331sm360279ejx.165.2023.03.10.14.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 14:30:29 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 2/2] crypto - img-hash: Drop of_match_ptr for ID table
Date:   Fri, 10 Mar 2023 23:30:27 +0100
Message-Id: <20230310223027.315954-2-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230310223027.315954-1-krzysztof.kozlowski@linaro.org>
References: <20230310223027.315954-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The driver can match only via the DT table so the table should be always
used and the of_match_ptr does not have any sense (this also allows ACPI
matching via PRP0001, even though it is not relevant here).

  drivers/crypto/img-hash.c:930:34: error: ‘img_hash_match’ defined but not used [-Werror=unused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/crypto/img-hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index fe93d19e3044..4e9a6660d791 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -1106,7 +1106,7 @@ static struct platform_driver img_hash_driver = {
 	.driver		= {
 		.name	= "img-hash-accelerator",
 		.pm	= &img_hash_pm_ops,
-		.of_match_table	= of_match_ptr(img_hash_match),
+		.of_match_table	= img_hash_match,
 	}
 };
 module_platform_driver(img_hash_driver);
-- 
2.34.1

