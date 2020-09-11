Return-Path: <SRS0=Quof=CU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3CA7C43461
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Sep 2020 15:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 893B321D47
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Sep 2020 15:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599839833;
	bh=rGbqf9/+lTR20/q7Oy//dTrBqkiYio6GueIG0oElcGY=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=mCIggqN9vAptSYGNnH1gqU5Ey8nhSOz/lgEnjhYwu6iwe3/0T8eCO9grWR3IvQHjp
	 cpKf5LRSqxt2MwPwV7cWHjQIx3bCSjXjnuxWzZ/Yk30TNCNv2veIjUzpmkc5jeNZ15
	 t9BlDKGMsSqTPHtz2VHzZNsLchKXxkgUjgz2gGZA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgIKP5J (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Sep 2020 11:57:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726228AbgIKPza (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Sep 2020 11:55:30 -0400
Received: from e123331-lin.nice.arm.com (unknown [91.140.123.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0F0322269;
        Fri, 11 Sep 2020 14:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599833496;
        bh=rGbqf9/+lTR20/q7Oy//dTrBqkiYio6GueIG0oElcGY=;
        h=From:To:Cc:Subject:Date:From;
        b=ZQdAe5klBavXVdVmWwUvddVN51f4YmXyaQ7YmDxBa77Lv/tQ7xOLKuh4zvdnA3p1I
         L/KyvkhfWZWwQ5BQNqR73F58lI2+xeCeWldaj3GbZFDFDYpvzVbGVzt26G/cyOC+kt
         AjRT4MdCnfLVdA0hRXI5PmMl9GeZubBWGt5KaPjY=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: mark unused ciphers as obsolete
Date:   Fri, 11 Sep 2020 17:11:03 +0300
Message-Id: <20200911141103.14832-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We have a few interesting pieces in our cipher museum, which are never
used internally, and were only ever provided as generic C implementations.

Unfortunately, we cannot simply remove this code, as we cannot be sure
that it is not being used via the AF_ALG socket API, however unlikely.

So let's mark the Anubis, Khazad, SEED and TEA algorithms as obsolete,
which means they can only be enabled in the build if the socket API is
enabled in the first place.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
Hopefully, I will be able to convince the distro kernel maintainers to
disable CRYPTO_USER_API_ENABLE_OBSOLETE in their v5.10+ builds once the
iwd changes for arc4 make it downstream (Debian already has an updated
version in its unstable distro). With the joint coverage of their QA,
we should be able to confirm that these algos are never used, and
actually remove them altogether.

 crypto/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index e85d8a059489..fac10143d23f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1185,6 +1185,7 @@ config CRYPTO_AES_PPC_SPE
 
 config CRYPTO_ANUBIS
 	tristate "Anubis cipher algorithm"
+	depends on CRYPTO_USER_API_ENABLE_OBSOLETE
 	select CRYPTO_ALGAPI
 	help
 	  Anubis cipher algorithm.
@@ -1424,6 +1425,7 @@ config CRYPTO_FCRYPT
 
 config CRYPTO_KHAZAD
 	tristate "Khazad cipher algorithm"
+	depends on CRYPTO_USER_API_ENABLE_OBSOLETE
 	select CRYPTO_ALGAPI
 	help
 	  Khazad cipher algorithm.
@@ -1487,6 +1489,7 @@ config CRYPTO_CHACHA_MIPS
 
 config CRYPTO_SEED
 	tristate "SEED cipher algorithm"
+	depends on CRYPTO_USER_API_ENABLE_OBSOLETE
 	select CRYPTO_ALGAPI
 	help
 	  SEED cipher algorithm (RFC4269).
@@ -1613,6 +1616,7 @@ config CRYPTO_SM4
 
 config CRYPTO_TEA
 	tristate "TEA, XTEA and XETA cipher algorithms"
+	depends on CRYPTO_USER_API_ENABLE_OBSOLETE
 	select CRYPTO_ALGAPI
 	help
 	  TEA cipher algorithm.
-- 
2.17.1

