Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE9C0C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Dec 2022 23:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiL0XEm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Dec 2022 18:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbiL0XEV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2022 18:04:21 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA4DDF54
        for <linux-crypto@vger.kernel.org>; Tue, 27 Dec 2022 15:04:20 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id z7so9400150ljq.12
        for <linux-crypto@vger.kernel.org>; Tue, 27 Dec 2022 15:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ALCXqoODJG4Fl1tVrTYiR0YIC0rXIReKhT1lUtG3hdA=;
        b=yUVecZ76fCB6IvA+Cy8N88tPkw06p37lZ0KXjxTx3ZHIslky5t2WXlZV9KZb/ZaFPK
         26aLSaHZwMTeKto5N5oUi4HW12FrVrdFD8umOH9DB8DoPdV3MIL7bsFbWfGkoP0hxs98
         A3267hW+oerZP6yQzyh2Gn/JaxqbCm8XCBJ+q4M3H+jOIPsQae5d1TEuD0BUiFkp376H
         iY1LUWlWKCFJGekC4nxaq5WJczPk5sUoAFpX/DZC9cT8Plmy3MCkuutHjcmfNnPMxiJw
         fW3RrTjPpbINPMFi26xnHCtSRItCjMSvKI10Ew9AnhUQzNFoBTVYD4WHjeh3WLLPGBr4
         3LBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ALCXqoODJG4Fl1tVrTYiR0YIC0rXIReKhT1lUtG3hdA=;
        b=jWz/2/iZgG8RGlnYrz9wMvGuE/pr8nW4Z3UOiQiEaXYdkwwsoHfgzYZA9FNYtZZ3Kw
         VwMbE5PnaOkLjEdlvho9ryRScPWObtWYncPGO4WWhmQEAbEdIVdstciNkZJh1OIpwL0u
         fnlvVl2u72loZebiV5V/825RWzGv7K3OF60I7EsjTATdyZEjbRxcAKvbOv8aEiB2AFAZ
         bFUWgTH9hZtH+xRny8mTLlCqGGeDVGsuWk7Z0Z63M+CZGSVDtpmcEdGfRPcDW2yVlgXT
         nq25YPhDUl4d65iprvJdIUWW5upHGtuxM7W8F+zinHJbZEF8B+27LjLXZ/FW7IjVZ/P9
         oALg==
X-Gm-Message-State: AFqh2kq/3XhqWJu99qg7+1DAOVfopKgSsHscRivEcJL3mgTDd9n0H3lb
        94zqVhzkc86kMkSeyX0JELml1g==
X-Google-Smtp-Source: AMrXdXuLm80d+XZDJHjvTajcZdy9zM+KujZjLg2FBDMAjQSW+sWpH+i5cLf5CJvpjqnCzwbw8l2iiA==
X-Received: by 2002:a2e:b0d0:0:b0:27f:8b85:4098 with SMTP id g16-20020a2eb0d0000000b0027f8b854098mr6719151ljl.52.1672182260250;
        Tue, 27 Dec 2022 15:04:20 -0800 (PST)
Received: from Fecusia.local (c-05d8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.216.5])
        by smtp.gmail.com with ESMTPSA id bg25-20020a05651c0b9900b0027fbd4ee003sm876925ljb.124.2022.12.27.15.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 15:04:15 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 28 Dec 2022 00:03:37 +0100
Subject: [PATCH 5/7] crypto: stm32/hash: Wait for idle before final CPU xmit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221227-ux500-stm32-hash-v1-5-b637ac4cda01@linaro.org>
References: <20221227-ux500-stm32-hash-v1-0-b637ac4cda01@linaro.org>
In-Reply-To: <20221227-ux500-stm32-hash-v1-0-b637ac4cda01@linaro.org>
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

When calculating the hash using the CPU, right before the final
hash calculation, heavy testing on Ux500 reveals that it is wise
to wait for the hardware to go idle before calculating the
final hash.

The default test vectors mostlt worked fine, but when I used the
extensive tests and stress the hardware I ran into this problem.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/crypto/stm32/stm32-hash.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 5f03be121787..92b2d55d6e93 100644
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
2.38.1
