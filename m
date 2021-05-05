Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5157FC43461
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 21:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 313EE613F9
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 21:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235007AbhEEVlN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 May 2021 17:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbhEEVk5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 May 2021 17:40:57 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D906C06135B
        for <linux-crypto@vger.kernel.org>; Wed,  5 May 2021 14:39:43 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id gc22-20020a17090b3116b02901558435aec1so1743628pjb.4
        for <linux-crypto@vger.kernel.org>; Wed, 05 May 2021 14:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gqMsEIhJm5EqUOgNeJCrpzezZPASaD0w7LK6NRTqosc=;
        b=pzbOscr85X4EFeeMDqwg9QrjOk6I1RQdc7g7pzKkYlY3dH0iLlhi72s1X2XWWMpM2s
         QvGZNRQjdPZvog/lGq4VdeZwsy30G1ovMEGiKDjmnF3dpiEVc4VY5vkv6HYQJFCfUfTf
         i2bPSmolUuj9lE2IcWYgkJhuddwgjd4LvHe7l2qploh7CB3JM4FVgmVE1glQAwOS5XQq
         wXIuEO7FDs7Fxr281q7alYvVu70/98vHSffE3Mt3lSJZom2aMOIdBTKI+W/EJDYnSKVP
         +3vhZCJfnYs76p4pTF/qWbBBv+Gnqoqrb8c0v7bdxxb6M0wFGRWsHruT524pi7sgCoQC
         nisA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gqMsEIhJm5EqUOgNeJCrpzezZPASaD0w7LK6NRTqosc=;
        b=RUqLXEqI1z4TZKSQqybepLWq7neTyQuVHHReOXW0lMXPTIk2IDgPhuk0F/YeE9OVoe
         8cIj/Jsnd+Rh0AB4zlRb40GMe1FCQNmzHHm1xXRXUM076JPLO1oNCIzaNYfs4HXEoxBb
         58TZVPwR+P7n1FqdGTfczn0Jl3H9z/BPHzK9qHiY4fu2YyQQbOmmUgW45dugl74vWA4h
         YqvgvJRL/sP5HwHWuo9iyLONXyqOIdDLSztTthaCCXj1O8/DlMYDB9+ZZqvuYZIotSd5
         20EndGRZ0qbw7j4Z34LD7rjUVQzkJAZWpKiZ9Y0XllA/G3Hcu6aWtsGc8bpfqt6y9idX
         9coA==
X-Gm-Message-State: AOAM531JnK0eeYiffoj03rhYEqLz4Kxnv5mbxpqvxqRACBJM4PzYFDoT
        JecBNEWwtxu+jtT+XvtUkWMqlg==
X-Google-Smtp-Source: ABdhPJyf8nn6KA3HWAacIkBqf+Zbuzkl16c37vrDWzE9zSrrG100mjqBC57zNCVbO7cuI0BgF0fwNw==
X-Received: by 2002:a17:902:b609:b029:ec:e80d:7ebd with SMTP id b9-20020a170902b609b02900ece80d7ebdmr771721pls.75.1620250782828;
        Wed, 05 May 2021 14:39:42 -0700 (PDT)
Received: from localhost.localdomain.name ([223.235.141.68])
        by smtp.gmail.com with ESMTPSA id z26sm167031pfq.86.2021.05.05.14.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 14:39:42 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhupesh.linux@gmail.com
Subject: [PATCH v2 16/17] crypto: qce: Defer probe in case interconnect is not yet initialized
Date:   Thu,  6 May 2021 03:07:30 +0530
Message-Id: <20210505213731.538612-17-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505213731.538612-1-bhupesh.sharma@linaro.org>
References: <20210505213731.538612-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On some Qualcomm parts the qce crypto driver needs the interconnect between
the crypto block and main memory to be initialized first before the crypto
registers can be accessed. So it makes sense to defer the qce crypto driver
probing in case the interconnect driver is not yet probed.

This fixes the qce probe failure issues when both qce and
interconnect drivers are compiled as static part of the kernel.

Cc: Thara Gopinath <thara.gopinath@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Andy Gross <agross@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: dmaengine@vger.kernel.org
Cc: linux-clk@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: bhupesh.linux@gmail.com
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 drivers/crypto/qce/core.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 3e742e9911fa..9915b184f780 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -222,6 +222,20 @@ static int qce_crypto_probe(struct platform_device *pdev)
 		return ret;
 
 	qce->mem_path = of_icc_get(qce->dev, "memory");
+
+	/* Check for NULL return path, which indicates
+	 * interconnect API is disabled or the "interconnects"
+	 * DT property is missing.
+	 */
+	if (!qce->mem_path)
+		/* On some qcom parts, the qce crypto block needs interconnect
+		 * paths to be configured before the registers can be accessed.
+		 * Check here for the same.
+		 */
+		if (!strcmp(of_id->compatible, "qcom,ipq6018-qce") ||
+		    !strcmp(of_id->compatible, "qcom,sdm845-qce"))
+			return -EPROBE_DEFER;
+
 	if (IS_ERR(qce->mem_path))
 		return PTR_ERR(qce->mem_path);
 
-- 
2.30.2

