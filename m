Return-Path: <SRS0=4UkV=XO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D8D1C49ED7
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 05:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 193D821927
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 05:10:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pdgjowYL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731757AbfISFKk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Sep 2019 01:10:40 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43157 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730949AbfISFKk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Sep 2019 01:10:40 -0400
Received: by mail-wr1-f68.google.com with SMTP id q17so1556049wrx.10;
        Wed, 18 Sep 2019 22:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ttCTUHrEZ8RqxMqrfUks/MJVxPs2athVlNQVJH23ON0=;
        b=pdgjowYLRCsuSv+iBZ5rHqIu+XC7Y9/cD2khPCOXEgPLOtByZUabXyd+pJgoS/hJjp
         5Ang/uWeIaLhscF6XMOZNYeYPwVJZ6BVKxSZj6aQLbLJxrzjx7GMceAcyq6bi+JjOKah
         pnZZq33rabWGrHt4TwpO+ApAcTm2EbXb1pVqCRVjWE8wiI4zPoUNfnjv76JJeiVc6CcW
         towxbanDYZi+wCkEt0gUi8excCGijYHtQyPGRzGC/YFBiQ0k3GBlaQO8jQStkzutmkdv
         c+UMU7Dtd54b6Y5hndx9o3L9vusx8IPqMHjWjYDrcuPaYzQkv5zVKKngNE5988Ire5rz
         UK2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ttCTUHrEZ8RqxMqrfUks/MJVxPs2athVlNQVJH23ON0=;
        b=KnMs6F5eYUghZ02TkS6cnbJwKupU11CW421YmCI17Jxao1Q03lstBnO+g2kR3VAC68
         OjtNziVcY3dK/Mgv7Yf1BUxD1C7s1ocfW4RDH3EWn/bqOFXzhzY7Qmz+GHccKf8HzK4U
         NWOfyiaKV9Kas8xUk1uGaVM57iQYgXPilj9YuE9uum7GEA7yNrs0jwkqs7vnrrpPtJtM
         K7Rxqa9h/z+ICMqWZsboXEW+LtGqF2xnzArDpkR2tGmGZZ71Y7xVZjZ4KOZ9oNaBV9Wt
         Imb0w+D+XpgfmGZgMXQmRJytaYmb+mdAUM3FuA6ct8MeJ4L/K9Zw/549fDkLI1eIOIK1
         dkcw==
X-Gm-Message-State: APjAAAVBDD1cCZno1RHYXBFqLMtQp08I+gFYPlvQzUaDAztyaKmrg2b0
        Q+Cvareccy8nift3WZim3QA=
X-Google-Smtp-Source: APXvYqzGta9q+xvqr076suhGvyYMAdJl62tIA2pJNMA7bhe1Kn3CF25JtfwxOo/WWeoF4ToKaq1CmQ==
X-Received: by 2002:adf:f401:: with SMTP id g1mr5140106wro.275.1568869839395;
        Wed, 18 Sep 2019 22:10:39 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id 94sm6575552wrk.92.2019.09.18.22.10.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 22:10:38 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 0/2] crypto: sun4i-ss: Enable power management
Date:   Thu, 19 Sep 2019 07:10:33 +0200
Message-Id: <20190919051035.4111-1-clabbe.montjoie@gmail.com>
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

Changes since v1:
- Fixed style in patch #1
- Check more return code of PM functions
- Add PM support in hash/prng
- reworked the probe order of PM functions and the PM strategy

Corentin Labbe (2):
  crypto: sun4i-ss: simplify enable/disable of the device
  crypto: sun4i-ss: enable pm_runtime

 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c |   9 ++
 drivers/crypto/sunxi-ss/sun4i-ss-core.c   | 157 ++++++++++++++++------
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c   |  12 ++
 drivers/crypto/sunxi-ss/sun4i-ss-prng.c   |   9 +-
 drivers/crypto/sunxi-ss/sun4i-ss.h        |   2 +
 5 files changed, 149 insertions(+), 40 deletions(-)

-- 
2.21.0

