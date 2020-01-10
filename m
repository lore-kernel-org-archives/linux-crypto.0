Return-Path: <SRS0=JhzL=27=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C027BC282DD
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 14:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E7302072E
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 14:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578668077;
	bh=ViOktEQfPeyL9ULZ7ZNFDRBnZeCYxoWxar371Wbv7Rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=zyUwFjVzDwNMyADfLO1UHpEbz28CygpVqnMOEctMUzcfYyVfPNGuzpwCnXT83dDIP
	 M+vt8VaVKdW1AmrUBSCYhOmOpJTasqvM3CgJN2E7g9kgL3oTyRBijTQC67ns+a+D3l
	 HzCn1TBTi2I/Bz/OksWH2gdsBm+eMDOjQC4hD1Ro=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgAJOyg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jan 2020 09:54:36 -0500
Received: from foss.arm.com ([217.140.110.172]:45844 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728239AbgAJOyg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jan 2020 09:54:36 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 36B5930E;
        Fri, 10 Jan 2020 06:54:36 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B58393F6C4;
        Fri, 10 Jan 2020 06:54:35 -0800 (PST)
From:   Mark Brown <broonie@kernel.org>
To:     linux-arch@vger.kernel.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Borislav Petkov <bp@alien8.de>, linux-s390@vger.kernel.org,
        herbert@gondor.apana.org.au, x86@kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Richard Henderson <rth@twiddle.net>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 04/10] linux/random.h: Remove arch_has_random, arch_has_random_seed
Date:   Fri, 10 Jan 2020 14:54:16 +0000
Message-Id: <20200110145422.49141-5-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200110145422.49141-1-broonie@kernel.org>
References: <20200110145422.49141-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Richard Henderson <richard.henderson@linaro.org>

The arm64 version of archrandom.h will need to be able to test for
support and read the random number without preemption, so a separate
query predicate is not practical.

Since this part of the generic interface is unused, remove it.

Signed-off-by: Richard Henderson <rth@twiddle.net>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 include/linux/random.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/include/linux/random.h b/include/linux/random.h
index f189c927fdea..7fd0360908d2 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -175,10 +175,6 @@ static inline bool arch_get_random_int(unsigned int *v)
 {
 	return 0;
 }
-static inline bool arch_has_random(void)
-{
-	return 0;
-}
 static inline bool arch_get_random_seed_long(unsigned long *v)
 {
 	return 0;
@@ -187,10 +183,6 @@ static inline bool arch_get_random_seed_int(unsigned int *v)
 {
 	return 0;
 }
-static inline bool arch_has_random_seed(void)
-{
-	return 0;
-}
 #endif
 
 /* Pseudo random number generator from numerical recipes. */
-- 
2.20.1

