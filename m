Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7299CC433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:00:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3461223357
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:00:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgLGJAW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 04:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgLGJAW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 04:00:22 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18995C0613D0
        for <linux-crypto@vger.kernel.org>; Mon,  7 Dec 2020 00:59:45 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id b26so9170996pfi.3
        for <linux-crypto@vger.kernel.org>; Mon, 07 Dec 2020 00:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=exAB1FYzHwQgD+P+46YKKGhymyTXic+lwSqDkTcD8Ts=;
        b=J2InDNyl29V0qPdXijENSr4d62GxfiKNKv3lpycr+j7rvRy6K2Mv5BW9vLj+qyAkAc
         FUBOVZD22pMFlCSIcqOb1DIYN1xBI6AqIwdx1XOGOLysA7K5CltqooN4frxZuAbBtZD8
         xfskVfs1iHkXQ898poVgHcuVJA67loR9sSLrT0GqpixJd/HN7zcy+9URWM0xcKcU4UXM
         kukptK7YduItrSWZMYCPjIlWPod0fHTvfETw/CfwxoRLNgmAliQEPyr6/t+R2Scy04iF
         JeIgPI0HtsMTW/N/4wKZky4nlCMeLXYWhCWu2dEzYHUsMbqG7bC6YE9Lu6sLf/2VLan0
         U7TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=exAB1FYzHwQgD+P+46YKKGhymyTXic+lwSqDkTcD8Ts=;
        b=ggfLqsOCGTFwVUiOZ7nCd3+VAzKe0ZmeWKOLp08BCVV2qliAw5NOGofi6PQ3+Yp0ZD
         8UD2wzrI2j0tjpU8v8NeSmUg/lN4Vai8GkdQw1HuLzS8f9Dy5mmuqDDP1+KsFuLjL/Xe
         Yit9wOXezxIR4QEXw9Dlx6L03uvDPyNrALUqbZBNmLfYO9X/8qDK9csuW5KFe5rHkd58
         AtpKFClEEcJuG9vpU1isihTdWTIPfLMOrja0AlfaMbhuSO/qgQNsqnqh4ieemr51OJcx
         GRoN3Qs7WKdNclP7HsfkbY+DAdbvGnpH2uzVGigKaHOFvxt+Jr/Rd3vhOeKVP11gr6Ue
         Ljwg==
X-Gm-Message-State: AOAM53250jH4EvzFMlWnPo8FkVcDAoDPCW7q9UmgU3Xq2pdJgHDaM7g5
        uaV/QV/n6aIQJcHO3n19ytc=
X-Google-Smtp-Source: ABdhPJwnZDe+BocPQcDnCgkHcFVx486HAkS8lGG2oAt6E80+x4OyO86IMIPz86wKL0uSVARIhKaE5A==
X-Received: by 2002:a17:902:b410:b029:d6:b42c:7af9 with SMTP id x16-20020a170902b410b02900d6b42c7af9mr14944015plr.21.1607331584611;
        Mon, 07 Dec 2020 00:59:44 -0800 (PST)
Received: from localhost.localdomain ([49.207.208.18])
        by smtp.gmail.com with ESMTPSA id w200sm11325029pfc.14.2020.12.07.00.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 00:59:43 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, bbrezillon@kernel.org,
        arno@natisbad.org, schalla@marvell.com, matthias.bgg@gmail.com,
        heiko@sntech.de, krzk@kernel.org, vz@mleia.com,
        k.konieczny@samsung.com, linux-crypto@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>
Subject: [RESEND 00/19] crypto: convert tasklets to use new tasklet_setup API()
Date:   Mon,  7 Dec 2020 14:29:12 +0530
Message-Id: <20201207085931.661267-1-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

Commit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
introduced a new tasklet initialization API. This series converts
all the crypto modules to use the new tasklet_setup() API

The series is based on 5.10-rc6 (b65054597872)

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
 drivers/crypto/ccree/cc_fips.c                |  6 +--
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
 34 files changed, 151 insertions(+), 180 deletions(-)

-- 
2.25.1

