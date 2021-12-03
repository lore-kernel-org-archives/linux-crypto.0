Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F05C43217
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Dec 2021 14:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245039AbhLCOuU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Dec 2021 09:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352632AbhLCOuS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Dec 2021 09:50:18 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E60DC0698C2
        for <linux-crypto@vger.kernel.org>; Fri,  3 Dec 2021 06:46:49 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id r199-20020a6b2bd0000000b005e234972ddfso2388498ior.23
        for <linux-crypto@vger.kernel.org>; Fri, 03 Dec 2021 06:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5j0nTnnTae7ucgIsj28o/kyyvCBiva97gISeau3JhKc=;
        b=QP9nub4ojl3a0CqeB1HYfLmqbdzRPZJtR6+Pv9Y4KYnpLqqxYuti7T4iIrRtKO5Tyj
         AZZK1D2o46MTL6NY6ggIQXBTr3pgDcuXUriftsLS6diRDsG49LyzkTnVUD2AazhhCHRM
         +pifuHQDSO3XkQLpFMoP34TLHoKkv2hBYXI2nyoGkgaoQShwz5AYXMo7I8nz/FJfdEb2
         A091FzWadb3jM2YJoQszaHNi/VQAg9FA7GU2gQzmNhM+3/249Qyknco2cSnvN3mseHQa
         screQz9BDzp07J0BuDTi0ERXxG0sYvTBQ84ByBzPuja7sApSKYZd3bqnHmk4FttDO7Hv
         SZOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5j0nTnnTae7ucgIsj28o/kyyvCBiva97gISeau3JhKc=;
        b=bVcI05HKTNDik3g5Q0h1btn39a035PrFi0qC3YzP4/WjnuAYZSu7qhcwmHjYxkRGAN
         oSFDgerHIbcNmSEyC3Noz/UnvZx1pL/5LBRCF7+FHBKudSI9574ov2cMR64KX7EVI/6n
         ne7owdiHPXLlIl1oFBcq8wIRY4ip/M3LMSnneMFkQ0yzv4uhe4xydcjoPZH8QBu14dmY
         qym4RCOg/9ezUY/MMjsUgaaWV4ZlqgYPym/+TiWV17AA59+uqUQK471FgjKWeJUP+oA+
         IXrMCS0J7yHoE96OKJhLNXTE25lnFImVbmAbJomgCgMGAkGZl9AX1VuFbeIZZzT/kdp2
         pX1g==
X-Gm-Message-State: AOAM5317j7dj7Hcpq+kSqzztNZWYyBF7N3uaceKM4Bd9ndeuRy4rzDLM
        QxY1Iaao3VcsOWybPPDpSHWrCJ03Gs8=
X-Google-Smtp-Source: ABdhPJwB8zssRzEx/gt0Lzegldks+iaNRzhixYi7GxjIg/Eh0N4oC3wOmR3IQnorTWwQ5aBItXckSQrCgCY=
X-Received: from pgonda2.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:ac9])
 (user=pgonda job=sendgmr) by 2002:a05:6602:1604:: with SMTP id
 x4mr21455462iow.84.1638542808479; Fri, 03 Dec 2021 06:46:48 -0800 (PST)
Date:   Fri,  3 Dec 2021 14:46:41 +0000
In-Reply-To: <20211203144642.3460447-1-pgonda@google.com>
Message-Id: <20211203144642.3460447-5-pgonda@google.com>
Mime-Version: 1.0
References: <20211203144642.3460447-1-pgonda@google.com>
X-Mailer: git-send-email 2.34.0.384.gca35af8252-goog
Subject: [PATCH V5 4/5] crypto: ccp - Add psp_init_on_probe module parameter
From:   Peter Gonda <pgonda@google.com>
To:     thomas.lendacky@amd.com
Cc:     Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Rientjes <rientjes@google.com>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add psp_init_on_probe module parameter that allows for skipping the
PSP's SEV platform initialization during module init. User may decouple
module init from PSP init due to use of the INIT_EX support in upcoming
patch which allows for users to save PSP's internal state to file. The
file may be unavailable at module init.

Also moves the PSP ABI version log message to after successful PSP init
instead of module init in case this new parameter is used.

Signed-off-by: Peter Gonda <pgonda@google.com>
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
 drivers/crypto/ccp/sev-dev.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 7f467921b1dc..ab3752799011 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -43,6 +43,10 @@ static int psp_probe_timeout = 5;
 module_param(psp_probe_timeout, int, 0644);
 MODULE_PARM_DESC(psp_probe_timeout, " default timeout value, in seconds, during PSP device probe");
 
+static bool psp_init_on_probe = true;
+module_param(psp_init_on_probe, bool, 0444);
+MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initialized on module init. Else the PSP will be initialized on the first command requiring it");
+
 MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
 MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
 MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
@@ -305,7 +309,10 @@ static int __sev_platform_init_locked(int *error)
 
 	dev_dbg(sev->dev, "SEV firmware initialized\n");
 
-	return rc;
+	dev_info(sev->dev, "SEV API:%d.%d build:%d\n", sev->api_major,
+		 sev->api_minor, sev->build);
+
+	return 0;
 }
 
 int sev_platform_init(int *error)
@@ -1110,16 +1117,14 @@ void sev_pci_init(void)
 		dev_warn(sev->dev,
 			 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
 
+	if (!psp_init_on_probe)
+		return;
+
 	/* Initialize the platform */
 	rc = sev_platform_init(&error);
-	if (rc) {
+	if (rc)
 		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
 			error, rc);
-		return;
-	}
-
-	dev_info(sev->dev, "SEV API:%d.%d build:%d\n", sev->api_major,
-		 sev->api_minor, sev->build);
 
 	return;
 
-- 
2.34.0.384.gca35af8252-goog

