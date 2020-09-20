Return-Path: <SRS0=6s16=C5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B945C43463
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Sep 2020 18:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A134207D3
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Sep 2020 18:37:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="UueFFA/8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgITSh0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 20 Sep 2020 14:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgITSh0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 20 Sep 2020 14:37:26 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F8CC0613CE
        for <linux-crypto@vger.kernel.org>; Sun, 20 Sep 2020 11:37:25 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id o5so10477457wrn.13
        for <linux-crypto@vger.kernel.org>; Sun, 20 Sep 2020 11:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=j8r9eEl8b7+QpEqzy5gmnEbcHSyuwwOv6avMlgJ9/Pc=;
        b=UueFFA/89e6NVRES7AU3cSYTUDSZZ+3RpMQPDgj9UUtObN6e+V2mRI3SUm9XGPfhyO
         +PnfC7qHBd4YtETur0QBRQXabuLaqWO3yZ+rEHTjdoTZSWTTsBR2h/3xAaP9lSkeNzvo
         yswIdwoRVVmsvWYppFNeoW9icBxA0oYx+dkznNpG6B0/gKF4/VLPym1XIDqEVv/t517G
         wIq3323NNV/Qv3qWiuLa3/4XnruhOAVK1JNbTNXI//fnP0Y/mkmSsnWE2io+5Jiclgxl
         yi/IOLU4hz4yfJjq2+UKYaoOwqQ0KSNTgoxlbAksOSWY/1E8YXGlqVQSd+rgeUCt0xOJ
         FTTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=j8r9eEl8b7+QpEqzy5gmnEbcHSyuwwOv6avMlgJ9/Pc=;
        b=EjWHyzJANFLjvoAi075YJ8wmfYMzDnkJadhKJRmSfZiWgen7Wk7cC13+MudQD30yh6
         EL1rRHzEj6cmOp8jxFoPlaP8Brqw+Uj5LsM/tyBtt4zFcg5+kbJwKFxHBYrYcFTDIqRk
         Ia8VknQMJLXXoBxormc6ZTFE9nyj1o5mKYYAKINrOx5Mb55S4StOEqlBRqrxXl9kH6c9
         C8cM5P/cQWyMp52A76gErzkgE9YS7PLPTwl29RFoWZPEgSTCfbjAbvTBULI7s2tN+ptG
         rCe70CgOcND4ScKrDCT049mK63TBeWXgKQHrrrhFHKGyp/oGw0vlZRVbnpCkKIjAr/S2
         6WTw==
X-Gm-Message-State: AOAM533jgF8sUZ4H55Ma0ceMidI8owZ7vdX7VL1g5rkhK3eLI6Bd8tZw
        3Y2PvaIXEemNhsS6Sr361PgO8g==
X-Google-Smtp-Source: ABdhPJwOnrMjEvc/9cxVRZ9axQzvCMFOdtPwe7N+OxLcHz643vix8ovK7cKjIC9bvXuk16+sFhKXjw==
X-Received: by 2002:adf:a1d6:: with SMTP id v22mr50135924wrv.185.1600627044136;
        Sun, 20 Sep 2020 11:37:24 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id e18sm16419841wrx.50.2020.09.20.11.37.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Sep 2020 11:37:22 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 0/7] crypto: sun4i-ss: prevent always fallback for ciphers
Date:   Sun, 20 Sep 2020 18:37:11 +0000
Message-Id: <1600627038-40000-1-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
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

Changes since v1:
- patch #4 is sufficient to fix BE problem (removed todo)

Corentin Labbe (7):
  crypto: sun4i-ss: linearize buffers content must be kept
  crypto: sun4i-ss: checking sg length is not sufficient
  crypto: sun4i-ss: IV register does not work on A10 and A13
  crypto: sun4i-ss: handle BigEndian for cipher
  crypto: sun4i-ss: initialize need_fallback
  crypto: sun4i-ss: enabled stats via debugfs
  crypto: sun4i-ss: add SPDX header and remove blank lines

 drivers/crypto/allwinner/Kconfig              |  9 ++
 .../allwinner/sun4i-ss/sun4i-ss-cipher.c      | 82 ++++++++++++++-----
 .../crypto/allwinner/sun4i-ss/sun4i-ss-core.c | 54 ++++++++++++
 .../crypto/allwinner/sun4i-ss/sun4i-ss-hash.c |  8 ++
 .../crypto/allwinner/sun4i-ss/sun4i-ss-prng.c |  6 ++
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h  | 11 +++
 6 files changed, 148 insertions(+), 22 deletions(-)

-- 
2.26.2

