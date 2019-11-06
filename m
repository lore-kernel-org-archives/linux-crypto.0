Return-Path: <SRS0=HcMk=Y6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C991C5DF68
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 14:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C6B92173E
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 14:14:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="e5nNk39V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731911AbfKFOOB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Nov 2019 09:14:01 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55491 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731922AbfKFONl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Nov 2019 09:13:41 -0500
Received: by mail-wm1-f68.google.com with SMTP id b11so678438wmb.5
        for <linux-crypto@vger.kernel.org>; Wed, 06 Nov 2019 06:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EtW7c5+Vxuw361NPgarxEa4pkxF91xrS2XEr4qnN4jI=;
        b=e5nNk39VJ5IOgRqdcXf58JkLAmLsag2O4+U458JjYo5P0PSEMekSFRL7LZc2d3m3VJ
         URQyFUvE8jMn4eVvMtPS4S4bwU+o51HOhtfgwYme4dhoLAOHd8OHl1q5buqF/oxhumhw
         +z3jc1g7Ck1yBgoUiT30MrVfaQcI9SAZcV6//J2C/MjC41OM02IYNasElc3UDquPybqb
         baWyh7WRSDEfEhipTjcqjxsGo/IM/qSUCmUCE5UrGsB4dj0txgaPvPHy4E6e/8b6xTks
         +7wsbS1O4VTbwJoSISfsP2WPk3MvEuhRHnX4Tq6FkCgrC9KgWh7M7bDPmgQZAuRo+xGE
         Q0vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EtW7c5+Vxuw361NPgarxEa4pkxF91xrS2XEr4qnN4jI=;
        b=qQ/givsx4rWI/O/LzWuJMThUdRXVKIb3d0w92T9jOHmABoSwhjAeELejhmZSpLdBus
         wA8ylk4B5Zd2Z/IwuwmSl3JgvpqTxzHjmgLiCLmKnWjHmNtKA0T+6kSwwbMO+syNnPRA
         2fnh82stszzLR6Nnww4hlNCC09C6LNHmYjWQXZ2A1ySbr3zKC4onPxTNllBiIfvi8Wbf
         sZB4FhPLSn3aY1mKmDmB1tK2UNHuu0QLk/6SmNMwTo6wRiNzmnwR2x6D075PNmH7Xxel
         PUASLzVbE5oUtWB1r8b0aa6AlTxhSNX/4IjzFoW1/ZHQeKWInBqOoltFT4UN2GJLj2O0
         qhUQ==
X-Gm-Message-State: APjAAAXUCnBI9YJ/AXokXPE8h2Uf1ma2on1d4td4teRXwpXSZ/zkIvJx
        CqFI3wpP8UzESrJpnGkJ7ObDp5FAUQD5Yw==
X-Google-Smtp-Source: APXvYqwQkS3HkPb4xqO71j4GDBQsJDOPu6hiWKUGgF3l2gy8AO8EiMAAlXbkknCw6t0pwT+ISh1RMQ==
X-Received: by 2002:a7b:c776:: with SMTP id x22mr2609658wmk.144.1573049619319;
        Wed, 06 Nov 2019 06:13:39 -0800 (PST)
Received: from localhost.localdomain (31.red-176-87-122.dynamicip.rima-tde.net. [176.87.122.31])
        by smtp.gmail.com with ESMTPSA id b3sm2837556wma.13.2019.11.06.06.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 06:13:38 -0800 (PST)
From:   Richard Henderson <richard.henderson@linaro.org>
X-Google-Original-From: Richard Henderson <rth@twiddle.net>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, linux-arch@vger.kernel.org,
        x86@kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 10/10] s390x: Mark archrandom.h functions __must_check
Date:   Wed,  6 Nov 2019 15:13:08 +0100
Message-Id: <20191106141308.30535-11-rth@twiddle.net>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191106141308.30535-1-rth@twiddle.net>
References: <20191106141308.30535-1-rth@twiddle.net>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We must not use the pointer output without validating the
success of the random read.

Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/s390/include/asm/archrandom.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/archrandom.h b/arch/s390/include/asm/archrandom.h
index 9a6835137a16..de61ce562052 100644
--- a/arch/s390/include/asm/archrandom.h
+++ b/arch/s390/include/asm/archrandom.h
@@ -21,17 +21,17 @@ extern atomic64_t s390_arch_random_counter;
 
 bool s390_arch_random_generate(u8 *buf, unsigned int nbytes);
 
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
 	if (static_branch_likely(&s390_arch_random_available)) {
 		return s390_arch_random_generate((u8 *)v, sizeof(*v));
@@ -39,7 +39,7 @@ static inline bool arch_get_random_seed_long(unsigned long *v)
 	return false;
 }
 
-static inline bool arch_get_random_seed_int(unsigned int *v)
+static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
 {
 	if (static_branch_likely(&s390_arch_random_available)) {
 		return s390_arch_random_generate((u8 *)v, sizeof(*v));
-- 
2.17.1

