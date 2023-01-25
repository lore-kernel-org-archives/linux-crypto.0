Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80C86C54E94
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Jan 2023 00:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbjAYAXd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 Jan 2023 19:23:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234345AbjAYAX3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Jan 2023 19:23:29 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497A34DE15
        for <linux-crypto@vger.kernel.org>; Tue, 24 Jan 2023 16:23:27 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id az20so43574603ejc.1
        for <linux-crypto@vger.kernel.org>; Tue, 24 Jan 2023 16:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XtSwGpV2j0nQXiZ+LcNdnpcv1hVjkJ1W08Bggr7Cjy0=;
        b=TIneo37BFcCoCvPMeBd+WYwoMRhtkaoPCmdy6r3Ws0YPEw99fpwL9/3Z9uvGBE8G5I
         J0pATloRutbCl+kMFdBctuX/JUuWrbwmXJqt0ZIKbXvl7cfejdjxN0iGJojYnm0HawTY
         +Pk9+qH+/lIxmXXnq7Iqzbfl3chdCfS7pl6Zw8sfTy99Ez9YeHDDZtnR/8UxtIMQJpvl
         88AJ+ATsMy51AlyxKQeUZjZIO7qOp1rNA9txjGTgCxfK6LtYcawgt68/Xu/YTlTQ7Lzt
         qB4+3/1iG6jrEY+Fs3ZJLGVFvwtVrxbJxaqyEmQrEFShhadwx4/8EKqUefbFNUlelut9
         M2wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XtSwGpV2j0nQXiZ+LcNdnpcv1hVjkJ1W08Bggr7Cjy0=;
        b=vfj6sW6/OyANXqzw4RVSbrr/WKfZTQQq0YjCDF9qxP9yAAK1raXdXIgNpln+A2okg4
         DEFABJ6LuJ5yo6CYP5S6XGvMJsgoyyEhOzO/hp1uuY1FZHCA4G26Ldygg8UhOQuOc2wd
         AdbZwTghZU8NqV6GHxtB+RzadgALLlTbysGL9FIitsE/zwGvY6nRFNenxARf4JNMeeAZ
         7LOuClrXL0SQcmnFtPI4QN1Aldqe5PrsnucWMNE3+zXV3oKpNutMziqz00rpVlykoXX0
         BO4zlTIZvivcLHxX44D08yvNAxTi3pCW/LmEs5qDpDlf/FMg4nkSgF7EOMTxJKk5Dx9X
         Idrw==
X-Gm-Message-State: AFqh2kofba+a224ript1L1JodK/pYHP7e5YTzuUTUJtDYvU21bz2qvso
        9fovgjKZ0meGUaYlNdT8aftg2Q==
X-Google-Smtp-Source: AMrXdXsWPHwaqA3WsFV3Zsw9CNtSgOoeqJLePtVfjlhhSr1kf3GR4doCP1rTJ0p7Jd0Cz9n8wGI1Zg==
X-Received: by 2002:a17:906:8298:b0:86d:be0:607d with SMTP id h24-20020a170906829800b0086d0be0607dmr32534825ejx.70.1674606204058;
        Tue, 24 Jan 2023 16:23:24 -0800 (PST)
Received: from fedora.local (c-05d8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.216.5])
        by smtp.gmail.com with ESMTPSA id if10-20020a170906df4a00b00738795e7d9bsm1584606ejc.2.2023.01.24.16.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 16:23:23 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 25 Jan 2023 01:23:09 +0100
Subject: [PATCH v3 4/6] crypto: stm32/hash: Wait for idle before final CPU xmit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221227-ux500-stm32-hash-v3-4-32ee12cd6f06@linaro.org>
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

When calculating the hash using the CPU, right before the final
hash calculation, heavy testing on Ux500 reveals that it is wise
to wait for the hardware to go idle before calculating the
final hash.

The default test vectors mostly worked fine, but when I used the
extensive tests and stress the hardware I ran into this problem.

Acked-by: Lionel Debieve <lionel.debieve@foss.st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- No changes
ChangeLog v1->v2:
- Pick up Lionel's ACK
---
 drivers/crypto/stm32/stm32-hash.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index cc0a4e413a82..d4eefd8292ff 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -362,6 +362,9 @@ static int stm32_hash_xmit_cpu(struct stm32_hash_dev *hdev,
 		stm32_hash_write(hdev, HASH_DIN, buffer[count]);
 
 	if (final) {
+		if (stm32_hash_wait_busy(hdev))
+			return -ETIMEDOUT;
+
 		stm32_hash_set_nblw(hdev, length);
 		reg = stm32_hash_read(hdev, HASH_STR);
 		reg |= HASH_STR_DCAL;

-- 
2.39.0
