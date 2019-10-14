Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F41DCC4CECE
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 05:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC6982168B
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 05:18:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GF/EoEen"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfJNFSr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 01:18:47 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34596 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfJNFSq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 01:18:46 -0400
Received: by mail-wr1-f68.google.com with SMTP id j11so18029762wrp.1;
        Sun, 13 Oct 2019 22:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VV3IaZnskbUr1GiFO2X9yDGhA134LORR3NXQx0QiOlA=;
        b=GF/EoEenQBXCUWJ2k0tzuqQR085/nEg2EkMXurnyEdNA2zKX6mjtAE5DIkxdZ0UU5Q
         wSofKEtnAsrgiJeTSdIjD03CU0AYKb/SncJB2yl5/6p80ZrpgWSQoPklhw3I461/0+89
         zm7Sp2nZb/rLh1lZG8RLs1GXPEV8El4hcQ661jDremdTBE5H9wt8573KGsGOPmbhlZoC
         1yHBDrCLpIEkaqxcvFLeaCQMEoWaNvrrRsqGeqp50z8CPYO7Fp7+cftycC7iLB4mmS0n
         QQzIa0U6xir7ZDLNcQlPRwVrRP3iWp9AdJI6aK3c+j38tJ61NbCXeZrw7E3NjzG116Gb
         keTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VV3IaZnskbUr1GiFO2X9yDGhA134LORR3NXQx0QiOlA=;
        b=dKrmCFsN2NRqEZjmFlD5wTc4JYhAkXf1jYR8L7eTE9PKNRKE8mHHuZobUdWgbqqfxG
         tBen3FMdn2rWczzxA3xuos8RZEVDZis5aJnMUaG6v/dUeTstf4G5yAHnedDDjuviPSu0
         CJcRMt/Pb0Obp3wF/eyKPv686oeoZGwZln9VtaznFLcLS03iY7oaoKL9tIWPdqtIrJwK
         OF53PqAIS/9FwtPic88EpHNdJfbayoOAth8JcLigX568J0cghhKZPrL74nwfS0dJw1ui
         lc4UTfQg5H3k1L8dsxJ3Zw6UHKi3y5EbE72EcjcwakNKqJORo5C9peDU/6ql5BG1oUfJ
         pXQA==
X-Gm-Message-State: APjAAAW7wuAiolgVdIEK6tvAceI+JIt+a7NpA2j89PzkSv7les8RtSj3
        h5kxHiqtgCI9Lq1ldvYOu+RroB0P
X-Google-Smtp-Source: APXvYqwSkfiMiVUM22hh3eH+vxUD6VrSroLzyJM2IkERg+/i7QXfkOq9fwEWbQq/e+W1/GbC3PcE0Q==
X-Received: by 2002:a05:6000:18d:: with SMTP id p13mr1507726wrx.396.1571030324402;
        Sun, 13 Oct 2019 22:18:44 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id 5sm14660340wrk.86.2019.10.13.22.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2019 22:18:43 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        khilman@baylibre.com, mark.rutland@arm.com, robh+dt@kernel.org,
        martin.blumenstingl@googlemail.com
Cc:     devicetree@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 0/4] crypto: add amlogic crypto offloader driver
Date:   Mon, 14 Oct 2019 07:18:35 +0200
Message-Id: <20191014051839.32274-1-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

This serie adds support for the crypto offloader present on amlogic GXL
SoCs.

Tested on meson-gxl-s905x-khadas-vim and meson-gxl-s905x-libretech-cc

Regards

Changes since v1:
- renamed files and algo with gxl
- removed unused reset handlings
- splited the probe functions
- splited meson_cipher fallback in need_fallback() and do_fallback()

Corentin Labbe (4):
  dt-bindings: crypto: Add DT bindings documentation for amlogic-crypto
  MAINTAINERS: Add myself as maintainer of amlogic crypto
  crypto: amlogic: Add crypto accelerator for amlogic GXL
  ARM64: dts: amlogic: adds crypto hardware node

 .../bindings/crypto/amlogic,gxl-crypto.yaml   |  52 +++
 MAINTAINERS                                   |   7 +
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi    |  10 +
 drivers/crypto/Kconfig                        |   2 +
 drivers/crypto/Makefile                       |   1 +
 drivers/crypto/amlogic/Kconfig                |  24 ++
 drivers/crypto/amlogic/Makefile               |   2 +
 drivers/crypto/amlogic/amlogic-gxl-cipher.c   | 381 ++++++++++++++++++
 drivers/crypto/amlogic/amlogic-gxl-core.c     | 333 +++++++++++++++
 drivers/crypto/amlogic/amlogic-gxl.h          | 170 ++++++++
 10 files changed, 982 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
 create mode 100644 drivers/crypto/amlogic/Kconfig
 create mode 100644 drivers/crypto/amlogic/Makefile
 create mode 100644 drivers/crypto/amlogic/amlogic-gxl-cipher.c
 create mode 100644 drivers/crypto/amlogic/amlogic-gxl-core.c
 create mode 100644 drivers/crypto/amlogic/amlogic-gxl.h

-- 
2.21.0

