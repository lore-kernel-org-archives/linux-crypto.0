Return-Path: <SRS0=Ncaf=5T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 349BAC2BA12
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 19:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AC98208E4
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 19:50:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="a9N6X3yR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgDCTuv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Apr 2020 15:50:51 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38046 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727322AbgDCTuu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Apr 2020 15:50:50 -0400
Received: by mail-wm1-f67.google.com with SMTP id f6so9012288wmj.3
        for <linux-crypto@vger.kernel.org>; Fri, 03 Apr 2020 12:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=nFx9+E3/I3cB6us//mWp1dQ/lgfKdqFwPaZtN2Fz8F8=;
        b=a9N6X3yRHB1eUo8fHlrRPYDRWb0Dmp/Y+K6uUEA2mCZqFhCsFmFkm3uh5cyg2F7cUg
         mWw6jU1pl15z9+9j1LzeK3X/cm8T5TgS+/Uy0uKEhB9SVKJaTk2/8nztX2utpd/MHSbH
         xq9oqXMO0zeUcFmQKD13FKOVaDL3gS1R2FnFky5Ip4MdaPw0KCjFQ2+j2JjfbCjn8OJs
         awphxpsaIxsMAIhmFWIGknHVD4vFHqDDYXnp6WpQ18tLnXE4L/UYNGPvr6MoIdOyk+wx
         EzF3//SnimpL96RLJ1VN+rSh77GLM7SUzBD+xTRKAp2D4M4PRFeOCKmGCfKz4Plzfq+M
         Vt/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nFx9+E3/I3cB6us//mWp1dQ/lgfKdqFwPaZtN2Fz8F8=;
        b=DQ83mzjj05nKid1J7fauDs1/2YEmYSxoGZQ6dWNr7+8h0/Pmx3CUL89WPr9SO+g1zT
         IyKuyC8XLxMNTz3pngTkZG5aUpIWDhdXAFFlGdCIjs7lom3JZ7gFQ9aUBU8aDrhe4NcM
         tpmN0k/Q6pBRpLrv19EsLN7O3CovqFdcevwbqqPXeEJ80jKIBTy4jsEVrRXAt1grimFw
         FKecs2LSZ9x1WBcXM1UBIY3fUNyEEQzFxRnLFwhXrsFuFYutujnY32oGxLpqo1OBq5w4
         WXinca2M7YtXnMg3yqUXQkPADFpQLO14RlmbwQPz6EouMR4v2IzfeezzjOZJD0MwHIRi
         3qtA==
X-Gm-Message-State: AGi0PubsvP4yru7H7MFFvhR3W+ten3VFVAfy7/nrir44XpJmNLKHVRVD
        A+aQ32H/rC4wJoceXsTppIR/pA==
X-Google-Smtp-Source: APiQypIF0ut2srpAxEZKs7x+LNw+xXPDmIM+QWqFYlREFjQlIbCeKGLvmqhiFyfO/WD4LC6sVSkxig==
X-Received: by 2002:a1c:2056:: with SMTP id g83mr10219642wmg.179.1585943447063;
        Fri, 03 Apr 2020 12:50:47 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id c17sm8102448wrp.28.2020.04.03.12.50.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 03 Apr 2020 12:50:46 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 0/7] crypto: sun8i-ss: support PRNG and hashes
Date:   Fri,  3 Apr 2020 19:50:31 +0000
Message-Id: <1585943438-862-1-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

The main goal of this serie is to add support for PRNG and hashes to the
sun8i-ss.
The whole serie is tested with CRYPTO_EXTRA_TESTS enabled and loading
tcrypt.
The PRNG is tested with rngtest.

Regards

Corentin Labbe (7):
  crypto: rng - add missing __crypto_rng_cast to the rng header
  crypto: sun8i-ss: Add SS_START define
  crypto: sun8i-ss: Add support for the PRNG
  crypto: sun8i-ss: support hash algorithms
  crypto: sun8i-ss: fix a trivial typo
  crypto: sun8i-ss: Add more comment on some structures
  crypto: sun8i-ss: better debug printing

 drivers/crypto/allwinner/Kconfig              |  17 +
 drivers/crypto/allwinner/sun8i-ss/Makefile    |   2 +
 .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 198 +++++++-
 .../crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 446 ++++++++++++++++++
 .../crypto/allwinner/sun8i-ss/sun8i-ss-prng.c | 169 +++++++
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h  |  93 +++-
 include/crypto/rng.h                          |   5 +
 7 files changed, 927 insertions(+), 3 deletions(-)
 create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
 create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c

-- 
2.24.1

