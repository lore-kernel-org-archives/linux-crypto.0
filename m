Return-Path: <SRS0=HcMk=Y6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F141C5DF66
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 14:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21AAF21929
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 14:14:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Lt8NSkic"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731906AbfKFOOB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Nov 2019 09:14:01 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36016 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731918AbfKFONk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Nov 2019 09:13:40 -0500
Received: by mail-wr1-f66.google.com with SMTP id w18so26005339wrt.3
        for <linux-crypto@vger.kernel.org>; Wed, 06 Nov 2019 06:13:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LOCSV59QoWVHACgzHE/U/CUT/RhU8DoyNGp2OnfJ+HA=;
        b=Lt8NSkicjrMViO5Eg4iicjQ9Um4Q/kPhTekzALb+HzNHfhDBmznekCXpWfFCqxbPf1
         XOZbS8K2jooY/Eh/31ehUIBaypEbhpyPqh9lub2S0lbmj/O81IwFa7dqMAQj6ppnMr97
         h/sNucOFsQ1bw9fFy47CCesF+0lx7lCCx4pM7OMgkxiGq6zqQ0YuondQvtGoWarNmqPF
         O03RynY9JHqQ9r3dfWX6s/Iy4zuK/kFgiBT3QXKGHNPYenHtppO+8gHzQKodjZWngOGF
         /2dp4+1OO0PAUlrW0CXW7rSAK8WFPvwHkNyb3WEsqOlkKLv3LtcOVNpqbcfmzzDC32/P
         I53w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LOCSV59QoWVHACgzHE/U/CUT/RhU8DoyNGp2OnfJ+HA=;
        b=pN3h9M/RvITGGwYCvzuA+9oZVyEFnRbi1sdnPHHM1uvQvCpFlZZ0xfskLXUWmqbZuS
         Mpc1HntfKBwXwVVpY72idl8e2/AaA2Xe8O1uknFQrynnzXtOqjwjmsQPM2uWGfCJTbbb
         k557fFIn9D15qS/mubXLtwNKWgDiiMOUfD4MjhEplY8EJU3nUvDXWoLQvur1bgTIooh+
         9Y4kvGu5NTdW7oziRpk1PLCMnlFoAzJCY2xZsPP+Mqzb++zNxWpMGH118Jb6+UZWXG/V
         h2Lx8bOitrW+9+f/vKtgOOnlVkPr0SyovJOcpTBFRT9ZuFgCI00UN3Dbte02+pudIX0d
         lppg==
X-Gm-Message-State: APjAAAURaqck7HzapyIHvjlxgE2a5UnLPol0PFEMvYoCYuSiEEym+arh
        MUjtZjU3xYkE3yUv4fxbRc4d6w50Ux9KQg==
X-Google-Smtp-Source: APXvYqzK5FGfZx+mRuVsrOtGAG1CMADIYVflqnomqokFyeKkGb54YgnosWkS0ihW4ENT9j5fGGhC4g==
X-Received: by 2002:a5d:4885:: with SMTP id g5mr3106213wrq.287.1573049612495;
        Wed, 06 Nov 2019 06:13:32 -0800 (PST)
Received: from localhost.localdomain (31.red-176-87-122.dynamicip.rima-tde.net. [176.87.122.31])
        by smtp.gmail.com with ESMTPSA id b3sm2837556wma.13.2019.11.06.06.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 06:13:32 -0800 (PST)
From:   Richard Henderson <richard.henderson@linaro.org>
X-Google-Original-From: Richard Henderson <rth@twiddle.net>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, linux-arch@vger.kernel.org,
        x86@kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 06/10] linux/random.h: Mark CONFIG_ARCH_RANDOM functions __must_check
Date:   Wed,  6 Nov 2019 15:13:04 +0100
Message-Id: <20191106141308.30535-7-rth@twiddle.net>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191106141308.30535-1-rth@twiddle.net>
References: <20191106141308.30535-1-rth@twiddle.net>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We must not use the pointer output without validating the
success of the random read.

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 include/linux/random.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/random.h b/include/linux/random.h
index ea0e2f5f1ec5..d319f9a1e429 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -167,19 +167,19 @@ static inline void prandom_seed_state(struct rnd_state *state, u64 seed)
 #ifdef CONFIG_ARCH_RANDOM
 # include <asm/archrandom.h>
 #else
-static inline bool arch_get_random_long(unsigned long *v)
+static inline bool __must_check arch_get_random_long(unsigned long *v)
 {
 	return false;
 }
-static inline bool arch_get_random_int(unsigned int *v)
+static inline bool __must_check arch_get_random_int(unsigned int *v)
 {
 	return false;
 }
-static inline bool arch_get_random_seed_long(unsigned long *v)
+static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
 {
 	return false;
 }
-static inline bool arch_get_random_seed_int(unsigned int *v)
+static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
 {
 	return false;
 }
-- 
2.17.1

