From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: caam - Remove bogus references to crypto API internals
Date: Wed, 22 Apr 2015 11:56:34 +0800
Message-ID: <20150422035634.GA7004@gondor.apana.org.au>
References: <201504221137.VMCTf1uc%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, Yuan Kang <Yuan.Kang@freescale.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39687 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbbDVD4o (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Apr 2015 23:56:44 -0400
Content-Disposition: inline
In-Reply-To: <201504221137.VMCTf1uc%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 22, 2015 at 11:43:39AM +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   b617b702da4e922277806f81c411d3051107d462
> commit: acec27ff35af9caf34d76d16ee17ff3b292e7d83 [31/40] crypto: rng - Convert low-level crypto_rng to new style
> config: powerpc-corenet32_smp_defconfig (attached as .config)
> reproduce:
>   wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>   chmod +x ~/bin/make.cross
>   git checkout acec27ff35af9caf34d76d16ee17ff3b292e7d83
>   # save the attached .config to linux build tree
>   make.cross ARCH=powerpc 
> 
> All error/warnings:
> 
> >> drivers/crypto/caam/caamalg.c:3386:18: error: field 'rng' has incomplete type
>       struct rng_alg rng;

Thanks for the report.

---8<---
The caam driver includes algorithm types that it doesn't even
use, such as struct rng_alg which has recently been moved to an
internal header file and consequently broke the build of caam.

This patch removes these bogus references.
    
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 29071a1..3c025d4 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -3380,10 +3380,6 @@ struct caam_alg_template {
 	union {
 		struct ablkcipher_alg ablkcipher;
 		struct aead_alg aead;
-		struct blkcipher_alg blkcipher;
-		struct cipher_alg cipher;
-		struct compress_alg compress;
-		struct rng_alg rng;
 	} template_u;
 	u32 class1_alg_type;
 	u32 class2_alg_type;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
