Return-Path: <SRS0=yFEM=YD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D6E6C4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 18:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 737E221835
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 18:24:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="io5NZfnX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfJJSXy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Oct 2019 14:23:54 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39596 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfJJSXy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Oct 2019 14:23:54 -0400
Received: by mail-wm1-f68.google.com with SMTP id v17so7761962wml.4;
        Thu, 10 Oct 2019 11:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cDdKG7BuYNC0klxFn+6EUkgCJfJh5dVTOm1e7l3a8X0=;
        b=io5NZfnXNdyoKtTWghcI85hs4yVXyAGO1vHhUB2FceE2MUrARbpAxq+Cg3u6bM4ISL
         NgUSOdVcQpDyARPoHhC6ycU6HiCuJxAJDjkgEnYpme2m1Cbac7GURGxhQP7bzbUbCK53
         0luRDQPjMcAKzv32H++RmjAZ2sV+rzNsrchQa75aHDbRFKC0a5RpUlpwHoZp/Ndj2dAn
         iSeZVz1WKfV6mBVQ2Ig5xMb/dX2nr1kmyOfOjYhcv1urZ40MQaJeNBm7d1rXHeEg4Jq5
         xyMwwAN2UVsJThtcILRfemRsWVirGWyu9+PW09MIuuo0hzrQQyrJWaWU/tPrioSeaf7r
         JJgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cDdKG7BuYNC0klxFn+6EUkgCJfJh5dVTOm1e7l3a8X0=;
        b=R4fJQnaSAyIqkBN4nf9/n036WDfr0JdIKfS9mE6b+ZnDIEq1f1mFGgDrIl/uBVp8P4
         LTY+C60czMQ1NTiOO1goRVFaW8LON0NayHqUh9P1fomy9uXT7Il84b3MWJbPkb7Iwj+g
         ruXHHVNK6cCmPngWP69zkP9TZALixeziy4+NCar/6i/SziCZN7BAsKlwo2oSOMiqb5qB
         mWTKo+oqMIRzlqUADGqpoffpICL/cLCeTC4NSLah11Ghz4aBhON3UOgABMkZAfhIZMXq
         mQ7mnPuogLEbblkg63xMfMbC+a9z/2picE0N97H4kgj/a8Barfb5BWFv8jZ4t03VsPFI
         eQjQ==
X-Gm-Message-State: APjAAAXBouy3ZFoaUJtKWJIfjv4g/6k4PQJbKtlf5RGf62pomqLQTaIn
        b2gZx194v3WqtE/7URa444s=
X-Google-Smtp-Source: APXvYqzUch2MFYwpJZP8PCs0aVC6hg6H6/bb/JQCgRe9bZhljWJCK3/gs9E0yK41y1NwLVfW7XXCgg==
X-Received: by 2002:a05:600c:490:: with SMTP id d16mr8707908wme.131.1570731831084;
        Thu, 10 Oct 2019 11:23:51 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id y186sm11367664wmb.41.2019.10.10.11.23.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 11:23:50 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v3 00/11] crypto: add sun8i-ce driver for Allwinner crypto engine
Date:   Thu, 10 Oct 2019 20:23:17 +0200
Message-Id: <20191010182328.15826-1-clabbe.montjoie@gmail.com>
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
Patchs for CTR/CTS/XTS, RSA and RNGs will came later.

This serie is tested with CRYPTO_MANAGER_EXTRA_TESTS
and tested on:
sun50i-a64-bananapi-m64
sun50i-a64-pine64-plus
sun50i-h5-libretech-all-h3-cc
sun50i-h6-pine-h64
sun8i-h2-plus-libretech-all-h3-cc
sun8i-h2-plus-orangepi-r1
sun8i-h2-plus-orangepi-zero
sun8i-h3-libretech-all-h3-cc
sun8i-h3-orangepi-pc
sun8i-r40-bananapi-m2-ultra

Regards

