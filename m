Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33CA8C31E5B
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 16:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03CD7208C4
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 16:03:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GEbgzSr+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbfFQQD5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 12:03:57 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42183 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbfFQQD5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 12:03:57 -0400
Received: by mail-pg1-f196.google.com with SMTP id l19so6055515pgh.9;
        Mon, 17 Jun 2019 09:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gldVmdE+kbOBaEyP28aTa8TNMptT/hmHnswBXsj9exw=;
        b=GEbgzSr+SeiaUrlixmOsCdJZuCqzY/kMzs1C8A3pms8s+zRn2f/3dk9CM1gG0OqCjk
         WVFy1aT4H9J1bUa7KXcCdt4tgqz/cAzX5xiNV7hcqGMAbwUkNH1Bk6FoYZP9UaKZfMXn
         q3cdhwtaEcm+iwEQvbFuSKsVE9mSNV5CL7xvdQIDe035ksz3cF+I6PlmoiBxsw/C3Z4N
         PWVWgpfErh1rT1SjJApr+fCvcJdPki9qLNdmQzabGw++qkKTappAuxx1e6PFFg+dv+DW
         Fvfjd8uyE+t1mAjnOnGYOzvhGiQOJPCqSa86Np2BXsUKS5kOwjwdflNWzLPd0TZMcLoq
         TzCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gldVmdE+kbOBaEyP28aTa8TNMptT/hmHnswBXsj9exw=;
        b=ceBF+ld8pAG74ZkVvZmoz/bNo0kXl5Kh8pO7Seb2bKhd8faxEJXjat+eNUqay2Yevq
         hGzMUxxIn9jPcJCmOTAnsmzJL70uRM2tk/ZFpaY1NPu7jog5hu3yEHGUOGXE/EnQW5/i
         J60IFGQKnm37ugfQiM068q0BjXbGSwuvgMiQzM8drELii6iHdCU85BiUgbVHwdNvWSIQ
         FtmopBkAiftsjg+wmypZn6GGut9gggLNXReOZoEMjzgynB4vVVnlfzVP3ziV2P8TGf9w
         +OCC4lIMdK214zVNuJkDVsnJfLJcr5sUPSGFnnwQjH/QSoekVtNziTSBqOEBQ6bHu/uh
         r+1w==
X-Gm-Message-State: APjAAAWHBKbmFr0fLpKmG+GI6rCa8NoGrqaL1sZ6marYy053PdhHKpqW
        /BIqFNn6NQoGF7gAheLxwRPAqiRvxPI=
X-Google-Smtp-Source: APXvYqx2OD3dEeOF9vExTqtv/owO7ZgKW4mS3DXvB5ORhd6PozpJOw4bpJ+/Ak8fk/BKiPLesRgSaQ==
X-Received: by 2002:a63:a514:: with SMTP id n20mr20313003pgf.438.1560787436432;
        Mon, 17 Jun 2019 09:03:56 -0700 (PDT)
Received: from localhost.lan (c-24-22-235-96.hsd1.wa.comcast.net. [24.22.235.96])
        by smtp.gmail.com with ESMTPSA id d187sm12834073pfa.38.2019.06.17.09.03.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 09:03:55 -0700 (PDT)
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
Subject: [PATCH v3 0/5] crypto: caam - Add i.MX8MQ support
Date:   Mon, 17 Jun 2019 09:03:34 -0700
Message-Id: <20190617160339.29179-1-andrew.smirnov@gmail.com>
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

[v2] lore.kernel.org/r/20190607200225.21419-1-andrew.smirnov@gmail.com
[v1] https://patchwork.kernel.org/cover/10825625/


Andrey Smirnov (4):
  crypto: caam - move DMA mask selection into a function
  crypto: caam - always select job ring via RSR on i.MX8MQ
  crypto: caam - simplfy clock initialization
  crypto: caam - add clock entry for i.MX8MQ

Chris Spencer (1):
  crypto: caam - correct DMA address size for the i.MX8

 drivers/crypto/caam/ctrl.c        | 233 +++++++++++++++---------------
 drivers/crypto/caam/desc_constr.h |  24 +--
 drivers/crypto/caam/intern.h      |  29 +++-
 drivers/crypto/caam/jr.c          |  15 +-
 drivers/crypto/caam/pdb.h         |  49 ++++---
 drivers/crypto/caam/regs.h        |  21 ++-
 6 files changed, 193 insertions(+), 178 deletions(-)

-- 
2.21.0

