Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17573C636D4
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Feb 2023 13:51:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbjBBNvV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Feb 2023 08:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbjBBNvH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2023 08:51:07 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9ACF8FB64
        for <linux-crypto@vger.kernel.org>; Thu,  2 Feb 2023 05:50:54 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id cw4so2018300edb.13
        for <linux-crypto@vger.kernel.org>; Thu, 02 Feb 2023 05:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oCbqvORx24QYDOSwcFJXyWQd0s0yT+w31F5oNZstwBs=;
        b=bmmg3KkS0nzITvHmzjv661grJmumPmx8/8K9g7d7Oh2ZCJY8hOoUZkJPa8pJW46iYD
         xAUFij6lYoXFfTb6qfRo3Lsf8BCWXXwMx0a5Tm0R4zX/yck4nUWBqHsgAGvN3wDKJW00
         h7mqVxbLIE1aHkPdAYvP3UKDrAbhgXSgj1XOgnJBbxQuqi62knS/p3k6pq005OEpniB6
         HRUSO6nwBVTD0uzy1srgQD9UuyMWOuVzIsdrIHyqtg7g4mM39TsYYKQO80axpLvvCCQZ
         sYX2z+rMm6q4wdIrA9YAgC22BpOEDw9y+HYOGard8PEsZz4g3yk8vuc6isK4qabV+2Bk
         9T3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oCbqvORx24QYDOSwcFJXyWQd0s0yT+w31F5oNZstwBs=;
        b=VJebI1O+C/1/otJH8+9VCNbtcUSYSZ53y4hL39DritGstYK8KysnbHB3AmkLJ5x/AS
         OLbAdTFSO7OjZo4+dGfEDsAAvUeOD2FLNH4biEFdG8a39nmHVzZM8QrTuIaRe3oLFOdX
         KyOQkYOQCnQN/UO9b3VjdoQDd7EsH8xSCrQ0OOd5skPPahO6fLrYNIajEXh3EvYdszRP
         vtcIkPmoxIwaGU4EWd7i+Q+S5axbLt5grWsq/6DKY6FBBYfLri2w77XFRpwtj1GTi1wF
         zWzhcRwSneTkVb7pmPor39XBVgf74r5BuihCw2WrOT78c35lN9pORw4Q+wYPKE/JDTNE
         /YFg==
X-Gm-Message-State: AO0yUKUSlRaTuhR84NPqvQrCtwoNU6SKROcGPNESObaXEu9JVe8aqhGl
        keX81CVYt69TaNJe6mJ+3V0jgA==
X-Google-Smtp-Source: AK7set+5WXg+XjiI2lc5qdpF6HR4DET7H/I4VycOwstEgIu9xLxEX+9Wo3oax3fAcYLWaEOwdSh3PA==
X-Received: by 2002:a05:6402:74c:b0:4a2:590b:668a with SMTP id p12-20020a056402074c00b004a2590b668amr6528640edy.3.1675345854269;
        Thu, 02 Feb 2023 05:50:54 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id r23-20020aa7c157000000b0049e1f167956sm7596332edp.9.2023.02.02.05.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 05:50:53 -0800 (PST)
From:   Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Andy Gross <agross@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Jordan Crouse <jorcrous@amazon.com>
Subject: [PATCH v8 8/9] crypto: qce: core: Make clocks optional
Date:   Thu,  2 Feb 2023 15:50:35 +0200
Message-Id: <20230202135036.2635376-9-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230202135036.2635376-1-vladimir.zapolskiy@linaro.org>
References: <20230202135036.2635376-1-vladimir.zapolskiy@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Thara Gopinath <thara.gopinath@gmail.com>

On certain Snapdragon processors, the crypto engine clocks are enabled by
default by security firmware and the driver need not/ should not handle the
clocks. Make acquiring of all the clocks optional in crypto engine driver
so that the driver initializes properly even if no clocks are specified in
the dt.

Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: herbert@gondor.apana.org.au
Tested-by: Jordan Crouse <jorcrous@amazon.com>
Signed-off-by: Thara Gopinath <thara.gopinath@gmail.com>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
[Bhupesh: Massage the commit log]
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
---
 drivers/crypto/qce/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 336edba2513e..8e496fb2d5e2 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -209,15 +209,15 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
-	qce->core = devm_clk_get(qce->dev, "core");
+	qce->core = devm_clk_get_optional(qce->dev, "core");
 	if (IS_ERR(qce->core))
 		return PTR_ERR(qce->core);
 
-	qce->iface = devm_clk_get(qce->dev, "iface");
+	qce->iface = devm_clk_get_optional(qce->dev, "iface");
 	if (IS_ERR(qce->iface))
 		return PTR_ERR(qce->iface);
 
-	qce->bus = devm_clk_get(qce->dev, "bus");
+	qce->bus = devm_clk_get_optional(qce->dev, "bus");
 	if (IS_ERR(qce->bus))
 		return PTR_ERR(qce->bus);
 
-- 
2.33.0

