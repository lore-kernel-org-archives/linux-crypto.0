Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77298C4332F
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 16:58:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 640816109E
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 16:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237943AbhJMRA5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Oct 2021 13:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238081AbhJMRAs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Oct 2021 13:00:48 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DC3C061753
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 09:58:44 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id d23so2916460pgh.8
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 09:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oNIscZN4pNeT8xlXkzpt1e9k3wuAf/h4QxrluxNZacc=;
        b=ym+HmUToOB0nIJ/6QJjlzffUg+ZcWGWEvFUbu1MlwxwjY9RT3TdDlfYqbIveutngzk
         u7Bj6p8alGws5CgUK5Y/qLqGBp9KYjczUgLzX87/cEPgc8cfB0zC6cVkJ26gkYjrV5NX
         NAcRDulgmaoJdYJ4c/XkzcieuK+CvkZMerl36a+RIJtgVcr6ZkGNUVpg3fvE/oQ84Nxy
         YULfAUGPPko6tWz52u3wMjgc9gbV1FQV4Qp13wUj0yLUyNQGyPoTkKLFFaaygFXqqZcx
         nZ9iMVPTFBpM99FYTwi4VhoyhCeTOEOUteL4cu1tcY35jb7HCWSH7N1eo8PCFXnhRegV
         WxRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oNIscZN4pNeT8xlXkzpt1e9k3wuAf/h4QxrluxNZacc=;
        b=xRJSm5yXMY2IZ1JHytdsBirQ4co0kMlxcHuySf/jRwKtgTukKVokgA9dxjM+9QZ0u4
         8QYvbZPOWzJDqXLoSMT4+wRf8YcVin2jLkcw6qnX0uXbhqldWAG2goHk6Imm+coWcCjJ
         Fk5Q4CQAPBoyAmHNpAY0tu66xDSwQk69nj8aqQ8dzrMhgn2Epz+FJNIcn33w4SKA0ZZX
         wr3wynmG/cncF08QlZW2FawkP6kpdXTY0QtCT9SaEVxBEeb9L00R07DBT38dKkxq67rB
         Wi83Oz4+N1V1ari1rGMcgpnjiUQBgEPsqYhflljKoPvIwJibYmwWqfROfDNG3kYkBapD
         MNbA==
X-Gm-Message-State: AOAM533zhFC3zSwaivPVxKFYQx/+NGoG6gmPRY6wlD9dfRqz767wyQv6
        hdQrIXv8P7LDHHrPKDWZ40PDKg==
X-Google-Smtp-Source: ABdhPJycuIqU30EM3ra9hlqSMZ7W8ZLMQTmaR6xBqWr0oIay7sNaTF6yyf/UJRlmDRa+BiVFJ6PdUQ==
X-Received: by 2002:a63:6a05:: with SMTP id f5mr203416pgc.97.1634144323611;
        Wed, 13 Oct 2021 09:58:43 -0700 (PDT)
Received: from localhost.name ([122.161.48.68])
        by smtp.gmail.com with ESMTPSA id z11sm6661602pjl.45.2021.10.13.09.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 09:58:43 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 1/2] crypto: qce: Add 'sm8150-qce' compatible string check
Date:   Wed, 13 Oct 2021 22:28:22 +0530
Message-Id: <20211013165823.88123-2-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013165823.88123-1-bhupesh.sharma@linaro.org>
References: <20211013165823.88123-1-bhupesh.sharma@linaro.org>
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
index 4c55eceb4e7f..ecbe9f7c6c0a 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -306,6 +306,7 @@ static int qce_crypto_remove(struct platform_device *pdev)
 static const struct of_device_id qce_crypto_of_match[] = {
 	{ .compatible = "qcom,ipq6018-qce", },
 	{ .compatible = "qcom,sdm845-qce", },
+	{ .compatible = "qcom,sm8150-qce", },
 	{ .compatible = "qcom,sm8250-qce", },
 	{}
 };
-- 
2.31.1

