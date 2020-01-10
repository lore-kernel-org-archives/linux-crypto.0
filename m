Return-Path: <SRS0=JhzL=27=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69522C282DD
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 14:54:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 374F520721
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 14:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578668094;
	bh=NnO8LD80BLQ6NMe8Vcq34YRLsH8jn+4NOHXtIyTJHKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=eHSCVP3Tem+1ic96unczO44K5Bjdh1y4LKlBbGXot7mZVXt6a2R4pUnTykKAT0m2u
	 3w12nbBfkKDewsdOArHumcClY0OlPeQCF5xe4CTyv8zUoRU5s9pw1ND1b4tuCs3pL1
	 8pUoITVDjbczP6tZwkPuRzHG/g8S58419vs8V0yI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgAJOyu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jan 2020 09:54:50 -0500
Received: from foss.arm.com ([217.140.110.172]:45952 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728381AbgAJOyr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jan 2020 09:54:47 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2B5271063;
        Fri, 10 Jan 2020 06:54:47 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A9E913F6C4;
        Fri, 10 Jan 2020 06:54:46 -0800 (PST)
From:   Mark Brown <broonie@kernel.org>
To:     linux-arch@vger.kernel.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Borislav Petkov <bp@alien8.de>, linux-s390@vger.kernel.org,
        herbert@gondor.apana.org.au, x86@kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Richard Henderson <rth@twiddle.net>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 09/10] powerpc: Mark archrandom.h functions __must_check
Date:   Fri, 10 Jan 2020 14:54:21 +0000
Message-Id: <20200110145422.49141-10-broonie@kernel.org>
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

We must not use the pointer output without validating the
success of the random read.

Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Richard Henderson <rth@twiddle.net>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/powerpc/include/asm/archrandom.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/archrandom.h b/arch/powerpc/include/asm/archrandom.h
index f0f16b4fc5ea..9a53e29680f4 100644
--- a/arch/powerpc/include/asm/archrandom.h
+++ b/arch/powerpc/include/asm/archrandom.h
@@ -6,17 +6,17 @@
 
 #include <asm/machdep.h>
 
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
 	if (ppc_md.get_random_seed)
 		return ppc_md.get_random_seed(v);
@@ -24,7 +24,7 @@ static inline bool arch_get_random_seed_long(unsigned long *v)
 	return false;
 }
 
-static inline bool arch_get_random_seed_int(unsigned int *v)
+static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
 {
 	unsigned long val;
 	bool rc;
-- 
2.20.1

