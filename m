Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50862C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09FE864E92
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:47:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbhBHJrB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 04:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbhBHJou (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 04:44:50 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0380CC0617A9;
        Mon,  8 Feb 2021 01:43:02 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id z21so9860154pgj.4;
        Mon, 08 Feb 2021 01:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=txs7p2lUu3mQQNGb4QbINzzk0t98H9jYcM78Yvdl14E=;
        b=Zq+lhqnt/wmGY4lc0sgTrXURXAgtEIkPTFhDeyad7JOR3m30IE2hJGI88ASsxFunb5
         3vSm2yaRvnvMTpqPon/ESv4xh9G5PScWb9VhC4zV3o1r7IPbkszZBKL5Q14vFpfxtrPp
         Mgz3UK3GkoEtYQ4lh08j6YrJL0yqPh9rrpO9M1KFCyWiP6AixP5oTDCUPK+qA85ZD2Wg
         3uAngYnAtvfWAn6otF3R78lGmmLHKRWHa2m6S3YSzWJC4AfY8HwRwm4Wir3h/KKrXSPt
         ARbOKdu1pnj+7y3kygj8h6RHb+x76pjnIMTCl2tozg+ck4CvztXvVoFpJGfYaBvMOcby
         ohTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=txs7p2lUu3mQQNGb4QbINzzk0t98H9jYcM78Yvdl14E=;
        b=U+OS/6GGSyPKMCMx8pQ1fdr+RZxRGX0bt5kOHPA5Nw4sYDrVzM8oh/qtdj6TlOJdqI
         zXyp92eRO0J+Syut+tDmrgO197srXeDzbJAukRyNkR0Yd39N4Qj4zzlEMb0nkRmsfvX7
         FLQjsevVZv7I2NHvdXiZDxzRjcwa/YVhjT4dey8xChG0h3p9226xFs37U/ISyuUtpWwB
         oEGJRgJjY9XFols15MhjQSneJXUUiiXh1vrXXCmnc5+5quQNVDGdq8SzS81u/IUngL30
         CES0y1FMaMwwxveza2Nz2jXPbu3p6nB6XyrX8fGetmY0zVxKcyduDCWaZSs1i4i5vKYr
         bisA==
X-Gm-Message-State: AOAM530y9kdggYcFob47VF0fCt8Q4WpSuPv7PSkB2Rfo1tX+FFRMNQHj
        Xnb77gDvtSSCMp+ZfL4GZTI=
X-Google-Smtp-Source: ABdhPJwk+dGrDJOWa2ATJE4AdcYPlJ7+xZZSyryXD2QxZfkecl1zsiWHwa/5y3X0lnMPMwKzOXfo2g==
X-Received: by 2002:a05:6a00:15d2:b029:1b7:30c1:8495 with SMTP id o18-20020a056a0015d2b02901b730c18495mr16861944pfu.32.1612777381616;
        Mon, 08 Feb 2021 01:43:01 -0800 (PST)
Received: from localhost.localdomain ([49.207.205.214])
        by smtp.gmail.com with ESMTPSA id k69sm12208958pfd.4.2021.02.08.01.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 01:43:01 -0800 (PST)
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
Subject: [PATCH v5 00/19]crypto: convert tasklets to use new tasklet_setup API()
Date:   Mon,  8 Feb 2021 15:12:19 +0530
Message-Id: <20210208094238.571015-1-allen.lkml@gmail.com>
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

The series is based on v5.11-rc4 (19c329f68089)
v5:
  - Fix amcc build failure. 

v4:
  - added acks
  - fixed checkpatch errors(Giovanni Cabiddu)

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

 drivers/crypto/amcc/crypto4xx_core.c          | 10 ++---
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
 34 files changed, 154 insertions(+), 182 deletions(-)

-- 
2.25.1

