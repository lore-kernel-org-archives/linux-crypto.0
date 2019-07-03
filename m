Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3647BC5B578
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09E53218A3
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:14:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O5NbxhUw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfGCIN6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 04:13:58 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45099 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbfGCIN6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 04:13:58 -0400
Received: by mail-pg1-f194.google.com with SMTP id o13so798634pgp.12;
        Wed, 03 Jul 2019 01:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l/fW7R33i6r3L87mywXzhr7gnJzg2boZZl1A7ts9QtY=;
        b=O5NbxhUwXBjtORIyUkBBUPPOyAVmr4Ny6Q8TaxcBFBtsHViCYLVUtdSRqWauh7Jwyq
         czNpjX/8R5lg9so1PACVXyUYcO4xpVbqHb/E9Ub3n6siceZ9msHWx5km7FzX3uvLVyzL
         6B+E8EPF/cV+37JYWg8JuS0xq76cQmZNgRasa6fc2Hm89/F3AHKw27V6VXPv+hxKbAQV
         +tEUSJqgD29vvQVLmHTG6cWHOwAQa7gUSQgNfrVnIQZ4MHcvYqv93/32x/aGrb7UmXFQ
         vdlYcXc5cbS/uJVFWbnMWEOmHX61Hu18n4K9SblQCs5WdfaOCmfYT5HYpr5hr5mtURwZ
         D2IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l/fW7R33i6r3L87mywXzhr7gnJzg2boZZl1A7ts9QtY=;
        b=n7ovSRk2LmDfwkN16jKaMCTD6NBp2GVZLLw1sh7gbdE9oAEdSWOAX3yiL7B86ndV24
         1hcpmBh8/U0kij8jxoyB5LAhQkL+xpAlZp236hsr0xP8DzIAm0occG4xdrsUpxLqG6Fl
         r1lXWDt1r4eW4BTaWCqFxYSfkO8AMmdri2+aQuXURq5husaZaGYlE2mtgrtIBGCIWK9d
         dHoVpFRCS2MsCijJdJHIKFX4Udhg809oDHXUjZ9O9klScGqLk6gBJjN68mFxdrChVaAv
         rfFV7UK8tHYGqTgR3lavkYAC0uOWoGvpS9p4smxEpAwCG4rqqGu2+ooK//0wUiK0jxqH
         OMUw==
X-Gm-Message-State: APjAAAWICCixOddkCMcgRH8EBRSEtcDAObYMKxSYxw1y237gT5j21zpy
        JNpgCirABRuT8Q1vI6pyS1EdiDwNQGA=
X-Google-Smtp-Source: APXvYqyphdSGjtgLfSmMWuT4DgKpCYgJRPkXQh4PxTXji4zrUdFHSNmoM2SaAHd1wsAws+6V4WzIfA==
X-Received: by 2002:a17:90a:ae12:: with SMTP id t18mr11462614pjq.32.1562141637151;
        Wed, 03 Jul 2019 01:13:57 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id d2sm1445306pgo.0.2019.07.03.01.13.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 01:13:56 -0700 (PDT)
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
Subject: [PATCH v4 00/16] crypto: caam - Add i.MX8MQ support
Date:   Wed,  3 Jul 2019 01:13:11 -0700
Message-Id: <20190703081327.17505-1-andrew.smirnov@gmail.com>
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

[v3] lore.kernel.org/r/20190617160339.29179-1-andrew.smirnov@gmail.com
[v2] lore.kernel.org/r/20190607200225.21419-1-andrew.smirnov@gmail.com
[v1] https://patchwork.kernel.org/cover/10825625/


Andrey Smirnov (16):
  crypto: caam - move DMA mask selection into a function
  crypto: caam - simplfy clock initialization
  crypto: caam - move tasklet_init() call down
  crypto: caam - use deveres to allocate 'entinfo'
  crypto: caam - use devres to allocate 'outring'
  crypto: caam - use devres to allocate 'inpring'
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
 drivers/crypto/caam/ctrl.c        | 224 ++++++++++++++----------------
 drivers/crypto/caam/desc_constr.h |  20 ++-
 drivers/crypto/caam/error.c       |   3 +
 drivers/crypto/caam/intern.h      |  32 ++++-
 drivers/crypto/caam/jr.c          |  67 +++------
 drivers/crypto/caam/pdb.h         |  16 ++-
 drivers/crypto/caam/pkc_desc.c    |   8 +-
 drivers/crypto/caam/regs.h        | 139 ++++++++++++------
 12 files changed, 294 insertions(+), 229 deletions(-)

-- 
2.21.0

