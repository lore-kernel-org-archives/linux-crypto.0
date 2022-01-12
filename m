Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C523C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jan 2022 14:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353851AbiALOCp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jan 2022 09:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242108AbiALOCo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jan 2022 09:02:44 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46E7C06173F
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jan 2022 06:02:44 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id s127so3475086oig.2
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jan 2022 06:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RaVClApmtGgpRlYnM5kQpmqztW/pi5heVD5J5MFzplI=;
        b=flO9fP2R8WxzaJ5Kz5uUQGdJ9lkgnZI5KNf9FiEeiTBfnzdk6169QVXGSlisfb8gyE
         N0Ru1BKCEDNAC6E6h5Y0sy32K7KeuC2QXpRFJikJm0/m8W5cKZpl6oqLaeLmP9gqxNB4
         GmViploQHdPwmEpbtTplhUqlbMCfSxLi6ZM6s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=RaVClApmtGgpRlYnM5kQpmqztW/pi5heVD5J5MFzplI=;
        b=hT6PjUoaeuvrsaGnKLJt+3hvsJyT1vNbYSigG9rBfQGof/2IVQ/KD3Ja4ZO2uIOluB
         PFFWKk/c5L8Mw8ooiHOP8wqIJtlybXABrBqpb2feoW4BGzRxekPNxQ6+kL0oAksfQYuV
         CYkjCHOOsAyE62BLLeWc6nIDa8QC9fNr+HQ9c7HR384V8fYO4WfE3gu6oPJiYoxrQf/W
         IEV6U8iZrPn+Vans5V0+1vnV+5L1tkf4dwQc7iRNejv7sxoxYqUweM0mK7DYYWlU//g9
         VPYf9Mwih6r92SqvcZiT/m5kRhXXF8jPvqJggPOeo5QKWxR9eqsokbFpqJj7nkMkLOhC
         Azog==
X-Gm-Message-State: AOAM533z+WZmhkA/A/eUE7w32CJRXoyhYWigceSzuoFutRDgm1OGFKd5
        jgIipNw4YnuQBrkPHa3VddMpVA7BnpO3vYRS
X-Google-Smtp-Source: ABdhPJx9rhiB6CInae9e3Xbxkk8u46Hp4Mlkg0iMTBYFaUSEbWc9CaA9aF/soaurH+X6eataEsYC9g==
X-Received: by 2002:a05:6808:208e:: with SMTP id s14mr5356378oiw.170.1641996163942;
        Wed, 12 Jan 2022 06:02:43 -0800 (PST)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id x11sm2532015oot.20.2022.01.12.06.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 06:02:43 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
From:   "Justin M. Forbes" <jforbes@fedoraproject.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     jmforbes@linuxtx.org,
        "Justin M. Forbes" <jforbes@fedoraproject.org>
Subject: [PATCH v2] lib/crypto: add prompts back to crypto libraries
Date:   Wed, 12 Jan 2022 08:01:38 -0600
Message-Id: <20220112140137.728162-1-jforbes@fedoraproject.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Commit 6048fdcc5f269 ("lib/crypto: blake2s: include as built-in") took
away a number of prompt texts from other crypto libraries. This makes
values flip from built-in to module when oldconfig runs, and causes
problems when these crypto libs need to be built in for thingslike
BIG_KEYS.

Fixes: 6048fdcc5f269 ("lib/crypto: blake2s: include as built-in")
Signed-off-by: Justin M. Forbes <jforbes@fedoraproject.org>
---
 lib/crypto/Kconfig | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 8620f38e117c..179041b60294 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0

+menu "Crypto library routines"
+
 config CRYPTO_LIB_AES
 	tristate

@@ -40,7 +42,7 @@ config CRYPTO_LIB_CHACHA_GENERIC
 	  of CRYPTO_LIB_CHACHA.

 config CRYPTO_LIB_CHACHA
-	tristate
+	tristate "ChaCha library interface"
 	depends on CRYPTO_ARCH_HAVE_LIB_CHACHA || !CRYPTO_ARCH_HAVE_LIB_CHACHA
 	select CRYPTO_LIB_CHACHA_GENERIC if CRYPTO_ARCH_HAVE_LIB_CHACHA=n
 	help
@@ -65,7 +67,7 @@ config CRYPTO_LIB_CURVE25519_GENERIC
 	  of CRYPTO_LIB_CURVE25519.

 config CRYPTO_LIB_CURVE25519
-	tristate
+	tristate "Curve25519 scalar multiplication library"
 	depends on CRYPTO_ARCH_HAVE_LIB_CURVE25519 || !CRYPTO_ARCH_HAVE_LIB_CURVE25519
 	select CRYPTO_LIB_CURVE25519_GENERIC if CRYPTO_ARCH_HAVE_LIB_CURVE25519=n
 	help
@@ -100,7 +102,7 @@ config CRYPTO_LIB_POLY1305_GENERIC
 	  of CRYPTO_LIB_POLY1305.

 config CRYPTO_LIB_POLY1305
-	tristate
+	tristate "Poly1305 library interface"
 	depends on CRYPTO_ARCH_HAVE_LIB_POLY1305 || !CRYPTO_ARCH_HAVE_LIB_POLY1305
 	select CRYPTO_LIB_POLY1305_GENERIC if CRYPTO_ARCH_HAVE_LIB_POLY1305=n
 	help
@@ -109,7 +111,7 @@ config CRYPTO_LIB_POLY1305
 	  is available and enabled.

 config CRYPTO_LIB_CHACHA20POLY1305
-	tristate
+	tristate "ChaCha20-Poly1305 AEAD support (8-byte nonce library version)"
 	depends on CRYPTO_ARCH_HAVE_LIB_CHACHA || !CRYPTO_ARCH_HAVE_LIB_CHACHA
 	depends on CRYPTO_ARCH_HAVE_LIB_POLY1305 || !CRYPTO_ARCH_HAVE_LIB_POLY1305
 	select CRYPTO_LIB_CHACHA
@@ -120,3 +122,5 @@ config CRYPTO_LIB_SHA256

 config CRYPTO_LIB_SM4
 	tristate
+
+endmenu
-- 
2.34.1

