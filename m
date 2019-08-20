Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5897EC41514
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FDBE22DD3
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:24:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AY1B8ig4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730838AbfHTUYS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:24:18 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37793 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728283AbfHTUYS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:18 -0400
Received: by mail-pl1-f196.google.com with SMTP id bj8so42094plb.4;
        Tue, 20 Aug 2019 13:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kw+BWVelTojkJsvwqygtdNO4/vmivNNP6hXgKWpJlMw=;
        b=AY1B8ig4lPv0H4990HMtOBhM+w78X/94pERUJguyjkGjofwlJbbxu3z4kRLvV4Nrc+
         8OzORrTBOFb4aD7Sc+XjPgJ4CSKUcJeeyPWNv52CbN92OvA80rqysz31DkORfSt1ddtc
         dYTubwXXUxxY5xFPI7D/okDsoKIeTPjA/loRQ9nDZlG8iMrmhg9dqGTT5IxCyctdF+wr
         KaitROyEr7Tlb9WE+PWT65BRmjTebJMjjOp2yvQAq92gBL8R+DdnjeGVLJiYcq+2p++q
         YDcsEWpMMQfPjOQiKmo+FEPNx3xPW5l1LReJGD75pO+W42s9nMDLkc0WRKDXw1lIe2c4
         9vnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kw+BWVelTojkJsvwqygtdNO4/vmivNNP6hXgKWpJlMw=;
        b=tw4GgTs+Q4xgEJqhbqZrv9NGYfdN+CUoCLmeD/JVzEVpIvZU9+RoYCtVq7yjvyEGYd
         bwwwcfiKsqrjXb3zqsLIsxgWv22qOiV/vUk8brO9k7GMyUEVf2vPeW+XNqZrqJ3Rjpzi
         Oct4HQlLBI7+YIGtELJQuaEmnVVYwLlFcsu4BXGKSsnxQDOCehPcEjpSQGwgzND9JWnK
         tPc1pB2wN0ThbPYfN5ZcYmxf1dcPjj+3BTBaVzxIVAVBuIShffxdSujJXzieBmZpmgF8
         0FW7j1rUzDmSJc3e8BAVlZVwMXgmWSmNMklUV6ULoPjtu1866PYp5NahrD/gchNYBYE4
         xD7g==
X-Gm-Message-State: APjAAAWWoUcDqr7bNDllXdFhR79uesJcDM6b+D0sYpcvDlLvDJZz7hyM
        RiBNtTH2djIecSlOe+QzW++6Ozr6hSA=
X-Google-Smtp-Source: APXvYqwZ+Lc/dCqYfVfBb89477ZwCXF48UX2ajOhv+/NeBwesgrQN0ffmL938+8xnMZ6xYKjZ+e8Kg==
X-Received: by 2002:a17:902:9889:: with SMTP id s9mr30630138plp.100.1566332657434;
        Tue, 20 Aug 2019 13:24:17 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id k3sm36149846pfg.23.2019.08.20.13.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 13:24:16 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 00/16] crypto: caam - Add i.MX8MQ support
Date:   Tue, 20 Aug 2019 13:23:46 -0700
Message-Id: <20190820202402.24951-1-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Everyone:

Picking up where Chris left off (I chatted with him privately
beforehead), this series adds support for i.MX8MQ to CAAM driver. Just
like [v1], this series is i.MX8MQ only.

Feedback is welcome!
Thanks,
Andrey Smirnov

Changes since [v7]:

  - Series rebase on latest cryptodev-2.6 (198429631a85)

  - "crypto: caam - force DMA address to 32-bit on 64-bit i.MX SoCs"
    converted to use CTPR and MCFGR to determine CAAM pointer width
    and renamed to "crypto: caam - select DMA address size at runtime"

  - Patch adding corresponding DT node added to the series

Changes since [v6]:

  - Fixed build problems in "crypto: caam - make CAAM_PTR_SZ dynamic"

  - Collected Reviewied-by from Horia

  - "crypto: caam - force DMA address to 32-bit on 64-bit i.MX SoCs"
    is changed to check 'caam_ptr_sz' instead of using 'caam_imx'
    
  - Incorporated feedback for "crypto: caam - request JR IRQ as the
    last step" and "crypto: caam - simplfy clock initialization"

