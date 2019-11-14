Return-Path: <SRS0=sx3D=ZG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F42FC43141
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 14:48:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1294B2071B
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 14:48:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U/FOKbDD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfKNOsd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Nov 2019 09:48:33 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34239 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbfKNOsc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Nov 2019 09:48:32 -0500
Received: by mail-wm1-f67.google.com with SMTP id j18so7656714wmk.1;
        Thu, 14 Nov 2019 06:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TyZ/otN+2/jtuodzdCxNt8qwSNX0TrMQiPm2CTPWkRg=;
        b=U/FOKbDDLg2JM3grxeN38aCsdwc3jh412ceT2fTzVBvTDM9uWmvRxpGNwh30CG9xn7
         /N0cVEibw5eull+Vuz8ph2IihqI3+3feCp0TDaVTJHWftcQVLTUpGKzpxaTnaPUIVokH
         o2uDfaagIauVTB4aWyhwuBkFvDjZFAyFKPnwruBzxdxjWrttvZ9AyZqFM71CYiPSsZPf
         RIghjHWDJxeE1G4oBuqRaMdnP9V2t/J4i9zoZ6QowjmSNeKVrSnxBH8ESqUcM+rAHCYp
         6IgHRAQe8dSaHW93bjNhOuMTXWXpRkGTcG1cWFw48r+eSGb//b7Js9CupJcHtjBL3W45
         vfgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TyZ/otN+2/jtuodzdCxNt8qwSNX0TrMQiPm2CTPWkRg=;
        b=OjbBh0V5oQVtDY7uHswc2xRsQliFj+p9Zru1e8Ot8pthjJMzAbIzUGMQZ1Aa9JjV7E
         1zmFjhXz/M+CBAW+NYx06ol489c2hwUEzOundRAvWxhm8LJ4f4pOMvfRrzjG21kgMLB2
         LyDYmNlsQQmRxCibiHNw59s7+NT1PJv0egjNWeinxFe/7EUFKVrhJXwx9PQO+LCx7N8B
         P6B1aprgeNQ02s5xKRbPJaNB5FSi1fTcgG+TBjbbiN/q0TW1ZX7b5qUuYiDaNKw+m3Er
         Y9K+xYoaDbWRpNt3mt3vKYUqyaafX1QNnXjrIcJdoh+46seaEf6ea2mE1bk6ZpGnVVqK
         s5lQ==
X-Gm-Message-State: APjAAAWKoVZXbBWoZjVnrhyqL3+k/Mus8ilc84vKF5qycBj5yih9VYqW
        wEczQqekS/vLlkTK1AyocCk=
X-Google-Smtp-Source: APXvYqydvsyjX1qugxYeMDfQDrgoAzhWIvbwyXJ0MMSPIPkXRA0YEzaJyXxoPSk+RTHE99ZJ3r4apQ==
X-Received: by 2002:a1c:e915:: with SMTP id q21mr8582834wmc.164.1573742910794;
        Thu, 14 Nov 2019 06:48:30 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id v9sm7153223wrs.95.2019.11.14.06.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 06:48:30 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 0/3] crypto: sun4i-ss: fix SHA1 on A33 SecuritySystem
Date:   Thu, 14 Nov 2019 15:48:09 +0100
Message-Id: <20191114144812.22747-1-clabbe.montjoie@gmail.com>
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

Corentin Labbe (3):
  dt-bindings: crypto: add new compatible for A33 SS
  ARM: dts: sun8i: a33: add the new SS compatible
  crypto: sun4i-ss: add the A33 variant of SS

 .../crypto/allwinner,sun4i-a10-crypto.yaml    |  3 +++
 arch/arm/boot/dts/sun8i-a33.dtsi              |  3 ++-
 .../crypto/allwinner/sun4i-ss/sun4i-ss-core.c | 22 ++++++++++++++++++-
 .../crypto/allwinner/sun4i-ss/sun4i-ss-hash.c |  5 ++++-
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h  |  9 ++++++++
 5 files changed, 39 insertions(+), 3 deletions(-)

-- 
2.23.0

