Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE02C433FE
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Dec 2021 14:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352610AbhLCOuT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Dec 2021 09:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381600AbhLCOuK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Dec 2021 09:50:10 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1317DC061D7E
        for <linux-crypto@vger.kernel.org>; Fri,  3 Dec 2021 06:46:46 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id m127-20020a6b3f85000000b005f045ba51f9so2474340ioa.4
        for <linux-crypto@vger.kernel.org>; Fri, 03 Dec 2021 06:46:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=n9U31kqgJhRjTrQuE7/WsUbjvo3IuvChEsgfsakfCtM=;
        b=rd8pvcG1vzx/DDDuvYSdtXAbva5Itbs/PnhB2WR1urv/bO8ZPp1DXeuDB3jbK7bmyf
         75UG+udWEFJy8HARO2Hsjt7/V3HgxUa5q1tD2eb8FUez3UnZ16pl+I/xkf7mtyqUuOWt
         StHChCjRJ3LEGPKWX2cyCvF60W7tn6tWuesxf6QVhunXkJ+oNLShrPBUJEpKRu7ZjJY8
         oCWpUPIlDcJhu/dtw1NSeEGwFwHripXIlJChpleBS6lUg4pa7uYJjaJDZzyrOGgCZBjt
         1mLvnBInioIoe2BKwg2LFcr+6Su5RMkhn5riAysWBEMbCplY2a2MUSLSZuLL3uTQqeEa
         LEMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=n9U31kqgJhRjTrQuE7/WsUbjvo3IuvChEsgfsakfCtM=;
        b=s90mTWcNfn4jPnuNgTA/Y5cXGdtnrOD9dBiJoLBE21Ilg+PtX8Hf1rZL6qIQLQk8hL
         A9MMqWDKNc2mT5HardSDjbR+CEozcKopOHHVMagk2axnFrtd9FVIzVzAPrnMxsVAtlzQ
         /AS/lSAHHiB+4x1uSEzvW87UmDU34oSOPBDUwPL5A7z2IGsKQzLrEGbYpTpXfbeBC014
         cMvc/Ip3mRnv8dTEnK74f6A953DZKemuxLqOUBpEJNW8vV+5Y5hSO4chMLWAC0aC4bRA
         12172fHyPzvlxiXCS8y/+EKz+NJJh0oK95MvX6EJz5uCZ8vUczrfQGExvT/ujghLV8do
         G22A==
X-Gm-Message-State: AOAM533oH53msdNbo+tTChm9fLf/txtUCAI+yqTsC+ynnTA8DCy4iGOh
        42FrZeio1k45d19j0Tj3JMzpa7lvxt8=
X-Google-Smtp-Source: ABdhPJzrzQYwNY4O2vuTS5sr2ZpqPQQ+UCFOGbe72sin34/pwiPQ5VQ0RpEhgLuzb96y4borqsRF0Z6nWwI=
X-Received: from pgonda2.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:ac9])
 (user=pgonda job=sendgmr) by 2002:a6b:700e:: with SMTP id l14mr20659616ioc.20.1638542805449;
 Fri, 03 Dec 2021 06:46:45 -0800 (PST)
Date:   Fri,  3 Dec 2021 14:46:38 +0000
In-Reply-To: <20211203144642.3460447-1-pgonda@google.com>
Message-Id: <20211203144642.3460447-2-pgonda@google.com>
Mime-Version: 1.0
References: <20211203144642.3460447-1-pgonda@google.com>
X-Mailer: git-send-email 2.34.0.384.gca35af8252-goog
Subject: [PATCH V5 1/5] crypto: ccp - Add SEV_INIT rc error logging on init
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
2.34.0.384.gca35af8252-goog

