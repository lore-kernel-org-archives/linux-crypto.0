Return-Path: <SRS0=HVQB=5E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77FB8C4332B
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Mar 2020 16:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 467F120663
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Mar 2020 16:12:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R1WN1N+8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgCSQMx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Mar 2020 12:12:53 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42709 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728043AbgCSQMx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Mar 2020 12:12:53 -0400
Received: by mail-pl1-f193.google.com with SMTP id t3so1247991plz.9;
        Thu, 19 Mar 2020 09:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UKzLlIAn/trFOtiy1zgJFwH3XQgGFbyfLEfTTC8N0j8=;
        b=R1WN1N+8WYM1yoFsjZDYlo/P06FPvqLQHXEZ9UJJKu7GjaRgwtJmScXBrbbA0c2EXs
         gQS8cuaF970xu/lKVD0oaI2AtFYelyL7gdPeJaH4+7FfSq2rwdIkm9StYZs4FRSs+tbx
         D0ds9ojA2liB17vrPf9z2PYR5AN+FmTnidrVq0xcycT6a/wUKDSrFCzOZJWVPeDJykPN
         9Y+cPM8iDI6uuKtnIXtPc2n1boypuYrGL1Ogx8nWERU7QanOl0Qz5tl+Q50x19HANWSt
         OATSbaLDxpxD0pnbhlT/lrP77FOTSjBpimGXi4+OzWjQzqRPA1qNeVJYWsMjTmHvl0kp
         ya2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UKzLlIAn/trFOtiy1zgJFwH3XQgGFbyfLEfTTC8N0j8=;
        b=PrV3me2/G2I5h8JL7MilzVV/ajIuYhy/qrVT4L9hui9r9c1GkV/OZLlQpdw2TYyrG3
         9kX70/Eq/h0tXETMzAB/Rlgw6H40cS97Xj6/EcV8gswxdSY63wc5XSIaTRWPOCfXjP0m
         YWFHyPV108d3ztWJD/nECeEBZtorQY3ogUuWQ1+rHxsJ1P+JkTui5wqxQjecQ9g+A+W2
         wvjrKJoo7PE1k0gZhOF2KfCZKOzWAmeCeZ+SF7ljwLLcCoAWLrH4f9rEBw5dqyu2mSfK
         rSSNW31dAXCTkB5tpch7uwbxXT3jATK31kAOy9qBoXVDGPe7FuQYvceICCKjNWcgguaF
         QZRg==
X-Gm-Message-State: ANhLgQ2bnVcFglfY5K7YhrN4l83TtANFTxpryGReM+/WvQKXhOnuJSpY
        ic7C1lgP4KmqAcZSQmaUMoULYs7m
X-Google-Smtp-Source: ADFU+vuL7WukFuO44yw4tOMgUC4g7pNFZfexJNk6N0qYe6DCM0uFORRu/EiKrmAtVmuir1iQwz4nCQ==
X-Received: by 2002:a17:902:b60f:: with SMTP id b15mr4452877pls.14.1584634370490;
        Thu, 19 Mar 2020 09:12:50 -0700 (PDT)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id x189sm3000078pfb.1.2020.03.19.09.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 09:12:48 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v9 0/9] enable CAAM's HWRNG as default
Date:   Thu, 19 Mar 2020 09:12:24 -0700
Message-Id: <20200319161233.8134-1-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Everyone:

This series is a continuation of original [discussion]. I don't know
if what's in the series is enough to use CAAMs HWRNG system wide, but
I am hoping that with enough iterations and feedback it will be.

Changes since [v1]:

    - Original hw_random replaced with the one using output of TRNG directly

    - SEC4 DRNG IP block exposed via crypto API

    - Small fix regarding use of GFP_DMA added to the series

Chagnes since [v2]:

    - msleep in polling loop to avoid wasting CPU cycles

    - caam_trng_read() bails out early if 'wait' is set to 'false'

    - fixed typo in ZII's name

Changes since [v3]:

    - DRNG's .cra_name is now "stdrng"

    - collected Reviewd-by tag from Lucas

    - typo fixes in commit messages of the series

