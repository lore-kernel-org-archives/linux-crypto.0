Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A72CCC61DA4
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Feb 2023 17:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbjBVRXC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Feb 2023 12:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbjBVRWz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Feb 2023 12:22:55 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A62C172F
        for <linux-crypto@vger.kernel.org>; Wed, 22 Feb 2023 09:22:50 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id y14so1475792ljq.4
        for <linux-crypto@vger.kernel.org>; Wed, 22 Feb 2023 09:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677086568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s4tu+9hvWNsyR0/yv5PN7ELWZurg0nfmLYekkIOjHbs=;
        b=aC4eFBO9CjSZD4SbilaG0x3E0WFLqmroIdlamMs9Uqf3+iwaw/gRm9mOmdiJ4x5Dkr
         2zAi7Qjy0VyssFoBDtrEfXOecsS+cky8NAn7rm8F6hGIWbv4lYVtc6CoVIs4CqtWOZr6
         +SJhCaGMQBsu60/+mJAo5XEO7Kqd1105i/jL2UOUqSdQvErMfyeba2jWXlAwgdq3RqHr
         tdE2DzxIr7AC851o/s9tz4lxaP8Dl9GhhAuho8n70GMRc9xR3xILW1WLV0ACnemESe85
         la39wCAxgddDCELUkAUJi+4FMN23DSW2gJSId2Dl3Xccnm+gmGHtZsJTx6w6rCqwWEK5
         +ykA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677086568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s4tu+9hvWNsyR0/yv5PN7ELWZurg0nfmLYekkIOjHbs=;
        b=JbbcqkibWpycp3EWSlHdoZRl30XdnZ+8Tpn9CmTR1Cg+L/gzPPekkfynaVWw9XreYb
         PFYQJcxr/MPDKuP4JkDpgIFbD3Jqx+MF+KfjTh/XH81U5i/uX9xDyosAI60/X7k1NEAa
         F5laVew1+iRQQXoLIi8J6ZssErAo0ul4FAihysOmI7xzlw07HvJfN8OUOp63vc9OlhFB
         an3BFJwvYAdFEiF8T3fz7TrOq09s6Q+XJzKFxroq1l/1GRB+fLk+1qJHJ6NELrH2dgV9
         3kFX3K2LoFtbeylIjomtvD474UdFl/pdlcP9Qcu2hBWkWePaLouZKBjFyX87DDSp0O4F
         Oggw==
X-Gm-Message-State: AO0yUKX07hwoI+xpXz5qrGfxKiyoLAP8riVAD/ih6EUKVV45HkDl/q77
        wdaJJsoDk6dOqdg8c7pw3vvMEGg2cXE0qqz3GjbfTD9e
X-Google-Smtp-Source: AK7set+RaJ+ThnPmwhdYHG6nl40jKfyR0wo16lTcWemAG7Qwy9OasE9kDaORO1pH3wMC8Y4jSNPTZQ==
X-Received: by 2002:a05:651c:ba8:b0:293:253c:a435 with SMTP id bg40-20020a05651c0ba800b00293253ca435mr3151964ljb.5.1677086568571;
        Wed, 22 Feb 2023 09:22:48 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id r3-20020a2e80c3000000b0029358afcc9esm805233ljg.34.2023.02.22.09.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 09:22:47 -0800 (PST)
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
        linux-crypto@vger.kernel.org
Subject: [PATCH v11 02/10] MAINTAINERS: Add qcom-qce dt-binding file to QUALCOMM CRYPTO DRIVERS section
Date:   Wed, 22 Feb 2023 19:22:32 +0200
Message-Id: <20230222172240.3235972-3-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230222172240.3235972-1-vladimir.zapolskiy@linaro.org>
References: <20230222172240.3235972-1-vladimir.zapolskiy@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Bhupesh Sharma <bhupesh.sharma@linaro.org>

Add the entry for 'Documentation/devicetree/bindings/crypto/qcom-qce.yaml'
to the appropriate section for 'QUALCOMM CRYPTO DRIVERS' in
MAINTAINERS file.

Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b0db911207ba..0d54050f2f51 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17275,6 +17275,7 @@ M:	Thara Gopinath <thara.gopinath@gmail.com>
 L:	linux-crypto@vger.kernel.org
 L:	linux-arm-msm@vger.kernel.org
 S:	Maintained
+F:	Documentation/devicetree/bindings/crypto/qcom-qce.yaml
 F:	drivers/crypto/qce/
 
 QUALCOMM EMAC GIGABIT ETHERNET DRIVER
-- 
2.33.0

