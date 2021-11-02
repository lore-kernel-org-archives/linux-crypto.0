Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41625C433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 14:23:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A7396112F
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 14:23:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhKBO0U (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Nov 2021 10:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbhKBO0S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Nov 2021 10:26:18 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB313C06120B
        for <linux-crypto@vger.kernel.org>; Tue,  2 Nov 2021 07:23:39 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id e6-20020a637446000000b002993ba24bbaso11992282pgn.12
        for <linux-crypto@vger.kernel.org>; Tue, 02 Nov 2021 07:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eKW1MHsHQDoXENEgPhRYyUnBRHGSJfmJzWx+eKoMHHI=;
        b=hN5ApV6fAKbY1X/1kLS6N4R8Fn6gxuxQgit5pkn/H7KDDISaXwUZMN3sudewY1r3nq
         SLy2d/RCriMBir9LjSfcf6XsC41QATE1SO/5PnJbDjXnBP08a7FqHORaDdfhhhxhmEY9
         Y9YnV9ml/zJatIT0jOnAOVxEef2gCHSyYDsbhS6ouoxYfEkqq6fr9wVtuyzXYXwcDSD6
         PDs7ql4oP7CJ3iyfnsK+/YpkTvEpgQvujr8O2H0LbleKqwqUkb/USrKMOq1KqXtMORdy
         EE/7LTWVIZDHIUAYfDIcM4niNkpsShvhRS4tQP9P7uQdhZ+0o+///xjzwTuWSxPBv0kS
         QXVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eKW1MHsHQDoXENEgPhRYyUnBRHGSJfmJzWx+eKoMHHI=;
        b=JgCRUhED0ETgwx6/QRk2xgjSn+nMwaYYbl6UNNfQJG6iaUpxzfd89Ntb/5yFLe2rx7
         sX5pzlCt04YFGAilE3w1niSSK+KZPDYpIXrLzp+FTGOAmhGlWlh99uw/Ir7+CHVD9USF
         xat0brLWGJEH0KPIa9gc3EcnyoHXqR3MhourNVA8hJkFsfmjAbRE5GY12ky8RqWJNxD6
         IRqw3R7P2I9vObaR9Hfx3tAypEXadmEO4AaCyaTh4Bn8sHvtDKIAFTIcIGdc6T8MwQTd
         hoqK+P7hf67MFnPJeX/0lymPbj09pFxLLojidfAJ+S7bKfZ/EJDsRFe7qHAcBPplkF+E
         SKQg==
X-Gm-Message-State: AOAM533Ehs35ulbw+BPc+2GAQUMBnTcGioZOn1P7FS7gi/FXA/4yAxn8
        wzvZD1J4s3tBFdebdOL956n0zCrDhaE=
X-Google-Smtp-Source: ABdhPJxS9KO380TsnTeSwizEoAhyC7xPnb22rfVT3Wny3ufjxSSsiS2U5MvlRugjtsPi2jVw2ip60IjP4l0=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:3109:8497:f59d:9150])
 (user=pgonda job=sendgmr) by 2002:a17:902:7ec2:b0:13d:b563:c39 with SMTP id
 p2-20020a1709027ec200b0013db5630c39mr31705058plb.14.1635863018600; Tue, 02
 Nov 2021 07:23:38 -0700 (PDT)
Date:   Tue,  2 Nov 2021 07:23:30 -0700
In-Reply-To: <20211102142331.3753798-1-pgonda@google.com>
Message-Id: <20211102142331.3753798-4-pgonda@google.com>
Mime-Version: 1.0
References: <20211102142331.3753798-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH V3 3/4] crypto: ccp - Refactor out sev_fw_alloc()
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

Creates a helper function sev_fw_alloc() which can be used to allocate
aligned memory regions for use by the PSP firmware. Currently only used
for the SEV-ES TMR region but will be used for the SEV_INIT_EX NV memory
region.

Signed-off-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Acked-by: David Rientjes <rientjes@google.com>
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
index e4bc833949a0..00ca74dd7b3c 100644
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
@@ -1076,7 +1087,6 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
 void sev_pci_init(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
-	struct page *tmr_page;
 	int error = 0, rc;
 
 	if (!sev)
@@ -1092,14 +1102,10 @@ void sev_pci_init(void)
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
2.33.1.1089.g2158813163f-goog

