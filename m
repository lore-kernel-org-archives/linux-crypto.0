Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 287CBE776F0
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Oct 2023 03:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbjJCDcE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Oct 2023 23:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjJCDcD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Oct 2023 23:32:03 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BC99D
        for <linux-crypto@vger.kernel.org>; Mon,  2 Oct 2023 20:31:57 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qnW8V-002wK2-QN; Tue, 03 Oct 2023 11:31:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Oct 2023 11:31:55 +0800
Date:   Tue, 3 Oct 2023 11:31:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: skcipher - Add dependency on ecb
Message-ID: <ZRuLK6SIuq9qYqpB@gondor.apana.org.au>
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
 <20230914082828.895403-9-herbert@gondor.apana.org.au>
 <20231002202522.GA4130583@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231002202522.GA4130583@dev-arch.thelio-3990X>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 02, 2023 at 01:25:22PM -0700, Nathan Chancellor wrote:
>
> I am noticing a failure to get to user space when booting OpenSUSE's
> armv7hl configuration [1] in QEMU after this change as commit
> 705b52fef3c7 ("crypto: cbc - Convert from skcipher to lskcipher"). I can
> reproduce it with GCC 13.2.0 from kernel.org [2] and QEMU 8.1.1, in case
> either of those versions matter.  The rootfs is available at [3] in case
> it is relevant.

Thanks for the report.  This is caused by a missing dependency
on ECB.  Please try this patch:

---8<---
As lskcipher requires the ecb wrapper for the transition add an
explicit dependency on it so that it is always present.  This can
be removed once all simple ciphers have been converted to lskcipher.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Fixes: 705b52fef3c7 ("crypto: cbc - Convert from skcipher to lskcipher")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/Kconfig b/crypto/Kconfig
index ed931ddea644..bbf51d55724e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -85,6 +85,7 @@ config CRYPTO_SKCIPHER
 	tristate
 	select CRYPTO_SKCIPHER2
 	select CRYPTO_ALGAPI
+	select CRYPTO_ECB
 
 config CRYPTO_SKCIPHER2
 	tristate
@@ -689,7 +690,7 @@ config CRYPTO_CTS
 
 config CRYPTO_ECB
 	tristate "ECB (Electronic Codebook)"
-	select CRYPTO_SKCIPHER
+	select CRYPTO_SKCIPHER2
 	select CRYPTO_MANAGER
 	help
 	  ECB (Electronic Codebook) mode (NIST SP800-38A)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
