Return-Path: <SRS0=W4lJ=6I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8BFDC55191
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 14:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87B1520776
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 14:02:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="M/YU1V3r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgDXOCZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Apr 2020 10:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726717AbgDXOCY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Apr 2020 10:02:24 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5C1C09B045
        for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2020 07:02:24 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id j1so10967561wrt.1
        for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2020 07:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=7ZczxD3IWu8/fwlBlJGiVi7Lo8lRg9T/jE4rdraMVHA=;
        b=M/YU1V3r+a/4U52L4urd8LZmQAjraZmMFffJo/cvoynAvedsZpr+HGLFo5pARAE9na
         aNeIvVge/RB983yam/OB4Dstz4W/2DpFAh7aAlIbbtNrVhpsWWQN38K2JhtgEYZF6qel
         6nVp8RnxVrK0SyRbHWDyAeGu19yJmMqGc3wu65ExvQPi76vWrRYLkhfaclE6k3fmu3X4
         +TQ1dVRTEka/4ssVjBPKTTvrV2Zewt1b9l0AuV7smmkflPuKcwC0gAX2jV1AqwevOFZ9
         Yq/iZZptWBnlysoFCKRzNWYIrYrcar5GNpBXxvniX+/rnV/84xJvYluscPYl+/GRJ/Th
         t/SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7ZczxD3IWu8/fwlBlJGiVi7Lo8lRg9T/jE4rdraMVHA=;
        b=rpxCN6rnGEv3t5odVyxJX2LKK0r42cnrNRrqMJUIfze3TX76hkOri1IYw0FawO9xXH
         JKQmmHo9FkunEXBwTZ6Fh/vh1nAERsBLn3A0tYdPGPjL7kk2tAR54kRm6kWEXg/EPNdf
         lGHsKl/ptrZUPzvtkprDUzckH/oO7r5r7v3Xzqq87NWYfLhTIJMzuRAxpAr3OSJj4/Ys
         duDLbp3/AaihNlSAecD4ApVZsj1CnxuGqjMkCYJ5ZIhByTZM5MMqRJH1LXl7MFopyn3Q
         PdgC0E9Xgx2YCJl3VE5Q18Wnawqjo8BbWNAeabohBRsDEJwQaU1hv2tqHE6+X4jsdoaK
         I+dg==
X-Gm-Message-State: AGi0PuZRYcXjuB4c11AQx2ANHZTPBVC+agA+dM/w9+wx1JS4cF6fqau2
        BOOoGQJa4GkleYNhvdRySkoFEQ==
X-Google-Smtp-Source: APiQypKaNGGMpvmyVINuIht/92jMND+x+I0jOdoShhcOzF62gR5+c4rD4idckshS2G+eaaNLoMu3DQ==
X-Received: by 2002:adf:bb0d:: with SMTP id r13mr11991980wrg.251.1587736943098;
        Fri, 24 Apr 2020 07:02:23 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id v131sm3061051wmb.19.2020.04.24.07.02.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 07:02:22 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 00/14] crypto: allwinner: add xRNG and hashes
Date:   Fri, 24 Apr 2020 14:02:00 +0000
Message-Id: <1587736934-22801-1-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

The main goal of this serie is to add support for TRNG, PRNG and hashes
to the sun8i-ss/sun8i-ce.
The whole serie is tested with CRYPTO_EXTRA_TESTS enabled and loading
tcrypt.
The PRNG and TRNG are tested with rngtest.

Regards

Change since v1:
- removed _crypto_rng_cast patch

Corentin Labbe (14):
  crypto: sun8i-ss: Add SS_START define
  crypto: sun8i-ss: Add support for the PRNG
  crypto: sun8i-ss: support hash algorithms
  crypto: sun8i-ss: fix a trivial typo
  crypto: sun8i-ss: Add more comment on some structures
  crypto: sun8i-ss: better debug printing
  crypto: sun8i-ce: move iv data to request context
  crypto: sun8i-ce: split into prepare/run/unprepare
  crypto: sun8i-ce: handle different error registers
  crypto: sun8i-ce: rename has_t_dlen_in_bytes to cipher_t_dlen_in_bytes
  crypto: sun8i-ce: support hash algorithms
  crypto: sun8i-ce: Add stat_bytes debugfs
  crypto: sun8i-ce: Add support for the PRNG
  crypto: sun8i-ce: Add support for the TRNG

 drivers/crypto/allwinner/Kconfig              |  43 ++
 drivers/crypto/allwinner/sun8i-ce/Makefile    |   3 +
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      |  99 +++-
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 365 +++++++++++++-
 .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 415 ++++++++++++++++
 .../crypto/allwinner/sun8i-ce/sun8i-ce-prng.c | 189 ++++++++
 .../crypto/allwinner/sun8i-ce/sun8i-ce-trng.c | 123 +++++
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  | 135 +++++-
 drivers/crypto/allwinner/sun8i-ss/Makefile    |   2 +
 .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 198 +++++++-
 .../crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 446 ++++++++++++++++++
 .../crypto/allwinner/sun8i-ss/sun8i-ss-prng.c | 167 +++++++
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h  |  93 +++-
 13 files changed, 2236 insertions(+), 42 deletions(-)
 create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
 create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
 create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
 create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
 create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c

-- 
2.26.2