Changes since [v4]:

    - Dropped "crypto: caam - RNG4 TRNG errata" and "crypto: caam -
      enable prediction resistance in HRWNG" to limit the scope of the
      series. Those two patches are not yet ready and can be submitted
      separately later.

    - Collected Tested-by from Chris

Changes since [v5]:

    - Series is converted back to implementing HWRNG using a job ring
      as per feedback from Horia.

Changes since [v6]:

    - "crypto: caam - drop global context pointer and init_done"
      changed to use devres group to allow freeing HWRNG resource
      independently of the parent device lifecycle. Code to deal with
      circular deallocation dependency is added as well

    - Removed worker self-scheduling in "crypto: caam - simplify RNG
      implementation". It didn't bring much value, but meant that
      simple cleanup with just a call to flush_work() wasn't good
      enough.

    - Added a simple function with a FIXME item for MC firmware check in
      "crypto: caam - enable prediction resistance in HRWNG"

    - "crypto: caam - limit single JD RNG output to maximum of 16
      bytes" now shrinks async FIFO size from 32K to 64 bytes, since
      having a buffer that big doesn't seem to do any good given that
      througput of TRNG

Changes since [v7]:

    - Collected Reviewd-bys from Horia

    - updated "crypto: caam - simplify RNG implementation" to drop
      custom type and fix comments

    - updated "crypto: caam - enable prediction resistance in HRWNG"
      to integrate code from Andrei Botila

    - updated "crypto: caam - drop global context pointer and
      init_done" to use .priv instead of container_of for private data
      pointer

Changes since [v8]

    - Collected more Reviewd-bys from Horia

    - Pulled "bus: fsl-mc: add api to retrieve mc version" into the set_

    - Moved RNG quality setting back to "crypto: caam - limit single
      JD RNG output to maximum of 16 bytes" where it belongs

    - Fixed comparison and checkpatch warnings in "crypto: caam -
      enable prediction resistance in HRWNG" per feedback from Horia


Feedback is welcome!

Thanks,
Andrey Smirnov

[discussion] https://patchwork.kernel.org/patch/9850669/
[v1] https://lore.kernel.org/lkml/20191029162916.26579-1-andrew.smirnov@gmail.com
[v2] https://lore.kernel.org/lkml/20191118153843.28136-1-andrew.smirnov@gmail.com
[v3] https://lore.kernel.org/lkml/20191120165341.32669-1-andrew.smirnov@gmail.com
[v4] https://lore.kernel.org/lkml/20191121155554.1227-1-andrew.smirnov@gmail.com
[v5] https://lore.kernel.org/lkml/20191203162357.21942-1-andrew.smirnov@gmail.com
[v6] https://lore.kernel.org/lkml/20200108154047.12526-1-andrew.smirnov@gmail.com
[v7] https://lore.kernel.org/lkml/20200127165646.19806-1-andrew.smirnov@gmail.com
[v8] https://lore.kernel.org/lkml/20200316150047.30828-1-andrew.smirnov@gmail.com

Andrei Botila (1):
  bus: fsl-mc: add api to retrieve mc version

Andrey Smirnov (8):
  crypto: caam - allocate RNG instantiation descriptor with GFP_DMA
  crypto: caam - use struct hwrng's .init for initialization
  crypto: caam - drop global context pointer and init_done
  crypto: caam - simplify RNG implementation
  crypto: caam - check if RNG job failed
  crypto: caam - invalidate entropy register during RNG initialization
  crypto: caam - enable prediction resistance in HRWNG
  crypto: caam - limit single JD RNG output to maximum of 16 bytes

 drivers/bus/fsl-mc/fsl-mc-bus.c |  33 +--
 drivers/crypto/caam/Kconfig     |   1 +
 drivers/crypto/caam/caamrng.c   | 405 ++++++++++++--------------------
 drivers/crypto/caam/ctrl.c      |  88 +++++--
 drivers/crypto/caam/desc.h      |   2 +
 drivers/crypto/caam/intern.h    |   7 +-
 drivers/crypto/caam/jr.c        |  13 +-
 drivers/crypto/caam/regs.h      |   7 +-
 include/linux/fsl/mc.h          |  16 ++
 9 files changed, 276 insertions(+), 296 deletions(-)

--
2.21.0
