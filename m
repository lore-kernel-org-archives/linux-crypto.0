Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0036CCA473
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 14:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbiGYOHP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 10:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbiGYOHO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 10:07:14 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF2413CC6
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 07:07:13 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id p10so10691701lfd.9
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 07:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E+MqVWiTt4M07TAuz476g665X1OQ10c+s7nQjeZcXao=;
        b=vXXTBYN9fy/KLckuzoHjRLsSAOG3iTFaJevAhWukskqkE6nFb2LrveWYIzZsRCSLJp
         SqblcR7p7d66Qp8VvqWTCvhBjnGSdGJL2yB7mVczIHZB4c5VLhrQqDLAsVFJEyzhxC2/
         MRd/wuxbxVa30dbhXLINSmNGl93P9zGeYuXrt6ErrzBI+Q9mliphMMXbMtDyA24A6m7K
         3j9/76a2dSYklT1jHmYQbWjOt01YbsBVEVyAVEXHtWFvC4ExGd3yFhRQY63+MDvOi3ho
         bhrH91ROhuIRpeCwZ3yP1hLyEr3OnKIOx5kfHid7BXL0Nzhy8WX7xaQUn14cXoEWBIcU
         h8eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E+MqVWiTt4M07TAuz476g665X1OQ10c+s7nQjeZcXao=;
        b=O/L3b+GGW9cV9FOPLYLsbZQohFN56bybKrGGURP/wDnUKpX8Jyd2P59p8NLTRrTvht
         wIN9Nl7qWgaiKd+Ul3eQkGHo8Ftco7q/42rwtaMbJu+diBym+GYJMVe31tPkpHOAfqIp
         wv/cpQX+q84UX4psGndMNpX+sbsOhKu5gIoG78LGBqoEx9d+latCGHpaXiczoB/NI1Nu
         zuQCZFPa82KPvIV4BY2Jx+em4VIzGBbJhaYwAUwYDYQL50eY+rRvc7hul/6ik8MoYOoQ
         8c4u5wRb1DTpsy36NYZuscATTZiU5rm+sPck8LCa9r3UIWXZuue8jYp4TH6w8qE7Hvao
         pJFg==
X-Gm-Message-State: AJIora8+AARQv8c9LI5tTN3CRqOlNP8TahymMcCBxJ+BuBhAfpLpwQOV
        m+QkPUbSHU/EFMKHN1ObBo/F78pSCLVg9A==
X-Google-Smtp-Source: AGRyM1vwSJjCkc0eqa0IsWGr1A6On88LLH9HyLUYQ///G4y0axxOQQn7sz8ej2Tp45u7Ql+TeUieAg==
X-Received: by 2002:a05:6512:c13:b0:48a:9341:68ad with SMTP id z19-20020a0565120c1300b0048a934168admr1079989lfu.333.1658758032054;
        Mon, 25 Jul 2022 07:07:12 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id o7-20020a05651205c700b0047f7419de4asm901127lfo.180.2022.07.25.07.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 07:07:11 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 00/15 v2] Ux500 hash cleanup
Date:   Mon, 25 Jul 2022 16:04:49 +0200
Message-Id: <20220725140504.2398965-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This cleans up the Ux500 hash accelerator.

This has been very sparingly maintained the last few years,
but as it happens an active user appeared and sent me a
bug report, so here is a series cleaning up the driver
so we can maintain it going forward.

Most patches are modernizations, using new frameworks and
helpers.

The expensive self tests are passing fine after this series.

I think it is a bit too big to backport to stable :/
But please put it in as non-urgent fix.

If this goes well the plan is to do the same for the crypto
driver which has all the same problems.

ChangeLog v1->v2:
- Iron out some minor runtime bugs.
- Fix a regmap initialization error.
- Fix up to use runtime PM and drop custom power states.

Linus Walleij (15):
  crypto: ux500/hash: Pass ctx to hash_setconfiguration()
  crypto: ux500/hash: Get rid of custom device list
  crypto: ux500/hash: Pass context to zero message digest
  crypto: ux500/hash: Drop custom state save/restore
  crypto: ux500/hash: Drop bit index
  crypto: ux500/hash: Break while/do instead of if/else
  crypto: ux500/hash: Rename and switch type of member
  crypto: ux500/hash: Stop saving/restoring compulsively
  crypto: ux500/hash: Get rid of state from request context
  crypto: ux500/hash: Implement .export and .import
  crypto: ux500/hash: Drop custom uint64 type
  crypto: ux500/hash: Drop regulator handling
  crypto: ux500/hash: Convert to regmap MMIO
  crypto: ux500/hash: Use AMBA core primecell IDs
  crypto: ux500/hash: Implement runtime PM

 drivers/crypto/ux500/Kconfig          |    1 +
 drivers/crypto/ux500/hash/hash_alg.h  |  262 ++----
 drivers/crypto/ux500/hash/hash_core.c | 1154 ++++++++++---------------
 3 files changed, 536 insertions(+), 881 deletions(-)

-- 
2.36.1

