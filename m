Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 887FDC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Oct 2021 17:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A1416108F
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Oct 2021 17:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhJ1SAf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Oct 2021 14:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbhJ1SAa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Oct 2021 14:00:30 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A87C061243
        for <linux-crypto@vger.kernel.org>; Thu, 28 Oct 2021 10:58:00 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id p19-20020a17090a429300b001a1fd412f57so3697883pjg.9
        for <linux-crypto@vger.kernel.org>; Thu, 28 Oct 2021 10:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pUbRXJ25fy+xevW413+zLfvLf6jaUw9jcscxCVLb4Cs=;
        b=tkzxxgdJUgne+bl6xlY7dEKbNgEmlTUQE+6kwYO8iNVjnyzADc9loZ30ez3Q9ahv9y
         ojmm355V9dEk71j5eJIdmHNGrx8kvDHcy1Ru1wuQ34r26D+8e/1yHrbxoG0LZZ3G3W1q
         bwOTwtAkcVgC4ZUyxtGoqdcF1xanaCvfMzf5GqYcCaK0XLod7MxB5T4mmYNCmLrihBuj
         DK+AhwB7Knr5qV2tpy+xleOBBgzI03/bZ9WfG/GfM5A9Gax0UmGX1xpjiDmPNtVxg4rL
         9qKzQv/MeC2x60x1oi5LP02ZNETRklZWkVnlwl9zFHIMx8kuUMtVZvnokxW7VQnVlD5I
         jdbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pUbRXJ25fy+xevW413+zLfvLf6jaUw9jcscxCVLb4Cs=;
        b=aQYqL09GUHApKkv8pE04sEko3kq3N18vSRk7UDBbMAT9nngunJPhY6rDVamHd0qFfd
         +jnN55rPaJ4MqffcA+nePwCbFNZcRj3773SRnYaj6xHcK3bVr9sjnCXxREwAzdItK0Kv
         JEmp+Qtrtv/Zp44EludeTNVMl8DLMlIUOu5OdF++CHQrBCoZIHGOqM0uykflpJgpnBPf
         d5x1hPLTL+52A02byWxUSjC76lxtlUU9swtmNxd/NXzBFFB+blq+ZE4BtdT4QlYpZ7aX
         FUDvE8i5rQGM/qj3p4XchlHqCstOjpQrZDpZrvrllHMhLXA7UiIZRaoid3+8lGABlglZ
         v4uA==
X-Gm-Message-State: AOAM532OkobYXihSvOdygk8JkyknuLLEk5K/+hsrgxb9YdSTNUroBMQx
        4DVFPeUcn63AoQkVlpPOSV2FZOtBEvY=
X-Google-Smtp-Source: ABdhPJzqOnx7SEZ0kVkTfQ/v4ayQwRsf2S5JsjBXHeWfbCG426uCSPbsqaeTxliJzDM7roMZeHWN7jxz8U8=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:41d0:ac84:3b61:5938])
 (user=pgonda job=sendgmr) by 2002:a63:5646:: with SMTP id g6mr3803105pgm.216.1635443879499;
 Thu, 28 Oct 2021 10:57:59 -0700 (PDT)
Date:   Thu, 28 Oct 2021 10:57:48 -0700
In-Reply-To: <20211028175749.1219188-1-pgonda@google.com>
Message-Id: <20211028175749.1219188-4-pgonda@google.com>
Mime-Version: 1.0
References: <20211028175749.1219188-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH 3/4] crypto: ccp - Refactor out sev_fw_alloc()
From:   Peter Gonda <pgonda@google.com>
To:     thomas.lendacky@amd.com
Cc:     Peter Gonda <pgonda@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
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
Acked-by: David Rientjes <rientjes@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Rientjes <rientjes@google.com>
Cc: John Allen <john.allen@amd.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paolo Bonzini <pbonzini@redhat.com> (
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/ccp/sev-dev.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index e4bc833949a0..b568ae734857 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -141,6 +141,21 @@ static int sev_cmd_buffer_len(int cmd)
 	return 0;
 }
 
+static void *sev_fw_alloc(unsigned long len)
+{
+	const int order = get_order(len);
+	struct page *page;
+
+	if (order > MAX_ORDER-1)
+		return NULL;
+
+	page = alloc_pages(GFP_KERNEL, order);
+	if (!page)
+		return NULL;
+
+	return page_address(page);
+}
+
 static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 {
 	struct psp_device *psp = psp_master;
@@ -1076,7 +1091,6 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
 void sev_pci_init(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
-	struct page *tmr_page;
 	int error = 0, rc;
 
 	if (!sev)
@@ -1092,14 +1106,10 @@ void sev_pci_init(void)
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

