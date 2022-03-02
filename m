Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB59BC43217
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Mar 2022 21:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245136AbiCBVN1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Mar 2022 16:13:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245232AbiCBVMj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Mar 2022 16:12:39 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E65DEA3A
        for <linux-crypto@vger.kernel.org>; Wed,  2 Mar 2022 13:11:38 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id r10-20020a1c440a000000b00386f2897400so359614wma.5
        for <linux-crypto@vger.kernel.org>; Wed, 02 Mar 2022 13:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RX6tCFk3hNm9Gk+PiwU50ATyVkVvp6LIG+MNsngfsTs=;
        b=8IGVmzH/BSis609i9JwFsXDD7H2AbTMD3C+Cucibqc6F49yuajLO1aoJPPFD7V/FKY
         D3QljzlNYGC2BcYWY3GWOR6TsCZNlUzxtYLOHXo0XllaZQmLcw2AhRj44/i/GPIq/pcD
         zaji7LMah++zo+YaSJEU6wRTHRFewQFAn4xS1tXqJHtlGBFyNKBn8R43qBUpiFZ22V60
         hm0tZGfaW22cCDeSVWGPtRMyvFVvKCJFYRQZs6gpsYIUos0pahV9MkNqJjSl6E6UYyRn
         eXCJKi9wCmV4OlvmujJ8JcVQgfuGitj1wkSU8dHp9jSeM9xS7wzfZmHue8OzNlqJOAko
         r82Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RX6tCFk3hNm9Gk+PiwU50ATyVkVvp6LIG+MNsngfsTs=;
        b=n8d5PwLsVx8m8gKtvKbe908Hq+rQQe+/t1IMD7o0pa2cxBQWyPGm1XT4WEss2/f+gR
         705nWGBU0VDNH/JGuphAbc+xqXLrTqBgPm3ThM0rwu9XFwAxNkVf9XsE5soklz71RmVb
         ALniJmrGcBPQsh4AVdPHHx2G2YeUAOuwxY7ggjZCnZDqNXhmR2YiCfTJEiOBtDETetxq
         yeRBzYWhWZRL45THGpqTJ8gJ/jMOVsuN4QKR2iSk4y9hvXQW9OlO+eKEKutySJbVClmO
         uqNb8cNS7Ty0X6MO442bjKKLb1mowhTZbMLuZ1dxJNxZHcCqYbbrXSvaZLHx7hbH7JDP
         Ewgw==
X-Gm-Message-State: AOAM530rQlUrJ5R8LtjwdcFQotSWyCelNQcPyX6yrnlCjPPGIdIwZRrD
        DKv1ByJ0IOsF8iaoZ5VzCuuTWw==
X-Google-Smtp-Source: ABdhPJxn7GN3e1PbdIoruwI0xTr6ME+fNKFNjPs2K7w1yitP5dYdFU4xEo5TIkBM+9WNiMWCOm8mYg==
X-Received: by 2002:a05:600c:6c5:b0:380:dda2:d562 with SMTP id b5-20020a05600c06c500b00380dda2d562mr1420983wmn.138.1646255496568;
        Wed, 02 Mar 2022 13:11:36 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id z5-20020a05600c0a0500b0037fa93193a8sm145776wmp.44.2022.03.02.13.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 13:11:36 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org, john@metanate.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 18/18] crypto: rockchip: add myself as maintainer
Date:   Wed,  2 Mar 2022 21:11:13 +0000
Message-Id: <20220302211113.4003816-19-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220302211113.4003816-1-clabbe@baylibre.com>
References: <20220302211113.4003816-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Nobody is set as maintainer of rockchip crypto, I propose to do it as I
have already reworked lot of this code.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 960add1b4079..3279be7d0e32 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16831,6 +16831,12 @@ F:	Documentation/ABI/*/sysfs-driver-hid-roccat*
 F:	drivers/hid/hid-roccat*
 F:	include/linux/hid-roccat*
 
+ROCKCHIP CRYPTO DRIVERS
+M:	Corentin Labbe <clabbe@baylibre.com>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	drivers/crypto/rockchip/
+
 ROCKCHIP I2S TDM DRIVER
 M:	Nicolas Frattaroli <frattaroli.nicolas@gmail.com>
 L:	linux-rockchip@lists.infradead.org
-- 
2.34.1

