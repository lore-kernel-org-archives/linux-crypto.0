Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF895C46467
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Jan 2023 16:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239059AbjAJQyY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Jan 2023 11:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239005AbjAJQyO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Jan 2023 11:54:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50BD193C9
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 08:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673369606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Kup4HOCIEU1szEBLKhvEmi75KAA9Nb/HeMnvSYwk5j0=;
        b=LI4G1rCUuToZQyYr8LY6EFzljUELpDzV6Jf3cKwIaT6Dy2R855uSURPVJrXbexTXjQ+1A6
        zzrkWnz5mmCEVDsRgFUMv09v5zgr07mPCqUlnUAR8IMQ9t+7rGXsrmKZfiQt3ivcoZSj0K
        Y2sH/Sjw8WxTYciG7qt0u9sfqx4V0Rg=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-484-tCzbOWyrPMCyws-Kg8XjSw-1; Tue, 10 Jan 2023 11:53:21 -0500
X-MC-Unique: tCzbOWyrPMCyws-Kg8XjSw-1
Received: by mail-qt1-f200.google.com with SMTP id ay40-20020a05622a22a800b003a978b3019cso5786749qtb.16
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 08:53:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Kup4HOCIEU1szEBLKhvEmi75KAA9Nb/HeMnvSYwk5j0=;
        b=4EGaAvR7VVOFg+YeuP6yJQxJ4BNuJwR/7D3Cqy6a9SwwW76Lx4Cb91G3YFudnzh/0V
         ZYsKXKfK/HAL+B70xYMbH9RW/8n10b//huqewgvb6G6/bn6j5aW18X52TficFB/mEDQD
         4Mo+bYEN7dvYX1b2HZDkuuNrscaY096GlDB8LuV1eaOrULDUn098XTdCUXMidakutU8c
         AlJ12X79b9DrdiZw+Rihmhs5s9Dtu2jmvu3jbkFakR3Pg/UUceo6wLluTQPe4OczmJi3
         131lU8PCCjlI0QvWqL7E88NdVuZmQrdsfWMM6hvaCwOfHkioMado78GmIcyhqo72ojj6
         3phA==
X-Gm-Message-State: AFqh2koxr0bgv4zpcpG9Tsr4amWgX8lhFTk/2V/YcIm+khToNi438TgT
        9B7BXuOWQ1MH/FdxPRldKRHywKC8moW85+GaQo74Xxyk6RImhTbFzaqcnDsk+S9FHWFantdeYkj
        a/u6+D3XfrHKOgWFC9+72aMEV
X-Received: by 2002:a05:622a:1f06:b0:3ae:55ba:8392 with SMTP id ca6-20020a05622a1f0600b003ae55ba8392mr8544546qtb.32.1673369600684;
        Tue, 10 Jan 2023 08:53:20 -0800 (PST)
X-Google-Smtp-Source: AMrXdXu1gy+R4UVBxdneGHh2kFQ1PNWrp1or09a54OsiH2i2fXOwcKnmCac0ajbB6/JUU7bf9dSNdA==
X-Received: by 2002:a05:622a:1f06:b0:3ae:55ba:8392 with SMTP id ca6-20020a05622a1f0600b003ae55ba8392mr8544521qtb.32.1673369600490;
        Tue, 10 Jan 2023 08:53:20 -0800 (PST)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id y19-20020a05620a44d300b006fba44843a5sm7452833qkp.52.2023.01.10.08.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 08:53:20 -0800 (PST)
From:   Tom Rix <trix@redhat.com>
To:     brijesh.singh@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        nathan@kernel.org, ndesaulniers@google.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH v2] crypto: ccp: initialize error
Date:   Tue, 10 Jan 2023 11:53:16 -0500
Message-Id: <20230110165316.2870300-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

clang static analysis reports this problem
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
v2 : cleanup commit log
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

