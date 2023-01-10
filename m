Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B85C46467
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Jan 2023 16:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbjAJQUO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Jan 2023 11:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238899AbjAJQTz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Jan 2023 11:19:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0595C913
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 08:18:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673367520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=J7MvbGohPb9c5KuFVDOSy13hj72U3Wx/T4iJQbVeyfQ=;
        b=AklHkyA4rx/b3ReaMnb/Mz//e3f32wYWKT5x4qrLGIu6BuhcKUFscsHfBr/2PqQBaM0UsX
        fnTsJ6g5sgVtjq/dkerdeCAu7PfUF4Nlg015kDR0I+aDy+x3N9D2gn6TB13bCAU73cNBdf
        ZWQYuO4RPm0PEpG2nXzwlafoiIpBcC4=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-281-D1NxGZZEPcmq0CCBds7RDg-1; Tue, 10 Jan 2023 11:18:38 -0500
X-MC-Unique: D1NxGZZEPcmq0CCBds7RDg-1
Received: by mail-qt1-f199.google.com with SMTP id u12-20020a05622a198c00b003ad1125712dso2807969qtc.2
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 08:18:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J7MvbGohPb9c5KuFVDOSy13hj72U3Wx/T4iJQbVeyfQ=;
        b=E1FlQ5V/Sa82Ozdx2E7zbGicwE1CHG8Ql0Bdw/XF3yXYDbafTZiTAjyMHAAILnY2lz
         o47sYm8WyckVNdjFU/rczTilr6D9yy1pLkoKeX3cXMTfBq1LQqkSurj4wg0GUwbJP+S1
         4ZwsVZrItwZtPqJUfJ7DChNX6r+mZjX6AyTGSfaWzsrF8QKw4ObuAjCpDysOw2p4NgfC
         d/Et0YW5h21JAGbFlgCBFt8lhWeWGc94IQpnetBF3FhoRtP3w135NYoUmcuDIi7kad2D
         wdLh9KmV0Ew/aZOY8VGpOEIyehlwIqRPgvtG5QVGTo51ueIKiKISvONOEuWcWvjlGmjs
         jNaQ==
X-Gm-Message-State: AFqh2koVHu5Z9Ezr1qiJ4BpNv1oIpTQgj+tHib2yYwFHjYj0HlCgjC5T
        9ANe+6HMPQrLebIY0IEnb/kLVTSNOsIayGIp/zZLE9np4N3LuPulCCLDegtc2JIHEpO6hzjPJO3
        cC8tf6UX9hHUCfhNDKeuhCu44
X-Received: by 2002:a05:622a:4d06:b0:3a9:9217:9e6c with SMTP id fd6-20020a05622a4d0600b003a992179e6cmr109627049qtb.55.1673367516970;
        Tue, 10 Jan 2023 08:18:36 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtvz6UJWZ+sKLEjeZfRYxKqad/zTOI/hkz1wPhI9svfnbTHZgxVGTtTAGAgwHNF9SUsIhqUjw==
X-Received: by 2002:a05:622a:4d06:b0:3a9:9217:9e6c with SMTP id fd6-20020a05622a4d0600b003a992179e6cmr109626901qtb.55.1673367515311;
        Tue, 10 Jan 2023 08:18:35 -0800 (PST)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id t34-20020a05622a182200b003a527d29a41sm6190082qtc.75.2023.01.10.08.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 08:18:34 -0800 (PST)
From:   Tom Rix <trix@redhat.com>
To:     brijesh.singh@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        nathan@kernel.org, ndesaulniers@google.com, rientjes@google.com,
        marcorr@google.com, pgonda@google.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH] crypto: initialize error
Date:   Tue, 10 Jan 2023 11:18:31 -0500
Message-Id: <20230110161831.2625821-1-trix@redhat.com>
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
error parameter, causing the dev_err() to report a gargage
value.

Fixes: 3d725965f836 ("crypto: ccp - Add SEV_INIT_EX support")
Signed-off-by: Tom Rix <trix@redhat.com>
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

