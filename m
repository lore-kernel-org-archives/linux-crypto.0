From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: simd ciphers
Date: Thu, 29 Dec 2016 17:44:15 +0800
Message-ID: <20161229094415.GA14453@gondor.apana.org.au>
References: <3279008.xAQAe6ukNz@positron.chronox.de>
 <3170771.4e7c0aHuJX@positron.chronox.de>
 <20161228102826.GB12607@gondor.apana.org.au>
 <2449210.sSYcIB5U3R@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58181 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752518AbcL2JoX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Dec 2016 04:44:23 -0500
Content-Disposition: inline
In-Reply-To: <2449210.sSYcIB5U3R@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 28, 2016 at 12:21:52PM +0100, Stephan Müller wrote:
> 
> This patch does not help. But I now found the issue: we need some Kconfig 
> wizardry to mandate pcbc to be compiled statically when AES-NI is static. 
> Currently I had pcbc always as a module even when selecting AES-NI as static 
> compilation.

OK, please test this patch and see if it cures the problem with
aesni built-in and pcbc built as a module.

Thanks,

---8<---
Subject: crypto: aesni - Fix failure when built-in with modular pcbc

If aesni is built-in but pcbc is built as a module, then aesni
will fail completely because when it tries to register the pcbc
variant of aes the pcbc template is not available.

This patch fixes this by modifying the pcbc presence test so that
if aesni is built-in then pcbc must also be built-in for it to be
used by aesni.

Fixes: 85671860caac ("crypto: aesni - Convert to skcipher")
Reported-by: Stephan Müller <smueller@chronox.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 36ca150..7ad0ed7 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1024,7 +1024,8 @@ struct {
 	const char *basename;
 	struct simd_skcipher_alg *simd;
 } aesni_simd_skciphers2[] = {
-#if IS_ENABLED(CONFIG_CRYPTO_PCBC)
+#if (defined(MODULE) && IS_ENABLED(CONFIG_CRYPTO_PCBC)) || \
+    IS_BUILTIN(CONFIG_CRYPTO_PCBC)
 	{
 		.algname	= "pcbc(aes)",
 		.drvname	= "pcbc-aes-aesni",
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