Changes since v2:
- changed additionalproperties
- splited fallbacks functions out of sun8i_ce_cipher()
- changed variant "model" to "has_t_dlen_in_bytes"
- splited sun8i_ce_register_algs/sun8i_ce_get_clks out of sun8i_ce_probe()

Changes since v1:
- Add sun4i-ss to allwinner directory
- Cleaned variant structure
- Renamed clock name from ahb to bus (and mbus to ram)
- Fixed DT bindings problem reported by mripard
- Cleaned unneeded status = ""  in R40 DT
- Removed old unnecessary interrupt_names in A64 DT
- Added arm64 defconfig
- Added support for PM functions
- Splitted probe functions
- Reworked clock settings
- made reset mandatory

Corentin Labbe (11):
  crypto: Add allwinner subdirectory
  crypto: Add Allwinner sun8i-ce Crypto Engine
  dt-bindings: crypto: Add DT bindings documentation for sun8i-ce Crypto
    Engine
  ARM: dts: sun8i: R40: add crypto engine node
  ARM: dts: sun8i: H3: Add Crypto Engine node
  ARM64: dts: allwinner: sun50i: Add Crypto Engine node on A64
  ARM64: dts: allwinner: sun50i: Add crypto engine node on H5
  ARM64: dts: allwinner: sun50i: Add Crypto Engine node on H6
  sunxi_defconfig: add new Allwinner crypto options
  arm64: defconfig: add new Allwinner crypto options
  crypto: sun4i-ss: Move to Allwinner directory

 .../bindings/crypto/allwinner,sun8i-ce.yaml   |  92 +++
 MAINTAINERS                                   |   4 +-
 arch/arm/boot/dts/sun8i-h3.dtsi               |  10 +
 arch/arm/boot/dts/sun8i-r40.dtsi              |  10 +
 arch/arm/configs/sunxi_defconfig              |   2 +
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi |  10 +
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi  |  10 +
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi  |  10 +
 arch/arm64/configs/defconfig                  |   2 +
 drivers/crypto/Kconfig                        |  28 +-
 drivers/crypto/Makefile                       |   2 +-
 drivers/crypto/allwinner/Kconfig              |  60 ++
 drivers/crypto/allwinner/Makefile             |   2 +
 .../{sunxi-ss => allwinner/sun4i-ss}/Makefile |   0
 .../sun4i-ss}/sun4i-ss-cipher.c               |   0
 .../sun4i-ss}/sun4i-ss-core.c                 |   0
 .../sun4i-ss}/sun4i-ss-hash.c                 |   0
 .../sun4i-ss}/sun4i-ss-prng.c                 |   0
 .../sun4i-ss}/sun4i-ss.h                      |   0
 drivers/crypto/allwinner/sun8i-ce/Makefile    |   2 +
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 434 +++++++++++
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 677 ++++++++++++++++++
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  | 254 +++++++
 23 files changed, 1580 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
 create mode 100644 drivers/crypto/allwinner/Kconfig
 create mode 100644 drivers/crypto/allwinner/Makefile
 rename drivers/crypto/{sunxi-ss => allwinner/sun4i-ss}/Makefile (100%)
 rename drivers/crypto/{sunxi-ss => allwinner/sun4i-ss}/sun4i-ss-cipher.c (100%)
 rename drivers/crypto/{sunxi-ss => allwinner/sun4i-ss}/sun4i-ss-core.c (100%)
 rename drivers/crypto/{sunxi-ss => allwinner/sun4i-ss}/sun4i-ss-hash.c (100%)
 rename drivers/crypto/{sunxi-ss => allwinner/sun4i-ss}/sun4i-ss-prng.c (100%)
 rename drivers/crypto/{sunxi-ss => allwinner/sun4i-ss}/sun4i-ss.h (100%)
 create mode 100644 drivers/crypto/allwinner/sun8i-ce/Makefile
 create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
 create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
 create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h

-- 
2.21.0

