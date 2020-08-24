Return-Path: <SRS0=tkOt=CC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44979C433E1
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 14:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22F0B206B5
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 14:01:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kbEqpq12"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbgHXOBR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Aug 2020 10:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726886AbgHXOBN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Aug 2020 10:01:13 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600A5C061574
        for <linux-crypto@vger.kernel.org>; Mon, 24 Aug 2020 07:01:13 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id 6so6193676qtt.0
        for <linux-crypto@vger.kernel.org>; Mon, 24 Aug 2020 07:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mi86+WphliiE46rge60tCAlVsMmu7FS4d8IzZESWhL8=;
        b=kbEqpq12FNAu/2vT9L2fQEO7zBNYtapgY8AMifK5255p+PY9p/NZ4Pii14G9YIRR+0
         TgeZM4zpB1iowxqFm3Kc7yOmgUL2ghyxSFB34by1kfH8/asHa8z6MDGe9BA3SLvZqrMY
         CdpkPZZjwsCVjH1EblUnYRcPMrWQT8WpKFzsnVHR3xOXFYlXWqumKCd8n11MGWDHrP+G
         ZPfrSyipYHuhNd7gP92m+Gn2D8HcMVwPlBeGRlnGGgAXrs75qNAi2LKx2TTIFlU+s0ko
         XACx24Avzvxnc8pI1z0ujQBBQkYVPYF5RGG0yTn2jq03GYyI4kKVOp9JTCITPvaNYHDB
         K44w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mi86+WphliiE46rge60tCAlVsMmu7FS4d8IzZESWhL8=;
        b=FBg65fSXMlb39TCCGYF+uE4JGYMBPCCdxZrNvzhQcSWUxJ3qpg4vvn/wHiuPZ0VcqV
         +vVC08rHbcSntcnKTEefIVo17Kz8Dyx9R/e0fbnXG9PBb8A8FxWK1XUBtmGnF5qS+2eT
         lmeZgHFGcmYsK23+dZq8AwHbHtcbiIEDHU/YSTKshhwpvhuPwElzhr8zmcdNUtrZVYkm
         EvT/nwuwoLES50pvDrr1v2YnoAEvqsEhC0pL751CasYkEB0tNRD105eoAqp7JcgsdMOR
         gkXHl4ftFdmpXlRxx4Kw1Am0IMYJ9/dC1XfZnlHSh3Tz7l+A+1GyNtuaaOcetnFVwGuw
         acqg==
X-Gm-Message-State: AOAM532FCbx52k+RM7lDpPaRbYxnx+zJc+EcEdV3lEkOCeXHNblYc5Lc
        Kzm5IraQv0wt3M5Gl8Jmks8=
X-Google-Smtp-Source: ABdhPJw+LruaJmmWJO+Mtw5M3vgeggarBNQ1YOjhxoESzHvNExHtKePDygkeiBdJjbAieDiAUxQ6XA==
X-Received: by 2002:ac8:6c6:: with SMTP id j6mr5025543qth.129.1598277672543;
        Mon, 24 Aug 2020 07:01:12 -0700 (PDT)
Received: from localhost.localdomain ([177.194.72.74])
        by smtp.gmail.com with ESMTPSA id r20sm3244459qtc.87.2020.08.24.07.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 07:01:11 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        mcoquelin.stm32@gmail.com, Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 2/2] crypto: stm32/hash - include <linux/dma-mapping.h>
Date:   Mon, 24 Aug 2020 10:58:40 -0300
Message-Id: <20200824135840.3716-2-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200824135840.3716-1-festevam@gmail.com>
References: <20200824135840.3716-1-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Building ARM allmodconfig leads to the following warnings:

drivers/crypto/stm32/stm32-hash.c:492:18: error: implicit declaration of function 'dma_map_sg'; did you mean 'dma_cap_set'? [-Werror=implicit-function-declaration]
drivers/crypto/stm32/stm32-hash.c:493:8: error: 'DMA_TO_DEVICE' undeclared (first use in this function); did you mean 'MT_DEVICE'?
drivers/crypto/stm32/stm32-hash.c:501:3: error: implicit declaration of function 'dma_unmap_sg' [-Werror=implicit-function-declaration]
drivers/crypto/stm32/stm32-hash.c:589:8: error: 'DMA_TO_DEVICE' undeclared (first use in this function); did you mean 'MT_DEVICE'?

Include <linux/dma-mapping.h> to fix such warnings

Reported-by: Olof's autobuilder <build@lixom.net>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 drivers/crypto/stm32/stm32-hash.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 03c5e6683805..092eaabda238 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -9,6 +9,7 @@
 #include <linux/clk.h>
 #include <linux/crypto.h>
 #include <linux/delay.h>
+#include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
-- 
2.17.1

