Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C189C433DB
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 21:57:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D200620799
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 21:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbhABV5E (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Jan 2021 16:57:04 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:37232 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726667AbhABV5D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Jan 2021 16:57:03 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kvosk-0000Q0-TS; Sun, 03 Jan 2021 08:56:20 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sun, 03 Jan 2021 08:56:18 +1100
Date:   Sun, 3 Jan 2021 08:56:18 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Daniel Axtens <dja@axtens.net>, nayna@linux.ibm.com,
        pfsmorigo@gmail.com
Subject: crypto: vmx - Move extern declarations into header file
Message-ID: <20210102215618.GA4493@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch moves the extern algorithm declarations into a header
file so that a number of compiler warnings are silenced.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/vmx/aesp8-ppc.h b/drivers/crypto/vmx/aesp8-ppc.h
index 01774a4d26a2..5764d4438388 100644
--- a/drivers/crypto/vmx/aesp8-ppc.h
+++ b/drivers/crypto/vmx/aesp8-ppc.h
@@ -7,6 +7,12 @@ struct aes_key {
 	int rounds;
 };
 
+extern struct shash_alg p8_ghash_alg;
+extern struct crypto_alg p8_aes_alg;
+extern struct skcipher_alg p8_aes_cbc_alg;
+extern struct skcipher_alg p8_aes_ctr_alg;
+extern struct skcipher_alg p8_aes_xts_alg;
+
 int aes_p8_set_encrypt_key(const u8 *userKey, const int bits,
 			   struct aes_key *key);
 int aes_p8_set_decrypt_key(const u8 *userKey, const int bits,
diff --git a/drivers/crypto/vmx/vmx.c b/drivers/crypto/vmx/vmx.c
index 87a194455d6a..a40d08e75fc0 100644
--- a/drivers/crypto/vmx/vmx.c
+++ b/drivers/crypto/vmx/vmx.c
@@ -17,11 +17,7 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 
-extern struct shash_alg p8_ghash_alg;
-extern struct crypto_alg p8_aes_alg;
-extern struct skcipher_alg p8_aes_cbc_alg;
-extern struct skcipher_alg p8_aes_ctr_alg;
-extern struct skcipher_alg p8_aes_xts_alg;
+#include "aesp8-ppc.h"
 
 static int __init p8_init(void)
 {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
