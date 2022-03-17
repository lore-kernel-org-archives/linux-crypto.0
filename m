Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A82DAC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Mar 2022 20:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiCQU5d (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Mar 2022 16:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiCQU5c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Mar 2022 16:57:32 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF898154078
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 13:56:12 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id x15so8988442wru.13
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 13:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xxLigyYubLEfmpzYjesUYMDr681KbgpjvGFg62V3uuo=;
        b=q43mTTbnckKvjJEG6SpmkOL75jCyN+O53AbqkF2sH5XMTWnKY3PtwkqyaFIEcLXBim
         3a5P9Yat03SsVCxysdY+Vius+9jF0kAGvK2I/n8oARjFd3FY/RlfrpMJhteTpo/lMTsb
         Mn0St1xk/mewvcj3k7LJsveBJuz9x+Y2D+9NDvVegPO0tuByXsWqKUec8lQof/z9+E6n
         hrEjrRVUcIeUQ6ZtwLDDoFLlisG/7IFWts55uGoEIvY/8CKvEv4ZJZvPu0PniNQhSGRp
         uPLSb+EBMMR8u5Q3XBqaRUKhL0Y5QN/kudoZl5PEJWeEJC/l+kGAbUjl52UsF3pgIr0+
         Lmxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xxLigyYubLEfmpzYjesUYMDr681KbgpjvGFg62V3uuo=;
        b=UP6B8Gp3ROYF5d32HsO3QGjZ7TuB+epCA2ksMgiAIh24Ir+J+AvEhknK9SpH+SlQxj
         dMrOQHNJktXRN+hHNRo40hG22KZRt5fgEegnmURsWvfUfLbkXAwUXq33ZSjnNkmGX859
         m7HZrSyX2oN1pW/UlCPGM9TRAL5RaOiq8VfBVwFtgyzt8Zn/sxSGRxx23T15oSmz454E
         aHXbmlG64UkQcxX3lwVzS3R3QjvrucKmZpaZI6MN40K0JEpwrxtWkaUgdrdbdgmhKQUz
         9kSuiaXVPGWNy+FkBljdkvj/x0p5kx0HTjmVwBJcK06oSzIwEO3x6DL7JW6gP/48zKnZ
         0ivw==
X-Gm-Message-State: AOAM533XG5kSXuqlqZsmLM81xxm0zeaooVhagKrohlkAu9AHQN5hxnxK
        33pQAGmenKMRbTF3MVSH2xYT3A==
X-Google-Smtp-Source: ABdhPJwnwLdUdvOyaa98IK90oH6uDYzGms32CnUFdkUB2BE7Anl0fygB88gDwIBMvxdSPZP7d0z/vQ==
X-Received: by 2002:adf:9581:0:b0:1ed:c341:4ed1 with SMTP id p1-20020adf9581000000b001edc3414ed1mr5616024wrp.299.1647550571570;
        Thu, 17 Mar 2022 13:56:11 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id r4-20020a05600c35c400b00389f368cf1esm3695424wmq.40.2022.03.17.13.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 13:56:11 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     herbert@gondor.apana.org.au, jernej.skrabec@gmail.com,
        samuel@sholland.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 00/19] crypto: allwinner: lots of fixes
Date:   Thu, 17 Mar 2022 20:55:46 +0000
Message-Id: <20220317205605.3924836-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

This series is all fixes which I found on allwinner crypto drivers.

Regards

Corentin Labbe (19):
  crypto: sun8i-ce: Fix minor style issue
  crypto: sun8i-ce: do not allocate memory when handling requests
  crypto: sun4i-ss: do not allocate backup IV on requests
  crypto: sun8i-ss: rework handling of IV
  crypto: sun8i-ss: handle zero sized sg
  crypto: sun8i-ss: remove redundant test
  crypto: sun8i-ss: test error before assigning
  crypto: sun8i-ss: use sg_nents_for_len
  crypto: sun8i-ss: do not allocate memory when handling hash requests
  crypto: sun8i-ss: do not zeroize all pad
  crypto: sun8i-ss: handle requests if last block is not modulo 64
  crypto: sun8i-ss: rework debugging
  crypto: sun8i-ss: Add function for handling hash padding
  crypto: sun8i-ss: add hmac(sha1)
  crypto: sun8i-ss: do not fallback if cryptlen is less than sg length
  crypto: sun8i-ce: Add function for handling hash padding
  crypto: sun8i-ce: use sg_nents_for_len
  crypto: sun8i-ce: rework debugging
  crypto: sun8i-ce: do not fallback if cryptlen is less than sg length

 .../allwinner/sun4i-ss/sun4i-ss-cipher.c      |  22 +-
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h  |   1 +
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 102 +++--
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c |  54 ++-
 .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 130 ++++--
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  |  19 +-
 .../allwinner/sun8i-ss/sun8i-ss-cipher.c      | 180 +++++---
 .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c |  92 ++++-
 .../crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 385 +++++++++++++++---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h  |  33 +-
 10 files changed, 767 insertions(+), 251 deletions(-)

-- 
2.34.1

