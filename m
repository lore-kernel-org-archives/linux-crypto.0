Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF4FFC47088
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Dec 2022 04:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbiLEEcF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 4 Dec 2022 23:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbiLEEcD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Dec 2022 23:32:03 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8046812622;
        Sun,  4 Dec 2022 20:32:02 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1p238q-003w68-I8; Mon, 05 Dec 2022 12:31:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 05 Dec 2022 12:31:44 +0800
Date:   Mon, 5 Dec 2022 12:31:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Linux Crypto List <linux-crypto@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        PowerPC <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: [PATCH] crypto: api - Use linux/cache.h instead of asm/cache.h
Message-ID: <Y410MAxoqND62k1r@gondor.apana.org.au>
References: <20221205104857.2dab1586@canb.auug.org.au>
 <20221205105225.502d2278@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205105225.502d2278@canb.auug.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 05, 2022 at 10:52:25AM +1100, Stephen Rothwell wrote:
>
> Or maybe you should have included linux/cache.h instead of asm/cache.h?

You're right Stephen.  Thanks!

---8<---
Directly including asm/cache.h leads to build failures on powerpc
so replace it with linux/cache.h instead.

Fixes: e634ac4a8aaa ("crypto: api - Add crypto_tfm_ctx_dma")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 8722fd67f40a..61b327206b55 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -7,8 +7,8 @@
 #ifndef _CRYPTO_ALGAPI_H
 #define _CRYPTO_ALGAPI_H
 
-#include <asm/cache.h>
 #include <linux/align.h>
+#include <linux/cache.h>
 #include <linux/crypto.h>
 #include <linux/kconfig.h>
 #include <linux/list.h>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
