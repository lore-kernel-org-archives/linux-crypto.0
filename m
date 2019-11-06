Return-Path: <SRS0=HcMk=Y6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24899C5DF64
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 14:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA6DD2178F
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 14:14:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Opt6blMO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731882AbfKFOOA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Nov 2019 09:14:00 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53330 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731804AbfKFON2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Nov 2019 09:13:28 -0500
Received: by mail-wm1-f67.google.com with SMTP id x4so3608809wmi.3
        for <linux-crypto@vger.kernel.org>; Wed, 06 Nov 2019 06:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gp6KNxHNYtmFYMKMCYa0gsOo8NLakQXjLI1+wdZrrFY=;
        b=Opt6blMOd91CMO9Sq9Y5A3q4PwF3GSjNzIXhSluaGOyG+rbDxGLdCQGbPVE5bXKBKZ
         aiLXzj4m6i5ZQoTXpmx5rChqonOJISLaMtdj1+byk7Lr8lPtDs28C0jlPzGHMMtEbZmm
         7dm9d8IvcXzRGMnZAKYMbPIBPY2bDTOk49lIHT4bFr5KqZ5prLSSgXUOv6jUPSLjGUYR
         6DJPE/b5BRZTkL0wI0LsgP3k3jLyGQ9uB69hYUuVFG9xxRxpoVLOxmiRAUjNlawvAFIn
         cXqLhSYYSbeV1YOl+1KwcdK62FIuDKKMLAF0JTvEXftqvOXeMxpVSFsKMNrZ9n/m2c0V
         I1nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gp6KNxHNYtmFYMKMCYa0gsOo8NLakQXjLI1+wdZrrFY=;
        b=KtuKwFFAair/JrSiZegdG3IuOb5H1N+cPz6K7DQB4TZG7D8aXqwIFpv7+OSU+l3R/Z
         tp1+IexHFGcMSYvtEPDOAEufBdRV/hWzwk/zUSd8tNP60BQH7WvQmFB/WPPM1U5noeAT
         kaZ4GM/64w56JJpPF+uNW58qjhMyaTgUkVKmTR8/97hyar4+bI+jDLpT/jXY28/OYA1e
         FgX7yJb1MWES08GQBl7cfMUWglGfivBBwRY4rVSXqB6Z5SbD7UWpvBL38B4ZUeIeQKyn
         kkmdyusCi85desX7OUjCpaOnA7+zL//Z9hlMmHs8tkRH7ETmyGv8VGnA6VXReSBsI+hH
         l55w==
X-Gm-Message-State: APjAAAWMa6cHtvBtV2uM5ljiebPlzcmFNQyhnbfpdmFpG8MW0G0coIdy
        i5GQlefr9ZZdV2PcNFyoU/Zaugpsc4zpzw==
X-Google-Smtp-Source: APXvYqxzkw9+rREvmeedrYS01ECAtNQ4De91+b1ooIUzZfNnnzCG5td8seHkoCoHaz61lQ9u/onNCg==
X-Received: by 2002:a7b:c549:: with SMTP id j9mr2820695wmk.88.1573049605900;
        Wed, 06 Nov 2019 06:13:25 -0800 (PST)
Received: from localhost.localdomain (31.red-176-87-122.dynamicip.rima-tde.net. [176.87.122.31])
        by smtp.gmail.com with ESMTPSA id b3sm2837556wma.13.2019.11.06.06.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 06:13:25 -0800 (PST)
From:   Richard Henderson <richard.henderson@linaro.org>
X-Google-Original-From: Richard Henderson <rth@twiddle.net>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, linux-arch@vger.kernel.org,
        x86@kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 02/10] powerpc: Remove arch_has_random, arch_has_random_seed
Date:   Wed,  6 Nov 2019 15:13:00 +0100
Message-Id: <20191106141308.30535-3-rth@twiddle.net>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191106141308.30535-1-rth@twiddle.net>
References: <20191106141308.30535-1-rth@twiddle.net>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

These symbols are currently part of the generic archrandom.h
interface, but are currently unused and can be removed.

Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/powerpc/include/asm/archrandom.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/powerpc/include/asm/archrandom.h b/arch/powerpc/include/asm/archrandom.h
index 9c63b596e6ce..c2ed3b4681f5 100644
--- a/arch/powerpc/include/asm/archrandom.h
+++ b/arch/powerpc/include/asm/archrandom.h
@@ -34,16 +34,6 @@ static inline int arch_get_random_seed_int(unsigned int *v)
 
 	return rc;
 }
-
-static inline int arch_has_random(void)
-{
-	return 0;
-}
-
-static inline int arch_has_random_seed(void)
-{
-	return !!ppc_md.get_random_seed;
-}
 #endif /* CONFIG_ARCH_RANDOM */
 
 #ifdef CONFIG_PPC_POWERNV
-- 
2.17.1

