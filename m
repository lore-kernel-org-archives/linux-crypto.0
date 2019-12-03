Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C88C432C0
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 16:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E050A20833
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 16:24:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ocaq0D2M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbfLCQYO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 11:24:14 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36520 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfLCQYO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 11:24:14 -0500
Received: by mail-pf1-f193.google.com with SMTP id b19so2100387pfd.3;
        Tue, 03 Dec 2019 08:24:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UF68x/KuCHKog45NJwPbUxi85MNam/g/8jmiTNyQvwE=;
        b=Ocaq0D2M6Zm1TRioVqqndRLyX8n+8aHCZRA7WPMFkKTdAb1BpVM9vr30wU5X3bsfKU
         wJN+srOBZsZVj6I/npeZo3nofRj9nWyz0wUHJlUvYv0ic3hqz2ak6bvdOwvf52E5Nnv9
         xp3hRHxCSWM5vj1Nwko8cGUUdfN4nNsnUIazQJtG5Vb82RsnnWIhRj7Uclnrh1zWBzuD
         BP8mFsmoCHd0fWn7UJCQKouvJ7CYi37tG+dI4ydDv26GTi52rp0PHrk0TuFrjV7hybYk
         u05dbMhPY3sgREdA4ptcbuQLwywlOpLPjPdcukjxcmtW+esMAsrF8LzdIFYYmIAzKc2Y
         m4uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UF68x/KuCHKog45NJwPbUxi85MNam/g/8jmiTNyQvwE=;
        b=Ole5VYjCXNXP7M/vj2Is41ZEA+ZiZcGlmwlyaDX3OW3LOZj2ZL97eCYP2ckjBFkhlK
         0MZVfRA/qquIqG6uQdNetfGtrz79bzQ1Cp7KlkiSDS0xQBg91gHyPGeKGeamxvszKrfM
         8zZHsbVuFd/MLlj96fH9Ep3lY5ACjNu6kKnKM8w7l8hc+M+wSXwgNJEcdJqquQu1joD5
         jDujcacxKgyNF/bM+rJ2l8XX5gzriF0Hjz+5LaOA8W/CXHDm59d2Q0udj+GOdeh4SUt2
         590xqKqrc2gTRAe+ARbL/U5MoQdP8Sn7EUhSsLEWtuoSYrI3LbpG/flpGOyo1FhvS/Yv
         yrXg==
X-Gm-Message-State: APjAAAVsUa7ey/6q9ubm76Qdy24Kg7IKkGI2twx66eF2akNHs5QDMKMv
        +L6vT2Sj/IopjOLZF7LjatX9pg2BdpY=
X-Google-Smtp-Source: APXvYqzkMkKwlby+VAtipSB3PC7III49VAd83ljH9tCYZri4Rn7UPM7Oxw/yWV6jdhwEp+3vAerE5g==
X-Received: by 2002:a63:e145:: with SMTP id h5mr5918290pgk.387.1575390252701;
        Tue, 03 Dec 2019 08:24:12 -0800 (PST)
Received: from localhost.hsd1.wa.comcast.net ([2601:602:847f:811f:babe:8e8d:b27e:e6d7])
        by smtp.gmail.com with ESMTPSA id g10sm4052093pgh.35.2019.12.03.08.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 08:24:11 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v5 0/4] enable CAAM's HWRNG as default
Date:   Tue,  3 Dec 2019 08:23:53 -0800
Message-Id: <20191203162357.21942-1-andrew.smirnov@gmail.com>
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

Feedback is welcome!

Thanks,
Andrey Smirnov

[discussion] https://patchwork.kernel.org/patch/9850669/
[v1] https://lore.kernel.org/lkml/20191029162916.26579-1-andrew.smirnov@gmail.com
[v2] https://lore.kernel.org/lkml/20191118153843.28136-1-andrew.smirnov@gmail.com
[v3] https://lore.kernel.org/lkml/20191120165341.32669-1-andrew.smirnov@gmail.com
[v4] https://lore.kernel.org/lkml/20191121155554.1227-1-andrew.smirnov@gmail.com

Andrey Smirnov (4):
  crypto: caam - allocate RNG instantiation descriptor with GFP_DMA
  crypto: caam - move RNG presence check into a shared function
  crypto: caam - replace DRNG with TRNG for use with hw_random
  crypto: caam - expose SEC4 DRNG via crypto RNG API

 drivers/crypto/caam/Kconfig   |  15 +-
 drivers/crypto/caam/Makefile  |   3 +-
 drivers/crypto/caam/caamrng.c | 358 ----------------------------------
 drivers/crypto/caam/ctrl.c    |  10 +-
 drivers/crypto/caam/drng.c    | 174 +++++++++++++++++
 drivers/crypto/caam/intern.h  |  32 ++-
 drivers/crypto/caam/jr.c      |   3 +-
 drivers/crypto/caam/regs.h    |  11 +-
 drivers/crypto/caam/trng.c    |  89 +++++++++
 9 files changed, 320 insertions(+), 375 deletions(-)
 delete mode 100644 drivers/crypto/caam/caamrng.c
 create mode 100644 drivers/crypto/caam/drng.c
 create mode 100644 drivers/crypto/caam/trng.c

-- 
2.21.0

