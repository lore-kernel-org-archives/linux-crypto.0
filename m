Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85526C43219
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 17:21:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E98360232
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 17:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhKARYL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Nov 2021 13:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbhKARYK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Nov 2021 13:24:10 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA158C061714
        for <linux-crypto@vger.kernel.org>; Mon,  1 Nov 2021 10:21:36 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id y9-20020a17090a2b4900b001a41086b3e0so7984361pjc.8
        for <linux-crypto@vger.kernel.org>; Mon, 01 Nov 2021 10:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eKW1MHsHQDoXENEgPhRYyUnBRHGSJfmJzWx+eKoMHHI=;
        b=mbTPTmCqWZ7agTm+pbsSTSzqn6BGOP9/WqBIhceK+w4I0w8YzrPHxWZxrccLQyDE+7
         13kUZA0UmRR13yb9mGPKk5cLudHd7D12K9P3KNxCYKePe++ylU/Y6RNhO0iKcmEj96mn
         48AEYjtt+MZT9rrNbHq4UBEf3WD48PhkWhFAqUg8I+XtQyOpSjkX2BzJzGzBYA32/sML
         sQpatz8kVfPxoHsln/Z6uEv3q61UtiXhNNzddEVP0SYjcA18J/PW70S2MSGFwFOtdpgj
         iMnlCHt/hqE+2BOj6HU5Lk6jSPOtCMa3Jid07CK/yjeyS2snAEqxTvqQGyoGP97Mygmv
         7J2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eKW1MHsHQDoXENEgPhRYyUnBRHGSJfmJzWx+eKoMHHI=;
        b=RRQP7yxW6uD0QIkZdTqL/ZFmisC56laO7xRLPB83ZXxmmpBbKR+bYx9XhkO3mOji5t
         WrJPO4tYkmk6tIWDlhUBEAeuhAbnGOmq2icDznMTddXUMVsqEHdJQ2DdxSLycG5KzoNx
         glTdjtj0V1ZxuxEZVes8yNiJzohQ0uytGvWVuelp6eEbv3L5yleRmcZBEoHwVw9YrLqb
         px8uoHdzsWlJqyGf2u3RFFQ6l0xL15egMn72UzoWie6ujmcX377haz5qWLKO/dMTPzFj
         sHI5nxebnMQjKIcu1RXhw0Z9fBmJCS4Uv68yxISiSfY777w70cU3HfHTTHtxYroRbQWe
         qetw==
X-Gm-Message-State: AOAM532qrrlfINS2EZs5kLTP74BKegW5helYIEcDB3WlsAtDwldD98Db
        kvsHopGuevryjIgQTIQnIcmEh3eh1NQ=
X-Google-Smtp-Source: ABdhPJyvfEQVQhP2DYhkvJlM6Tz1Q3bBGVLsgE1iCbf9E32mJIkhTkC2sg3uK68QRIIvV3G+eRKMUV1zIYo=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:98c4:afe5:ed9f:d0db])
 (user=pgonda job=sendgmr) by 2002:a17:902:d395:b0:141:a913:1920 with SMTP id
 e21-20020a170902d39500b00141a9131920mr20874752pld.81.1635787296342; Mon, 01
 Nov 2021 10:21:36 -0700 (PDT)
Date:   Mon,  1 Nov 2021 10:21:26 -0700
In-Reply-To: <20211101172127.3060453-1-pgonda@google.com>
Message-Id: <20211101172127.3060453-4-pgonda@google.com>
Mime-Version: 1.0
References: <20211101172127.3060453-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH V2 3/4] crypto: ccp - Refactor out sev_fw_alloc()
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

