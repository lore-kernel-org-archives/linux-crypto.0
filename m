Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A20AC433FE
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Dec 2021 23:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242621AbhLGXgu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Dec 2021 18:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242614AbhLGXgt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Dec 2021 18:36:49 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FE2C061746
        for <linux-crypto@vger.kernel.org>; Tue,  7 Dec 2021 15:33:18 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id i12-20020a63584c000000b00330ec6e2c37so281202pgm.7
        for <linux-crypto@vger.kernel.org>; Tue, 07 Dec 2021 15:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ekOV9da4eWSrPoL63ChA67xsZs2WyoWSKbx3HEcftwg=;
        b=l3kk4SnixWXF3tsv+8v1l4PbSejH8gJCJykpVyS6vkQvCnmub/r5nqHlySnBYEnJ3R
         NR4ESPRwI6Rgf4coACYSAVfkb8btWBUsg0w9bA8Ip8NE6IWBWSiJt3ehxqo3ict286d5
         wj1lp1D7qhiN8rClhEH2sV0b0q6s4kqOUdTRlpw/SPTB5Rrrs581tmUfSTE5E8cLDWkG
         wm8rDrt+KdK3pgpVAHmXp0wSohvArd2dJMUCAmbYBOt/CltCS7m5VKUZTwC3iUe5U5DT
         GfPZmLr0vPdw714idQxMClczLIVbGoRvd3z0284BjqqWA41ua7s8InQTeaoVB03QyXgo
         n5rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ekOV9da4eWSrPoL63ChA67xsZs2WyoWSKbx3HEcftwg=;
        b=pBFL3zsu/OCapqqQPygAtMWtrLUJT0GEu17jNrKzk21pvXqP7elBlTOsRafHdh7a4h
         vN++bPVnYDs2JB4xg3FCtSiO4grK0cHJnfq0ZRQFaHuFALptdkSgqad0JhU349JyaTnU
         9bx5PjsEWFAIjCTq17nabMfY41gz/WLKmjGRItqxIwO10vj7V9jJlUzQZf0aPmnZwkqH
         nSc3gl7lfyXHMnbud2xubwbiR++noxI70C9bHZC3Vv56G2pvLu/J4ODHNd3vaBiAEZMS
         SkqIZ2du40xvteoFrQ/NRil1IW/aWc5hexZuaPJgtBkvxYl+hkbQetFnVf8IBui2avcX
         9v0A==
X-Gm-Message-State: AOAM530BRTC5k8k3e+D85tlNi6iWlbCd1JeWdhA4+lIbwtvU2LLIbERS
        flpmvl0elpZg6/YPn3hufjgcavcYjrU=
X-Google-Smtp-Source: ABdhPJzuKzhttUxwRDHCLWpasUIlmUcvPliCCRNSdYKkfltOWOcn8RtTEBhof61Y9WOWhgY/FjJ8hItvmH0=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:46ed:9c47:8229:475d])
 (user=pgonda job=sendgmr) by 2002:a17:90a:a786:: with SMTP id
 f6mr2842553pjq.158.1638919997919; Tue, 07 Dec 2021 15:33:17 -0800 (PST)
Date:   Tue,  7 Dec 2021 15:33:04 -0800
In-Reply-To: <20211207233306.2200118-1-pgonda@google.com>
Message-Id: <20211207233306.2200118-4-pgonda@google.com>
Mime-Version: 1.0
References: <20211207233306.2200118-1-pgonda@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH V6 3/5] crypto: ccp - Refactor out sev_fw_alloc()
From:   Peter Gonda <pgonda@google.com>
To:     thomas.lendacky@amd.com
Cc:     Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Create a helper function sev_fw_alloc() which can be used to allocate
aligned memory regions for use by the PSP firmware. Currently only used
for the SEV-ES TMR region but will be used for the SEV_INIT_EX NV memory
region.

Signed-off-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Rientjes <rientjes@google.com>
Cc: John Allen <john.allen@amd.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/ccp/sev-dev.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index ef7e8b4c6e02..8ea362ac014f 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -141,6 +141,17 @@ static int sev_cmd_buffer_len(int cmd)
 	return 0;
 }
 
+static void *sev_fw_alloc(unsigned long len)
+{
+	struct page *page;
+
+	page = alloc_pages(GFP_KERNEL, get_order(len));
+	if (!page)
+		return NULL;
+
+	return page_address(page);
+}
+
 static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 {
 	struct psp_device *psp = psp_master;
@@ -1078,7 +1089,6 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
 void sev_pci_init(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
-	struct page *tmr_page;
 	int error, rc;
 
 	if (!sev)
@@ -1094,14 +1104,10 @@ void sev_pci_init(void)
 		sev_get_api_version();
 
 	/* Obtain the TMR memory area for SEV-ES use */
-	tmr_page = alloc_pages(GFP_KERNEL, get_order(SEV_ES_TMR_SIZE));
-	if (tmr_page) {
-		sev_es_tmr = page_address(tmr_page);
-	} else {
-		sev_es_tmr = NULL;
+	sev_es_tmr = sev_fw_alloc(SEV_ES_TMR_SIZE);
+	if (!sev_es_tmr)
 		dev_warn(sev->dev,
 			 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
-	}
 
 	/* Initialize the platform */
 	rc = sev_platform_init(&error);
-- 
2.34.1.400.ga245620fadb-goog

