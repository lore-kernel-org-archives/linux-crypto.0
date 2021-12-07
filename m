Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D4CC433FE
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Dec 2021 23:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242593AbhLGXgp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Dec 2021 18:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242588AbhLGXgp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Dec 2021 18:36:45 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F455C061746
        for <linux-crypto@vger.kernel.org>; Tue,  7 Dec 2021 15:33:14 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id s18-20020a63ff52000000b00320f169c0aaso259149pgk.18
        for <linux-crypto@vger.kernel.org>; Tue, 07 Dec 2021 15:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=S9HhHEaCqq8juujlhIoNSDxxgNKBtqtxQU5YxI2svaw=;
        b=buSpmo6M3pApRVi2NMxwXaGteg1Oc/DvWa79jtkAI+ISl8TMCW35+eMMUUoyoK1QcC
         UNqEVoxRdO14/y7jxx3fFTNE/w03VlqjR5XRmzAjoaOo1cA5i/L16zjXiP1lJetwqWaW
         BaJGKQsoPMOZKtEVCEYj6C2Gvv2q1Qs6kzwiTSzyaSVtSZT5rxfRo3zEFhl0giCg8wCi
         D2tx/VgNUgAiLa+EXrAZltK+ZxoM05XdFIitPQ4pU11Wn46OdyarwbMXktqnTEpQDqWp
         SdUtliVCq5zCL1Ir3WMMMZQFNgz2Q0mLMQYgQur4KZ0oOgPibVDbZaOMEZXg1WxSl9d1
         q7sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=S9HhHEaCqq8juujlhIoNSDxxgNKBtqtxQU5YxI2svaw=;
        b=SeSG0ai5Vzh6JsgltcyqCaAxLOe3XwQQqfiS243NT+cYpMHXQZ/KOmVXgiW1SIwq0b
         ZraLUcD3ak/lsw0Ji15UubQYvSU/7l900geudRsW/hyjpch117moZEVb1y8KFOudyQK5
         CLLCpGaAJiap09qx8KpupJf5rwrdjHBwmzFYmWpoIxBBzQXKo5il4kcB+baKjdCGtwPT
         FfVj7bDjCG0bsZRq3n10m88mOoMGOKaVHA0HJK9i+1DIR8E9+MJZ6MKf2CIIobAvfio7
         TwGx/9LEz4S/RtGnnRfpcjesylIc5Odl7aJihSrEtFAQVYqFU0HnqqKwx1MxJrzHXygK
         tnzQ==
X-Gm-Message-State: AOAM533CDP5e8kUJq/ekF+YKL7cm+0WNTWosNoMbWHOpCzpm5cgp4qga
        TwQZln5A/LqEuW6lWAGi5U/qhRvLSAw=
X-Google-Smtp-Source: ABdhPJzik9hif76tFQLVlE/NgW3Vi0SZTTbgEMWcCDandafb499HCVkP0qAqheDHdbNZvEjUyQek2sCGZOI=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:46ed:9c47:8229:475d])
 (user=pgonda job=sendgmr) by 2002:a17:902:c20d:b0:142:21e:b1e8 with SMTP id
 13-20020a170902c20d00b00142021eb1e8mr54167478pll.27.1638919994074; Tue, 07
 Dec 2021 15:33:14 -0800 (PST)
Date:   Tue,  7 Dec 2021 15:33:02 -0800
In-Reply-To: <20211207233306.2200118-1-pgonda@google.com>
Message-Id: <20211207233306.2200118-2-pgonda@google.com>
Mime-Version: 1.0
References: <20211207233306.2200118-1-pgonda@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH V6 1/5] crypto: ccp - Add SEV_INIT rc error logging on init
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

Currently only the firmware error code is printed. This is incomplete
and also incorrect as error cases exists where the firmware is never
called and therefore does not set an error code.

Signed-off-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
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
 drivers/crypto/ccp/sev-dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index e09925d86bf3..f527e5f9ed1f 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1104,7 +1104,8 @@ void sev_pci_init(void)
 	}
 
 	if (rc) {
-		dev_err(sev->dev, "SEV: failed to INIT error %#x\n", error);
+		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
+			error, rc);
 		return;
 	}
 
-- 
2.34.1.400.ga245620fadb-goog

