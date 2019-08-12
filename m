Return-Path: <SRS0=O5Fb=WI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A2E1C433FF
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 20:08:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B0D6208C2
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 20:08:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JxvCjXta"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbfHLUIC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 16:08:02 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38974 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727185AbfHLUIC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 16:08:02 -0400
Received: by mail-pl1-f196.google.com with SMTP id z3so1471238pln.6;
        Mon, 12 Aug 2019 13:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2syLlTVhNHsDTeVEzdI/tKwBsqEX2YHhMZRmgITX0Gs=;
        b=JxvCjXtalTO/ZH3psxI0p4fVYL7O/Bckv3waQaYS67jgSWaT6h0yqzd4FHP/VRqBiN
         bB7IR2su8uhxYQv3o24YD90FgnG84PoMxUg/HjVuFIYN/ZM3anjPlqU1CcJUQRQJaqhE
         CbOY+2Gh7Ge+jPvvoulkRMxvDWMPy25NJTYOIz/PC+DP2psiqBhLI4ff3+asjYkn5eNK
         RdKLYH78A7kvoxN0KwifiRwS+J7fZKHSlkTsNxNkK5w9MeG7zYTURpf1tmtH/8DE3cIR
         IrJHRXy2uvL2r6Vmv6X/YGdjJgvM3cXeWeHsbIEwfkTF4WaILVhk5BT/F2R8gkm6I4aX
         lhqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2syLlTVhNHsDTeVEzdI/tKwBsqEX2YHhMZRmgITX0Gs=;
        b=SSWmpNtmUN0ZSmT9A+zoZGGfJCGuRgwPPYebuD8zgKZh0lOUPwxHuMG79ZYiAXxvtE
         GXtxLMCDmMoFZqirD5+crxlRmu+DG0FuMZZya179FRmdt4tj0KCVCHZ7EpEeQwEWrbJP
         R0Q05ZDvF3tKwYH4hutzPRJsufJ1TLt6MX2TLj+BcSaR5tkJT0GAVRfxjAVWYeNiZSqz
         vlXpAzoUbI/CRbbsLxdnoi33xiq28gO9TsjT07MDn6SNNME973csigWVrY+0B5drWQgr
         /BshsblCexRnYUHk1ajlVztGEIlbl2QAzgWbSQHtvFkLkIzsFg8Nvl/R0VKGohXuEUbE
         Ahsg==
X-Gm-Message-State: APjAAAXzdBy8yb/h068uROcbqUnulbi1mI/6rnGT9k/A0QFN61Ex5hnT
        cZqELRpAYGLoW+Lhh88Whyj0pxEk
X-Google-Smtp-Source: APXvYqyIBrUQF+p5m/tYM2DWPxvdNXsDMHIqc7zPN9b8bUl1QE5lqLdpFka/ELAo2wLt9gIQtxA6Ug==
X-Received: by 2002:a17:902:59c3:: with SMTP id d3mr33378424plj.22.1565640480450;
        Mon, 12 Aug 2019 13:08:00 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id o14sm352844pjp.19.2019.08.12.13.07.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 13:07:59 -0700 (PDT)
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
Subject: [PATCH v7 00/15] crypto: caam - Add i.MX8MQ support
Date:   Mon, 12 Aug 2019 13:07:24 -0700
Message-Id: <20190812200739.30389-1-andrew.smirnov@gmail.com>
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

[v6] lore.kernel.org/r/20190717152458.22337-1-andrew.smirnov@gmail.com
[v5] lore.kernel.org/r/20190715201942.17309-1-andrew.smirnov@gmail.com
[v4] lore.kernel.org/r/20190703081327.17505-1-andrew.smirnov@gmail.com
[v3] lore.kernel.org/r/20190617160339.29179-1-andrew.smirnov@gmail.com
[v2] lore.kernel.org/r/20190607200225.21419-1-andrew.smirnov@gmail.com
[v1] https://patchwork.kernel.org/cover/10825625/

Andrey Smirnov (15):
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
  crypto: caam - force DMA address to 32-bit on 64-bit i.MX SoCs
  crypto: caam - always select job ring via RSR on i.MX8MQ
  crypto: caam - add clock entry for i.MX8MQ

 drivers/crypto/caam/caamalg.c     |   2 +-
 drivers/crypto/caam/caamalg_qi2.h |  27 ----
 drivers/crypto/caam/caamhash.c    |   2 +-
 drivers/crypto/caam/caampkc.c     |   8 +-
 drivers/crypto/caam/caamrng.c     |   2 +-
 drivers/crypto/caam/ctrl.c        | 220 ++++++++++++++----------------
 drivers/crypto/caam/desc_constr.h |  47 ++++++-
 drivers/crypto/caam/error.c       |   3 +
 drivers/crypto/caam/intern.h      |  32 ++++-
 drivers/crypto/caam/jr.c          |  93 ++++---------
 drivers/crypto/caam/pdb.h         |  16 ++-
 drivers/crypto/caam/pkc_desc.c    |   8 +-
 drivers/crypto/caam/qi.h          |  26 ----
 drivers/crypto/caam/regs.h        | 139 +++++++++++++------
 14 files changed, 326 insertions(+), 299 deletions(-)

-- 
2.21.0

