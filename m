Return-Path: <SRS0=q4N3=V5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9644C41514
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Aug 2019 02:11:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 916CA20693
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Aug 2019 02:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfHACLr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 22:11:47 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:43240 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbfHACLr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 22:11:47 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ht0Z6-0001dL-KY; Thu, 01 Aug 2019 12:11:36 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ht0Z3-0000Of-W1; Thu, 01 Aug 2019 12:11:33 +1000
Date:   Thu, 1 Aug 2019 12:11:33 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] asm-generic: Remove redundant arch-specific rules for simd.h
Message-ID: <20190801021133.GA1428@gondor.apana.org.au>
References: <20190801115346.77439e35@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801115346.77439e35@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 01, 2019 at 11:53:46AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the crypto tree, today's linux-next build (arm
> multi_v7_defconfig) produced this warning:
> 
> scripts/Makefile.asm-generic:25: redundant generic-y found in arch/arm/include/asm/Kbuild: simd.h
> 
> Introduced by commit
> 
>   82cb54856874 ("asm-generic: make simd.h a mandatory include/asm header")
> 
> Also the powerpc ppc64_defconfig build produced this warning:
> 
> scripts/Makefile.asm-generic:25: redundant generic-y found in arch/powerpc/include/asm/Kbuild: simd.h

Thanks for the heads up Stephen.  This patch should fix the
warnings.

---8<---
Now that simd.h is in include/asm-generic/Kbuild we don't need
the arch-specific Kbuild rules for them.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 82cb54856874 ("asm-generic: make simd.h a mandatory...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
index 6b2dc15..68ca86f 100644
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -17,7 +17,6 @@ generic-y += parport.h
 generic-y += preempt.h
 generic-y += seccomp.h
 generic-y += serial.h
-generic-y += simd.h
 generic-y += trace_clock.h
 
 generated-y += mach-types.h
diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
index 9a1d2fc..64870c7 100644
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -11,4 +11,3 @@ generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += vtime.h
 generic-y += msi.h
-generic-y += simd.h
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
