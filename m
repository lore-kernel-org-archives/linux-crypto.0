Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8354C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jan 2022 21:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbiAZVEv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jan 2022 16:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbiAZVEv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jan 2022 16:04:51 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBFEC06173B
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jan 2022 13:04:50 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id i187-20020a1c3bc4000000b0034d2ed1be2aso4581208wma.1
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jan 2022 13:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DMvBRIpA0/pHSEkKz7ZQmVefisxCnIB7c3bp5JfnGsI=;
        b=L57gwERWThKBhvaTL9wZxDoT9Uhvyw8ANdyTtCWnAuSsuaNszVO/1RbEqab0HZfJ2c
         wS6kqxR/hfcodFA4B62COohudajaOF5MxYXGJUz2u7iJw0JgJ0Fum4LqCbox1EUwHp0Y
         1gYvm+qONdkKKp8cUdKq4f8O6PMhVNucnlCk+ojbLATN0YrFYEqyHFpF/uUvgb1k1kBu
         RIj4UPWfiGVL2MdCALyXFcUjY5Qljo8afk10M7vuGP7xGggLVS2ugt1RsZtbQS0+Os5n
         21788Z6ANCX263OseF9RFedtWrRq2dys6NRUDdxZEVpbzkKc8q+lDL00GEIVstWyhUAM
         lisA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DMvBRIpA0/pHSEkKz7ZQmVefisxCnIB7c3bp5JfnGsI=;
        b=7tAV8GKJGKbIeZG3Wt0/CY0tP9+m2TQuCZNSEtCgnvHzPH/EAcNa+pPvj48qWM5O/A
         +ABAGFCWWiPfLu/RD8aC1E1JXt21r5YxNFYRVeuW5aS7UxkTSfasCusi7I0uf3abCBhi
         BypbcVpr1VvpBT9RerU3Ucad2fvHBtKki91XN/jWWqU3pUG6uqFTUFZUOGGKmuOt4i5Q
         WmHqcfkwfk/nD4+39W1725GlOXDZvwSWKUf+WZmqdZZgpvWly+yNtzZbCtjFi+yh/2vM
         0oqSxarZskZobA2F0LMMKSK6IexZ/NMR+8fjldS8nc5nBxZcNhJUur8hPzrcYrm9lEn8
         U4+g==
X-Gm-Message-State: AOAM531/KcLZCuJFdzyTu0PhRhohEZvzFsRq0ZFXNyWM41vK4fYuu1uE
        xsaJa9j6h2SXeesugOLL6kYmiGcemBHONg==
X-Google-Smtp-Source: ABdhPJxxTiJUsakyD/bKlH9lLMOR6zqVufOIQclFGT9QW+h9m5/4JkNUq6391sN7S8QoXfZJZGsH6A==
X-Received: by 2002:a05:600c:350e:: with SMTP id h14mr448174wmq.166.1643231089360;
        Wed, 26 Jan 2022 13:04:49 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id j19sm4948611wmq.17.2022.01.26.13.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 13:04:48 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@gmail.com, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        linux-sunxi@googlegroups.com, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 0/8] crypto: allwinner: various improvments
Date:   Wed, 26 Jan 2022 21:04:33 +0000
Message-Id: <20220126210441.3661782-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

The main topic was to remove memory allocation from requests function.
Doing this on sun8i-ss, lead to some extra fixes to be found.

Regards

Corentin Labbe (8):
  crypto: sun8i-ce: do not allocate memory when handling requests
  crypto: sun4i-ss: do not allocate backup IV on requests
  crypto: sun8i-ss: handle zero sized sg
  crypto: sun8i-ss: do not allocate memory when handling hash requests
  crypto: sun8i-ss: do not zeroize all pad
  crypto: sun8i-ss: remove redundant test
  crypto: sun8i-ss: test error before assigning
  crypto: sun8i-ss: handle requests if last block is not modulo 64

 .../allwinner/sun4i-ss/sun4i-ss-cipher.c      | 22 ++---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h  |  1 +
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 28 ++-----
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 20 ++++-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  |  8 +-
 .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 10 +++
 .../crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 84 ++++++++++---------
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h  |  6 ++
 8 files changed, 100 insertions(+), 79 deletions(-)

-- 
2.34.1

