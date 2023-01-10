Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E591FC678DB
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Jan 2023 19:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239782AbjAJTTx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Jan 2023 14:19:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239801AbjAJTTl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Jan 2023 14:19:41 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9424E5329D
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 11:19:39 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id y25so20024067lfa.9
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 11:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xlq2CbHJ+i9XV8+jNLPey1GnGzkjb+RabVFKJfxLUEk=;
        b=cCr03c8OuR3SxnQcfmUXa5UYpYW/hjC3nMq95tqfrFBv83fwN8AaPfeyefx/H7Bnzt
         irg/urOSRix4aVAUCrwcXDVrm7lkLGBlURTs2ihDKek6Ust2Cq6BkaqTyLn6oPu/gk61
         j91iraxv1DqxLFZTvyMOqBKE6Rw5HZ2sqKRjkUAZAVgQkju6G9GjFHN8ULbsv3C3WBz/
         Q50vVOo9pFaaep4yYJ+RafWYHDsNAbrAPphVtujYgewY21XzgEsypCAYYJUNhkjARy1r
         NpqQvKxZIgr06PI1BDXxLk9uzjQVDV9uLtb4N2O3lCPB6Wj+RAidFQK5jwRSvuF81abZ
         Xy8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xlq2CbHJ+i9XV8+jNLPey1GnGzkjb+RabVFKJfxLUEk=;
        b=vqzb3KvkE5O6khMlhYDlg+GFyiF9K+q7iVJcJ2Omoh2SpO/AHRV17qbwHxxCl3E/zZ
         4IE4OGZfF+2cnBwKoXZC1LXSRURc6dOTx4Mjkxj+3ZP07EsKLVzbphKsGUMZHXRjA8K1
         BgVmmg6Q0KjTfVNtCZFUzyVzGd22NHnoAYNQ7ltOF4uyevk611VK6YjHW4+hnZShD+Cm
         ujVpxy0hX+YCJIl0Kd8/Y3OAzDKUjsjbssdJZ2CUbMq9EZX9M6D0pQH+bulBQES2lYAs
         /hFxVo+nDeSzreqI4Kc3HBurAtKeNOUxlbN4+d5OHc95LPeLk5lnHBlQL5CfrEGVXqAl
         Juww==
X-Gm-Message-State: AFqh2kpQ4ATstzMXSYROpTqYfmPjgTK1XpF65cjtg4z8dHzr6Z9v0B67
        GkMmnuPBcmXT4BDjaKxvX6rfUA==
X-Google-Smtp-Source: AMrXdXt72stXioSMjkZTM/iKtBKW04S+MylRrfbbR19vpORoaY2m0ITpHLr/qexleH2KJ/KJ7v47aw==
X-Received: by 2002:a05:6512:c1b:b0:4cb:3e50:f5e3 with SMTP id z27-20020a0565120c1b00b004cb3e50f5e3mr10337407lfu.61.1673378377977;
        Tue, 10 Jan 2023 11:19:37 -0800 (PST)
Received: from Fecusia.local (c-05d8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.216.5])
        by smtp.gmail.com with ESMTPSA id x28-20020a056512131c00b004b549ad99adsm2297725lfu.304.2023.01.10.11.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 11:19:37 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 10 Jan 2023 20:19:15 +0100
Subject: [PATCH v2 4/6] crypto: stm32/hash: Wait for idle before final CPU xmit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221227-ux500-stm32-hash-v2-4-bc443bc44ca4@linaro.org>
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

When calculating the hash using the CPU, right before the final
hash calculation, heavy testing on Ux500 reveals that it is wise
to wait for the hardware to go idle before calculating the
final hash.

The default test vectors mostly worked fine, but when I used the
extensive tests and stress the hardware I ran into this problem.

Acked-by: Lionel Debieve <lionel.debieve@foss.st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
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
