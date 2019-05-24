Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9359C072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 16:27:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADDD5217D7
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 16:27:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xkOIhFq0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390689AbfEXQ1p (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 12:27:45 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33574 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390720AbfEXQ1o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 12:27:44 -0400
Received: by mail-wr1-f68.google.com with SMTP id d9so10645685wrx.0
        for <linux-crypto@vger.kernel.org>; Fri, 24 May 2019 09:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BDVCH2sHIJOl3oTxOH2Xw8NSMYpE4DumvzxW/scZEI8=;
        b=xkOIhFq0XHfmFE1n3FRXs6JDt2lQu5s66J2ADnAbAa6G2kZ+fdlzQ6RAtv2nlGhsyM
         R1rf+nYHj8/njLWYLvOIXVxdniD8av3d/k/Pg2GCmUlhTOEeVlsr2y1JaK/4roNGmv8Q
         NxZ/oitIzGsyzysXL7SpXZWRuERubYmKXWV1S3WM1WxnKiqVxVODCo70sO5Gu3QvaDSX
         vFUPndyRzLKABkHMXXtWLuPUTiMH2UM5PqOREsziEIhZtW6wx12xwFyl3imoHDy5EFqg
         gM3CC7Te/YcQRp+VUJvX3mr3oZKOCbJF94ooJFH83CtwHuTJM1vKWOGqAttr+T3YCxoK
         UvHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BDVCH2sHIJOl3oTxOH2Xw8NSMYpE4DumvzxW/scZEI8=;
        b=ZlVdk15tMFwlR6YWXtOde9jtVMlZDUTC+ohijV1twu8l+H4pKzO8HM8eik3RZwHciw
         PFYoHqESYHN48QVdP0rslsOUrlF43R57cwBW3T7o3bhpSE4/YmZ1DLwTs+eqGwa0vW9j
         3bqO7dUvk7K8lDlqN66QY650BHNXGFyxabmKsD+h9J/iGfKCEwv7SwhcnAubC27UGMlm
         cmTcJ0oM6mv7T50wBTva3kpe2Vs5pgjDwq8mdPVkX/Uv1+Ym9pyFvSi4KE9cCM0x5D/H
         rp+/ms8K6+oobPH31h6clCH1NxEqbnjXoUs50DyWqTgrk9uRiz88STQrV1yWT9DEvOW5
         +rdg==
X-Gm-Message-State: APjAAAXLRkaQzxyB2xpZYIqCLXeQkXzzBBbl9jEIl0Nh9Jl3Oy9eWvMK
        6S+E873Ypk31q7A8BzB9eZbGtGe8uFnctHAr
X-Google-Smtp-Source: APXvYqxUvB1wZ5HmkiCejCPEp/9BFe7k2AxZDdmzViyasNUYn8c87N7Yp9bXOdxE1FhkAFbci5NyWA==
X-Received: by 2002:a5d:61c4:: with SMTP id q4mr53273464wrv.295.1558715263199;
        Fri, 24 May 2019 09:27:43 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:2042:d8f2:ded8:fa95])
        by smtp.gmail.com with ESMTPSA id l6sm2200320wmi.24.2019.05.24.09.27.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 09:27:42 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 5/6] dt-bindings: add Atmel SHA204A I2C crypto processor
Date:   Fri, 24 May 2019 18:26:50 +0200
Message-Id: <20190524162651.28189-6-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190524162651.28189-1-ard.biesheuvel@linaro.org>
References: <20190524162651.28189-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add a compatible string for the Atmel SHA204A I2C crypto processor.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 Documentation/devicetree/bindings/trivial-devices.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/trivial-devices.yaml b/Documentation/devicetree/bindings/trivial-devices.yaml
index 747fd3f689dc..a572c3468226 100644
--- a/Documentation/devicetree/bindings/trivial-devices.yaml
+++ b/Documentation/devicetree/bindings/trivial-devices.yaml
@@ -52,6 +52,8 @@ properties:
           - at,24c08
             # i2c trusted platform module (TPM)
           - atmel,at97sc3204t
+            # i2c h/w symmetric crypto module
+          - atmel,atsha204a
             # CM32181: Ambient Light Sensor
           - capella,cm32181
             # CM3232: Ambient Light Sensor
-- 
2.20.1

