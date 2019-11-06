Return-Path: <SRS0=HcMk=Y6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA737C5DF64
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 14:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBCB52173E
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 14:13:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="huUR3QVI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbfKFON0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Nov 2019 09:13:26 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45016 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727616AbfKFON0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Nov 2019 09:13:26 -0500
Received: by mail-wr1-f66.google.com with SMTP id f2so17072998wrs.11
        for <linux-crypto@vger.kernel.org>; Wed, 06 Nov 2019 06:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=leR1246hJ3phHrVVcpyVvX9EN15YsfZYkjubgOlomC8=;
        b=huUR3QVIlM/iMH0usGmIB9OiEcCLZqXcp97YwEo5S55jvpui/qZdGTCJbFI62dX4/j
         2W64NWcBKbPpYtkVVdo/cO1Jt92q8rAf5ACvD4PU71NfcDy1YwoV8btWGC4x7jK7xBZH
         4pgY90Y5biZu7ryNMqgndRgyVybVzvi6p61/yXwqnS60DGsgWKw/oS56vnc+2wljX/IS
         jjo7CDxwHqosEN+WVtvNt9GxrZEEeNlAO6la4IXeWWkEZQG8RuRmPzPChqiiwmD03fka
         KBkfelHAHCWA/mSrfKOHrqlItLLBFxLHUluhYQUZBpOvPwIkowMuH0Ftl02VvxcVd/Z3
         ixaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=leR1246hJ3phHrVVcpyVvX9EN15YsfZYkjubgOlomC8=;
        b=KQizo1xGjlI4roHrPdf2LTgnCUTNT4S5HyYsC7gEEsLjnaZAqlV1+nTxJm0BKxY3uk
         PzPh9xbyt7moCrrGWTNxdYksEqShWG7/jiGpYAN8zSCr6+sS02mwiOSnSeyJ/g37BirI
         PFMNfS3Vmi4XZ9CtZpQ0Bl3T02u2qPhZ684SMLWgns56QcHrpu6GxhrjRcEd0lsTcBA7
         CPW2DNka2m85GdsdqQlBX6fYbjU3rhS5yNwqtgCpMs1mN2Gw6P2j/g0pkRYDBL2eBp5X
         NsxJNdLcJRa1ZgQ43mD4VIKiB7iDhjJlJG5W119sURraeh4nHCK9yPbNqn3wEzUOUaVg
         IF9w==
X-Gm-Message-State: APjAAAUmcXESgtOU0XP8kutlzHuJ4UjhM7Ni8F79ojOf1tUUqVPIxzz3
        sIgkaCk68XxrOU9Wy6An/jR0G1Yxb/IXwQ==
X-Google-Smtp-Source: APXvYqzTCPrOAhbnRRsKuw2OzTsArhsUJQHzqkaNltD2nhsBQHhmx9VSsUTnBXDMMqtS237fmG6/dA==
X-Received: by 2002:a5d:4649:: with SMTP id j9mr2973687wrs.248.1573049604042;
        Wed, 06 Nov 2019 06:13:24 -0800 (PST)
Received: from localhost.localdomain (31.red-176-87-122.dynamicip.rima-tde.net. [176.87.122.31])
        by smtp.gmail.com with ESMTPSA id b3sm2837556wma.13.2019.11.06.06.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 06:13:23 -0800 (PST)
From:   Richard Henderson <richard.henderson@linaro.org>
X-Google-Original-From: Richard Henderson <rth@twiddle.net>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, linux-arch@vger.kernel.org,
        x86@kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 01/10] x86: Remove arch_has_random, arch_has_random_seed
Date:   Wed,  6 Nov 2019 15:12:59 +0100
Message-Id: <20191106141308.30535-2-rth@twiddle.net>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191106141308.30535-1-rth@twiddle.net>
References: <20191106141308.30535-1-rth@twiddle.net>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the expansion of these macros directly in arch_get_random_*.

These symbols are currently part of the generic archrandom.h
interface, but are currently unused and can be removed.

Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/x86/include/asm/archrandom.h | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/archrandom.h b/arch/x86/include/asm/archrandom.h
index af45e1452f09..feb59461046c 100644
--- a/arch/x86/include/asm/archrandom.h
+++ b/arch/x86/include/asm/archrandom.h
@@ -73,10 +73,6 @@ static inline bool rdseed_int(unsigned int *v)
 	return ok;
 }
 
-/* Conditional execution based on CPU type */
-#define arch_has_random()	static_cpu_has(X86_FEATURE_RDRAND)
-#define arch_has_random_seed()	static_cpu_has(X86_FEATURE_RDSEED)
-
 /*
  * These are the generic interfaces; they must not be declared if the
  * stubs in <linux/random.h> are to be invoked,
@@ -86,22 +82,22 @@ static inline bool rdseed_int(unsigned int *v)
 
 static inline bool arch_get_random_long(unsigned long *v)
 {
-	return arch_has_random() ? rdrand_long(v) : false;
+	return static_cpu_has(X86_FEATURE_RDRAND) ? rdrand_long(v) : false;
 }
 
 static inline bool arch_get_random_int(unsigned int *v)
 {
-	return arch_has_random() ? rdrand_int(v) : false;
+	return static_cpu_has(X86_FEATURE_RDRAND) ? rdrand_int(v) : false;
 }
 
 static inline bool arch_get_random_seed_long(unsigned long *v)
 {
-	return arch_has_random_seed() ? rdseed_long(v) : false;
+	return static_cpu_has(X86_FEATURE_RDSEED) ? rdseed_long(v) : false;
 }
 
 static inline bool arch_get_random_seed_int(unsigned int *v)
 {
-	return arch_has_random_seed() ? rdseed_int(v) : false;
+	return static_cpu_has(X86_FEATURE_RDSEED) ? rdseed_int(v) : false;
 }
 
 extern void x86_init_rdrand(struct cpuinfo_x86 *c);
-- 
2.17.1

