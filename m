Return-Path: <SRS0=eCgR=XT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A177C4320D
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Sep 2019 08:08:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E593321655
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Sep 2019 08:08:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qTUPUuia"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436589AbfIXIIi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 Sep 2019 04:08:38 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53670 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436523AbfIXIIh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Sep 2019 04:08:37 -0400
Received: by mail-wm1-f65.google.com with SMTP id i16so1034898wmd.3;
        Tue, 24 Sep 2019 01:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LvmWXRtGWT9R3WNFFzfM69HUUZTLJdLx3RX6w/RLwN8=;
        b=qTUPUuiaB1BbUrj1/J+eC4muw+BCr0E6ZHcwgfrV8I+uv7diyW8G8RVHouV/04bXSB
         2y4pboyPEWtF5PGHbRRBDZMKUl2R4PowLAuv1CVw90DiALiuZT/9SWNpM0jtDEeOiQVO
         W5S1Mc0PJBQrV5/dpGE61cEcfWndDUamlixQYwH7lKoQeOfczOOh5SgXmdWXr9ypf5Wr
         x38S87iRhJBat9iEVEfuv3tOMGf+bsZ3j5DRS/00CPac229ZnqSReiFu3DBSzzpYcQtM
         1+a5Mag4cbpMvU6iuHB76LP1jdiTQ1RooGE56ilT8W0ygz4b+OHsahXzk39PqNhQM4wi
         qAWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LvmWXRtGWT9R3WNFFzfM69HUUZTLJdLx3RX6w/RLwN8=;
        b=M8xDbWc53P8FI4k4jjKWjsKdJK/HGDIdIGwIDtmpxGaz/LNoYYACM5x7Jh6mKUDYLT
         TcxhE20BYkxKWEcg+DQG0Z+7B8Tj5CtTPKjZGbcyJhsRlYBSUyhmEIPkS8xqyko3BaV0
         Cco+VNPKBQ+CaeTnRCXesRCUebah7bgJefHqEMOmr8bSt7KyeSGtm6UI4Kg30hINn1jo
         8SCGfOIN+rEi4ndEe/JfQZkr9centa97gBQyv8JQO7KKm2Ee8SyW1UXUUasiZCCden08
         RwQo5yI7s6LNZUxhDAiIKBRiljLCOT6M7jLU3GvBlqzRidV5mmlwin7IJU06j3+HVi81
         QqVA==
X-Gm-Message-State: APjAAAXY3Q0hXg3OylOYbQ+oCz0q2AaJbbmUQIdKvBF7s0lgnCGag1DT
        X1vvEVN5ID9TFWAhvpFOfyk=
X-Google-Smtp-Source: APXvYqx5+wQFqSOFrr3XdMZfbvhzWsF4sw0PdC7cOZYcRdMZ/dTvBJ/GlLlkBdx+VNumT9tyn4uIGw==
X-Received: by 2002:a1c:7f4f:: with SMTP id a76mr1575598wmd.117.1569312515832;
        Tue, 24 Sep 2019 01:08:35 -0700 (PDT)
Received: from Red.local ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id u22sm1825256wru.72.2019.09.24.01.08.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Sep 2019 01:08:35 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v3 0/2] crypto: sun4i-ss: Enable power management
Date:   Tue, 24 Sep 2019 10:08:30 +0200
Message-Id: <20190924080832.18694-1-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

This serie enables power management in the sun4i-ss driver.

Regards

Changes since v2 ( https://lore.kernel.org/linux-arm-kernel/20190919051035.4111-2-clabbe.montjoie@gmail.com/T/ ):
- depends on PM
- fusioned suspend/resume functions with sun4i_ssenable/disable
- fixed style problem

Changes since v1:
- Fixed style in patch #1
- Check more return code of PM functions
- Add PM support in hash/prng
- reworked the probe order of PM functions and the PM strategy

Corentin Labbe (2):
  crypto: sun4i-ss: simplify enable/disable of the device
  crypto: sun4i-ss: enable pm_runtime

 drivers/crypto/Kconfig                    |   1 +
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c |  10 ++
 drivers/crypto/sunxi-ss/sun4i-ss-core.c   | 139 ++++++++++++++++------
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c   |  12 ++
 drivers/crypto/sunxi-ss/sun4i-ss-prng.c   |   9 +-
 drivers/crypto/sunxi-ss/sun4i-ss.h        |   2 +
 6 files changed, 133 insertions(+), 40 deletions(-)

-- 
2.21.0

