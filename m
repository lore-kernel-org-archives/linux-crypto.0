Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EB6BC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Jan 2022 21:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343857AbiAJVSn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Jan 2022 16:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343856AbiAJVSn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jan 2022 16:18:43 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6DBC06173F
        for <linux-crypto@vger.kernel.org>; Mon, 10 Jan 2022 13:18:43 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id c12-20020a17090a558c00b001b364b735efso9496081pji.6
        for <linux-crypto@vger.kernel.org>; Mon, 10 Jan 2022 13:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=7XDHIQkhsAFmNz1F7Z7Ne/ZIuNNWSEpngowKx7s8JYs=;
        b=nUk9kjwMdR6qRzfl3wzfyUkxYmuly83tWgqFOJw1pLxvoQ7hKuYQrOXBdfRkY14d5H
         6gwaZjRcQlBg1RFdGkHEyliqLcbmeDadjLud6TZ3darksPzY2a6AWhuIBCXKgBg0/dgf
         kXxZcKHxe7YYXGjm6tmKomEupSCE6PoTt2Mozk3sQvBzsreBa1ja+6vgEqy5L0fK3fw9
         t9So7qgOFY+Y/T6cdzspDLjgdHagb9AjDSfMPEy/up45WVbyJqzwRfLNfN80UNlE8oAh
         toS2BUm84IfuM/oIzCyURBHMnXJPJkxuPth0/qDkHG+1INxNuE1UbE7qSKEkmA2F5x2O
         Yd/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=7XDHIQkhsAFmNz1F7Z7Ne/ZIuNNWSEpngowKx7s8JYs=;
        b=37WJcI29Iy8qxvRNc1ED/nd39wrO7p5yxyvohjpLM8Deedc6s40zhnceO4uhdiamxk
         puCFSPAuJveNRIJ/fVl9782SLTddYisuxynwY6ACsfwSxmfDdaOb/kfNpemw/tN8LOhz
         q4dADeZUddd1sz37wH18RxKAb7vvl5hdJloSAWWw6YVsnQ6avgf2ar7IgSpr7pFR6aT2
         Rj76NF+5GTn1ZjdvsXT4FVHIDCmPUxXqpK9UIqjGu4auAbNp4oV6ij0rht6n4tF2mcpp
         qtqCKJuBNpYE7Mu/FGOpz/8y1JjPwc5W6Rr95pQVfe6CA1BXJMGLpgHQ2pZd/rZL0R15
         V+9A==
X-Gm-Message-State: AOAM5335yjWkGp9Kd8bNA/4RNB9RM632fMnTN1asvPJqGWD7wDnsi5/5
        vF/TbDOWkp5HJSxKjYpqZyX+J+Vpr2k=
X-Google-Smtp-Source: ABdhPJxbSopsi0gXi+ocn3Abe3Eflcm38jSOAXrIUMpZRH0GunsY706DD7saQA4+IIYI8telNGDfhpjl/vo=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:4f78:6ed1:42d2:b0a7])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:22d2:b0:4bb:721:7337 with SMTP id
 f18-20020a056a0022d200b004bb07217337mr1418074pfj.76.1641849522551; Mon, 10
 Jan 2022 13:18:42 -0800 (PST)
Date:   Mon, 10 Jan 2022 13:18:37 -0800
Message-Id: <20220110211837.1442964-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [PATCH] crypto: ccp - Ensure psp_ret is always init'd in __sev_platform_init_locked()
From:   Peter Gonda <pgonda@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Marc Orr <marcorr@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Initialize psp_ret inside of __sev_platform_init_locked() because there
are many failure paths with PSP initialization that do not set
__sev_do_cmd_locked().

Fixes: e423b9d75e77: ("crypto: ccp - Move SEV_INIT retry for corrupted data")

Signed-off-by: Peter Gonda <pgonda@google.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: John Allen <john.allen@amd.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/ccp/sev-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 8fd774a10edc..6ab93dfd478a 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -413,7 +413,7 @@ static int __sev_platform_init_locked(int *error)
 {
 	struct psp_device *psp = psp_master;
 	struct sev_device *sev;
-	int rc, psp_ret;
+	int rc, psp_ret = -1;
 	int (*init_function)(int *error);
 
 	if (!psp || !psp->sev_data)
-- 
2.34.1.575.g55b058a8bb-goog

