Return-Path: <SRS0=sxdd=YF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2EDFC4360C
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 18:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B086F222D3
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 18:49:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SoAu1WTF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729675AbfJLStL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Oct 2019 14:49:11 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43576 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729663AbfJLStK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Oct 2019 14:49:10 -0400
Received: by mail-wr1-f68.google.com with SMTP id j18so15231543wrq.10;
        Sat, 12 Oct 2019 11:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zV4+mJumjqZCVRf0c568eaULYg2KEJ/Mri+qUnmNENE=;
        b=SoAu1WTF4Hz+Q5KvCZRtqKd7pcLykCWR3rS4humVHxIq2FXg01UbNWrURbDgVAA5tO
         OFkbBzxGNoqA/pLYVvzGUWBtnUjIhAvD1HA4yafhkvrcHwvSHgGag/qQaqPsDTW0K6Zn
         Cmw4/4WU6Ia/3JPbqdb5ET0pVfob3XjusoHu7f4ks3bzSqYLpP/gny2O7T+UQe8VMjeW
         2QDk1VNHzWPnAxCigpf8Z83IwP/+7zq3HVQ3XHpRnep+SH8Ukta6+CG6DCFKGvoyJ6uS
         FmdRe0MJhHzrL27iHOxyieHGLp8CK7JNLB9AnmlXw6xIbWCR+ZaKDaW0JHeH6ka1f4Kj
         GqDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zV4+mJumjqZCVRf0c568eaULYg2KEJ/Mri+qUnmNENE=;
        b=cV0JDizPcIcyrDbbGnckaXD/ImaaswOPyjMI+bYbG59Jm2r8cIA+oYnL9rSLieWq6I
         XrOx0iNqZyoAyu36Cq3zdiU/+tLcRHRMhM+Rm462/X2p5iE5/dZLJoLNoec1y6rnaW36
         6RO2QhK0/faFBFnMs4ImrhtyozsIgZtUJfV24A/Aau/6aXPE8uqfo82xiHyrtFufAV9Y
         GsP/OTuFXA3fHyGe2RVZmgeDjPZ5JvDXO6+5vh3T6+TbTkmxR1ziNu8B33ieT89Rw731
         XtWltBeL9KQGBXs4LI8TAsbIwzdCPxaQZCIuWYs0+wAyDyfOpoRNK4mlkCBi6oy8mwfI
         fHvQ==
X-Gm-Message-State: APjAAAXjlqK4tIDzBp68i1TwlePfwsTcjwhpT9monenGUeGTwiwo8Bq5
        rjI1kDqGF8l7kClbstJ9y/I=
X-Google-Smtp-Source: APXvYqyCDqkwYKGrmgm0KnsgLTZDi4etAKSyk1EAu2zh+IJ1tKM6xB6y6T1lZyPLZhBTN8BzP1h+rQ==
X-Received: by 2002:adf:fa92:: with SMTP id h18mr18391370wrr.220.1570906148927;
        Sat, 12 Oct 2019 11:49:08 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id a13sm33670580wrf.73.2019.10.12.11.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 11:49:08 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v4 09/11] sunxi_defconfig: add new Allwinner crypto options
Date:   Sat, 12 Oct 2019 20:48:50 +0200
Message-Id: <20191012184852.28329-10-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191012184852.28329-1-clabbe.montjoie@gmail.com>
References: <20191012184852.28329-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds the new Allwinner crypto configs to sunxi_defconfig

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm/configs/sunxi_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/sunxi_defconfig b/arch/arm/configs/sunxi_defconfig
index df433abfcb02..d0ab8ba7710a 100644
--- a/arch/arm/configs/sunxi_defconfig
+++ b/arch/arm/configs/sunxi_defconfig
@@ -150,4 +150,6 @@ CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_PRINTK_TIME=y
 CONFIG_DEBUG_FS=y
+CONFIG_CRYPTO_DEV_ALLWINNER=y
+CONFIG_CRYPTO_DEV_SUN8I_CE=y
 CONFIG_CRYPTO_DEV_SUN4I_SS=y
-- 
2.21.0

