Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED45CC433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Dec 2021 23:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242626AbhLGXg4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Dec 2021 18:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242615AbhLGXgv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Dec 2021 18:36:51 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23DD3C061574
        for <linux-crypto@vger.kernel.org>; Tue,  7 Dec 2021 15:33:20 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 66-20020a630545000000b0032e4e898d24so275134pgf.10
        for <linux-crypto@vger.kernel.org>; Tue, 07 Dec 2021 15:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=46XSeEjo5H2NL/5/c9ldxW11TL6ltb9jVbtcCkM7Ayg=;
        b=Xgj8LvxT9/2jKZhK9jYnbUqDqVoXR/eQ5CH40LJNbyuFjJh6r+NeXM5uBby5wKHKJT
         QlXfRKBp/eDhbAS8mBIyvc+VlPtJGZqMiPQILjdGK/2FQQKV/KkSp2hWQYYtQTO2Jf34
         q4oVotoRGdWoH93ipYuUuJbgpPueWDRA2pppegsUxoPQQYtGEdG5is1YFvYazMi21O1p
         GlcU/42940PRMM980tPEBQwxxBhJ6OSUESXXZ3VWjXqDjHt5UKibdtMzfpv5PqtKbScO
         zCblgAC8G7fd7gJEhA9IyvDdzRNH6bn/H+nJYUoAB8mUEoORXTqQmT47AQZJDB5r0SDV
         zLJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=46XSeEjo5H2NL/5/c9ldxW11TL6ltb9jVbtcCkM7Ayg=;
        b=vYs34XzvVnLPcKEeIi486uX8ofgtJCF3KrKaWaRguoxNy1wSuS2e4vyBd0tfq+RRQN
         /72FnSBlh8L4jceCwMboqkPR9ZAjYPZ99hWIc/mhOBUO+JTun+OedGkPXoMYyOhiWb+I
         ioafrCBkBBrnPQn30wqcaE0qd5JtsyMKqW8PvW/sh3HgI5W5ikFt1WuprL3hjsQG54nO
         +31yLDSCtkiTxS38sMIpkZbANJ6nY7RlVLSGUbzkPTy4DNi5Exg0CH046yYjgu1adUNk
         0/fzi19bFgHTKAI+y6mug1rSDddYbuF836uH6pQJ34JoxW9jcFAygywYVQAJvPvAXw17
         LGww==
X-Gm-Message-State: AOAM531yE3pfic0tOOvemPzlipAs9BRof6YDtoujYTs9HsJCBdvLghIb
        6ctmQDmCgaxrW8fRnFROny5ifxJEi/c=
X-Google-Smtp-Source: ABdhPJy43pt5HEP3ID2ehicyXt/5AFj2Zd9cXGLqHXChM+79yHqoTBRRjrQTVB/szPpTIJj/HSuNFGtAVbM=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:46ed:9c47:8229:475d])
 (user=pgonda job=sendgmr) by 2002:a63:41c5:: with SMTP id o188mr26755932pga.206.1638919999631;
 Tue, 07 Dec 2021 15:33:19 -0800 (PST)
Date:   Tue,  7 Dec 2021 15:33:05 -0800
In-Reply-To: <20211207233306.2200118-1-pgonda@google.com>
Message-Id: <20211207233306.2200118-5-pgonda@google.com>
Mime-Version: 1.0
References: <20211207233306.2200118-1-pgonda@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH V6 4/5] crypto: ccp - Add psp_init_on_probe module parameter
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
 drivers/crypto/ccp/sev-dev.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 8ea362ac014f..686b16e69de7 100644
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
@@ -1109,16 +1116,14 @@ void sev_pci_init(void)
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
2.34.1.400.ga245620fadb-goog

