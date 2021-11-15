Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11073C43219
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 18:22:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0310361C4F
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 18:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241628AbhKOSX4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 13:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241303AbhKOSTY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 13:19:24 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF089C03D787
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 09:41:11 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id u11-20020a17090a4bcb00b001a6e77f7312so264126pjl.5
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 09:41:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Z1IwhrgDnkzSJOmXwvNBu0sMP6p99pljyR5KxxiXwH4=;
        b=lYz5b2egpJMUXe9ItRcNbGGA4P/ha7d8GGAmt11T219wmTmAhsTTuHC3uR3YRakfNG
         ZWt6j7o3JMWeearOH2Yzq10fyTIZQx00Bz7HK1Wo5Q8TRu4TJqUngLdUdBuUSbDc5lhV
         3aooqKEk9e9BQZ+UTZGYTxb+pT6kWWsBHnSgYTDrMw7BcU8xV1MQRbe8+UMLp6oQLDjx
         lXbTPyidGcolkIDbY9LKNe4bxZWDeA46GlyGvcKo1Sm+e7Jcqfwsyur0ly5eUCuz3buu
         2lds+2alW+OtimKA0bMufbDsYWEYB8BOvoD56ZCnmxXP3/MgPzCtFOdMZcf9QEUsKuyr
         8WTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Z1IwhrgDnkzSJOmXwvNBu0sMP6p99pljyR5KxxiXwH4=;
        b=QiFeAqV5UfFoaSqS2wAKOV0mJw64ybDd7SfQFMQOUaGdBBMmquBqxphwAqug888DOe
         kwCNlkIF9dzBwqL4IxP3FMqTTVxrcEtPK3uo6omEVaCtXCCP+FME8QkjsZ/wTKMdp2hF
         CbCccjISkjvb2Ln9qixPB2vQCdjNTboI9/rFdG+F3bpxPmGbH5NwlhQh1EfvwDL0//ou
         ZWBqv6wTYygCNJDxG2oI/8VyhWAHJ0yaeFhO9Kz6R8k7Uqz0jXH31UhSdRXoiE6Q5LEO
         MJtzOorqop0ahu3XaePlqbkyMDXb8u3nMjh2drYum5AdOkU1GxCn9bueVxOlZsilOIfY
         lcYQ==
X-Gm-Message-State: AOAM5336X4MZ4t8r8C+Ts9E9H44W48EbXUx8jwfjKY9mz8Dvn2D93rF6
        TAmKgzMlVraOuLgaMm2GvzOhSU19DLY=
X-Google-Smtp-Source: ABdhPJzfMJtpY2UERK5uTCvegz0J/jzIpR47pHN9gVjfuwCods3xoYjom/325TN4sSFoFCbl5N+LGmYT1u4=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:9fb:192e:3671:218c])
 (user=pgonda job=sendgmr) by 2002:a17:902:7d96:b0:142:87dc:7dd3 with SMTP id
 a22-20020a1709027d9600b0014287dc7dd3mr37036824plm.11.1636998071250; Mon, 15
 Nov 2021 09:41:11 -0800 (PST)
Date:   Mon, 15 Nov 2021 09:41:00 -0800
In-Reply-To: <20211115174102.2211126-1-pgonda@google.com>
Message-Id: <20211115174102.2211126-4-pgonda@google.com>
Mime-Version: 1.0
References: <20211115174102.2211126-1-pgonda@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH V4 3/5] crypto: ccp - Refactor out sev_fw_alloc()
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
 drivers/crypto/ccp/sev-dev.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index c9e7f2d92992..8e388f6c9b05 100644
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
@@ -1094,14 +1105,10 @@ void sev_pci_init(void)
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
2.34.0.rc1.387.gb447b232ab-goog

