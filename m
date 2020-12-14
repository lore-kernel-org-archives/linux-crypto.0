Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CCDC4361B
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 20:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7DA02168B
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 20:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502884AbgLNUDk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Dec 2020 15:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502903AbgLNUDa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Dec 2020 15:03:30 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE93C0613D3
        for <linux-crypto@vger.kernel.org>; Mon, 14 Dec 2020 12:02:50 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id l23so7343725pjg.1
        for <linux-crypto@vger.kernel.org>; Mon, 14 Dec 2020 12:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=QT8NIpdXPvB5AxHdzPljCniOubRI5wdzJKZjH5NenqY=;
        b=DujLLjbNY2EqBfSfkapUKZhtAMbzp6keOCUoGrS6UzdoyiRrmkjKWP6Ufrc4ru/3K2
         axkWExX+zhOPGOUPZIXVJk/zH6AwlYuYYbyF/y+U1WXH4rCPIgfcBOUyrOgH6DOHKVRD
         aB83q/S1BUogVWX5nRzlndQxQ4f2F/9dySQGMpsfe2t9nb9hpsx9C2hfiM+Dl29uc+IV
         Hh/WhUTDAILLkg7PFCmkWyMdi8UU2MQ+N4lPYDze0VMhgsww8DWG4PjN3d4hI9ckMJ4Y
         bdbxgjiIyqtTSuBkqj1PxtCjofRXWjzP5lmgyQ1ghOumixPFbxYc9MhWVqyP5mdLcUWZ
         +h2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QT8NIpdXPvB5AxHdzPljCniOubRI5wdzJKZjH5NenqY=;
        b=m0KJMJkRk/KlV0TkdI7kUcukFSIc629tmU1BLo0+vIZdydCWeyUyidTihsjCQwnKuF
         r95ZGvcxj5rCQubJFsKYqLQ4Nij0hFlDaB6b8qMlqEFhToqgV5qtN08jSRSya7ySKMJ2
         UarwhiW9I5V6Qi1A7xEQr733LLsL5f4e5f19SzyrqTK1PT1lRw3xXo9UxIf2SC0oER59
         1MSl3Fi7Dk4wlthsSxvWjLCKdSYHOjzpgjLJQO/p9f8xS4hlOQpwzG3sRbuOJ4yq0gHq
         1F1EKJklH1O0eZlqrY1FNRs2MwPlfQvOHUMK3e5UqD9PFo1LJsh/vGk9H9aXgrgBsLEh
         cTIg==
X-Gm-Message-State: AOAM530ugeiVEu6dMVIyoSft1/1rMCkDM8hgvVFMse49wzgssE+tRH1m
        Hu/T/ikIx0g9z6rQkJp6Kqw2+A==
X-Google-Smtp-Source: ABdhPJwkjyrENefrYh5pxJoB8S3p7TTI+eXMZ6+uwRGFC7DK+3jkBzZ+qU5Jx7hVyfjt+T6PNIbfkA==
X-Received: by 2002:a17:90a:7e95:: with SMTP id j21mr26783571pjl.217.1607976169812;
        Mon, 14 Dec 2020 12:02:49 -0800 (PST)
Received: from localhost.localdomain ([163.172.76.58])
        by smtp.googlemail.com with ESMTPSA id js9sm22434109pjb.2.2020.12.14.12.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:02:49 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@siol.net, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 0/8] crypto: sun4i-ss: prevent always fallback for ciphers
Date:   Mon, 14 Dec 2020 20:02:24 +0000
Message-Id: <20201214200232.17357-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

For help testing on "crypto: sun4i-ss - Fix sparse endianness markers",
I have added "stats" support like other allwinner's crypto drivers.
Seeing stats showed a clear problem, the ciphers function were not used
at all.
This is due to the not-inialized need_fallback which is "init" as true
everytime.
So basicly, since the patch introduced it, this probem hidden some bugs.

This serie fixes all hidden problems, then fix the initialization of
"need_fallback" and then add the stats like other allwinner drivers.

Regards

changes since v3:
- patch #2: Rewrite test as suggested by David Laight
- patch #7: removed all ifdef CONFIG_CRYPTO_DEV_SUN4I_SS_DEBUG
- added kmap patch

Changes since v2:
- patch #1: move buf/bufo out of function for reducing stack usage
- patch #4: use writesl()
- patch #6: use IS_ENABLED instead of #ifdef

Changes since v1:
- patch #4 is sufficient to fix BE problem (removed todo)

Corentin Labbe (8):
  crypto: sun4i-ss: linearize buffers content must be kept
  crypto: sun4i-ss: checking sg length is not sufficient
  crypto: sun4i-ss: IV register does not work on A10 and A13
  crypto: sun4i-ss: handle BigEndian for cipher
  crypto: sun4i-ss: initialize need_fallback
  crypto: sun4i-ss: fix kmap usage
  crypto: sun4i-ss: enabled stats via debugfs
  crypto: sun4i-ss: add SPDX header and remove blank lines

 drivers/crypto/allwinner/Kconfig              |   9 +
 .../allwinner/sun4i-ss/sun4i-ss-cipher.c      | 196 +++++++++++-------
 .../crypto/allwinner/sun4i-ss/sun4i-ss-core.c |  52 +++++
 .../crypto/allwinner/sun4i-ss/sun4i-ss-hash.c |   6 +
 .../crypto/allwinner/sun4i-ss/sun4i-ss-prng.c |   6 +
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h  |   8 +
 6 files changed, 207 insertions(+), 70 deletions(-)

-- 
2.26.2

