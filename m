Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC4FC61DB3
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Jan 2023 19:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239711AbjAJTTu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Jan 2023 14:19:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239790AbjAJTTj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Jan 2023 14:19:39 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99EAE532AB
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 11:19:38 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id bq39so20073440lfb.0
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 11:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4+OWBA1+r8w2OcO6/gRNLV+SbjGPnm7JmC4LYSiKYI4=;
        b=jBFgbqrTKPsUjyBlPD+b8nNXygbS1LXXv1GHK2bC7muFTSW1JsHYAScaB8fixOeuHc
         HvdeYk4vouKp/0mqM1dv3H+/J0x+HLagbcbmhz9ou//WaSxXfK+I30+MjgBO0T3zy0EN
         /t3dZd4wWhH6gycy4T1Ww6XiqvsSimqt0d0oPdHgbRU3qC+pocTqfp5ImtSim2tKwYUr
         NmWSyyHcZ4wTUFiJ+68vNutRqUZLfkBjERafNHs51FDjAfEuM95RjSRMPU1mqf1VJd6e
         giSSnRMUqcR06qzjnGtRab2jUroxcZD1GRC4zFUNIBB5fkCvQQ5JrIUIHR61QGxG3mXj
         FKAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4+OWBA1+r8w2OcO6/gRNLV+SbjGPnm7JmC4LYSiKYI4=;
        b=eJ07BhGqVsSJ7mrmYOASEIZ9agft6Jnjow5QY2pNlR7rDvh4l5hI0nWG8Wn9R4jeNU
         riUoaU0zyy866RSSNedgEo295EjlTBBe9SmoWZ+6RNYsu7bRz42zAyTScGSTgVPl7nXP
         7p5Fw2oNMRR0aruOslOhgKieXbuDCS3L4D+FBvCQVghKUfNdWklvr+1KqblYfm7Jng+r
         4xlsEInlG7HzVMeFJ9jnE8gzv4crqFBzVVe28msRPTufVPGVUL7aBRPdmkNyhNW4IFjA
         SXnV6n2QIhX/Ketx6UJ6Hfaj/iskpaqtH1aJ4H6LAf7EaXkmN40fYkGf+vG3L2XGi4u1
         G/dA==
X-Gm-Message-State: AFqh2kp3zjpRgZUoxXOxwBcZL2Ab11IbCTD81htwmsnFU+Aa9ikyBw98
        OfG2lpqGvM8nmq98/wnrSqiZOA==
X-Google-Smtp-Source: AMrXdXstDHWetjgC0Qv+so7RKr2iJFZe5YESIH6+9Zd+P8RgQ4tj3oBgosTOd+i05swE2dlUluhJgA==
X-Received: by 2002:a05:6512:3f26:b0:4a4:68b7:d625 with SMTP id y38-20020a0565123f2600b004a468b7d625mr24170805lfa.12.1673378376953;
        Tue, 10 Jan 2023 11:19:36 -0800 (PST)
Received: from Fecusia.local (c-05d8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.216.5])
        by smtp.gmail.com with ESMTPSA id x28-20020a056512131c00b004b549ad99adsm2297725lfu.304.2023.01.10.11.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 11:19:36 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 10 Jan 2023 20:19:14 +0100
Subject: [PATCH v2 3/6] crypto: stm32/hash: Use existing busy poll function
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221227-ux500-stm32-hash-v2-3-bc443bc44ca4@linaro.org>
References: <20221227-ux500-stm32-hash-v2-0-bc443bc44ca4@linaro.org>
In-Reply-To: <20221227-ux500-stm32-hash-v2-0-bc443bc44ca4@linaro.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
X-Mailer: b4 0.11.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When exporting state we are waiting indefinitely in the same
was as the ordinary stm32_hash_wait_busy() poll-for-completion
function but without a timeout, which means we could hang in
an eternal loop. Fix this by waiting for completion like the
rest of the code.

Acked-by: Lionel Debieve <lionel.debieve@foss.st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Pick up Lionel's ACK
---
 drivers/crypto/stm32/stm32-hash.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 0473ced7b4ea..cc0a4e413a82 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -960,11 +960,13 @@ static int stm32_hash_export(struct ahash_request *req, void *out)
 	struct stm32_hash_dev *hdev = stm32_hash_find_dev(ctx);
 	u32 *preg;
 	unsigned int i;
+	int ret;
 
 	pm_runtime_get_sync(hdev->dev);
 
-	while ((stm32_hash_read(hdev, HASH_SR) & HASH_SR_BUSY))
-		cpu_relax();
+	ret = stm32_hash_wait_busy(hdev);
+	if (ret)
+		return ret;
 
 	rctx->hw_context = kmalloc_array(3 + HASH_CSR_REGISTER_NUMBER,
 					 sizeof(u32),

-- 
2.39.0
