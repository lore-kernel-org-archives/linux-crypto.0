Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77038C433DB
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:48:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47DF522D6D
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732719AbhALBrt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 20:47:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbhALBrt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 20:47:49 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83320C061575;
        Mon, 11 Jan 2021 17:47:08 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id lj6so636814pjb.0;
        Mon, 11 Jan 2021 17:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zW9C/QxorEMeUx+kFawitRLf1fte/47nwM4QFK+urs8=;
        b=Xw2j31dYa7SMPypEzYJZYF8wY0mLXfYFnRrVxcJlbSxF0zGLpHLPR6T6Bg8zzujGzJ
         zaZiUQXiIkayvjga5aPESuNkqGgWOFFQpJvEybATylzQpZ1xIRuXQptih/ZGWPZzoaPR
         ksMLZwGXjGMwxnDyUNshkicHq9mDWY/odzVyLVRpqHtax39dopg5O5T6oZn4UeIJavJQ
         TuYKiMhudim7g3ptvZWU4FM6sz6hGq1jm8ByHFlPS/ilmXxTkAbVFmJLfnhFkZbemzgV
         VyDxLpCOCcE2sGfaOcuwmcxO4XHau8P9gKSGlganrQfq+Ttb+SvZ3EL4WDtL30hcfyL2
         dRtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zW9C/QxorEMeUx+kFawitRLf1fte/47nwM4QFK+urs8=;
        b=sotTJUN1J/2af6pHSR5M1O5QO3QdFpuWHrNHLS5z7isGHmWJ3j4YNu2jfsUkdnPWPV
         O6I+Jdv+2li/CSX0zjEdy2PNT0JgJH8bGJWpo5vlTKIFjIU1HsSUdAQ6faIidJ6E7FQ/
         KQdsx1aVKGTPQLezxvip2d+WkBdT1AZZHVu45uUd0JA0OpwiDngyKbXYFUfDiT6N8StR
         SdR+TES1CAtok8LWSzGVUXJVOWr540rnvKTsiOdyY+mW9xHYlUPw25mwWtpYPRt/o0y4
         46dg9SnDh30CaSYiIwhpDm4vqguXgloxGsk+rNFeuCqRZxSA6O2/I/T5Pnub0Xt5h/NQ
         fDpg==
X-Gm-Message-State: AOAM532EFowHtX+6L7LWTVpUhKUUF/Vx1iezfwudBeswE8jnUgKaPpVO
        h+/hF7C0ThqK7mzdjs4r5Jg=
X-Google-Smtp-Source: ABdhPJyxFPcLuVKER4Bl8+KtGfVHh/4AqA6sL49fG/uOu5r42FeKYv+0+bdSG/fKKm4dJGHuwUnqxw==
X-Received: by 2002:a17:902:d202:b029:da:d86b:78be with SMTP id t2-20020a170902d202b02900dad86b78bemr2264745ply.0.1610416027902;
        Mon, 11 Jan 2021 17:47:07 -0800 (PST)
Received: from localhost.localdomain ([49.207.194.207])
        by smtp.gmail.com with ESMTPSA id 14sm904376pfy.55.2021.01.11.17.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 17:47:07 -0800 (PST)
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
Subject: [PATCH v3 00/19]crypto: convert tasklets to use new tasklet_setup API()
Date:   Tue, 12 Jan 2021 07:16:31 +0530
Message-Id: <20210112014650.10887-1-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

Commit 12cc923f1ccc ("tasklet: Introduce new initialization API")
introduced a new tasklet initialization API. This series converts
all the crypto modules to use the new tasklet_setup() API

The series is based on v5.11-rc2 (e71ba9452f0b)

v3:
  - fixed rockchip driver(Emil Renner Berthing)

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

