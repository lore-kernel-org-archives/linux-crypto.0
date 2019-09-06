Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F666C43331
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 18:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 549B120838
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 18:46:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UF6J+7FY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392087AbfIFSqF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 14:46:05 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39569 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390235AbfIFSqF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 14:46:05 -0400
Received: by mail-wm1-f65.google.com with SMTP id q12so8171659wmj.4;
        Fri, 06 Sep 2019 11:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xrcge4xWSXW5K31t/HQVYFW44MIvXTrC+21SSJQ7ljI=;
        b=UF6J+7FY9nlRmV8MXdouTLIlk/PpuSE8Z9pSuifFCXnHcXTCm0fulWoCKMBAzrzRVi
         obsHYkHyHVJ3OSDqjzsFeZk544ak+rV+yH1Pn3qhjWsd5KRhsiU1SxR+8BL6110HXWQC
         Ujngu9jHfWMF3MycgtptWTwvEJNMRss+ip0TzJeuk/k3eeemWAdwOtkLYuSz0H8LUE+e
         FSQoGBUbAG/np/5n0NRInUUBJy8+oA7+USY0+cnxduQSk6oefxcmQpjXRyU3mzDfPRIW
         lzGBmFxrexM/E3tXPMJg9a8Z4wBJpoyj22Wy061OwTKatx0o03sE7BmpDA5hWsvPoXRh
         Poxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xrcge4xWSXW5K31t/HQVYFW44MIvXTrC+21SSJQ7ljI=;
        b=h7/ECtFPXNEcZiVh/qwVlM5YT7WcoXB3ixXJwYnCV/aV45Of/753C0GRg4NojFFP3L
         q8NBG2DiveF6WWBD92/VRMVQxreU7+jY9p23YVEO5ZQVNb/lLAgEMukD0Ob5293iHQwS
         eaxchRk/cwK3ZXuY9clPyYW3TRho5gf0WFRgsQJkJHtZkh7GH+n4NSGZ+O1x+V6w8dO9
         x/qLRBcgBYFFoJJU+O8ulrYOY687zTLny8VmlWBRa9Kd6CCMjSxpOS+UVu6soTaeOszL
         SLhSt0+XVn8pCO7TcFjqkoAudw/xaQdfKX/+aHO1n9Oenvl2td46FZDzhEe0aOLV2YST
         WDMg==
X-Gm-Message-State: APjAAAUNxppdwLQup3g9NflPB+tlLmQpJccc2AvjN6EYqIcxUzd19xrj
        6AQdAle51X4yGczuX4YpOIg=
X-Google-Smtp-Source: APXvYqwGlyUteBngMNlLK5XdG8uuNUUdHWlmcx4mol+MpShd8I2m1TXqYmGsLUTxg6Pg1YojLCiRjw==
X-Received: by 2002:a7b:c447:: with SMTP id l7mr8159910wmi.33.1567795562952;
        Fri, 06 Sep 2019 11:46:02 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id j1sm8677577wrg.24.2019.09.06.11.46.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 11:46:02 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux@armlinux.org.uk, mark.rutland@arm.com, mripard@kernel.org,
        robh+dt@kernel.org, wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 0/9] crypto: add sun8i-ce driver for Allwinner crypto engine
Date:   Fri,  6 Sep 2019 20:45:42 +0200
Message-Id: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

This patch serie adds support for the Allwinner crypto engine.
The Crypto Engine is the third generation of Allwinner cryptogaphic offloader.
The first generation is the Security System already handled by the
sun4i-ss driver.
The second is named also Security System and is present on A80 and A83T
SoCs, originaly this driver supported it also, but supporting both IP bringing
too much complexity and another driver (sun8i-ss) will came for it.

For the moment, the driver support only DES3/AES in ECB/CBC mode.
Patchs for CTR/CTS/XTS and RNGs will came later.

Regards

Corentin Labbe (9):
  crypto: Add allwinner subdirectory
  crypto: Add Allwinner sun8i-ce Crypto Engine
  dt-bindings: crypto: Add DT bindings documentation for sun8i-ce Crypto
    Engine
  ARM: dts: sun8i: r40: add crypto engine node
  ARM: dts: sun8i: h3: Add Crypto Engine node
  ARM64: dts: allwinner: sun50i: Add Crypto Engine node on A64
  ARM64: dts: allwinner: sun50i: Add crypto engine node on H5
  ARM64: dts: allwinner: sun50i: Add Crypto Engine node on H6
  sunxi_defconfig: add new crypto options

 .../bindings/crypto/allwinner,sun8i-ce.yaml   |  84 +++
 MAINTAINERS                                   |   6 +
 arch/arm/boot/dts/sun8i-h3.dtsi               |  11 +
 arch/arm/boot/dts/sun8i-r40.dtsi              |  11 +
 arch/arm/configs/sunxi_defconfig              |   2 +
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi |  11 +
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi  |  11 +
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi  |  10 +
 drivers/crypto/Kconfig                        |   2 +
 drivers/crypto/Makefile                       |   1 +
 drivers/crypto/allwinner/Kconfig              |  32 +
 drivers/crypto/allwinner/Makefile             |   1 +
 drivers/crypto/allwinner/sun8i-ce/Makefile    |   2 +
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 390 +++++++++++
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 630 ++++++++++++++++++
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  | 256 +++++++
 16 files changed, 1460 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
 create mode 100644 drivers/crypto/allwinner/Kconfig
 create mode 100644 drivers/crypto/allwinner/Makefile
 create mode 100644 drivers/crypto/allwinner/sun8i-ce/Makefile
 create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
 create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
 create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h

-- 
2.21.0

