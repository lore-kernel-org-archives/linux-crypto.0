Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D7F3C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Apr 2022 15:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbiDMQBE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Apr 2022 12:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235138AbiDMQBE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Apr 2022 12:01:04 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17546579C
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 08:58:40 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id p4-20020a631e44000000b00399598a48c5so1330481pgm.1
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 08:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=esOVAp2irCJ3Vjv6n3zKptfZxPr7nea31riVyn8IwzA=;
        b=mugdlaJfqV6BzoMRpaiK5wVOC89SQxXWIv/7SA2IWoQeqGxtkOVO5e99zdgZO6ByHl
         waiSJsfhCL8jqtYwCQ+fct8ZE+R7hsIX7mDJG3xCepYJfGzVjAF17sRtKceMz1Ke6++B
         jjzcxRMODxHIXlk+civmhu5EkMlEGgmhhDBQ39UBF8bdxHZTihLRAEhZ+kFHYq7ZqRFj
         BGZxnU/CjHVMuSNUZ+YeDA5zl9m/A0BEuNgfjkFNb5KPtaZ10l4OfZXEfO2hotQy1l2A
         LmoeViJzWmwIYiPEioHmqUIQ/ZkrOXZayOBr74hv0PSB3twNNCLdMtbml7MOTKkjjJjB
         KcuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=esOVAp2irCJ3Vjv6n3zKptfZxPr7nea31riVyn8IwzA=;
        b=BHFmYRi+fIUsCg3ENhHFUzeXfsB5wgDsQaJKpngKhyVai0D/KauIOEqOxtXKcsdVPO
         rrzLVpRjZpbjWHTBcDXUN9LxUc1i4mg8nf5NPUa+9F4gOI1VsdWRwC6vWXZN2Z8J7yI6
         wLXteSxFBTvFaJvQSLLtxxJuAfzOlJxy1ZwPmSBJwJSO2wyPIZ10YpqM+z2cSwCx4lol
         Ta1/FtAAEt496FNTZIVLBHVsqVT4f6EMoEG9suKutvSyKn8IWJB7AuVKuOYLvgFYMbLF
         eCD7b26avL22bEo2eUgfgN3iwXmJYASjm3QaEkWA25L+WLMRmhNura22sIr24YjdqaMC
         NsqA==
X-Gm-Message-State: AOAM5325QY64p/xvg9KrJceruMvP+6f8pW2shZ3Qr8Ve+yOjTlrRwwRo
        zZA1HqbUo7tl0IaaHGvH7qSrjOmYMQjrHqdAofbClmO0WkAPOoiLj2Ukzr53ZAdbbAaE177S6cy
        SeOw10wRAcGLqRwtJoPZE93SyvR/k4p48T+642i2d2/VZh6shDaB7wJ+4YgwmaeE3sWyFpw==
X-Google-Smtp-Source: ABdhPJxIsFvYT4ZGMIA9rMTLc6Euk99wC0DXG4Y79LtsWB+wAou+COvDqA1Unv9b4P15r7HklQzyIXoFiTI=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:9bb6:f53:456a:fd2d])
 (user=pgonda job=sendgmr) by 2002:a17:90b:2384:b0:1cb:5223:9dc4 with SMTP id
 mr4-20020a17090b238400b001cb52239dc4mr58307pjb.1.1649865519822; Wed, 13 Apr
 2022 08:58:39 -0700 (PDT)
Date:   Wed, 13 Apr 2022 08:58:35 -0700
Message-Id: <20220413155835.439785-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH] crypto: ccp - Log when resetting PSP SEV state
From:   Peter Gonda <pgonda@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        David Rientjes <rientjes@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently when the PSP returns a SECURE_DATA_INVALID error on INIT or
INIT_EX the driver retries the command once which should reset the PSP's
state SEV related state, meaning the PSP will regenerate its keying
material. This is logged with a dbg log but given this will change
system state this should be logged at a higher priority and with more
information.

Signed-off-by: Peter Gonda <pgonda@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: John Allen <john.allen@amd.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/ccp/sev-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 6ab93dfd478a..fd928199bf1e 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -435,7 +435,7 @@ static int __sev_platform_init_locked(int *error)
 		 * initialization function should succeed by replacing the state
 		 * with a reset state.
 		 */
-		dev_dbg(sev->dev, "SEV: retrying INIT command");
+		dev_err(sev->dev, "SEV: retrying INIT command because of SECURE_DATA_INVALID error. Retrying once to reset PSP SEV state.");
 		rc = init_function(&psp_ret);
 	}
 	if (error)
-- 
2.35.1.1178.g4f1659d476-goog

