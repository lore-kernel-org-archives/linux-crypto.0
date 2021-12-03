Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A33C4332F
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Dec 2021 14:47:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381596AbhLCOu0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Dec 2021 09:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381543AbhLCOuP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Dec 2021 09:50:15 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02841C061D7F
        for <linux-crypto@vger.kernel.org>; Fri,  3 Dec 2021 06:46:47 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id a3-20020a92c543000000b0029e6ba13881so2215156ilj.11
        for <linux-crypto@vger.kernel.org>; Fri, 03 Dec 2021 06:46:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=M8UHuMWhVxZJQGMzAZkZEJ9WyBjgWEVLzNxFlStluyE=;
        b=nFoFaOsZAw3z9Qh28b30bjPpE4ncomVVRcGjmmBXWrcIkjpWys13Juk7JixUepVnFn
         rLM426UOIje40G98phoDtkIvqWuJ1wBRIm82NpWYtXKbrf5Rl11fajHoKY4xLl0JHeCe
         EhTgU2K6w14frgDYWJPc1gFj7ILWlz3ZJ6P0J7iSMYAsBXfPg9MXUD4C4Y/ctqm6KGQq
         lh58fqg+rOZvSYf2D9q6v5kHQgo03X0jeXZMEt9rgJBXkZtlkP0dYSGdze2PO8uMWSB5
         LVHVnjTzRjXQ2+lFa4dfrx2So9QNCF1BhEIJ2FFDA/1Z3zGLSD9U8Rn8GdUlZ4oDlv/l
         9Gdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=M8UHuMWhVxZJQGMzAZkZEJ9WyBjgWEVLzNxFlStluyE=;
        b=NL01PAq/MZtQ3gL26hD5jIGnfNLemj4g7vZJk+YuyLZj5pQX7xb7noxn7yDkBjvoS6
         0Z5j7Z82nGFmkHpzO43bB2Xicwx3YsxEv14+8vj8aMoXgS2NsRM/Y/gKjmAezqA/v+G+
         lNKrcNuaelNlgvtGWTLQIFxPqz1VlVePW+vL8gkerZ+ir8VQpgpukJ/sz1BxxDmovQpk
         da9W62XM08TrcXJAf1JTKYxq7kPa69HDNLfC3C2mHntAmWpeRcgWlrYSN419CyZyNm3O
         NFIprq0RkEh1WXPjZH0OHyAhBVIT1HCFoZ7HyBsUmX81LbUY7I/XYeko/WrZcFLc0OXh
         IWcQ==
X-Gm-Message-State: AOAM530aEWUoJKH0ytzil0GIqhlZxdaK2ZP6oNWPk4ZwdNl8xiecb+1R
        Ctu+f5pz4RgXmqk5bwpiCnwuJZVsnAQ=
X-Google-Smtp-Source: ABdhPJzg737bzNUVNy4xTAOGNkc7lNZQuRhKSPEosH93uOND9gdMzK5vqgX1yxw54sF8iPHnDXShThKvkfk=
X-Received: from pgonda2.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:ac9])
 (user=pgonda job=sendgmr) by 2002:a05:6638:148b:: with SMTP id
 j11mr24140032jak.114.1638542806335; Fri, 03 Dec 2021 06:46:46 -0800 (PST)
Date:   Fri,  3 Dec 2021 14:46:39 +0000
In-Reply-To: <20211203144642.3460447-1-pgonda@google.com>
Message-Id: <20211203144642.3460447-3-pgonda@google.com>
Mime-Version: 1.0
References: <20211203144642.3460447-1-pgonda@google.com>
X-Mailer: git-send-email 2.34.0.384.gca35af8252-goog
Subject: [PATCH V5 2/5] crypto: ccp - Move SEV_INIT retry for corrupted data
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

Move the data corrupted retry of SEV_INIT into the
__sev_platform_init_locked() function. This is for upcoming INIT_EX
support as well as helping direct callers of
__sev_platform_init_locked() which currently do not support the
retry.

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
 drivers/crypto/ccp/sev-dev.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index f527e5f9ed1f..ef7e8b4c6e02 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -241,7 +241,7 @@ static int __sev_platform_init_locked(int *error)
 	struct psp_device *psp = psp_master;
 	struct sev_data_init data;
 	struct sev_device *sev;
-	int rc = 0;
+	int psp_ret, rc = 0;
 
 	if (!psp || !psp->sev_data)
 		return -ENODEV;
@@ -266,7 +266,21 @@ static int __sev_platform_init_locked(int *error)
 		data.tmr_len = SEV_ES_TMR_SIZE;
 	}
 
-	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
+	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, &psp_ret);
+	if (rc && psp_ret == SEV_RET_SECURE_DATA_INVALID) {
+		/*
+		 * Initialization command returned an integrity check failure
+		 * status code, meaning that firmware load and validation of SEV
+		 * related persistent data has failed. Retrying the
+		 * initialization function should succeed by replacing the state
+		 * with a reset state.
+		 */
+		dev_dbg(sev->dev, "SEV: retrying INIT command");
+		rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, &psp_ret);
+	}
+	if (error)
+		*error = psp_ret;
+
 	if (rc)
 		return rc;
 
@@ -1091,18 +1105,6 @@ void sev_pci_init(void)
 
 	/* Initialize the platform */
 	rc = sev_platform_init(&error);
-	if (rc && (error == SEV_RET_SECURE_DATA_INVALID)) {
-		/*
-		 * INIT command returned an integrity check failure
-		 * status code, meaning that firmware load and
-		 * validation of SEV related persistent data has
-		 * failed and persistent state has been erased.
-		 * Retrying INIT command here should succeed.
-		 */
-		dev_dbg(sev->dev, "SEV: retrying INIT command");
-		rc = sev_platform_init(&error);
-	}
-
 	if (rc) {
 		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
 			error, rc);
-- 
2.34.0.384.gca35af8252-goog

