Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FE07C433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 16:58:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C76761139
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 16:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237901AbhJMRAu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Oct 2021 13:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238047AbhJMRAn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Oct 2021 13:00:43 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B81EC061753
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 09:58:39 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so2806098pjb.0
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 09:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CZvmW6gpOIY8Lg6BO5LxT0GXA1DWFikx8MVUy0O3nh8=;
        b=jZafkBYRZZJL19BVpl8cMT5Fu/VthOYrmwDlAsl618GUnhD7IY3piXwR9KEUvHtA+G
         P7jCxmWDy90NyrqudklXJ9Ts+DRXY4n2y2YQjLny2i65guTFuED/QohCcNzQzr22oMeH
         CppHbgGPggCyDMj/IBQi2TexTyMIpRxwY8jqbGVQeXT7UoPiJXDtvpyCd4FAXslkqxbn
         MuPK/zgpLBWV7IIHSxW6jbaemE24sfDH9QTbVOlWc01Nf+hvdE+3qHnBuSeDwdI9V9nh
         Pa3MMkZ6G4rRYSIy1RwXvWG72dZFt8LmvmLM3d5opsEfWcUe32JP7gRvGRLVatpjtFbA
         Y/Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CZvmW6gpOIY8Lg6BO5LxT0GXA1DWFikx8MVUy0O3nh8=;
        b=f/DG8D+XIM8iTG65E4isPBquRN051j7OHqiP8QjFAr6OBtxPtkHWsqEIHfFaXopqNh
         PYbsP0C6zxeuGSUDMX5v3FtyddDOzXxqRyXLPp+Dyz/5juwFlmFLuHh2LOo+NxhS5uIr
         8k56EiJDdOgdp2iSjwMfHxJNADxYtv0vEyratACpjnuq8MXpNmmB8x5STtf7GTngo6Nz
         f4H9nbnn3XcTboABftfNda2/Ib1lmKeIntW/P8/EliRKS283+z6GpUFVup3d3pKSkXsU
         CcMhMZi3W05zummn9wzKGZ1hPcbhN+O6GZcFtYA/oa3ZJ8ANayW56rs+4rIfvqMfwcvu
         IEtw==
X-Gm-Message-State: AOAM5323ErOo41BlhT6KY1vRuYv/05q0gLPsbWPyuXqNJ/DAWP3Ptd/9
        QuyYO0O33oPj0iiKaER4PYQV/g==
X-Google-Smtp-Source: ABdhPJzMxHk/aANrs4y+2UIcI5V5euPkOIsB5ME2tTGztPXFvWzA4Wi9RYOD2KaSn6Tey8y0qlvlGQ==
X-Received: by 2002:a17:902:8648:b0:13e:dc2c:a594 with SMTP id y8-20020a170902864800b0013edc2ca594mr335542plt.23.1634144319026;
        Wed, 13 Oct 2021 09:58:39 -0700 (PDT)
Received: from localhost.name ([122.161.48.68])
        by smtp.gmail.com with ESMTPSA id z11sm6661602pjl.45.2021.10.13.09.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 09:58:38 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 0/2] Enable Qualcomm Crypto Engine on sm8150
Date:   Wed, 13 Oct 2021 22:28:21 +0530
Message-Id: <20211013165823.88123-1-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Qualcomm crypto engine is available on sm8150 SoC as well.
It supports hardware accelerated algorithms for encryption
and authentication. It also provides support for aes, des, 3des
encryption algorithms and sha1, sha256, hmac(sha1), hmac(sha256)
authentication algorithms.

Tested the enabled crypto algorithms with cryptsetup test utilities
on sm8150-mtp and sa8155p-adp boards (see [1]) and also with crypto self-tests,
including the fuzz tests (CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y).

Note that this series is rebased on the corresponding 
crypto engine enablement series for sm8250 SoCs (see [2]).

[1]. https://linux.die.net/man/8/cryptsetup
[2]. https://lore.kernel.org/lkml/20211013105541.68045-1-bhupesh.sharma@linaro.org/T/#t 

Cc: Thara Gopinath <thara.gopinath@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>

Bhupesh Sharma (2):
  crypto: qce: Add 'sm8150-qce' compatible string check
  arm64/dts: qcom: sm8150: Add dt entries to support crypto engine.

 arch/arm64/boot/dts/qcom/sm8150.dtsi | 28 ++++++++++++++++++++++++++++
 drivers/crypto/qce/core.c            |  1 +
 2 files changed, 29 insertions(+)

-- 
2.31.1

