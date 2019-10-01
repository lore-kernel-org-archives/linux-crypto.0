Return-Path: <SRS0=Oe9a=X2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53155C352AA
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Oct 2019 18:42:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DC2321855
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Oct 2019 18:42:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Op9nayN2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfJASmE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Oct 2019 14:42:04 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45953 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfJASmD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Oct 2019 14:42:03 -0400
Received: by mail-wr1-f67.google.com with SMTP id r5so16713754wrm.12;
        Tue, 01 Oct 2019 11:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zV4+mJumjqZCVRf0c568eaULYg2KEJ/Mri+qUnmNENE=;
        b=Op9nayN2gx2vxdmqgSLirxgZsMMurpxeBsyy2hN+atH5jEMJBF2teXoA2D46OAkVD3
         j7nr3LdYKDttEnbh8vyiQnPKWN/wPg8XhIrVZrWmF/zUHzpQOqVkXX4ffTZZBvIT+NIm
         O3qb4m63qCBjY6bUeqwSQSTqOPSerk1sy06/l3xR4GYXAX2Qk5KJFktNjDMVq7RaSPQE
         Dql0k3kviYR8nTxwEYAE5Np3Rz8Ovnde+WGbJWTTWtw2WRSmXUQq2yW6DFHjp3zoSoli
         UXsJx0vsv3fJcKlrMvIhBaDo893jpioOL94W1rp4OOoxQNxhUjB4i33vnHZ9ku2hII7x
         T6LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zV4+mJumjqZCVRf0c568eaULYg2KEJ/Mri+qUnmNENE=;
        b=CLzuo+mqyrgTY7NzbufEj1jwcP6OVPLe/prlH1vCcKraMi8GxbD3gyeWN2ZdmsM2LQ
         ZFdrUSlwwQ1Jsos6OY+CA/9LtBRG1e8r9/cBPqDcOw4p83sZF+LRnTfGFDiq2V9x7Ja4
         jWymrwrzcyM5y7TbwOq8MYKm/uSIHqKma/I1zM0Hl/Ph5Krs+IvAArwyehdWf87vDGs5
         NE0ot+3St53wlDSAl00gYQQoEPJbzbsTm1zX5H2HKZ9yMskci/kLA23RbR3iHtb4bEkW
         hVPS+Pp+Sit2RbbzIiD1bZe/D5rA3ujznD5npdVVGRQc4N/M6HITZ3PvRwT9oxN/INVj
         Nsgw==
X-Gm-Message-State: APjAAAWhV+smxv0N5yrdf0fzymUzUkxbb4D/ZCRXu5S76ik69kKFizGc
        aAf05RqfiMdlVvGJgVJGgvw=
X-Google-Smtp-Source: APXvYqzOH+WGVSlqfSbFWee70MnpoC4vk5oe7z/eWOzO0vbvatdBiDjTNAg2Jr8UrfCCcn0ObtgEMg==
X-Received: by 2002:adf:e443:: with SMTP id t3mr18894855wrm.181.1569955321546;
        Tue, 01 Oct 2019 11:42:01 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id n8sm6788987wma.7.2019.10.01.11.41.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 11:41:59 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 09/11] sunxi_defconfig: add new Allwinner crypto options
Date:   Tue,  1 Oct 2019 20:41:39 +0200
Message-Id: <20191001184141.27956-10-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191001184141.27956-1-clabbe.montjoie@gmail.com>
References: <20191001184141.27956-1-clabbe.montjoie@gmail.com>
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

