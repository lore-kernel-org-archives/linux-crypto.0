Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22FF6C5B577
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 02:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE3EC2177B
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 02:46:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NcH3rAze"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfF1Cqm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 22:46:42 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33559 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbfF1Cqm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 22:46:42 -0400
Received: by mail-pf1-f195.google.com with SMTP id x15so2198649pfq.0;
        Thu, 27 Jun 2019 19:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=IJEis1mjrPVU9kIf9sDkyYAOGPx0wVN8V19bPjXCBjg=;
        b=NcH3rAzeIkMkTLlgwlwcoVfSgXsQ2kMVzVFVlQ7S+ErntDBrCWyCjE8xTKyuiP8MiL
         KMuJo115lfnXkRLU3+oc1ZOWmekFS7agmvTyJgJgZkPi045WdP+idYHO6IDC5NemA2VX
         HmaChCbHA3Xkv+OsNnJoO8JyUd7ednoAuI5MlQ6N5VvDCGs5qGzzjZI73pXX0wutsQ8w
         sp2sC4+Bv7BUaNPjvWix+fiH839+ZxQUSOFIC+9kdI25dAYE4sr/lmKSqWnJUtc0v625
         a3MC1Fgut4mOZSr8xLabGRU0bBoRfuR5w9UE8keHGuOAjauHRwGHuc+N2qMLjLeJBpyi
         gbtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IJEis1mjrPVU9kIf9sDkyYAOGPx0wVN8V19bPjXCBjg=;
        b=oyvoaGBSCAqcd2LALWuouvH5icll+WWRsBFPNQI8FymHwHI/3hmUY1jfI8jmYE9tcB
         XgRTD9F7gdOOlD7RUBQ+i44X0lTOy9xZCNaaLvzgITQ+D1sSvWYEU1atgoPYWe5K69BA
         UL5yoq01srrjGXKbt2Ob8O39PA0p5u7vP6eIsvNO1YeK1v68RcqvbMHTbIYX7efAHnfp
         regU+BkfzFWXtXVf7Tt77EGm5LagW/sxhFB9YoBfDrN2fi6Ff4gWr3kTB3VGM+TNNSyQ
         0Lxvg5CusC//+Q7W4GwequgLig7TdBFvy+Dv74io7/sYse7QAfIx1uvy2KlcggNiCql6
         ACcA==
X-Gm-Message-State: APjAAAXbGoS9Ulpm3jZ7jWHyyzuTZGKIqrCKf+c6QyOIX7aetSRuVlxG
        8Nx4dXsuRwaIqYMWVf0ZLxw=
X-Google-Smtp-Source: APXvYqxhZOwgYL9R7I+ENbhX0qJqbnPCtiV9s+uRKQct0lXz15Mk0GYOrWW/LLlMA5aoKRsR3Xs24Q==
X-Received: by 2002:a63:fb17:: with SMTP id o23mr6898658pgh.362.1561690001123;
        Thu, 27 Jun 2019 19:46:41 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id d6sm386796pgf.55.2019.06.27.19.46.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 19:46:40 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Christian Lamparter <chunkeey@gmail.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/27] crypto: remove memset after dma_alloc_coherent
Date:   Fri, 28 Jun 2019 10:46:31 +0800
Message-Id: <20190628024632.15035-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 16d911aaa508..5e7f2e233406 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -182,7 +182,6 @@ static u32 crypto4xx_build_pdr(struct crypto4xx_device *dev)
 				  dev->pdr_pa);
 		return -ENOMEM;
 	}
-	memset(dev->pdr, 0, sizeof(struct ce_pd) * PPC4XX_NUM_PD);
 	dev->shadow_sa_pool = dma_alloc_coherent(dev->core_dev->device,
 				   sizeof(union shadow_sa_buf) * PPC4XX_NUM_PD,
 				   &dev->shadow_sa_pool_pa,
-- 
2.11.0

