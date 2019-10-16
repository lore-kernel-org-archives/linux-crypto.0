Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C35BFA3728
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 15:02:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E041E20640
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 15:02:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ysa/Wbos"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392440AbfJPPBo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 11:01:44 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54979 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388424AbfJPPBh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 11:01:37 -0400
Received: by mail-wm1-f67.google.com with SMTP id p7so3286929wmp.4;
        Wed, 16 Oct 2019 08:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k23qzR65sWJn/mMveQEHK8WGYolTSnSuyuXwsgz/Wto=;
        b=Ysa/Wbosmj7yFn7kFq97CA9V9dpVnv9bAN/2gngrwLYRA4IZ3E3OVzd13xbCRhw+wn
         L2ta2p1fJPQRy3t5fghUiRZFaqXJnYcDU4M44pZkEvlTLGp+FkZA1uiUNK84MXEeyDlQ
         JgB+JyqSMMkn0DoCuLGiDu3udI/U8v8IWwKhL1RrqVyXO+t83fK5udwDWmYfOWxCcYpO
         zmfWchPj3M5CcnVyOhNhRPPWEHaOV2yhlsh4OAF/meEc87saew9CRzdFQtUn6Vc8Pm+s
         h6MpbTH3sD49lB36PSB6xWlP5rzpIoQijgSAFuN+lJaCaHxPckkCpwB+MU2n6Vv3YRSo
         ebdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k23qzR65sWJn/mMveQEHK8WGYolTSnSuyuXwsgz/Wto=;
        b=kk1RSFlaLCJs0BEInJJlo5EO7p2Ia0XBzJljqA2tilGeLYsSrghzM1bugC3WZKx0Dk
         BdlaQEUQXUcAMS6EKtekWA1oYafb648lyi1iz/hpcEHhdVhc4gf66fEAsFUZHrQWYcY/
         VPAkbiJ2gUvTnx1IWY67uielaPPLKpwWaUe8mC6p4UDsXDXN3vNoSi4Vt2ES2iLE67+N
         y5gwpMZpEUyAYbmltih0w5LIT/YeC3jwC0ys//Zyd5YmHl2bwMTykNcXcWaXFqXRJY2A
         I8RYs/h8sf5vi3qeGkgd2X3BOJY8svQRyqXCQWc5bOQIesGVZ9AQcnvp6W84nnV18VGz
         srWQ==
X-Gm-Message-State: APjAAAUIQf114XvkdBTHbEBRcXemk0lPlWVzgpC1ELJR0wLnmcI3qDbc
        2T/CcnzL9GbAP9NUyaI74O4=
X-Google-Smtp-Source: APXvYqz+wePvv35aS7e3hggckLg0aCPANjZj2WxZWatpR0MRbCAEyOBvwKZVLF4uqfXj0VKf//4IWA==
X-Received: by 2002:a1c:ed04:: with SMTP id l4mr3950186wmh.116.1571238094745;
        Wed, 16 Oct 2019 08:01:34 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id r18sm3215437wme.48.2019.10.16.08.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 08:01:33 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v5 00/11] crypto: add sun8i-ce driver for Allwinner crypto engine
Date:   Wed, 16 Oct 2019 17:01:20 +0200
Message-Id: <20191016150131.15430-1-clabbe.montjoie@gmail.com>
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

DT and defconfig will go thru the mripard tree

Regards

Changes since v4:
- fixed some typos in kconfig
- made sun8i_ce_pm_ops static
- Use devm_platform_ioremap_resource

Changes since v3:
- removed need of reset-names
- made reset mandatory

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

 .../bindings/crypto/allwinner,sun8i-ce.yaml   |  88 +++
 MAINTAINERS                                   |   4 +-
 arch/arm/boot/dts/sun8i-h3.dtsi               |   9 +
 arch/arm/boot/dts/sun8i-r40.dtsi              |   9 +
 arch/arm/configs/sunxi_defconfig              |   2 +
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi |   9 +
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi  |   9 +
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi  |   9 +
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
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 675 ++++++++++++++++++
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  | 254 +++++++
 23 files changed, 1569 insertions(+), 29 deletions(-)
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

