Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 873E1C433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Nov 2021 08:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70F856115A
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Nov 2021 08:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235911AbhKIIiE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Nov 2021 03:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239048AbhKIIh4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Nov 2021 03:37:56 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630BDC061766;
        Tue,  9 Nov 2021 00:35:10 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y1so19598350plk.10;
        Tue, 09 Nov 2021 00:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o1cvMhjy6fdnuouwYm+15BaMU3WeB3ZqppuOOP+IdbA=;
        b=NuT+usCXZoscybyvMzPhWmJzLdkr4FzjbII6e+EiSMU0jT0pDUnp0whPvULMcJHsWA
         5UL0Fj1lfanlgShx2s9Vj8P8rrZVpFU0DEXTfz33PSF2FYvj8R4wooFR7KNru3u/Q5po
         6v36EgJuQT70yDJX0YltUindh6/tmvzTGZsvjh7BPt8N5lR0bLdqLS51ExQIMxrifsFM
         MZ509TmpP+ayPKvjDxmpR75mweuxM+MINhhub8rv4hHkgv7UoI87OlalSxZJwsTEWJYp
         fESmSS/vuLk4NVsKQ0GtnMop3zmKzPi8D2YxvT+i/49v5gwd6/6evlxBtJObm6UWEoYU
         IjoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o1cvMhjy6fdnuouwYm+15BaMU3WeB3ZqppuOOP+IdbA=;
        b=FHnSiumbt29TzKrSsomdVKvRHUmjVDzXjO/ogZEWAgM2nPuB22/BLUVUg1Xo+6rhls
         evtxMLnJo3AFNKTbccTVdEW8yOkDkY3RWDt+UvdXKm1SlkGeDUPYNbLs0TQ6av4cg0XY
         l1LIR3/GWcPGmg45MG4jiTBHYckr9OEuXnQU9MZKUfyyfclvEm+kv6y/jVqCNYmkga8a
         hnO3BIfKvOVi4bd+5Y2lH5dZJvsbuzn/qBVRtyGBF6l7bxBoRyieI1d8LUKagRsR9vCY
         lLUyzJLi/31+9CxHF8qoF4WIyDnxVe06MIO52yGZ1zZbrN9w27pF28Zqm8cYcjPERLF/
         RRzw==
X-Gm-Message-State: AOAM532+FFN7Y7ZSvOnRC9MiwdBKTnk+lUerV7dDY7e8MTkMhZNSTg9g
        s6e65hlAyJ3BQ+cke4Arqfc=
X-Google-Smtp-Source: ABdhPJz1Bmf4Sahmca+Rh+H2qps0zm9EFfGfJvy/OSzIAS6mrpd8zFFFzPtQQDiSLpdRpJurU5eVHw==
X-Received: by 2002:a17:902:8505:b0:142:892d:918 with SMTP id bj5-20020a170902850500b00142892d0918mr5468434plb.39.1636446909971;
        Tue, 09 Nov 2021 00:35:09 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id e11sm1820296pjl.20.2021.11.09.00.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 00:35:09 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     bbrezillon@kernel.org
Cc:     arno@natisbad.org, schalla@marvell.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        lbartosik@marvell.com, chi.minghao@zte.com.cn,
        schandran@marvell.com, ebiggers@google.com,
        ovidiu.panait@windriver.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] crypto:otx2_cptvf_algs: use swap() to make code cleaner
Date:   Tue,  9 Nov 2021 08:35:03 +0000
Message-Id: <20211109083503.131468-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: chiminghao <chi.minghao@zte.com.cn>

Fix the following coccicheck REVIEW:
./drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c:1688:16-17 use swap() to make code cleaner

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: chiminghao <chi.minghao@zte.com.cn>
---
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
index 877a948469bd..2748a3327e39 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
@@ -1682,11 +1682,8 @@ static void swap_func(void *lptr, void *rptr, int size)
 {
 	struct cpt_device_desc *ldesc = lptr;
 	struct cpt_device_desc *rdesc = rptr;
-	struct cpt_device_desc desc;
 
-	desc = *ldesc;
-	*ldesc = *rdesc;
-	*rdesc = desc;
+	swap(*ldesc, *rdesc);
 }
 
 int otx2_cpt_crypto_init(struct pci_dev *pdev, struct module *mod,
-- 
2.25.1

