Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B7C4C61DA2
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Jan 2023 00:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbjAYAX3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 Jan 2023 19:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234119AbjAYAX2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Jan 2023 19:23:28 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A358A4B8A7
        for <linux-crypto@vger.kernel.org>; Tue, 24 Jan 2023 16:23:22 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id cm4so2059572edb.9
        for <linux-crypto@vger.kernel.org>; Tue, 24 Jan 2023 16:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9/AsczzAoIWOzK8lXXQYr+oZjWpK7SKdHJ3MVSXvuVY=;
        b=G5sSLdwLn4mg94HvxPiDfL7ErUh2JaPb1dvXZIK7dW4TB9o4KJCsGO+civsatRjENj
         eB5CnYxpgVTynGQFCDLap3gEHuE3VsV6qAYe6Od/8USkm/H7MwWPqfnnX/RD4qIjtb4S
         4Z+4o7PbWsOD+zftvKx/HqRqH16rruAVChrd2R9oDdlDjgoVptjcnZNvJ/16j23vI5lf
         h00IW0b2nnEDfMoEYQHgFLmj8fxPSXiaBc/rNFwJSp2Yef20EZnMAVwg9pnliUanstTj
         RFPP76mjCFI7dOc92UuDD547Rr68oFWF870u8NqijqqpfY6Jh7jvk8tpRry100+RA/VI
         88Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9/AsczzAoIWOzK8lXXQYr+oZjWpK7SKdHJ3MVSXvuVY=;
        b=FmLPtRGw7mTwFU6XDyexaxyFS+z11q3Lhk7CtzP8mJWDWMBcimCzjL1YceY6AxvyrJ
         R/HMmZpIK4xnoavoGbQW5pUwlmMnDvZtC0kaHDp9WEPKJvjhoMsd7pOZlx6nlF7MqLvZ
         /0MZYHgKcPBYzA4JEoiDfJCZdwoGcCn7qCEszEfxOQQMYKWOvA13ax5UIjsli3Zyn7bV
         L9Rk0JtW/lv8sv3UmNPPLAtESa9Uqq7AJSowtGDOOeb0kaqJroht7TrreLcfKprOauyl
         ZfzetDAsQcSb5gXJMKmPNa4khsMH3OcJ+uNjgW0Xze/8BHD/4Dl6IqNlAnHsfGlqyS3K
         Ol/g==
X-Gm-Message-State: AO0yUKXGEoZhPdHqo2R2gd8aHc0ayo25RLDXDo88JiAZHRXe8rUjGlsX
        bd0ld023AihQteVkD+IuayKrcA==
X-Google-Smtp-Source: AK7set8pICFlSnupzt+B/4dEj+GIHPXyXilClxiORWUNlNS5tqZ3vG+e4gQbF27oTL658xWqahpvKQ==
X-Received: by 2002:a05:6402:298c:b0:49f:a3d7:b84d with SMTP id eq12-20020a056402298c00b0049fa3d7b84dmr5449787edb.34.1674606201166;
        Tue, 24 Jan 2023 16:23:21 -0800 (PST)
Received: from fedora.local (c-05d8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.216.5])
        by smtp.gmail.com with ESMTPSA id if10-20020a170906df4a00b00738795e7d9bsm1584606ejc.2.2023.01.24.16.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 16:23:20 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 25 Jan 2023 01:23:07 +0100
Subject: [PATCH v3 2/6] crypto: stm32/hash: Simplify code
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221227-ux500-stm32-hash-v3-2-32ee12cd6f06@linaro.org>
References: <20221227-ux500-stm32-hash-v3-0-32ee12cd6f06@linaro.org>
In-Reply-To: <20221227-ux500-stm32-hash-v3-0-32ee12cd6f06@linaro.org>
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
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh@kernel.org>
X-Mailer: b4 0.11.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We are passing (rctx->flags & HASH_FLAGS_FINUP) as indicator
for the final request but we already know this to be true since
we are in the (final) arm of an if-statement set from the same
flag. Just open-code it as true.

Acked-by: Lionel Debieve <lionel.debieve@foss.st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- No changes
ChangeLog v1->v2:
- Pick up Lionel's ACK
---
 drivers/crypto/stm32/stm32-hash.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index d33006d43f76..0473ced7b4ea 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -399,8 +399,7 @@ static int stm32_hash_update_cpu(struct stm32_hash_dev *hdev)
 	if (final) {
 		bufcnt = rctx->bufcnt;
 		rctx->bufcnt = 0;
-		err = stm32_hash_xmit_cpu(hdev, rctx->buffer, bufcnt,
-					  (rctx->flags & HASH_FLAGS_FINUP));
+		err = stm32_hash_xmit_cpu(hdev, rctx->buffer, bufcnt, 1);
 	}
 
 	return err;

-- 
2.39.0
