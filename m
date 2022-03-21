Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7704BC433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Mar 2022 20:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353146AbiCUUKu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Mar 2022 16:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353057AbiCUUJy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Mar 2022 16:09:54 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63A1182AFC
        for <linux-crypto@vger.kernel.org>; Mon, 21 Mar 2022 13:08:06 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id a1so20846048wrh.10
        for <linux-crypto@vger.kernel.org>; Mon, 21 Mar 2022 13:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=glbkwheqgo+YAwXKKccRcXjFIyD1/ids9/fwj2aHXuM=;
        b=IIFdmZFGMTy1XTsiFJ2yuqXCl4xUkZYDLDbpk+6xncAzjuKnt6aj29k14JEwZtQxcT
         q9iZem4IhopHHo2Pi25oKJ5SGuvfeQBLl/gneyZ22nthVW0TOqxNEFibVrf2TWeBOigu
         6NicvGvRoHntUToJ0n0snGfypZyo2f/OdxCLh6rBUHcwpIJRkXC1GGyq//bX6MUlHq9J
         Mbrv+brDGYH7J0c+BwIzgFLX26OOLAgUoTbAOKXNLUEuEosOi0lFGvrVmNvNb6EhZRNE
         IwuXCSte1ffXtUE4wxgTyKSlbwxn2ow0fCODAo0hi5WGjmDCLMR18NcyYERWnR6MfKlQ
         /Jiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=glbkwheqgo+YAwXKKccRcXjFIyD1/ids9/fwj2aHXuM=;
        b=0w4aotalFmQ7M+Nwsb2ySGVuZ5wLZahbvB7HE7c/ZEUOtToyHGUkUUCmB2frEJrLyJ
         XKS0bgpgCkW8GKube18kI4pXJXL/Q1M1zt6AQbNRkS8aKfU2AJ7JLtu0hZscqnUGIFeP
         SyFXfYkgwytf0yxtWXNSiii9crC7udJqFy4GtIU53xrnQE34nW/sYywnzkhJAPOFiLRi
         hssUpPleygU+8ySa/Upd1fj7kWBxWsgstRSjiRrf66MuL48UQHZrvhmOaI+sI//hW6Qu
         QIQOUni635mBxzaD9+8wq2w2tVH7m2vhySnIj4VecrGzTxSvSeJs0o4yJHmR7jWhZEux
         vuYg==
X-Gm-Message-State: AOAM532EPTJh/wt6WVH1BqlUZ/0KCpaUn3kVw2VGILzZb+C4gY3X8JJ2
        wnE9iuYqR82TGc3qFvUVWEsHHA==
X-Google-Smtp-Source: ABdhPJz7fCs1t2aqp8p1p2t3TcSgtujQDHRA0ZZy7GQGPnJaxekip2TbpedVAZt8pxnpLiZRg9JGPg==
X-Received: by 2002:a5d:6483:0:b0:203:801e:ad1b with SMTP id o3-20020a5d6483000000b00203801ead1bmr19292641wri.30.1647893285166;
        Mon, 21 Mar 2022 13:08:05 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id i14-20020a0560001ace00b00203da1fa749sm24426988wry.72.2022.03.21.13.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 13:08:04 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        mturquette@baylibre.com, robh+dt@kernel.org, sboyd@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v3 20/26] ARM: dts: rk3288: crypto does not need reset-names anymore
Date:   Mon, 21 Mar 2022 20:07:33 +0000
Message-Id: <20220321200739.3572792-21-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220321200739.3572792-1-clabbe@baylibre.com>
References: <20220321200739.3572792-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

reset-names are not necessary anymore for the crypto node.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 arch/arm/boot/dts/rk3288.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 26b9bbe310af..50f0890b3f6e 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -979,7 +979,6 @@ crypto: crypto@ff8a0000 {
 			 <&cru SCLK_CRYPTO>, <&cru ACLK_DMAC1>;
 		clock-names = "aclk", "hclk", "sclk", "apb_pclk";
 		resets = <&cru SRST_CRYPTO>;
-		reset-names = "crypto-rst";
 	};
 
 	iep_mmu: iommu@ff900800 {
-- 
2.34.1

