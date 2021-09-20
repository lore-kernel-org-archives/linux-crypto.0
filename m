Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F1BC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Sep 2021 10:06:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26A7760F9B
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Sep 2021 10:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhITKHZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Sep 2021 06:07:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231182AbhITKHW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Sep 2021 06:07:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FF5760F5D;
        Mon, 20 Sep 2021 10:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632132356;
        bh=mEIhB5gFO41gQ3sUmqJQlg/kWWUDHL4ECHOeQmvQpg8=;
        h=From:To:Cc:Subject:Date:From;
        b=TWh7aaNP0ht/JZhEtvnli9sWjRSesj7JtMP1fhpkq/Ox6LbM8AIvwD3rMhYAdffZx
         DflCXf/CEy6LwylZWp8KNf1t21ESsN1wyu9afVi1xJXkb1y2R3+eXuRvGd2GqnprTC
         IAVp/G8ruQXI2gryAgv4TFgr3cwi3z8ZKMfJAiV1+Gv9fG91wT2WGUmKZ+i4+9DGet
         RluQGa6j62yzuh21hSnmars9IXYDzPZwP/HGPji3w7pSl1wi7JnOA7/1hvCc5gEn5R
         hCZA3EPTg4tULLUH/gVasPIZBSqNsEGhqVTTMLga+ZaZDcfhvTW3hB5+M84RRhw/G4
         0p8mQnqU74Juw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Vitaly Chikunov <vt@altlinux.org>,
        Stefan Berger <stefanb@linux.ibm.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ecc: fix CRYPTO_DEFAULT_RNG dependency
Date:   Mon, 20 Sep 2021 12:05:35 +0200
Message-Id: <20210920100551.1568868-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The ecc.c file started out as part of the ECDH algorithm but got
moved out into a standalone module later. It does not build without
CRYPTO_DEFAULT_RNG, so now that other modules are using it as well we
can run into this link error:

aarch64-linux-ld: ecc.c:(.text+0xfc8): undefined reference to `crypto_default_rng'
aarch64-linux-ld: ecc.c:(.text+0xff4): undefined reference to `crypto_put_default_rng'

Move the 'select CRYPTO_DEFAULT_RNG' statement into the correct symbol.

Fixes: 0d7a78643f69 ("crypto: ecrdsa - add EC-RDSA (GOST 34.10) algorithm")
Fixes: 4e6602916bc6 ("crypto: ecdsa - Add support for ECDSA signature verification")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 536df4b6b825..285f82647d2b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -233,12 +233,12 @@ config CRYPTO_DH
 
 config CRYPTO_ECC
 	tristate
+	select CRYPTO_RNG_DEFAULT
 
 config CRYPTO_ECDH
 	tristate "ECDH algorithm"
 	select CRYPTO_ECC
 	select CRYPTO_KPP
-	select CRYPTO_RNG_DEFAULT
 	help
 	  Generic implementation of the ECDH algorithm
 
-- 
2.29.2

