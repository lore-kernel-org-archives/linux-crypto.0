Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D30DC433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 09:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A10C61005
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 09:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236352AbhEQKAR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 May 2021 06:00:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34573 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236461AbhEQJ7u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 May 2021 05:59:50 -0400
Received: from mail-ej1-f69.google.com ([209.85.218.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <juerg.haefliger@canonical.com>)
        id 1lia1B-0002Ra-CF
        for linux-crypto@vger.kernel.org; Mon, 17 May 2021 09:58:33 +0000
Received: by mail-ej1-f69.google.com with SMTP id sd18-20020a170906ce32b02903cedf584542so830547ejb.9
        for <linux-crypto@vger.kernel.org>; Mon, 17 May 2021 02:58:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q/wSN0+Q7UW1xpdFuLri53LFWf1u+HpJsXzIKwoz29A=;
        b=Z3o2xlBzX9voLRZDhPw+6i9ckvi5HHvWMT4cBOO6+wGsSCWntPPV43dVsvTOLsUuFM
         XDxjw9hXXK/dqwTxEp4a+HrA/Kea0j0qKLsHIYdM6CFEHFQ5lQW65+K7F5AoVNa0InJS
         wsEwCxTlT9nxgYjLUSPHXa4Z3rErv3wy3oE+FAdsSN1Pmr1g9iAymQ01uephhQzXRiZc
         xFbb7IdBzLpc7WxY2MXBhp5PxacLY6KHCDjGIanEu4MxvqJhWk9fgcD80bcT55kapoNF
         Q989BD8r21YwG+BsbzVLfAqlH6dxqxWdUZzEAc/GTUdF9BWhDgRkTZLtILmQgVvmhuCu
         UlXQ==
X-Gm-Message-State: AOAM533JhAOmCGI0FlwM6PUt3S4n8Zy5xPKV8JrKzBDbJiTCBrtMcVSQ
        RSUXCpHmJiRaLXUH2gtqMI7O99YHDidK0LZH7M0uniZXvBIdNgnLW7d3GEB5R8jcct33dR5FD6U
        hnrVi+Ns1bpiKwwt3fJGwxhISts2x3t+QwJ1VjE4vwg==
X-Received: by 2002:aa7:d818:: with SMTP id v24mr26537149edq.290.1621245513101;
        Mon, 17 May 2021 02:58:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNlXvNzVQOstOtLAhWapeNUCRt/jrF806iuW+e4UxXf45W748ZixHui0OO1NUHaHLpYFlN1A==
X-Received: by 2002:aa7:d818:: with SMTP id v24mr26537136edq.290.1621245512971;
        Mon, 17 May 2021 02:58:32 -0700 (PDT)
Received: from gollum.fritz.box ([194.191.244.86])
        by smtp.gmail.com with ESMTPSA id bh2sm7362212ejb.80.2021.05.17.02.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 02:58:32 -0700 (PDT)
From:   Juerg Haefliger <juerg.haefliger@canonical.com>
X-Google-Original-From: Juerg Haefliger <juergh@canonical.com>
To:     mpm@selenic.com, herbert@gondor.apana.org.au,
        zhouyanjie@wanyeetech.com, linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, juergh@canonical.com
Subject: [PATCH] hwrng: Remove leading spaces in Kconfig
Date:   Mon, 17 May 2021 11:58:31 +0200
Message-Id: <20210517095831.81631-1-juergh@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove leading spaces before tabs in Kconfig file(s) by running the
following command:

  $ find drivers/char/hw_random -name 'Kconfig*' | x\
    args sed -r -i 's/^[ ]+\t/\t/'

Signed-off-by: Juerg Haefliger <juergh@canonical.com>
---
 drivers/char/hw_random/Kconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 1fe006f3f12f..0e1e97680f08 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -168,14 +168,14 @@ config HW_RANDOM_OMAP
 	depends on ARCH_OMAP16XX || ARCH_OMAP2PLUS || ARCH_MVEBU
 	default HW_RANDOM
 	help
- 	  This driver provides kernel-side support for the Random Number
+	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on OMAP16xx, OMAP2/3/4/5, AM33xx/AM43xx
 	  multimedia processors, and Marvell Armada 7k/8k SoCs.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called omap-rng.
 
- 	  If unsure, say Y.
+	  If unsure, say Y.
 
 config HW_RANDOM_OMAP3_ROM
 	tristate "OMAP3 ROM Random Number Generator support"
@@ -485,13 +485,13 @@ config HW_RANDOM_NPCM
 	depends on ARCH_NPCM || COMPILE_TEST
 	default HW_RANDOM
 	help
- 	  This driver provides support for the Random Number
+	  This driver provides support for the Random Number
 	  Generator hardware available in Nuvoton NPCM SoCs.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called npcm-rng.
 
- 	  If unsure, say Y.
+	  If unsure, say Y.
 
 config HW_RANDOM_KEYSTONE
 	depends on ARCH_KEYSTONE || COMPILE_TEST
-- 
2.27.0

