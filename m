From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: 4.10 aesni-intel no longer having lrw/ablk_helper dependencies?
Date: Wed, 1 Feb 2017 22:17:39 +0800
Message-ID: <20170201141739.GD32415@gondor.apana.org.au>
References: <201701292231.59656.a.miskiewicz@gmail.com>
 <20170129234632.GA5253@zzz>
 <201701301742.35626.arekm@maven.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-crypto@vger.kernel.org
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50845 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750790AbdBAOSA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Feb 2017 09:18:00 -0500
Content-Disposition: inline
In-Reply-To: <201701301742.35626.arekm@maven.pl>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 30, 2017 at 05:42:35PM +0100, Arkadiusz Miśkiewicz wrote:
> On Monday 30 of January 2017, Eric Biggers wrote:
> 
> > First, aesni-intel no longer includes an LRW implementation itself. 
> > Instead, the generic LRW module must be selected.  Internally it will use
> > the aesni-intel accelerated ECB algorithm if available.  So you need to
> > make sure that the "lrw" module is included in the initrd if it's not
> > already.
> > 
> > But I think the bigger problem is that aesni-intel couldn't be insmod'ed at
> > all, which shouldn't happen.  The problem might actually be related to the
> > "pcbc" algorithm.  Upon initialization, aesni-intel now tries to wrap
> > "pcbc(__aes-aesni)" with the "fpu" template.  This will fail if the "pcbc"
> > module hasn't been inserted.  I think this wasn't a problem before because
> > the old code using ablk_helper instead of crypto_simd didn't try to find
> > "pcbc" until someone asked for it, while now aesni-intel will try to find
> > it immediately.  And since aesni-intel has no direct dependency on pcbc,
> > I'm guessing what happened is that pcbc didn't end up in your initrd even
> > though it may have been built.  (You can verify this by adding pcbc to
> > your initrd and seeing if that works around the problem.)
> 
> (hardcoded) loading of pcbc fixed my problem, intel-aesni loaded fine and luks 
> partition unlocked correctly.

Thanks for the report.  Does this patch fix the problem?

---8<---
Subject: crypto: aesni - Fix failure when pcbc module is absent

When aesni is built as a module together with pcbc, the pcbc module
must be present for aesni to load.  However, the pcbc module may not
be present for reasons such as its absence on initramfs.  This patch
allows the aesni to function even if the pcbc module is enabled but
not present.

Reported-by: Arkadiusz Miśkiewicz <arekm@maven.pl>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 7ad0ed7..93de8ea 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1089,9 +1089,9 @@ static void aesni_free_simds(void)
 		    aesni_simd_skciphers[i]; i++)
 		simd_skcipher_free(aesni_simd_skciphers[i]);
 
-	for (i = 0; i < ARRAY_SIZE(aesni_simd_skciphers2) &&
-		    aesni_simd_skciphers2[i].simd; i++)
-		simd_skcipher_free(aesni_simd_skciphers2[i].simd);
+	for (i = 0; i < ARRAY_SIZE(aesni_simd_skciphers2); i++)
+		if (aesni_simd_skciphers2[i].simd)
+			simd_skcipher_free(aesni_simd_skciphers2[i].simd);
 }
 
 static int __init aesni_init(void)
@@ -1172,7 +1172,7 @@ static int __init aesni_init(void)
 		simd = simd_skcipher_create_compat(algname, drvname, basename);
 		err = PTR_ERR(simd);
 		if (IS_ERR(simd))
-			goto unregister_simds;
+			continue;
 
 		aesni_simd_skciphers2[i].simd = simd;
 	}
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
