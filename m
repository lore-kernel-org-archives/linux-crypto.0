Return-Path: <SRS0=7mlD=VM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE249C7618F
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 20:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7969920665
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 20:20:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pn4hZfwT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731580AbfGOUTv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jul 2019 16:19:51 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45012 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729844AbfGOUTu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jul 2019 16:19:50 -0400
Received: by mail-pg1-f194.google.com with SMTP id i18so8241636pgl.11;
        Mon, 15 Jul 2019 13:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VwVZhf3FGp8Bt78SUPmSIUX1Y2n1U1qykgwrt3l8ads=;
        b=Pn4hZfwTFRycrCV2z94gxgkFSz5XkJ6yPfiYtZLkTN2uCO3RIeZCZytqJ7Rpr3rKTI
         r04HdhXREE6pMFFoKTTFieTDZ2xw2ybalxCez+307rae/7FgDJY6V6RntseHSwBYa2xm
         uc+j13X3Jrm6NOciiM2Ngj2gm7+rM07qs/UYa9Wt5v36VyVdwUTcyxAOFkImu91TyDQe
         nVueeO+zFNFgndd0T1x2gCs9PoXdVaumpiMd44y7h1h3vP4AP9tzUI1+G4wS4095UnU5
         /poLqIajRGwKJh98dNZLjmFAceoaLUL/LitB1VJ3gdH51W3zn7XK3wi/1dVxtNjgEf1Q
         VFew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VwVZhf3FGp8Bt78SUPmSIUX1Y2n1U1qykgwrt3l8ads=;
        b=igeoiEnmWsDgPKcY4irSG6mu7gpeKqPNKZJZsk4GnnK/XUbHtNhjREnCV3TeSwVjGk
         ZwxUlWg+qpGEjno0egXQoHHWBiE20PlHFw8/w8qFidUsY4aoeiI7X36QDYYbGzu0QkxY
         2HH8PlYp18Aad2Vd3jnxbwuU44dgfyxu349nBmARjCkrgyneJ11uIcx2Nmntr7ORVqkZ
         fhlPj+xUyKRDgb6ZXrsv4BmFeK2bu+qt7sisUqo/CFU7V7p4oRD6jtWfNFG5vg6g0xwj
         zoxcYRjiEkwWxOGGxSdVswYaAmk5fRnOgvgoGiH/QSAM0lzjdYzf2oi1CO1zKji4Pbuh
         KjMA==
X-Gm-Message-State: APjAAAXziITsPC8nmOVeEBb9bOI0DRuTOfvSIIuJyPB2WhRwCU2FJHWV
        KuibqWdT2BuV2nab8qSuwtTje6gA
X-Google-Smtp-Source: APXvYqzR6mDqGeTrVGHyF4Lakpv8XKdXKMk51OnIdeO23HuZFz9V6ShQvEQ5DUhEIa2ZMK6m4FdYGg==
X-Received: by 2002:a17:90a:b00b:: with SMTP id x11mr31496957pjq.120.1563221989251;
        Mon, 15 Jul 2019 13:19:49 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id h1sm22730534pfg.55.2019.07.15.13.19.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 13:19:48 -0700 (PDT)
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
Subject: [PATCH v5 00/14] crypto: caam - Add i.MX8MQ support
Date:   Mon, 15 Jul 2019 13:19:28 -0700
Message-Id: <20190715201942.17309-1-andrew.smirnov@gmail.com>
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

[v4] lore.kernel.org/r/20190703081327.17505-1-andrew.smirnov@gmail.com
[v3] lore.kernel.org/r/20190617160339.29179-1-andrew.smirnov@gmail.com
[v2] lore.kernel.org/r/20190607200225.21419-1-andrew.smirnov@gmail.com
[v1] https://patchwork.kernel.org/cover/10825625/

Andrey Smirnov (14):
  crypto: caam - move DMA mask selection into a function
  crypto: caam - simplfy clock initialization
  crypto: caam - convert caam_jr_init() to use devres
  crypto: caam - request JR IRQ as the last step
  crytpo: caam - make use of iowrite64*_hi_lo in wr_reg64
  crypto: caam - use ioread64*_hi_lo in rd_reg64
  crypto: caam - drop 64-bit only wr/rd_reg64()
  crypto: caam - make CAAM_PTR_SZ dynamic
  crypto: caam - move cpu_to_caam_dma() selection to runtime
  crypto: caam - drop explicit usage of struct jr_outentry
  crypto: caam - don't hardcode inpentry size
  crypto: caam - force DMA address to 32-bit on 64-bit i.MX SoCs
  crypto: caam - always select job ring via RSR on i.MX8MQ
  crypto: caam - add clock entry for i.MX8MQ

 drivers/crypto/caam/caamalg.c     |   2 +-
 drivers/crypto/caam/caamhash.c    |   2 +-
 drivers/crypto/caam/caampkc.c     |   8 +-
 drivers/crypto/caam/caamrng.c     |   2 +-
 drivers/crypto/caam/ctrl.c        | 225 ++++++++++++++----------------
 drivers/crypto/caam/desc_constr.h |  20 ++-
 drivers/crypto/caam/error.c       |   3 +
 drivers/crypto/caam/intern.h      |  32 ++++-
 drivers/crypto/caam/jr.c          |  95 ++++---------
 drivers/crypto/caam/pdb.h         |  16 ++-
 drivers/crypto/caam/pkc_desc.c    |   8 +-
 drivers/crypto/caam/regs.h        | 139 ++++++++++++------
 12 files changed, 306 insertions(+), 246 deletions(-)

-- 
2.21.0

