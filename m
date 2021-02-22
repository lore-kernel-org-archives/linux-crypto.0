Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8609BC433E9
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Feb 2021 23:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5750A64E5B
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Feb 2021 23:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhBVX07 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Feb 2021 18:26:59 -0500
Received: from 0x0c.xyz ([5.39.113.142]:51422 "EHLO mail.0x0c.xyz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230224AbhBVX0r (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Feb 2021 18:26:47 -0500
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Feb 2021 18:26:46 EST
Received: from localhost (unknown [10.10.0.4])
        by mail.0x0c.xyz (Postfix) with ESMTPSA id 9014A44CBD;
        Tue, 23 Feb 2021 00:18:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=0x0c.xyz; s=mail;
        t=1614035892; bh=qWcNFWHsgbM09aRmQEQDnsStnYE2utBnd+uAwJAf1Vc=;
        h=Date:From:To:Cc:Subject:From;
        b=IQNUkY36qCG7ga57/+AXlZBis1XYRSqs+SzoMj8qZgv5Z4z6reGAtP/oeU02AIlyM
         KZHSwrT+9weCcepdiVAAhN9t06tu8XcE0zRTWyPXkskDzeCXOZtDujbv0IQ6Px+xdO
         aaGA1r2Nycb2fbPNx/o6Dv5QfeHhHytcr6+rHeKaIkFLnvnNLpnr+vi2Kdcst9FtaF
         49S3NkP5lF372Jp5UHQNtbwb/lMy+Usk6yyK03kd0rGJXRgNnpfsPF90396cbUOI2L
         U6WPB2iEX12IZibRTZ72S6DXsho59gPHbE1qPas0AY2L+oYNIDB2JbOoCA1CkWdtGX
         IydbBe7gJLjiQ==
Date:   Tue, 23 Feb 2021 01:18:11 +0200
From:   dm9pZCAq <v@0x0c.xyz>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] crypto: jitterentropy: Add automatically deoptimization.
Message-ID: <20210222230023.eflhc5ktynpqy7uy@gentoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is needed to compile with `CFLAGS_KERNEL=-O2`.

Due to `CFLAGS_jitterentropy.o = -O0` comes after `CFLAGS_KERNEL`
the code is still optimized and gives an error.
This patch deoptimizes the code despite any `CFLAGS`.

Signed-off-by: dm9pZCAq <v@0x0c.xyz>
---
 crypto/jitterentropy.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index 6e147c43fc18..7d84bc10626f 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -50,7 +50,14 @@
  * version 2.2.0 provided at https://www.chronox.de/jent.html
  */
 
-#ifdef __OPTIMIZE__
+
+#ifdef __clang__
+ #pragma clang optimize off
+#else
+ #pragma GCC optimize ("O0")
+#endif
+
+#if !defined(__clang__) && defined(__OPTIMIZE__)
  #error "The CPU Jitter random number generator must not be compiled with optimizations. See documentation. Use the compiler switch -O0 for compiling jitterentropy.c."
 #endif
 
-- 
2.30.1

