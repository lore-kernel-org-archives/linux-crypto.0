From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev:master 98/130]
 arch/arm64/crypto/aes-neon-blk.o:(.bss+0x0): multiple definition of
 `aes_simd_algs'
Date: Thu, 1 Dec 2016 13:45:05 +0800
Message-ID: <20161201054505.GA6767@gondor.apana.org.au>
References: <201612010928.4e79TjrB%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, linux-crypto@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35067 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751997AbcLAFp0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Dec 2016 00:45:26 -0500
Content-Disposition: inline
In-Reply-To: <201612010928.4e79TjrB%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 01, 2016 at 09:45:30AM +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   81126d1a8bc23c72a13c05c4308dc6951afc3b45
> commit: d0ed0db149fce92f4d69490f18be23ddc470bf6f [98/130] crypto: arm64/aes - Convert to skcipher
> config: arm64-allyesconfig (attached as .config)
> compiler: aarch64-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout d0ed0db149fce92f4d69490f18be23ddc470bf6f
>         # save the attached .config to linux build tree
>         make.cross ARCH=arm64 

Thanks for the report!

---8<---
Subject: crypto: aes-ce - Make aes_simd_algs static

The variable aes_simd_algs should be static.  In fact if it isn't
it causes build errors when multiple copies of aes-ce-glue.c are
built into the kernel.

Fixes: da40e7a4ba4d ("crypto: aes-ce - Convert to skcipher")
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index 4a507c6..8857531 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -407,7 +407,7 @@ static int xts_decrypt(struct skcipher_request *req)
 	.decrypt	= xts_decrypt,
 } };
 
-struct simd_skcipher_alg *aes_simd_algs[ARRAY_SIZE(aes_algs)];
+static struct simd_skcipher_alg *aes_simd_algs[ARRAY_SIZE(aes_algs)];
 
 static void aes_exit(void)
 {

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
