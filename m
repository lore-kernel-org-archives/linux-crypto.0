Return-Path: <SRS0=xZqV=TK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A13FC04A6B
	for <linux-crypto@archiver.kernel.org>; Fri, 10 May 2019 17:31:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 444DE21479
	for <linux-crypto@archiver.kernel.org>; Fri, 10 May 2019 17:31:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LQetLOnP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbfEJRbz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 May 2019 13:31:55 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:33213 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbfEJRbz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 May 2019 13:31:55 -0400
Received: by mail-ed1-f67.google.com with SMTP id n17so6145350edb.0;
        Fri, 10 May 2019 10:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BkqdQRe9mocbh/BtLFtBEMRRvm28/epz/rHx+xkJ9iM=;
        b=LQetLOnPrFa+mDUusRJd1emPoySXmgbg9gGBsqRa1gkTB2y4wi66UFsMzX1WrlwGRQ
         rrtu86WTC3NZY9K0AyuKr5JCtxtmjzpSuIImgWB4jCMmgxgdK/jCKyG975vda4xcukoo
         9Qtj48T145nefSBtk9+MZKNURYqnCb4i1yZWqiR2QAdyPRILMsUCQtfj2pLL1151G7cE
         I5VZUicPf5NidKQ+MHpLlQ0YI++16dJRAptU10qq90VQiaoeEsTFbmBCBqPi0xuQ9NdE
         F18KQl3sJkx4+s5PZGd6srAiEXBKvVcRc7+0TesGQtNVhbzc4tjP+kHXyhu8qveqX4jd
         93HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BkqdQRe9mocbh/BtLFtBEMRRvm28/epz/rHx+xkJ9iM=;
        b=BnJXk48jQGmJ7wFe3mXpqSjJ0OnkWPts7OUIJV+BI5Srs1/NAFFJZdECDmoJ73exEb
         Id+GM3WSNNoEF47pHb9SkCqw8faQzmkfjl7evODuX5c7vhzD1Gh05Br2M+G1twyO01BM
         Xxxwq9uEeJI0iiY68Cy4I6b571Ckr1CJVxVJyJnOlRl9fANQQ9T5jZmcUc8bB0KtHI/k
         09OOkNEejF+Rr62vaAc9x4yKD6vQL+7KkPelyH1TovA+9f4SSVKMazqGGYgAqPpeqkKC
         udqwbaJaHJVcHhdh197nc/LnX2eJHC57yDVv7i/J0pWddNmQXX9Hr5tFN9zyVKW2OOxI
         PyjA==
X-Gm-Message-State: APjAAAVssQhIGA6g/XU8WSdk6NRkPq48A79XHij8jPXwkuGcG4Yr3lxN
        UI08sEh3RmfD/WPmFdwbE0qYBEsL
X-Google-Smtp-Source: APXvYqzU7LWG/KzpyyccU3qR3Ukd2BOwSZuj80PE5MrRIjQ4oMVuhPgVfRg5FzD5J01qcrs0RebmUA==
X-Received: by 2002:a50:ed14:: with SMTP id j20mr12720362eds.84.1557509511839;
        Fri, 10 May 2019 10:31:51 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id v16sm1599567edm.56.2019.05.10.10.31.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 10:31:50 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     bcm-kernel-feedback-list@broadcom.com, stefan.wahren@i2se.com,
        wahrenst@gmx.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, mpm@selenic.com,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 0/2] hwrng: Support for 7211 in iproc-rng200
Date:   Fri, 10 May 2019 10:31:09 -0700
Message-Id: <20190510173112.2196-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

This patch series adds support for BCM7211 to the iproc-rng200 driver,
nothing special besides matching the compatibile string and updating the
binding document.

Florian Fainelli (2):
  dt-bindings: rng: Document BCM7211 RNG compatible string
  hwrng: iproc-rng200: Add support for 7211

 Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt | 1 +
 drivers/char/hw_random/iproc-rng200.c                       | 1 +
 2 files changed, 2 insertions(+)

-- 
2.17.1

