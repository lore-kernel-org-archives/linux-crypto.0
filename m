Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9F2C433EF
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Dec 2021 16:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236103AbhLSQZn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Dec 2021 11:25:43 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.24]:35880 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233228AbhLSQZn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Dec 2021 11:25:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1639931134;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=QsOgwlfe2+DsZQr1xQaXNwe815T+l2m3Sbqn7B/xn7c=;
    b=BoXCux8+n3oOA9j7Md4HsE+D5mGgl1E/4xSc1gcHQGG7FBOnuK8e7xPgCzbE7ac+jW
    R8lPEhkN207ozDN7cuRxaFuiVx68puxxP6fSVlZrTuqFPSNYSrNeiRhNYofqo46uW2oD
    ZyKovcN+vnWSoHn72Pd8vWVyd97MW5wpnJog7edV8iyYy0qtsCHsJ5uPSdjqLFeaWUxE
    n/DGwK4klZg/AlSFntoJ4nFgwanyrTqTIL3CTXA3q5TBcrqhQdLrkvyW1GsBnR5Pjt12
    4o6RVgaciCFkhPjJGROi0/u+sEp685WS++7oyt8hp9lvxyxndM+J5YlsvWfHcTN05y69
    3A7g==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZI/SWzl0="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.35.3 DYNA|AUTH)
    with ESMTPSA id h03d91xBJGPXNN6
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 19 Dec 2021 17:25:33 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, simo@redhat.com, skozina@redhat.com,
        Nicolai Stange <nstange@suse.de>
Subject: [PATCH v2] crypto: jitter - add oversampling of noise source
Date:   Sun, 19 Dec 2021 17:25:32 +0100
Message-ID: <4712718.vXUDI8C0e8@positron.chronox.de>
In-Reply-To: <2573346.vuYhMxLoTh@positron.chronox.de>
References: <2573346.vuYhMxLoTh@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The output n bits can receive more than n bits of min entropy, of course,
but the fixed output of the conditioning function can only asymptotically
approach the output size bits of min entropy, not attain that bound.
Random maps will tend to have output collisions, which reduces the
creditable output entropy (that is what SP 800-90B Section 3.1.5.1.2
attempts to bound).

The value "64" is justified in Appendix A.4 of the current 90C draft,
and aligns with NIST's in "epsilon" definition in this document, which is
that a string can be considered "full entropy" if you can bound the min
entropy in each bit of output to at least 1-epsilon, where epsilon is
required to be <= 2^(-32).

Note, this patch causes the Jitter RNG to cut its performance in half in
FIPS mode because the conditioning function of the LFSR produces 64 bits
of entropy in one block. The oversampling requires that additionally 64
bits of entropy are sampled from the noise source. If the conditioner is
changed, such as using SHA-256, the impact of the oversampling is only
one fourth, because for the 256 bit block of the conditioner, only 64
additional bits from the noise source must be sampled.

This patch is derived from the user space jitterentropy-library.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
Reviewed-by: Simo Sorce <simo@redhat.com>
---
 crypto/jitterentropy.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index 8f5283f28ed3..7d6de0a29ab8 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -117,6 +117,22 @@ struct rand_data {
 #define JENT_EHEALTH		9 /* Health test failed during initialization */
 #define JENT_ERCT		10 /* RCT failed during initialization */
 
+/*
+ * The output n bits can receive more than n bits of min entropy, of course,
+ * but the fixed output of the conditioning function can only asymptotically
+ * approach the output size bits of min entropy, not attain that bound. Random
+ * maps will tend to have output collisions, which reduces the creditable
+ * output entropy (that is what SP 800-90B Section 3.1.5.1.2 attempts to bound).
+ *
+ * The value "64" is justified in Appendix A.4 of the current 90C draft,
+ * and aligns with NIST's in "epsilon" definition in this document, which is
+ * that a string can be considered "full entropy" if you can bound the min
+ * entropy in each bit of output to at least 1-epsilon, where epsilon is
+ * required to be <= 2^(-32).
+ */
+#define JENT_ENTROPY_SAFETY_FACTOR	64
+
+#include "linux/fips.h"
 #include "jitterentropy.h"
 
 /***************************************************************************
@@ -542,7 +558,10 @@ static int jent_measure_jitter(struct rand_data *ec)
  */
 static void jent_gen_entropy(struct rand_data *ec)
 {
-	unsigned int k = 0;
+	unsigned int k = 0, safety_factor = 0;
+
+	if (fips_enabled)
+		safety_factor = JENT_ENTROPY_SAFETY_FACTOR;
 
 	/* priming of the ->prev_time value */
 	jent_measure_jitter(ec);
@@ -556,7 +575,7 @@ static void jent_gen_entropy(struct rand_data *ec)
 		 * We multiply the loop value with ->osr to obtain the
 		 * oversampling rate requested by the caller
 		 */
-		if (++k >= (DATA_SIZE_BITS * ec->osr))
+		if (++k >= ((DATA_SIZE_BITS + safety_factor) * ec->osr))
 			break;
 	}
 }
-- 
2.33.1




