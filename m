From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: simd ciphers
Date: Wed, 28 Dec 2016 18:28:26 +0800
Message-ID: <20161228102826.GB12607@gondor.apana.org.au>
References: <3279008.xAQAe6ukNz@positron.chronox.de>
 <1497014.RmdRyQUAOo@positron.chronox.de>
 <20161228085938.GA11904@gondor.apana.org.au>
 <3170771.4e7c0aHuJX@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59639 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751219AbcL1K2f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Dec 2016 05:28:35 -0500
Content-Disposition: inline
In-Reply-To: <3170771.4e7c0aHuJX@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 28, 2016 at 11:00:51AM +0100, Stephan Müller wrote:
>
> When I configure AES-NI as module, it works. When compiling it statically, the 
> allocation returns an -ENOENT. 
> 
> Now, when I diff both config files after a simple toggle from AES-NI=y to =m I 
> see (linux-4.10.config contains the static config, .config contains the module 
> configuration):

Thanks Stephan! Does this patch help?

---8<---
Subject: crypto: pcbc - Move pcbc registration up to subsys_initcall

The pcbc template is required by aesni.  As aesni registers itself
at late_initcall, we have to make sure pcbc is registered before
that.

This patch moves it to subsys_initcall like cryptd.

Fixes: 85671860caac ("crypto: aesni - Convert to skcipher")
Reported-by: Stephan Müller <smueller@chronox.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index e4538e0..0855c61 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -307,7 +307,7 @@ static void __exit crypto_pcbc_module_exit(void)
 	crypto_unregister_template(&crypto_pcbc_tmpl);
 }
 
-module_init(crypto_pcbc_module_init);
+subsys_initcall(crypto_pcbc_module_init);
 module_exit(crypto_pcbc_module_exit);
 
 MODULE_LICENSE("GPL");
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
