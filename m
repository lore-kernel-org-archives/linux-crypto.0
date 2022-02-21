Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9DB3C433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Feb 2022 12:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357365AbiBUMJG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Feb 2022 07:09:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357338AbiBUMJF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Feb 2022 07:09:05 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE62201AB
        for <linux-crypto@vger.kernel.org>; Mon, 21 Feb 2022 04:08:41 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id j22so610742wrb.13
        for <linux-crypto@vger.kernel.org>; Mon, 21 Feb 2022 04:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CV5c3iXN0ZDroe+O7EtfCuby385XVMnLRIPAVIqOzLQ=;
        b=VzDjcwpFw8Bt4+sKQemYRvJXOFpFzlJC4o7nPKh7gBfc/1uZq9iZRUm/gUl0kzALwR
         oxPa9aCTLOW9FaGrfH7w7pLx0iVwTt/GOXHE768JxURnxqtjvX7Niy6SMgOihwz31ziU
         yiXn6isvXh+AOxd1bBRHl+XyKf89NyMrYj/FJQQ3/QHE0Lh4zHDWNZfayfVIsXYuqIiP
         rFEyNLRJGwn/TkVQQNt2eayE/f5SPebnOsJSJuaBmkUDnwTfOvuxe2egfKg+x5OrqbLW
         gPtWHM3dfsl5OfEkaprLcnzVF2zOuCiq9nLyXw6oGM2riIaq7T2S8PLyEtFKNZuRPqDc
         uwGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CV5c3iXN0ZDroe+O7EtfCuby385XVMnLRIPAVIqOzLQ=;
        b=zgCBngHi8/KFVsHjPFHRlrDHj4T/8x9bEkdvrgwpqp3SKP/aOJCvDEqGLBhlfVm6ug
         zVU0JbQI/5Nghm7aLMgerH6OzxLBEKX7gltGc0FvcwmZGRdpRlWyJVvyC835cZEa+a8j
         OPu3X2t1xbjNin10bzU6JRuFzMnTacfvPDPhIOkRyeT4JCbtCwdeMMlqjs4FwzWitSww
         wDeOl2dCKXhlxFpGHxlfpSCX/N3gnlASOEPQAZK+Myyv71g+DGXe69JViTDQFaXk6Lzp
         mYnutvzKOw0cfZff9YIj2SwL6G9q8/Cx7YW+f9f8fx62j+YG076qeNbcJH7pgT9v+GlH
         AwDw==
X-Gm-Message-State: AOAM532CRua8CgNdugvF20ohvdPdo9na+KEwENmqy3zWr7Z4mwlCkqEI
        2obTRHipcTYfyp+Bm+yIpFdjxS0SnoeUsQ==
X-Google-Smtp-Source: ABdhPJyecBtSfKLHEPz8mlqMUDjEEOgcR2GUvvzZ9e+5PQYFO/+gF3qRyJfmk0DgodzGmHicQFGuPw==
X-Received: by 2002:adf:ee0d:0:b0:1e3:f28:487f with SMTP id y13-20020adfee0d000000b001e30f28487fmr15441462wrn.620.1645445320385;
        Mon, 21 Feb 2022 04:08:40 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id a8sm11821546wra.0.2022.02.21.04.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 04:08:39 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     herbert@gondor.apana.org.au, jernej.skrabec@gmail.com,
        linus.walleij@linaro.org, narmstrong@baylibre.com,
        ulli.kroll@googlemail.com, wens@csie.org
Cc:     linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 0/5] crypto: completion should be ran with BH disabled
Date:   Mon, 21 Feb 2022 12:08:28 +0000
Message-Id: <20220221120833.2618733-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

This is the follow up of https://lore.kernel.org/lkml/Yd1SIHUNdLIvKhzz@Red/
and https://patchwork.kernel.org/project/linux-crypto/patch/20220127133332.4011509-1-clabbe@baylibre.com/
This serie fix all drivers which do not call completion with BH disabled
and add the check in crypto/engine asked by Herbert.
I have verified that this check does not generate warnings on all other crypto
hardware I got (omap, ccree, rockchip)

Regards

Corentin Labbe (5):
  crypto: sun8i-ss: call finalize with bh disabled
  crypto: sun8i-ce: call finalize with bh disabled
  crypto: amlogic: call finalize with bh disabled
  crypto: gemini: call finalize with bh disabled
  crypto: engine: check if BH is disabled during completion

 crypto/crypto_engine.c                              | 1 +
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 3 +++
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c   | 3 +++
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 3 +++
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c   | 3 +++
 drivers/crypto/amlogic/amlogic-gxl-cipher.c         | 2 ++
 drivers/crypto/gemini/sl3516-ce-cipher.c            | 2 ++
 7 files changed, 17 insertions(+)

-- 
2.34.1

