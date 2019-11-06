Return-Path: <SRS0=HcMk=Y6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0930EC47E49
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 14:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0F4C21882
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 14:14:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jlbxIkKe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731804AbfKFOOA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Nov 2019 09:14:00 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53162 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbfKFONa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Nov 2019 09:13:30 -0500
Received: by mail-wm1-f67.google.com with SMTP id c17so3609543wmk.2
        for <linux-crypto@vger.kernel.org>; Wed, 06 Nov 2019 06:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Bz6tm/Oq0JWNumhKoQOUWz+Q8JBAOdsIYOzjRyK0W9o=;
        b=jlbxIkKeL3Kg9sDbtCvzA0n80dNlWQeuKrHjCLy6JkLv+44YWN0XV/6Ri5hrDJmKx7
         RMw4nFFVFEbc3Y43ASQyDevRbQ1KafjwpXr/+E2NcnKi61gvBNO4T5/CoC/aVOJm1lF8
         afbdpOMvBrB1PiyE7mIkTCZmfFEppYlBRLE9bG4/7knt6uyuQCtc6yz3OfqEd7nJhW4y
         GaY42uHnvI3nskibfGwiI5um1+tf3nhRZnrxGC/x4jUZBdRvl7Ux9op1d4aYxNqMN6Yy
         Ugk6EsBMx1LG9OwSj5B/GAIoV5iSi0eBnC1ZNGpu0dDycG59m6by5s72ZnVqiH3P+Yu/
         polQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Bz6tm/Oq0JWNumhKoQOUWz+Q8JBAOdsIYOzjRyK0W9o=;
        b=WiJ5TaRWxMCYUZXyTrE2+v1Cs847FFT/N9eeNj0nQglEySYMay8A3pjmO0WTmkBD9j
         N5vkHjRVodXycbyuDhAtazK/8sz3Qc4WdcCYncYunYDTF0V+bx7x7+bUmHv4hq4EvZjz
         vCst3oaW+3mL9jcXXtc7kvtsaEYZcNseXbeeyEw9gQyrNT02685N9FFwIkCzizPDdqdW
         FhkP46FdJWevfEZxqXcRl0uwGabfI3ZhCZcLOvdtbNFeC2fizHTxTpbOUYPVf/pa1tiD
         YGt/oaxn6Y4CQ/gLyakz3N39zcgc9ZihdJ0S/+We2uA0zOL2qmzZHBkTIjnjd7KGxed/
         XHhQ==
X-Gm-Message-State: APjAAAWSP8wtGQlEEVBJgv3CpVSkKg7TfsE9hEPxdJyGap6mNfDArtNv
        uE5gmRUd/eFTYceALZf0LHCEkg1OFLHPsg==
X-Google-Smtp-Source: APXvYqx0JMbMKxvkK6MwbV+885ST1BoFA+6H9mqlYYb0WUFjcxzb2zWqAt5vUgOEk43WSZGg8BgArw==
X-Received: by 2002:a05:600c:28c:: with SMTP id 12mr2652459wmk.25.1573049607535;
        Wed, 06 Nov 2019 06:13:27 -0800 (PST)
Received: from localhost.localdomain (31.red-176-87-122.dynamicip.rima-tde.net. [176.87.122.31])
        by smtp.gmail.com with ESMTPSA id b3sm2837556wma.13.2019.11.06.06.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 06:13:27 -0800 (PST)
From:   Richard Henderson <richard.henderson@linaro.org>
X-Google-Original-From: Richard Henderson <rth@twiddle.net>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, linux-arch@vger.kernel.org,
        x86@kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 03/10] s390: Remove arch_has_random, arch_has_random_seed
Date:   Wed,  6 Nov 2019 15:13:01 +0100
Message-Id: <20191106141308.30535-4-rth@twiddle.net>
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
 arch/s390/include/asm/archrandom.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/s390/include/asm/archrandom.h b/arch/s390/include/asm/archrandom.h
index c67b82dfa558..9a6835137a16 100644
--- a/arch/s390/include/asm/archrandom.h
+++ b/arch/s390/include/asm/archrandom.h
@@ -21,18 +21,6 @@ extern atomic64_t s390_arch_random_counter;
 
 bool s390_arch_random_generate(u8 *buf, unsigned int nbytes);
 
-static inline bool arch_has_random(void)
-{
-	return false;
-}
-
-static inline bool arch_has_random_seed(void)
-{
-	if (static_branch_likely(&s390_arch_random_available))
-		return true;
-	return false;
-}
-
 static inline bool arch_get_random_long(unsigned long *v)
 {
 	return false;
-- 
2.17.1

