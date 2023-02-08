Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9895DC64EC6
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Feb 2023 18:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbjBHSit (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Feb 2023 13:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbjBHSiW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Feb 2023 13:38:22 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82715D500
        for <linux-crypto@vger.kernel.org>; Wed,  8 Feb 2023 10:38:13 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id v13so21672046eda.11
        for <linux-crypto@vger.kernel.org>; Wed, 08 Feb 2023 10:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YfZc7P3L4wBNnQQQ85wu2I6wsnovvh4e+MgGEWnocfk=;
        b=ZBpTHLCOzMVFoTQz2Jv4TYznabdtVlf9SsXJ3IEnljIUSkls1CsSKMmmrVQAkzSPhg
         /EbaraW0GDrRpCzuBZ1XUU7R1ZNk6clJqwVjWcGTjWSGZPzPnCXEjdAX9u1/yl0PXxVU
         GlKnql0RJ+yH7icZuYdYWxhhiTQKWIjO2qqLTg0jFTckkMCwCwkiyKEh1GugzgZbRytI
         WqpVD0WWM46A3nN//MjpwMfjZdvwvx9+TPAnQ3ClO5PoFQ/4XHbUo+Smm1mxDidqYCOi
         w4PGWgwbh1RzMA0CBRtCu7l8AwLGgc03qvHrPSbG8vtUe9G5LdXIInRyr19bsD8ayOts
         HhmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YfZc7P3L4wBNnQQQ85wu2I6wsnovvh4e+MgGEWnocfk=;
        b=Bn/zUh0wkwo9SrPsgq9CiJzQz8iJhulfuyGl5y6BarQip1UUmmffDLa9KaPhNR22XW
         VQhO2tQnn3paUyZL8/SqjdeypTu6Z8OKGHsPo0JM36MFSiGmI2BXwcKHJEAfXHGPCikf
         RBAbjXmUKVtYe7AQ461p2UIZCtZpSQEgJJSR4T3Q28BGG9bHT+ng8IgQ5ARLxUnLIc0l
         k8o9sGetjHfgd2TNirAcfx041fBdCGWuUD8oU0XjdDxTHjtCKamu97xIlA0LFiw/n9U4
         BEMQ4z/0sd+oTOdRspqGUQ8g+RHOH2NzmFM8tUJWHLgGOQpElRNZbFw5flplTv7CqzGU
         UuhA==
X-Gm-Message-State: AO0yUKUIDqjtjr4wGUsQBLthJEsA/Z5jH5WBIM+n/kpyOXgUx6WYXQuM
        yWnD73kv4PTvV5WRM+Dv/UAMZQ==
X-Google-Smtp-Source: AK7set+cagKM9BkXSwtVGVWAopVYKfpge2UcnWjcZKoOJhfslhwYQ0HE0OsSczF2Wqb0Odj7qMPg7Q==
X-Received: by 2002:a05:6402:510f:b0:49d:fd2a:39cd with SMTP id m15-20020a056402510f00b0049dfd2a39cdmr10565597edd.1.1675881492090;
        Wed, 08 Feb 2023 10:38:12 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id d22-20020a50cd56000000b004aaa8e65d0esm5179663edj.84.2023.02.08.10.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 10:38:11 -0800 (PST)
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
Subject: [PATCH v9 02/14] MAINTAINERS: Add qcom-qce dt-binding file to QUALCOMM CRYPTO DRIVERS section
Date:   Wed,  8 Feb 2023 20:37:43 +0200
Message-Id: <20230208183755.2907771-3-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230208183755.2907771-1-vladimir.zapolskiy@linaro.org>
References: <20230208183755.2907771-1-vladimir.zapolskiy@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Bhupesh Sharma <bhupesh.sharma@linaro.org>

Add the entry for 'Documentation/devicetree/bindings/crypto/qcom-qce.yaml'
to the appropriate section for 'QUALCOMM CRYPTO DRIVERS' in
MAINTAINERS file.

Cc: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 94971603568b..864bf5b7520f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17199,6 +17199,7 @@ M:	Thara Gopinath <thara.gopinath@gmail.com>
 L:	linux-crypto@vger.kernel.org
 L:	linux-arm-msm@vger.kernel.org
 S:	Maintained
+F:	Documentation/devicetree/bindings/crypto/qcom-qce.yaml
 F:	drivers/crypto/qce/
 
 QUALCOMM EMAC GIGABIT ETHERNET DRIVER
-- 
2.33.0

