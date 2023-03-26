Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF2EC6FD1C
	for <linux-crypto@archiver.kernel.org>; Sun, 26 Mar 2023 08:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbjCZIue (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 26 Mar 2023 04:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjCZIud (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Mar 2023 04:50:33 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130CA7EF8
        for <linux-crypto@vger.kernel.org>; Sun, 26 Mar 2023 01:50:31 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id ew6so24086127edb.7
        for <linux-crypto@vger.kernel.org>; Sun, 26 Mar 2023 01:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679820629;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HelX9TaRrTL0/uXiqpcAS3IoL+rsoXCQpE6cEfXOz3Q=;
        b=nXcN4xbgt18TOtDZK8uFwr6TCqdGFizMpBb60AEuO2T1D7SdGye5fAK2tnOgtiPdqD
         KXW+wCu1mbIxx9N0wmgaPehuUvS9wSxPrp3IMO6+DHgJHbJhWWpA8qXAkDkn6+WKLURl
         G2d9p1C5vukiSUC60DDr5HVzabzC6Ox6VYyRdrqJiDZ6DKENKSbzhdHUdf2LJEgVFl4g
         Xai5ZzXgZICPwmAlUxBnuaeUNniM9TgxCQoHbyoceebfbvIzaAeai1TUioBgN94k+NfY
         hUXpGw5h3Ax0rh1S1V3Zy1HdfUNbUkqdCoAoijqHn7TfRvUEND0m0CVbT8KpZf4/Imkc
         o5GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679820629;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HelX9TaRrTL0/uXiqpcAS3IoL+rsoXCQpE6cEfXOz3Q=;
        b=HQBjN9ZkVwplQD5ppOq7U4wem2Wlh2dyIE/hdAjBmIbo5hriBMVMXViOp5b2pD5jFL
         nvFdlY8Qx8fmJuBraVLJNcE1ivESAUbt6WMI5jVvqS1F27FRjyU0SrM0ru4Ew+1idM+3
         9CFsKrJEN8JY4h8rg3tGfOj69Y+9H7SQUSoAgLD9qcd2ABsCRjLDiiKgEid/qkYvspbp
         bk3XqoV1V9MUWaQbjvYzD1210JT6IR03SAd6YGmOrrQqFz4A6VvxZa8tv/YzdAvI6GDC
         sdOCViG7F1INojeLBv29vf3hu2y8Gx0o0PR/K6ok2WwjviEEFRsam+MpBcP2Xa8P89pY
         SPwQ==
X-Gm-Message-State: AAQBX9drvDaWTZd9fQ+Blf/lapQ9fdMQo6Aq/nlr4KqGNHX7hOrYdF65
        51SLObDy0bW0Ej9k6VwwhyMhaw==
X-Google-Smtp-Source: AKy350YURsee9IcVUspqIlMZJZ9hVHOq3HCdxcN5vA+XRdkAfAqpR6f3zs4y1LtjXTb6+g3+KaxoHw==
X-Received: by 2002:a17:906:ce26:b0:932:dac6:3e46 with SMTP id sd6-20020a170906ce2600b00932dac63e46mr10147737ejb.7.1679820629549;
        Sun, 26 Mar 2023 01:50:29 -0700 (PDT)
Received: from krzk-bin.. ([2a02:810d:15c0:828:6cac:926d:a4f2:aa09])
        by smtp.gmail.com with ESMTPSA id be8-20020a1709070a4800b0093f822321fesm1683165ejc.137.2023.03.26.01.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 01:50:29 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v3] crypto - img-hash: Depend on OF and silence compile test warning
Date:   Sun, 26 Mar 2023 10:50:27 +0200
Message-Id: <20230326085027.4759-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The driver is specific to OF platforms (can match only via OF table),
thus add dependency on CONFIG_OF.  Mark the of_device_id table as
unused.  This also fixes W=1 warning:

  drivers/crypto/img-hash.c:930:34: error: ‘img_hash_match’ defined but not used [-Werror=unused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Changes since v2:
1. Do not allow compile testing without OF.

Changes since v1:
1. Rework - depend on OF and add maybe_unused.
---
 drivers/crypto/Kconfig    | 1 +
 drivers/crypto/img-hash.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 3b2516d1433f..c636fbeb2144 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -647,6 +647,7 @@ source "drivers/crypto/vmx/Kconfig"
 config CRYPTO_DEV_IMGTEC_HASH
 	tristate "Imagination Technologies hardware hash accelerator"
 	depends on MIPS || COMPILE_TEST
+	depends on OF
 	select CRYPTO_MD5
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index fe93d19e3044..2be364d9f592 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -927,7 +927,7 @@ static void img_hash_done_task(unsigned long data)
 	img_hash_finish_req(hdev->req, err);
 }
 
-static const struct of_device_id img_hash_match[] = {
+static const struct of_device_id img_hash_match[] __maybe_unused = {
 	{ .compatible = "img,hash-accelerator" },
 	{}
 };
-- 
2.34.1

