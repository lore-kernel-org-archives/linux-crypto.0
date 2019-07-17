Return-Path: <SRS0=f4o8=VO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F126C7618F
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 15:25:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A8942173B
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 15:25:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e4kTfvFr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbfGQPZN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Jul 2019 11:25:13 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41448 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbfGQPZN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jul 2019 11:25:13 -0400
Received: by mail-pg1-f193.google.com with SMTP id x15so981992pgg.8;
        Wed, 17 Jul 2019 08:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dJ/XDOKRzUY7ykwDVGuFsuNbYl3BfIW5N+JCssJDiFQ=;
        b=e4kTfvFrO74bd3oqV9RSyAZS1KJ8OCiczLvi28RTxrrOAhGzo9a7OTy2XhGTrrYKVc
         oAs6pZNq5Z7WpHih5LGZ/ht/8NE+QDSbJd4LpnOMr2ceidxvpzF/YjJQbLTx54I+uDRq
         sO39CasHq7mgxr9GPwiwJgwD7pnVJl7ojWQLuPpQ4SandJvvuXbYqh1/mFeUc+w2c0Is
         iv3jMCPOaw7OD4Ovs0wwfnlWNISHEX5DgNV5W7YUish7QuOqqMaoJC06JmJTpPQPrC0O
         yqUaV8+52o5GZnLlNwJeO9zZh3nR/DpnpMvnU2YgVCEV4jZPui+7Z8GB9FNjsQr4uCVb
         z4cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dJ/XDOKRzUY7ykwDVGuFsuNbYl3BfIW5N+JCssJDiFQ=;
        b=lLTXnwT6bJgM3jXKe5PPgU96Vcvu4IUc4ePJAli1guDipRwKKJIh2dzUmDIpQ8ascE
         SKol2CkvvyME16/yuXKKcozr3VAE83X7wPFwHkmqUDVBcmel9dcioh7maD/xjQc/KFbB
         pTORftrkO1LK0BAFWnXMSZs6kdGiV0AVb1YfN/gdxGMGYAIgSBYrQ3IKeoE8UWpNFqDY
         3/XH4V14dpAXBtPEN42lAEKm/g6Ox8C7jvdfhe94tGAkD+YLalo1K0YXUE8NjLuyL1m3
         S+vVq3BtRZNtVJm93lDIcXYFpr+ZDBxQunBuLx6ufZz063lgeXTz7aY65+QR1/ybT6v5
         M3BA==
X-Gm-Message-State: APjAAAXijl1FB3IDTIU+8leXCmw5UoeIpgJIkHfx15C/TJfevjTIM7t5
        N40DXXLUAFwMFMBXknJ5s/L+Y7SA
X-Google-Smtp-Source: APXvYqxYeCMMqoO17bZSfq8sNxxrbnwA+xBBzCnyOu99NdNerR4rv5730W02lgyXkPJq7e1mUHIF8w==
X-Received: by 2002:a63:6c7:: with SMTP id 190mr41134854pgg.7.1563377111804;
        Wed, 17 Jul 2019 08:25:11 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id l1sm33771386pfl.9.2019.07.17.08.25.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 08:25:11 -0700 (PDT)
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
Subject: [PATCH v6 00/14] crypto: caam - Add i.MX8MQ support
Date:   Wed, 17 Jul 2019 08:24:44 -0700
Message-Id: <20190717152458.22337-1-andrew.smirnov@gmail.com>
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

[v5] lore.kernel.org/r/20190715201942.17309-1-andrew.smirnov@gmail.com
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

