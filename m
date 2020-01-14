Return-Path: <SRS0=ZPJC=3D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 127E0C33CB1
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jan 2020 13:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D719D24679
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jan 2020 13:59:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W5yD7THh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgANN7w (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jan 2020 08:59:52 -0500
Received: from mail-wm1-f41.google.com ([209.85.128.41]:36852 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgANN7w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jan 2020 08:59:52 -0500
Received: by mail-wm1-f41.google.com with SMTP id p17so13869409wma.1;
        Tue, 14 Jan 2020 05:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WxdkQ4fln/Ubg69SQWZPku8d8xfNPtcWo6lDszFAgoU=;
        b=W5yD7THh9GoPrqpAR+V6A99baoCffIA80ESDKdfUT4jQ43HWe7mgvJtpFBECNzWpfo
         bz8xxkmz7NEenvBfXfcRuOdyeWxr/pUVVyFOh9D5p9Nqf4DNNkAg8yMwt2KipmDXSA4m
         F/Xi7b8c+8LkgBp35W80e9OVXqAPJNH2bBe+He6wKRT0YZa0l/hFhJpvHkcEUovLUEpi
         UHyC1DShgeL4HbPe4cvV8l153bzO81NZY3bLWpc1uh9L8pOP8grJOHDrSBs/SEUo7Q/G
         C6IkbFOdSBNykmToWLZSS6dvZWgV7mwwdZTUK+lIjdgNba/X1T0dVEkSEzSu50mSY97i
         xWOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WxdkQ4fln/Ubg69SQWZPku8d8xfNPtcWo6lDszFAgoU=;
        b=MQPDaq883hDxv/L/2ACMJZQ2Bmg6p18NXzsPxP8T2LjCnCy32wmf3b62J1rtzIEMVp
         GEeEO022/ZMN80jUWChj181jxa69Ngd5ZpPstZeMkkjIZFWIIa7kLLzM+3ZDZ/nkryQE
         NcAoAcJK6BxENuRKyYQzS1ScZhFNvG4X2CA/V/69eqdROPcfU4TMW5YKA/dUBY6Aog8V
         Xwn0kDLa3iSkhQ68zmxHUkIeaf9jabJIJxrqZDhkF7oMezqFm6s8Q1/WWl5kgD4a0Cus
         jmrzLAM2d61SiDZPh54RuH7yTqQ5mB0kvMPXPUqtg086pmMO1SH3DYEkcovnMIhwbOQk
         oTww==
X-Gm-Message-State: APjAAAUqLadIONRnjWOpae8X//iqp9dNK4ZwpwlHvbshi4TCfd9Dxhb4
        tAwH/W0dRs02ANYR/ILLJPM=
X-Google-Smtp-Source: APXvYqzNVQbW7IsfrQ2HGsc5vwBjjCjT9FNXhoYr/xxz+X6aphiPMpyQ6yCNL9Z9aspgGTjXkf82iw==
X-Received: by 2002:a05:600c:20e:: with SMTP id 14mr19620970wmi.104.1579010389767;
        Tue, 14 Jan 2020 05:59:49 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id 4sm17854448wmg.22.2020.01.14.05.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 05:59:49 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     alexandre.torgue@st.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, mcoquelin.stm32@gmail.com,
        mripard@kernel.org, wens@csie.org, iuliana.prodan@nxp.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH RFC 00/10] crypto: engine: permit to batch requests
Date:   Tue, 14 Jan 2020 14:59:26 +0100
Message-Id: <20200114135936.32422-1-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

The sun8i-ce hardware can work on multiple requests in one batch.
For this it use a task descriptor, and chain them.
For the moment, the driver does not use this mechanism and do requests
one at a time and issue an irq for each.

Using the chaning will permit to issue less interrupts, and increase
thoughput.

But the crypto/engine can enqueue lots of requests but can ran them only
one by one.

This serie introduce a way to batch requests in crypto/engine by
- setting a batch limit (1 by default)
- refactor the prepare/unprepare code to permit to have x requests
  prepared/unprepared at the same time.

For testing the serie, the selftest are not enough, since it issue
request one at a time.
I have used LUKS for testing it.

Please give me what you think about this serie, specially maintainers
which have hardware with the same kind of capability.

Regards

Corentin Labbe (10):
  crypto: sun8i-ce: move iv data to request context
  crypto: sun8i-ce: increase task list size
  crypto: sun8i-ce: split into prepare/run/unprepare
  crypto: sun8i-ce: introduce the slot number
  crypto: engine: transform cur_req in an array
  crypto: engine: introduce ct
  crypto: sun8i-ce: handle slot > 0
  crypto: engine: add slot parameter
  crypto: engine: permit to batch requests
  crypto: sun8i-ce: use the new batch mechanism

 crypto/crypto_engine.c                        |  76 +++++++----
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 121 +++++++++++++-----
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c |  17 ++-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  |  17 ++-
 drivers/crypto/omap-aes-gcm.c                 |   2 +-
 drivers/crypto/omap-aes.c                     |   4 +-
 drivers/crypto/omap-des.c                     |   4 +-
 drivers/crypto/stm32/stm32-cryp.c             |   8 +-
 drivers/crypto/stm32/stm32-hash.c             |   4 +-
 include/crypto/engine.h                       |  27 +++-
 10 files changed, 201 insertions(+), 79 deletions(-)

-- 
2.24.1

