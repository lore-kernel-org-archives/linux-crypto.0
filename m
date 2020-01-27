Return-Path: <SRS0=Q+7j=3Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19740C2D0DB
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 16:57:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D786B214AF
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 16:57:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="idxvBz2w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgA0Q5G (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 11:57:06 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43907 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgA0Q5G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 11:57:06 -0500
Received: by mail-pf1-f194.google.com with SMTP id s1so4566663pfh.10;
        Mon, 27 Jan 2020 08:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bv9qjL9p/yTO8gI2IwvUm3d5y0oyhFWSWAgOHXsx4wg=;
        b=idxvBz2w+aDPboH83G0TRCoZR93M3a2oRwDAmVMg1dLJzwz3N4Gz6UO/P3zpwkJguc
         df25uXyjtvEgHVSz/1zgE3ApQoCjgbFPxwublu9lT7bjTeQM01xOhE/5b++tQC2pFnwg
         tsQoG8HgK5eYDV80f1Yr5oGvE5XMoPr8uLId9pWNyAbls3JUcTo8TFO6ZhpFS9nOU8Rp
         zVQBmJqpKq7fnlYpqwoDO0oGq4xmkRqqD/FUsoBwFM/rptFa81G1cw4f5uwPtN/seKEO
         Nv9vdsIHPDB//SNwZS/EADC8AoJuP8P16Ak73jJxRQyfcNFWPwNCrUVd9Is0EbR0cFGQ
         Krxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bv9qjL9p/yTO8gI2IwvUm3d5y0oyhFWSWAgOHXsx4wg=;
        b=bAi5eI4oNy4V2ZpGVZvDRehhNST5e1hGm6D6oB7TkW0Va3didNYtUWYBlMyfSTZB42
         HMJPST7HKhHyhOKXrEdbKjGCTw+McAgVD7GmhLkYj/Sub73N8lEOJRgVxiUo5MhTh1vm
         DiIH7Vl06moRJMeDW3xrBhZrkfQWx5AIe536oYFjUjKpbUCics5B/RT+0bjsEHMxUyPJ
         KfohdzxzTIsaR5x6ZK59xZTg7FKntQ+wW3spTd/1S7BXvtrjspRTWlUGzrn/nEyY5gU5
         WIxI2PHtoc2r1WND1B3o+1u1T917Uzkk/5CAUbBUkZiw6cCqlaJ000r1RrK/PzymMlug
         kMtg==
X-Gm-Message-State: APjAAAW21bwvYf7zhZDaUy9NHu/3mfNZSKedUknYwaOIoCCxo5qcujxI
        ZtriSfgFnwZfZ/9wTKZnKFKsR1vM
X-Google-Smtp-Source: APXvYqx3i4UK2TRjRn6wDnlzBZRK6VspL+auphc16edtcsB/OENNnTGMJ8MeaR8r+W+gKdTyE+tX+A==
X-Received: by 2002:a62:5213:: with SMTP id g19mr12705647pfb.188.1580144224832;
        Mon, 27 Jan 2020 08:57:04 -0800 (PST)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id u23sm16368642pfm.29.2020.01.27.08.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 08:57:03 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v7 0/9] enable CAAM's HWRNG as default
Date:   Mon, 27 Jan 2020 08:56:37 -0800
Message-Id: <20200127165646.19806-1-andrew.smirnov@gmail.com>
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


Andrey Smirnov (9):
  crypto: caam - allocate RNG instantiation descriptor with GFP_DMA
  crypto: caam - use struct hwrng's .init for initialization
  crypto: caam - use devm_kzalloc to allocate JR data
  crypto: caam - drop global context pointer and init_done
  crypto: caam - simplify RNG implementation
  crypto: caam - check if RNG job failed
  crypto: caam - invalidate entropy register during RNG initialization
  crypto: caam - enable prediction resistance in HRWNG
  crypto: caam - limit single JD RNG output to maximum of 16 bytes

 drivers/crypto/caam/caamrng.c | 395 +++++++++++++---------------------
 drivers/crypto/caam/ctrl.c    |  56 +++--
 drivers/crypto/caam/desc.h    |   2 +
 drivers/crypto/caam/intern.h  |   7 +-
 drivers/crypto/caam/jr.c      |  13 +-
 drivers/crypto/caam/regs.h    |   7 +-
 6 files changed, 209 insertions(+), 271 deletions(-)

--
2.21.0
