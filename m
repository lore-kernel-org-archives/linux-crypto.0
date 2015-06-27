From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Fixes for 4.2
Date: Sat, 27 Jun 2015 15:56:38 +0900
Message-ID: <20150627065638.GA29497@gondor.apana.org.au>
References: <20131107080131.GA32307@gondor.apana.org.au>
 <20140123115319.GA20602@gondor.apana.org.au>
 <20140401100001.GA12386@gondor.apana.org.au>
 <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150626102234.GA19393@gondor.apana.org.au>
 <CA+55aFwvyJkQXxTLzgtwv4wMmvwVtKdPMsNa05CgaKop9vQ1NQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43295 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbbF0G4t (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 27 Jun 2015 02:56:49 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFwvyJkQXxTLzgtwv4wMmvwVtKdPMsNa05CgaKop9vQ1NQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 26, 2015 at 01:07:02PM -0700, Linus Torvalds wrote:
> On Fri, Jun 26, 2015 at 3:22 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > * Kill testmgr warning for gcm-aes-aesni.
> 
> Hmm. You killed one of the warnings, but the setkey one remains.
> 
>     alg: aead: setkey failed on test 1 for rfc4106-gcm-aesni: flags=0
> 
> Expected?

I wanted to explore a more complete fix with delaying the testing
until all built-in registrations are complete but it turned out to
be too complicated for now.

So I think Tadeusz's patch is the simplest fix for 4.2.  Could you
please test it to see if it makes your warning go away? Just in
case you're running into something else that happens to look the
same.

Here is his patch again with a corrected changelog.

Thanks!

---8<---
From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: crypto: aesni - fix failing setkey for rfc4106-gcm-aesni

rfc4106(gcm(aes)) uses ctr(aes) to generate hash key. ctr(aes) needs
chainiv, but the chainiv gets initialized after aesni_intel when both
are statically linked so the setkey fails.
This patch forces aesni_intel to be initialized after chainiv.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 arch/x86/crypto/aesni-intel_glue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index ebcb981d..cb630a8 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1537,7 +1537,7 @@ static void __exit aesni_exit(void)
 	crypto_fpu_exit();
 }
 
-module_init(aesni_init);
+late_initcall(aesni_init);
 module_exit(aesni_exit);
 
 MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm, Intel AES-NI instructions optimized");


-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
