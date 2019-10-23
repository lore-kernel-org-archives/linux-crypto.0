Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47494CA9EBC
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 20:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C37D21929
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 20:10:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hBvZU4+r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389796AbfJWUKW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 16:10:22 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46931 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389786AbfJWUKW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 16:10:22 -0400
Received: by mail-wr1-f65.google.com with SMTP id n15so12669196wrw.13;
        Wed, 23 Oct 2019 13:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bpwS+F/PeAnITy9k+IFP+J0FMYCUcRVSLDnqP4k8tK4=;
        b=hBvZU4+rsFkkIkAEUe2UK9p+3+5+JWXtPl1AZcdpLaBuLUxk+tc9T4L0jRNaLQMGVw
         L+y3LVknu1uoc9CULFzf8dej8BNFwUTSnBIZzaZ6iMqnEGcQ10BglL/pjhbRsbFxA0nG
         TUqdThzwoDwZu8AijYEmyE0CjhaPz4jnW2qwRoJzTgGNO4lhQchAbhoHa8LC0QfcPbOv
         g1q9PZPUfgx5oe/ytQHpOxqMmbMNySxPiEVN4Udp/G5hmQpBdyBv4D+tK0ktG3Ky/40m
         h+3TAhalZNBLSbza7mE3tyVo0jG0X1Kgu7C9aFGpwlAh61iL9Qo30+bbPsMNkVnN2H8m
         4Cnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bpwS+F/PeAnITy9k+IFP+J0FMYCUcRVSLDnqP4k8tK4=;
        b=dxd1ArwrZjuJxpHEaGY2XYn4dahMUkk3ADNBqViPLrxwMLfhkMOEXVaw6T6k6+DttR
         WYxv2+edP3zy2+mOWSku4sl3qJXLJZmENZF5w1/kQgFVHelqkgdcyt1s7kot8KG/7vNO
         OLhZs22c9AvX96LA+gaQCvOtkcReipPRUX8F6yWx9hlOeHIxKha8wgW2M7CacnrNOQww
         lK4a5SrENkgOsiE1ji9t87VLqe5adQkYv9pH7705U67fQLbWbq0IYrL4RvWn6BkSPAbk
         6beO/Ko5CYHZbLUeRR8IbMR/6n96jYSQ20uiz0VrxNCfuw6AYlP7DBjHhXDejVo/4izN
         A0qA==
X-Gm-Message-State: APjAAAUGhjRQOtEW6B7xfhhUMlCF03Puluz5cezHTFzzssRA/JzHUKyr
        UiXFvdSHNYGQNwbCQr1VcYI=
X-Google-Smtp-Source: APXvYqwp9Wm0ez8TH/4MwrhNc/lRRV96afQBfhg751QLdG3fu7ojJDzZdlM9I3dHNw1gPuQ8UjiZig==
X-Received: by 2002:a5d:568b:: with SMTP id f11mr449675wrv.301.1571861419759;
        Wed, 23 Oct 2019 13:10:19 -0700 (PDT)
Received: from Red.localdomain (lfbn-1-7036-79.w90-116.abo.wanadoo.fr. [90.116.209.79])
        by smtp.googlemail.com with ESMTPSA id h17sm277261wmb.33.2019.10.23.13.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 13:10:18 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 0/4] crypto: add sun8i-ss driver for Allwinner Security System
Date:   Wed, 23 Oct 2019 22:10:12 +0200
Message-Id: <20191023201016.26195-1-clabbe.montjoie@gmail.com>
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

Changes since v1:
- fixed uninitialized err in sun8i_ss_allocate_chanlist
- Added missing commit description on DT Documentation patch

Corentin Labbe (4):
  crypto: Add Allwinner sun8i-ss cryptographic offloader
  dt-bindings: crypto: Add DT bindings documentation for sun8i-ss
    Security System
  ARM: dts: sun8i: a83t: Add Security System node
  ARM: dts: sun9i: a80: Add Security System node

 .../bindings/crypto/allwinner,sun8i-ss.yaml   |  64 ++
 arch/arm/boot/dts/sun8i-a83t.dtsi             |  10 +
 arch/arm/boot/dts/sun9i-a80.dtsi              |  10 +
 drivers/crypto/allwinner/Kconfig              |  28 +
 drivers/crypto/allwinner/Makefile             |   1 +
 drivers/crypto/allwinner/sun8i-ss/Makefile    |   2 +
 .../allwinner/sun8i-ss/sun8i-ss-cipher.c      | 438 ++++++++++++
 .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 642 ++++++++++++++++++
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h  | 218 ++++++
 9 files changed, 1413 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun8i-ss.yaml
 create mode 100644 drivers/crypto/allwinner/sun8i-ss/Makefile
 create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
 create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
 create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h

-- 
2.21.0

