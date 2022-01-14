Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB10C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jan 2022 06:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbiANGkd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jan 2022 01:40:33 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:59498 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232400AbiANGkd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jan 2022 01:40:33 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1n8GGE-0006T6-M5; Fri, 14 Jan 2022 17:40:31 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Jan 2022 17:40:30 +1100
Date:   Fri, 14 Jan 2022 17:40:30 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [v2 PATCH] crypto: testmgr - Move crypto_simd_disabled_for_test out
Message-ID: <YeEa3qCB7b4QzBH9@gondor.apana.org.au>
References: <Yd0jA4VOjysrdOu7@gondor.apana.org.au>
 <Yd36HsgI+ya6P7RF@gmail.com>
 <Yd4nmLgFr8XTxCo6@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd4nmLgFr8XTxCo6@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 12, 2022 at 11:58:00AM +1100, Herbert Xu wrote:
> On Tue, Jan 11, 2022 at 01:43:58PM -0800, Eric Biggers wrote:
> >
> > Maybe CRYPTO_MANAGER_EXTRA_TESTS should select CRYPTO_SIMD?
> 
> You're right.  I was focusing only on the module dependencies
> but neglected to change the Kconfig dependencies.
> 
> I'll fix this in the next version.

---8<---
As testmgr is part of cryptomgr which was designed to be unloadable
as a module, it shouldn't export any symbols for other crypto
modules to use as that would prevent it from being unloaded.  All
its functionality is meant to be accessed through notifiers.

The symbol crypto_simd_disabled_for_test was added to testmgr
which caused it to be pinned as a module if its users were also
loaded.  This patch moves it out of testmgr and into crypto/algapi.c
so cryptomgr can again be unloaded and replaced on demand.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index a366cb3e8aa1..9f15e11f5d73 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -6,6 +6,7 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/internal/simd.h>
 #include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/fips.h>
@@ -21,6 +22,11 @@
 
 static LIST_HEAD(crypto_template_list);
 
+#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
+DEFINE_PER_CPU(bool, crypto_simd_disabled_for_test);
+EXPORT_PER_CPU_SYMBOL_GPL(crypto_simd_disabled_for_test);
+#endif
+
 static inline void crypto_check_module_sig(struct module *mod)
 {
 	if (fips_enabled && mod && !module_sig_ok(mod))
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 5831d4bbc64f..3a5a3e5cb77b 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -55,9 +55,6 @@ MODULE_PARM_DESC(noextratests, "disable expensive crypto self-tests");
 static unsigned int fuzz_iterations = 100;
 module_param(fuzz_iterations, uint, 0644);
 MODULE_PARM_DESC(fuzz_iterations, "number of fuzz test iterations");
-
-DEFINE_PER_CPU(bool, crypto_simd_disabled_for_test);
-EXPORT_PER_CPU_SYMBOL_GPL(crypto_simd_disabled_for_test);
 #endif
 
 #ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
