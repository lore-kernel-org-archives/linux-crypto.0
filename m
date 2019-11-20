Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 953DAC43215
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 15:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C5FF2063A
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 15:28:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J+PYXrif"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbfKTP24 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 10:28:56 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43504 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730487AbfKTP2j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 10:28:39 -0500
Received: by mail-wr1-f65.google.com with SMTP id n1so243095wra.10;
        Wed, 20 Nov 2019 07:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DtyaiQZ8irKf16rmVxB3fmQ2TpmbrTyyFiQO6JUw5+o=;
        b=J+PYXrifIbFmzJD2YaGWqKDy4QL5/H44uzIhHRoNCHjqbjqh8+KI7fQQcDn0/3ZWXe
         TQuEkk4zRoznzfRwwFfViPXBbetRmVRz/+29JbND54mJIsTdrngr5SJ5QNNlaodGMcbb
         JtGzynOWqr3F+mKJ2N3gF/8N4ycKu91eJFb7DKHiKBHn/qrdHoTnl9NUbzhG+S9vaMSC
         QzoH7so7+Ybb67t/54HeLgepoPTfEiXMHFz/dZNWIWsUMcxQHGOT46jk1fO1EcrCQnxx
         hCut8hHXAhqcdHlaodE63ousJtSYac17WkrdLxGPQxjDYe2m6BiaQ50FStIokPE2Ggym
         tYsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DtyaiQZ8irKf16rmVxB3fmQ2TpmbrTyyFiQO6JUw5+o=;
        b=JSRIo8HWhdx+7KEdIBLjCfRd5lI1Yt5brMdnr67odkcnucCj4nbDUjL+tzxQWFvvFd
         mq/Uv5HTC5Ox3bfGJav5oyvBUk/66pAVHMStfhQxQZLm9sjD5AdakfUfY1Zxa3ZzlCQe
         pfZ3ZiUD8uBPTrZRv2gachQI1oxWVabh8vMNMX9zdO0bJY9HHRNk9NRrFPKMbS6UdAbP
         3YxPudYAC7yTKGPYvq/nyF8cgGxPyMRMVQDQEwFPDcAzJ2nDvo9Lmp8GWIOpY6Qp+ex1
         CKEWsXvsJBhbiQBQvytJdI2TSIAGr8k0iNkufFURdBIjae95zMBpIhApIq3xa22y+c3Z
         nYFw==
X-Gm-Message-State: APjAAAWGI/YGIvPvW/VBJqxHQN4mcbjr2pQvp4LHTZnN5SK4RcFP92E7
        8qRroZihDggL8CH4AaTsZ+8=
X-Google-Smtp-Source: APXvYqy8eB9w+wZZJo55+z14tlTOn1lf95zCLE3trwsy02lQ5kbg9t7377ZRZ81/CbuOutHBkGCqTA==
X-Received: by 2002:adf:a119:: with SMTP id o25mr4361024wro.74.1574263717216;
        Wed, 20 Nov 2019 07:28:37 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id w4sm31797881wrs.1.2019.11.20.07.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 07:28:36 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 0/3] crypto: sun4i-ss: fix SHA1 on A33 SecuritySystem
Date:   Wed, 20 Nov 2019 16:28:30 +0100
Message-Id: <20191120152833.20443-1-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thanks to Igor Pecovnik, I have now in my kernelCI lab, a sun8i-a33-olinuxino.
Strange behavour, crypto selftests was failling but only for SHA1 on
this A33 SoC.

This is due to the A33 SS having a difference with all other SS, it give SHA1 digest directly in BE.
This serie handle this difference.

Changes since v1:
- removed compatible fallback

Corentin Labbe (3):
  dt-bindings: crypto: add new compatible for A33 SS
  ARM: dts: sun8i: a33: add the new SS compatible
  crypto: sun4i-ss: add the A33 variant of SS

 .../crypto/allwinner,sun4i-a10-crypto.yaml    |  2 ++
 arch/arm/boot/dts/sun8i-a33.dtsi              |  2 +-
 .../crypto/allwinner/sun4i-ss/sun4i-ss-core.c | 22 ++++++++++++++++++-
 .../crypto/allwinner/sun4i-ss/sun4i-ss-hash.c |  5 ++++-
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h  |  9 ++++++++
 5 files changed, 37 insertions(+), 3 deletions(-)

-- 
2.23.0

