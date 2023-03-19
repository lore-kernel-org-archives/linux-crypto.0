Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD64CC6FD1F
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Mar 2023 14:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbjCSOou (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Mar 2023 10:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjCSOot (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Mar 2023 10:44:49 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F341CBFD
        for <linux-crypto@vger.kernel.org>; Sun, 19 Mar 2023 07:44:46 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id z21so37644975edb.4
        for <linux-crypto@vger.kernel.org>; Sun, 19 Mar 2023 07:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679237085;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wW0qmeq/XE/BS6QmstxltBCzT+Jl3DqWsgHErkJk2t4=;
        b=ZhlRshRBEeF/ffBl7mjoVExBy1LfUW86EngFn+0SoXLDONYnFeB0RjOhvD740DDdAq
         JiSAJjwb4kJ2Gg1MNMAr7Yyt/P8un0+y6PgqLhYkF4y5G4XC5Yl+O2vLHkHJ1NsiuEi6
         m3+E+ocdJ7X3Q0VM1iCfXmtc1F0YNyXt29IMQEL9VlQ58NeLCQfKJ8HRcfugC3lphXKO
         97ZOsbKI5k93f1iaVtpSgV3eu+AgDvQycjzPYCR4rZnsEGkIFfNuTAnnZS3EIyFUDF7k
         Q+QzYf8F08tq7D5hITFBmi11FLRyGxJgEQOxrK0mjWV14KpUzoADlhh8h71votf0T5ud
         4EZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679237085;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wW0qmeq/XE/BS6QmstxltBCzT+Jl3DqWsgHErkJk2t4=;
        b=LV9cSm+9FVp4lGIRxr80PdP+PD//PF5MAU5WHrcFAo3O+cmG3n6Veu0BJGKptvD8do
         aFOqH7txgzdeZHrzdG7KF+c2XmZOXkPB6E2cleJttMFcJvlyF+IK6ACASn7z+5qGrOcI
         efdOIoKgJ7W3gv7OMauW2YPYRFLk33qWmV5ATMmdWxbkeqsoxxmxQywdLNP/9mD4RpNG
         Ia1SU/vl3Xm35ucKGefxFgn8AyRk6mwdr2xhk8KTOUIOkw5V/19jRZo6FIoyExyE+2Gq
         48lIcsARipAd5ODnKG6uVUiYs+LlUEGuO/RAMo0L8Rm/kBmv7bA0KCSPDaPN6XP9xoIw
         QgOw==
X-Gm-Message-State: AO0yUKXXiHyamo8IuuM9ljvObtOW2hFZFiJwLEAPjn9jsXwuGZYmtFX0
        O2VAPeP3INbpDeA259q7x8Qg2w==
X-Google-Smtp-Source: AK7set/pmi9WCvGGmALTUjSWYkn5du0UgMhSPpbj8Do3+1D2jofLLlk23MQcoCW8cchbqZBOkChFpw==
X-Received: by 2002:a17:906:b349:b0:878:6b39:6d2a with SMTP id cd9-20020a170906b34900b008786b396d2amr6835060ejb.46.1679237084757;
        Sun, 19 Mar 2023 07:44:44 -0700 (PDT)
Received: from krzk-bin.. ([2a02:810d:15c0:828:5b5f:f22b:a0b:559d])
        by smtp.gmail.com with ESMTPSA id t14-20020a508d4e000000b004d8287c775fsm3583165edt.8.2023.03.19.07.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 07:44:44 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v2] crypto - img-hash: Depend on OF and silence compile test warning
Date:   Sun, 19 Mar 2023 15:44:39 +0100
Message-Id: <20230319144439.31399-1-krzysztof.kozlowski@linaro.org>
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

Changes since v1:
1. Rework - depend on OF and add maybe_unused.
---
 drivers/crypto/Kconfig    | 1 +
 drivers/crypto/img-hash.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 3b2516d1433f..4a4aff8b16f0 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -647,6 +647,7 @@ source "drivers/crypto/vmx/Kconfig"
 config CRYPTO_DEV_IMGTEC_HASH
 	tristate "Imagination Technologies hardware hash accelerator"
 	depends on MIPS || COMPILE_TEST
+	depends on OF || COMPILE_TEST
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

