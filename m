Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6728C63798
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 16:23:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 627F6221EB
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 16:23:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L3+pgOLL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731325AbgK0QXy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Nov 2020 11:23:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43260 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731209AbgK0QXy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Nov 2020 11:23:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606494233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=kTDF9XwgDcDsIbA1FWIWTR8j2rLY64TEJoSITNKSTYU=;
        b=L3+pgOLLTEsWGXbnrW/+iJxGjhc9fJHvUtoceuLlqkO2IynEDR2CtMSPurvD2ieOWDG8II
        gBu3aE1gh4fjTzFrjXIn6nJZiToSXeKFa2ZBnO8Bx2cXQWjjyZyn0dsPwYhEZrbVg5KgDz
        WMB2pwdTyU8iDmUQfKhjju/koRtBk/Y=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-BhPQ29sSP_iyKfyf3bDzUA-1; Fri, 27 Nov 2020 11:23:51 -0500
X-MC-Unique: BhPQ29sSP_iyKfyf3bDzUA-1
Received: by mail-qk1-f199.google.com with SMTP id c71so3970361qkg.21
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2020 08:23:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kTDF9XwgDcDsIbA1FWIWTR8j2rLY64TEJoSITNKSTYU=;
        b=YqGKr8/bgOmAF38a4BgokPI0X6puKlJ5rDN6a283kGqGLU1hoeHRFoGdwakqgJ+Xdw
         jz/dlSAjQc8JjAQuZfOW0DHdqHQOGPITF+t1GjnpbH38iiet64GW42ZbdcC8WSpLZd0S
         6Bspnmq3NMudBuXEYQQDgy1uKWo8KcrGxCVJBVH+Z41uBsAbBTFbAJccUWeyH1CGu8/l
         SEwl7VRT+XvGFaD7z7kbEHXWjfvm/a3nWUNKDv6flsG+gmMLNHW6+RQy/2CGKfiH+J5A
         azhuWblkyiBuwQlkUgGUbTztjqOQYxeG/kBD9z3FQh2z7Dg/xJ174mevvJCI/8ex5Mn9
         S0Pw==
X-Gm-Message-State: AOAM530WrdJhtBDaAQs1xYu2Mpt48kLsCayaILVHt1Dk/Gi47wi5psQz
        ukxIRE98Kio8N8X5OYI1VfH8ICbwMPQjO7Oo7+On7ajZqghtBwJcdL3LYA8b+9nizYawBQ9guEJ
        oGRKBrqRN3YLiiQXpIvc5S7pc
X-Received: by 2002:a37:a402:: with SMTP id n2mr9161510qke.131.1606494230945;
        Fri, 27 Nov 2020 08:23:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz0/csaobGZgvBTKF0C6I2w6quYFvr2gOO6F07wHiLj1lNz/WU0GUl9mHzKxBJ4sogYMaq5NQ==
X-Received: by 2002:a37:a402:: with SMTP id n2mr9161495qke.131.1606494230782;
        Fri, 27 Nov 2020 08:23:50 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id t126sm6183533qkh.133.2020.11.27.08.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 08:23:50 -0800 (PST)
From:   trix@redhat.com
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] crypto: remove trailing semicolon in macro definition
Date:   Fri, 27 Nov 2020 08:23:45 -0800
Message-Id: <20201127162345.2653351-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tom Rix <trix@redhat.com>

The macro use will already have a semicolon.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 crypto/seed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/seed.c b/crypto/seed.c
index 5e3bef3a617d..27720140820e 100644
--- a/crypto/seed.c
+++ b/crypto/seed.c
@@ -322,7 +322,7 @@ static const u32 KC[SEED_NUM_KCONSTANTS] = {
 		SS2[byte(t1, 2)] ^ SS3[byte(t1, 3)];	\
 	t0 += t1;					\
 	X1 ^= t0;					\
-	X2 ^= t1;
+	X2 ^= t1
 
 static int seed_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		        unsigned int key_len)
-- 
2.18.4