Changes since [v5]:

  - Hunk replacing sizeof(*jrp->inpring) to SIZEOF_JR_INPENTRY in
    "crypto: caam - don't hardcode inpentry size", lost in [v5], is
    back

  - Collected Tested-by from Iuliana

Changes since [v4]:

  - Fixed missing sentinel element in "crypto: caam - simplfy clock
    initialization"
    
  - Squashed all of the devers related patches into a single one and
    converted IRQ allocation to use devres while at it

  - Added "crypto: caam - request JR IRQ as the last step" as
    discussed

Changes since [v3]:

  - Patchset changed to select DMA size at runtime in order to enable
    support for both i.MX8MQ and Layerscape at the same time. I only
    tested the patches on i.MX6,7 and 8MQ, since I don't have access
    to any of the Layerscape HW. Any help in that regard would be
    appareciated.

  - Bulk clocks and their number are now stored as a part of struct
    caam_drv_private to simplify allocation and cleanup code (no
    special context needed)
    
  - Renamed 'soc_attr' -> 'imx_soc_match' for clarity

Changes since [v2]:

  - Dropped "crypto: caam - do not initialise clocks on the i.MX8" and
    replaced it with "crypto: caam - simplfy clock initialization" and 
    "crypto: caam - add clock entry for i.MX8MQ"


Changes since [v1]

  - Series reworked to continue using register based interface for
    queueing RNG initialization job, dropping "crypto: caam - use job
    ring for RNG instantiation instead of DECO"

  - Added a patch to share DMA mask selection code

  - Added missing Signed-off-by for authors of original NXP tree
    commits that this sereis is based on

[v7] lore.kernel.org/r/20190812200739.30389-1-andrew.smirnov@gmail.com
[v6] lore.kernel.org/r/20190717152458.22337-1-andrew.smirnov@gmail.com
[v5] lore.kernel.org/r/20190715201942.17309-1-andrew.smirnov@gmail.com
[v4] lore.kernel.org/r/20190703081327.17505-1-andrew.smirnov@gmail.com
[v3] lore.kernel.org/r/20190617160339.29179-1-andrew.smirnov@gmail.com
[v2] lore.kernel.org/r/20190607200225.21419-1-andrew.smirnov@gmail.com
[v1] https://patchwork.kernel.org/cover/10825625/

Andrey Smirnov (16):
  crypto: caam - move DMA mask selection into a function
  crypto: caam - simplfy clock initialization
  crypto: caam - convert caam_jr_init() to use devres
  crypto: caam - request JR IRQ as the last step
  crytpo: caam - make use of iowrite64*_hi_lo in wr_reg64
  crypto: caam - use ioread64*_hi_lo in rd_reg64
  crypto: caam - drop 64-bit only wr/rd_reg64()
  crypto: caam - share definition for MAX_SDLEN
  crypto: caam - make CAAM_PTR_SZ dynamic
  crypto: caam - move cpu_to_caam_dma() selection to runtime
  crypto: caam - drop explicit usage of struct jr_outentry
  crypto: caam - don't hardcode inpentry size
  crypto: caam - select DMA address size at runtime
  crypto: caam - always select job ring via RSR on i.MX8MQ
  crypto: caam - add clock entry for i.MX8MQ
  arm64: dts: imx8mq: Add CAAM node

 arch/arm64/boot/dts/freescale/imx8mq.dtsi |  30 +++
 drivers/crypto/caam/caamalg.c             |   2 +-
 drivers/crypto/caam/caamalg_qi2.h         |  27 ---
 drivers/crypto/caam/caamhash.c            |   2 +-
 drivers/crypto/caam/caampkc.c             |   8 +-
 drivers/crypto/caam/caamrng.c             |   2 +-
 drivers/crypto/caam/ctrl.c                | 221 ++++++++++------------
 drivers/crypto/caam/desc_constr.h         |  47 ++++-
 drivers/crypto/caam/error.c               |   3 +
 drivers/crypto/caam/intern.h              |  32 +++-
 drivers/crypto/caam/jr.c                  |  93 +++------
 drivers/crypto/caam/pdb.h                 |  16 +-
 drivers/crypto/caam/pkc_desc.c            |   8 +-
 drivers/crypto/caam/qi.h                  |  26 ---
 drivers/crypto/caam/regs.h                | 140 ++++++++++----
 15 files changed, 359 insertions(+), 298 deletions(-)

-- 
2.21.0

