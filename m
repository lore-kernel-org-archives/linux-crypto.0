Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCECCC46467
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Jan 2023 17:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbjAJRKK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Jan 2023 12:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238725AbjAJRJx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Jan 2023 12:09:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CBB26C7
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 09:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673370542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dsol8v/Y6ZKSi13JaYlImDhTwgtM/ldtPi7rslMNW7w=;
        b=Z/mAHg65jzeb8GcWGvnxChmJxpcpfssNnRNNkwgeY/BKC4HqqwGy6EBgDhb1mfWQAo/WpR
        oYBEj48hn/05w13kJ/3KBIAlqQ1dTjGkPio4txU8fMKS2s2+nzm2xUxw3H7JoiJkVe+UfE
        JH9y1r5DxbnZsy44s+GdVtXEIZKq/5o=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-360-So52z0ZCNvOPa-jRnLEq5A-1; Tue, 10 Jan 2023 12:09:00 -0500
X-MC-Unique: So52z0ZCNvOPa-jRnLEq5A-1
Received: by mail-pg1-f198.google.com with SMTP id e5-20020a63f545000000b0049b36d5a272so5473605pgk.12
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 09:09:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dsol8v/Y6ZKSi13JaYlImDhTwgtM/ldtPi7rslMNW7w=;
        b=hrgtM3wjA2HA6Q/FKI2KRdXYmDsYXqFRTkrHe6XU58fVdkMGZRMOKUwygQIEfaAqRn
         5KQLKVFEJvC2gSH7QPPpueSyr/4SgypR70jbZrnfBIs4oVnnLecyY1gHW1sgu56LxZ4Q
         bS7UQTP1Kfzgw4r6al/3fIuhcWe5v+0oAYCzJ6thS1k+eeCxciCElznoAhLKu8a5S4JB
         MZXoa3RkvfJY7BK+2FKPJvBOnKg7tvSKYBjQQM2LY33Pilj54fDPZ3HgHD71L85wMulh
         Yf5T5M0aiz3Ox9GwuSkBJTT5C58L5x/mdIoAfXX7nEgOq40YMx4/y0LDXHKZj5zmQLlE
         sG5g==
X-Gm-Message-State: AFqh2kq4GXnJcy2xSfmUBawuH4/br6PYlUBLzhoDLiTZPFk2+GI3F3PQ
        sV9OkDEfWO7nV6qcE8P1l0FIcvYEjf2CoZIKmwlVdsO20tkt6N19fEEAz71iCoSrse/yAyWm0l3
        ndDwX3aELvffvkwWlGkTSU9kp
X-Received: by 2002:a17:902:7fc2:b0:192:e2bb:c98e with SMTP id t2-20020a1709027fc200b00192e2bbc98emr21816367plb.6.1673370539508;
        Tue, 10 Jan 2023 09:08:59 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvef1/S8komThhaW5j6OMI0KSuDQUbOtSsCLVXNnWaNixCfpkyN2Bup+O3Pe2DgRCluN/6Xyw==
X-Received: by 2002:a17:902:7fc2:b0:192:e2bb:c98e with SMTP id t2-20020a1709027fc200b00192e2bbc98emr21816345plb.6.1673370539248;
        Tue, 10 Jan 2023 09:08:59 -0800 (PST)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id u14-20020a170902e5ce00b00189371b5971sm8386798plf.220.2023.01.10.09.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 09:08:58 -0800 (PST)
From:   Tom Rix <trix@redhat.com>
To:     brijesh.singh@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        nathan@kernel.org, ndesaulniers@google.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH v3] crypto: ccp: initialize 'error' variable to zero
Date:   Tue, 10 Jan 2023 12:08:48 -0500
Message-Id: <20230110170848.3022682-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Clang static analysis reports this problem
drivers/crypto/ccp/sev-dev.c:1347:3: warning: 3rd function call
  argument is an uninitialized value [core.CallAndMessage]
    dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

__sev_platform_init_locked() can return without setting the
error parameter, causing the dev_err() to report a garbage
value.

Fixes: 200664d5237f ("crypto: ccp: Add Secure Encrypted Virtualization (SEV) command support")
Signed-off-by: Tom Rix <trix@redhat.com>
---
v2 cleanup commit log
v3 cleanup commit log
---
 drivers/crypto/ccp/sev-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 56998bc579d6..643cccc06a0b 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1307,7 +1307,7 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
 void sev_pci_init(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
-	int error, rc;
+	int error = 0, rc;
 
 	if (!sev)
 		return;
-- 
2.27.0

