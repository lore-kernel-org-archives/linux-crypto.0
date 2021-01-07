Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 304A1C433E6
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0199623356
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:27:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbhAGM1p (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Jan 2021 07:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbhAGM1p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Jan 2021 07:27:45 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E0DC0612F4;
        Thu,  7 Jan 2021 04:27:04 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id d2so3762211pfq.5;
        Thu, 07 Jan 2021 04:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rdzhko0OrjkG6Nl0CuymqMX6T8qlz4I52QwBBCGkLMw=;
        b=QVbfURqlAvyfONwwA1cZ4PfkRS0kE3wlUIR8xdHj4CMNJa71Gj1zjLG/LfGbPyDJRa
         HG8uckhKBb80dcHlNhm5Z1N4yDdKc2eMnXAOCcprB8DBsGLIeIvTS0RSjFLlhKZQvMPL
         3UG40mVcLkOfIcjwdajPfw6sua4j4Uiq3S2iRi5egJsL64awGWaPIbS/OC7C0quILs2b
         qqOD2oERzYh67vRhLclK6DmRAtemTj8jfB7oF+1WJKL86ueMnGuYmqBF3Ts0J6Wje+4e
         VwXFU+daciJaQbXeCPo0V0F1wCKjdkEoxnkREMSwxNxonHVd9DrmCX60luxRzN223Zbh
         t13A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rdzhko0OrjkG6Nl0CuymqMX6T8qlz4I52QwBBCGkLMw=;
        b=OsXbb0DA4W4U7Dd9KVgBi1WeEx3WuaKy4A+C0aw8fZYUdum0E8llXMmgfYG8M75h+Q
         yo7t8bXR9Da0s+7x7a6cST6Hg82q1U5zUruOLFZKVY1kUub44u4TYOECiX8ZXPFCQoBh
         k1oaJoPgDwv669Kzn23l5IVJ/1xbkaNB32+uetu1h+Axwc2Dx1SUaLBYSKZU2n8kNdl2
         pCRtxAHIuJyA57hTp2ARk3Qufr5RNpyDC+3FpZUXrhbTHkw71ug3SBfNf/sX8U3sHlao
         Rdg8OVaHBphOMRh+5LLKX+vFE4D3pEy5YCi8o1yThp6ZbtMzPcZ49b1zRn5khDL6CYiL
         rRtg==
X-Gm-Message-State: AOAM533W//Sm+WMtUe0Bt4i7oZwVxOQR8q40KYEv5+CzxpOxa4uOGVTp
        wHf2OJsrBcF+NPdhtk63a44=
X-Google-Smtp-Source: ABdhPJxcXn2o1SIoGKUkyjfui4Ui1mGNILmr8LFU3SW1oA5A3jEzGZxheiIYztpJO/oNgHZukM36xw==
X-Received: by 2002:a63:4923:: with SMTP id w35mr1605236pga.404.1610022423958;
        Thu, 07 Jan 2021 04:27:03 -0800 (PST)
Received: from localhost.localdomain ([49.207.207.140])
        by smtp.gmail.com with ESMTPSA id x28sm5860403pff.182.2021.01.07.04.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 04:27:03 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, gcherian@marvell.com,
        thomas.lendacky@amd.com, john.allen@amd.com, gilad@benyossef.com,
        bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        matthias.bgg@gmail.com, jamie@jamieiles.com,
        giovanni.cabiddu@intel.com, heiko@sntech.de, krzk@kernel.org,
        vz@mleia.com, k.konieczny@samsung.com,
        linux-crypto@vger.kernel.org, linux-mediatek@lists.infradead.org,
        qat-linux@intel.com, linux-rockchip@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>
Subject: [PATCH v2 00/19]crypto: convert tasklets to use new tasklet_setup API()
Date:   Thu,  7 Jan 2021 17:56:27 +0530
Message-Id: <20210107122646.16055-1-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

Commit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
introduced a new tasklet initialization API. This series converts
all the crypto modules to use the new tasklet_setup() API

The series is based on v5.11-rc2 (e71ba9452f0b)

v2:
  - added acks
  - addressed comments [Krzysztof and Gilad]

Allen Pais (19):
  crypto: amcc: convert tasklets to use new tasklet_setup() API
  crypto: atmel: convert tasklets to use new tasklet_setup() API
  crypto: axis: convert tasklets to use new tasklet_setup() API
  crypto: caam: convert tasklets to use new tasklet_setup() API
  crypto: cavium: convert tasklets to use new tasklet_setup() API
  crypto: ccp: convert tasklets to use new tasklet_setup() API
  crypto: ccree: convert tasklets to use new tasklet_setup() API
  crypto: hifn_795x: convert tasklets to use new tasklet_setup() API
  crypto: img-hash: convert tasklets to use new tasklet_setup() API
  crypto: ixp4xx: convert tasklets to use new tasklet_setup() API
  crypto: mediatek: convert tasklets to use new tasklet_setup() API
  crypto: omap: convert tasklets to use new tasklet_setup() API
  crypto: picoxcell: convert tasklets to use new tasklet_setup() API
  crypto: qat: convert tasklets to use new tasklet_setup() API
  crypto: qce: convert tasklets to use new tasklet_setup() API
  crypto: rockchip: convert tasklets to use new tasklet_setup() API
  crypto: s5p: convert tasklets to use new tasklet_setup() API
  crypto: talitos: convert tasklets to use new tasklet_setup() API
  crypto: octeontx: convert tasklets to use new tasklet_setup() API

 drivers/crypto/amcc/crypto4xx_core.c          |  7 ++--
 drivers/crypto/atmel-aes.c                    | 14 +++----
 drivers/crypto/atmel-sha.c                    | 14 +++----
 drivers/crypto/atmel-tdes.c                   | 14 +++----
 drivers/crypto/axis/artpec6_crypto.c          |  7 ++--
 drivers/crypto/caam/jr.c                      |  9 ++--
 drivers/crypto/cavium/cpt/cptvf_main.c        |  9 ++--
 drivers/crypto/cavium/nitrox/nitrox_common.h  |  2 +-
 drivers/crypto/cavium/nitrox/nitrox_isr.c     | 13 +++---
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c  |  4 +-
 drivers/crypto/ccp/ccp-dev-v3.c               |  9 ++--
 drivers/crypto/ccp/ccp-dev-v5.c               |  9 ++--
 drivers/crypto/ccp/ccp-dmaengine.c            |  7 ++--
 drivers/crypto/ccree/cc_fips.c                |  8 ++--
 drivers/crypto/ccree/cc_request_mgr.c         | 12 +++---
 drivers/crypto/hifn_795x.c                    |  6 +--
 drivers/crypto/img-hash.c                     | 12 +++---
 drivers/crypto/ixp4xx_crypto.c                |  4 +-
 .../crypto/marvell/octeontx/otx_cptvf_main.c  | 12 +++---
 drivers/crypto/mediatek/mtk-aes.c             | 14 +++----
 drivers/crypto/mediatek/mtk-sha.c             | 14 +++----
 drivers/crypto/omap-aes.c                     |  6 +--
 drivers/crypto/omap-des.c                     |  6 +--
 drivers/crypto/omap-sham.c                    |  6 +--
 drivers/crypto/picoxcell_crypto.c             |  7 ++--
 drivers/crypto/qat/qat_common/adf_isr.c       |  5 +--
 drivers/crypto/qat/qat_common/adf_sriov.c     | 10 ++---
 drivers/crypto/qat/qat_common/adf_transport.c |  4 +-
 .../qat/qat_common/adf_transport_internal.h   |  2 +-
 drivers/crypto/qat/qat_common/adf_vf_isr.c    | 11 +++--
 drivers/crypto/qce/core.c                     |  7 ++--
 drivers/crypto/rockchip/rk3288_crypto.c       | 14 +++----
 drivers/crypto/s5p-sss.c                      | 13 +++---
 drivers/crypto/talitos.c                      | 42 +++++++++----------
 34 files changed, 152 insertions(+), 181 deletions(-)

-- 
2.25.1

