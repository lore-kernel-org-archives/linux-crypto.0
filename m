Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DDD7C433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 11:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A49361241
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 11:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbhKJLFO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Nov 2021 06:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbhKJLE6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Nov 2021 06:04:58 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D89FC06127A
        for <linux-crypto@vger.kernel.org>; Wed, 10 Nov 2021 03:01:23 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so1324772pjb.5
        for <linux-crypto@vger.kernel.org>; Wed, 10 Nov 2021 03:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rypbS1jQhxD+minj90kbROlU6qvWZNB4H4fxz7GH45w=;
        b=eYRatg+R0Gnpu0ntSnjoAR3UJbJXsaS3FMVNytVmlu4z/lchxwcywHviyow8KILpHZ
         peHxX8DhCILn8gr+YXz0e6gC7m+FDmCIauCHyOrSBsf7XglKRj31iY+ux0u9RoWIdsyn
         TcwLupkN3acv4/WrKCmscLssMK3GUBvsWL9ZCLPEJPgkK+ByZIU5i4lCjzgJj5xLeeLs
         j5WTL7HCPhAZavVsCbwifeSd1yrDCPrBshyMEoLwBgdx8Hf8S+IjszH8SX5pSFtss4qi
         +eLKGhKXkawBFTvIH4M2onW6ta1DOYvgmFadzr7fDk0L/lpmUMBSOgwRr8lUHvXRGqQw
         hgCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rypbS1jQhxD+minj90kbROlU6qvWZNB4H4fxz7GH45w=;
        b=R61yOFW3zGMJS5cWSqFmB/chNtoszgxkqWP+7hygtzSmwLwLuw7ITsMjRD6d3Hh6qu
         xa0e4oEU10jf/4VoGMFz5Cq9DZkU30I2ikj/J4eelmQ16cIC+B9DCgoSxKyQ1yqEUFEJ
         fPcCDsujCeCDtWgo6qrDVaecl26PhKMl30Qi9PEQOuj3BjE3uuwK+KlCjWqzyF4B/PO0
         EmQHVMDn2yuRXsO2QfWUm9vKCyDCsLxeyRpG5u0OlV/o0G4lNTJJX4FE8sCwdr5uXzjP
         A5SqOg1Pztu7exPkzytimQZ62aDBLoIzylLc6PLNizZowPl1//cO/4CzwCJcN+y/B5TQ
         RrqQ==
X-Gm-Message-State: AOAM533bLXJGxWfzsy/79Tgf1yX0yyXE/aoVUkbSvCrpebzHcwEuqxDf
        Ftv8aX53zzK/Aslo5q4cKt/ORuWtciF8zw==
X-Google-Smtp-Source: ABdhPJwvoWR2oZDeYdoqZr1ekGHBsPNhFe4Jc1GeY9EG7ajne5OayEZpzV5griYK0v7u1FnOV7qDQg==
X-Received: by 2002:a17:90b:1c0b:: with SMTP id oc11mr16073161pjb.237.1636542083180;
        Wed, 10 Nov 2021 03:01:23 -0800 (PST)
Received: from localhost.name ([122.161.52.143])
        by smtp.gmail.com with ESMTPSA id e11sm5585282pjl.20.2021.11.10.03.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 03:01:22 -0800 (PST)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, stephan@gerhold.net,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH v5 20/22] crypto: qce: Add 'sm8150-qce' compatible string check
Date:   Wed, 10 Nov 2021 16:29:20 +0530
Message-Id: <20211110105922.217895-21-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
References: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add 'sm8150-qce' compatible string check in qce crypto
driver as we add support for sm8150 crypto device in the
device-tree in the subsequent patch.

Cc: Thara Gopinath <thara.gopinath@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 drivers/crypto/qce/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index a7d7d7d5d02f..0a11ffacc2de 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -309,6 +309,7 @@ static const struct of_device_id qce_crypto_of_match[] = {
 	/* Add compatible strings as per updated dt-bindings, here: */
 	{ .compatible = "qcom,ipq6018-qce", },
 	{ .compatible = "qcom,sdm845-qce", },
+	{ .compatible = "qcom,sm8150-qce", },
 	{ .compatible = "qcom,sm8250-qce", },
 	{}
 };
-- 
2.31.1

