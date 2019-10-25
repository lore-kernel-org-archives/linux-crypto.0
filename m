Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD339CA9EBD
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 18:51:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90BD821D82
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 18:51:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="im4eTYKN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfJYSve (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 14:51:34 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50980 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfJYSve (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 14:51:34 -0400
Received: by mail-wm1-f68.google.com with SMTP id 11so3258641wmk.0;
        Fri, 25 Oct 2019 11:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jvqQFCdyN1pvYkijOxdEJawR4E6xBqBcwTGJlgojr5g=;
        b=im4eTYKNwnTjGuMqDlkPm3KlXWA2QgSKIB+DHkleGEiwYAAmqYdF7EJZdj8t9vgr94
         wtiO7VxLajV8qhV7v9t0a3K/YLWXRalXFjhRVPLdvVxl74NNVfh4/72byFQqf9uSOIXN
         W8ZVqTbBMd/sSWM9zZw1lqjnuYgHea4ipFfhSVvgJvPKrI4TgnhGMhN8F0FdkdVMZVqi
         U5Ly/6nIl8APyPbmZ73izwKEiD5//P1cIKz/a3nk1yC2CW+Ajx3PLhZN00e+0p0dcW0E
         +F+TFk/u+y0Z0CpTzEKazN85/G5EmsF+HTU43OSIKd9oks3GleaokGC0JbgFOW/whtTM
         6uRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jvqQFCdyN1pvYkijOxdEJawR4E6xBqBcwTGJlgojr5g=;
        b=Uf33/dk08QQwEU1MYEHoHSlWGgqG4RD3sdNCZ7RVESNSyWxdR+5e9Jufy/ejdjht4u
         +wSFCHEbeRWU2gPITuLnuoKYSFowwBJ03PXHLkiIBenvngnZWnPNPRg7q+w7ZY/SWJLK
         HTZlGO7d/gYfaWSq1N73GaL113Af4ChRfDRxcWe/cQnnqwKdnu+Jn2m4jahEXT42vqrC
         eTCyuX6bcW98wD1gPLtuxuzdv5MI99nkl8vZ2pfd+cnaz4QXW5SEFd/liuFq6opMZjvG
         5OAITIJNPqbrI97AxQdgHPZvQukar3dhKU3jysUNUJRNzb/mQPgAqDHupQw6eIXVzfNv
         h7zA==
X-Gm-Message-State: APjAAAWO8udTqa1aFT+9aszxSlnMdLI/3PqwU+74j9zQMmqdqEdynCqY
        KK+qkBxP3AD/oUFXv8oNR9R6PYPy
X-Google-Smtp-Source: APXvYqyJDmSMjXoIhZz7YYzF4aHENSS3QLnhmaaCUjWpRIvnUzpNbYBNijclpFIwtDgTNKamg23phw==
X-Received: by 2002:a1c:e912:: with SMTP id q18mr4908766wmc.29.1572029492174;
        Fri, 25 Oct 2019 11:51:32 -0700 (PDT)
Received: from Red.localdomain (lfbn-1-7036-79.w90-116.abo.wanadoo.fr. [90.116.209.79])
        by smtp.googlemail.com with ESMTPSA id l22sm4821683wrb.45.2019.10.25.11.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 11:51:31 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mark.rutland@arm.com, mripard@kernel.org, p.zabel@pengutronix.de,
        robh+dt@kernel.org, wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v3 0/4] crypto: add sun8i-ss driver for Allwinner Security System
Date:   Fri, 25 Oct 2019 20:51:24 +0200
Message-Id: <20191025185128.24068-1-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

This patch serie adds support for the second version of Allwinner Security System.
The first generation of the Security System is already handled by the sun4i-ss driver.
Due to major change, the first driver cannot handle the second one.
This new Security System is present on A80 and A83T SoCs.

For the moment, the driver support only DES3/AES in ECB/CBC mode.
Patchs for CTR/CTS, RSA and RNGs will came later.

This serie is tested with CRYPTO_MANAGER_EXTRA_TESTS
and tested on:
sun8i-a83t-bananapi-m3
sun9i-a80-cubieboard4

This serie is based on top of the "crypto: add sun8i-ce driver for
Allwinner crypto engine" serie.

Regards

Changes since v2:
- Made the reset mandatory
- Removed reset-names

Changes since v1:
- fixed uninitialized err in sun8i_ss_allocate_chanlist
- Added missing commit description on DT Documentation patch

Corentin Labbe (4):
  crypto: Add Allwinner sun8i-ss cryptographic offloader
  dt-bindings: crypto: Add DT bindings documentation for sun8i-ss
    Security System
  ARM: dts: sun8i: a83t: Add Security System node
  ARM: dts: sun9i: a80: Add Security System node

 .../bindings/crypto/allwinner,sun8i-ss.yaml   |  61 ++
 arch/arm/boot/dts/sun8i-a83t.dtsi             |   9 +
 arch/arm/boot/dts/sun9i-a80.dtsi              |   9 +
 drivers/crypto/allwinner/Kconfig              |  28 +
 drivers/crypto/allwinner/Makefile             |   1 +
 drivers/crypto/allwinner/sun8i-ss/Makefile    |   2 +
 .../allwinner/sun8i-ss/sun8i-ss-cipher.c      | 438 ++++++++++++
 .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 642 ++++++++++++++++++
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h  | 218 ++++++
 9 files changed, 1408 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun8i-ss.yaml
 create mode 100644 drivers/crypto/allwinner/sun8i-ss/Makefile
 create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
 create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
 create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h

-- 
2.21.0

