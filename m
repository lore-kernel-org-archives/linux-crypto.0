Return-Path: <SRS0=g3pl=VW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A260C76190
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 19:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00614229F3
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 19:43:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="UQg/tDmQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfGYTnJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jul 2019 15:43:09 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38846 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfGYTnI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jul 2019 15:43:08 -0400
Received: by mail-wm1-f67.google.com with SMTP id s15so24385508wmj.3
        for <linux-crypto@vger.kernel.org>; Thu, 25 Jul 2019 12:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=HpwqwqbOJStimlLPjV2WsSVvFoS5zR7dipevAmhXn+I=;
        b=UQg/tDmQSfp9ChPaHt8EGlDQzZ6S/EdbxNg82he/Mzh8kwJ1qDpcDDkFMwLldt0cJc
         lCF8BYMyw+DpR0ybV0yCoNWYL08yFyuTbTqO6aSQREaMO43xW88KfpTm8GecjxL8rJGw
         GyauPYbXAUfd+wepxHqkp3tFKGMm0w8zorbYNjo6KTprUZWLwZ/Fo8VRDIu+/lxrhFXM
         eDgKBYvOFPyY6b3EkW8UL0kebH0JQ+M7KxuybGZKYAD/kf7iDXT6S2sTLL26ra0MIe4W
         Qa6E4+gr7U08eq2pNnQbGEPANNHi3nhHnEMX5iaonM8eETL+dQ37+c+wg0iR530FfwHU
         Nk5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HpwqwqbOJStimlLPjV2WsSVvFoS5zR7dipevAmhXn+I=;
        b=p0FZa//XzWzoYevdCp83eoZ+4khyfecg11Bt1hZd3sTMVbQe2MI3AdKANUqp4pmD+M
         DpElx1Ps6G+IJVJ/dCGuiroU4HqdNSnLszK/mfTfpZDfFoIT5o0ZxKrwQgM0pg0PHPld
         FGbfSdAnhnxgMBDk4QkTrVgzmJhG8JwunTmVWIJ0jOv6Q1eQhpNJFQPbaEw8+3A7z30j
         yGBlnfE3HMDchKVkIOYZFSoct4xE2LMlsahDzX2YM7QZly6QzzuxH+Xr72syBM1IKKCz
         YcrW/Y46q6Z5awlkn8pWSnMUne/yxavFjZLwWvGPaFugVKQYukg64vWfepyR2yp21X/7
         JmBw==
X-Gm-Message-State: APjAAAXotXq2j180HhwfQi0fYXeFx2nqBSAW5PN0xyYxltpzATgTy6jE
        lO7cKlf2++8NHZY9QY9SGU17RA==
X-Google-Smtp-Source: APXvYqxpAh0jfU//NVh88rL1qSwss1rtJWAjuYNhw8soBe0yFJ+ERG4l4cq/Ofn+pyhmxoEsDSGiRA==
X-Received: by 2002:a1c:cb43:: with SMTP id b64mr82451700wmg.86.1564083786567;
        Thu, 25 Jul 2019 12:43:06 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id y16sm103410662wrg.85.2019.07.25.12.43.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 25 Jul 2019 12:43:05 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        khilman@baylibre.com, mark.rutland@arm.com, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, baylibre-upstreaming@groups.io,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 0/4] crypto: add amlogic crypto offloader driver
Date:   Thu, 25 Jul 2019 19:42:52 +0000
Message-Id: <1564083776-20540-1-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

This serie adds support for the crypto offloader present on amlogic GXL
SoCs.

Tested on meson-gxl-s905x-khadas-vim and meson-gxl-s905x-libretech-cc

Regards

Corentin Labbe (4):
  dt-bindings: crypto: Add DT bindings documentation for amlogic-crypto
  crypto: amlogic: Add crypto accelerator for amlogic GXL
  MAINTAINERS: Add myself as maintainer of amlogic crypto
  ARM64: dts: amlogic: adds crypto hardware node

 .../bindings/crypto/amlogic-gxl-crypto.yaml   |  45 +++
 MAINTAINERS                                   |   7 +
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi    |  11 +
 drivers/crypto/Kconfig                        |   2 +
 drivers/crypto/Makefile                       |   1 +
 drivers/crypto/amlogic/Kconfig                |  24 ++
 drivers/crypto/amlogic/Makefile               |   2 +
 drivers/crypto/amlogic/amlogic-cipher.c       | 358 ++++++++++++++++++
 drivers/crypto/amlogic/amlogic-core.c         | 326 ++++++++++++++++
 drivers/crypto/amlogic/amlogic.h              | 172 +++++++++
 10 files changed, 948 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/amlogic-gxl-crypto.yaml
 create mode 100644 drivers/crypto/amlogic/Kconfig
 create mode 100644 drivers/crypto/amlogic/Makefile
 create mode 100644 drivers/crypto/amlogic/amlogic-cipher.c
 create mode 100644 drivers/crypto/amlogic/amlogic-core.c
 create mode 100644 drivers/crypto/amlogic/amlogic.h

-- 
2.21.0

