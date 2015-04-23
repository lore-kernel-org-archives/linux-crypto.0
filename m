From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: api - Fix build error when modules are disabled
Date: Thu, 23 Apr 2015 14:48:05 +0800
Message-ID: <20150423064805.GA19442@gondor.apana.org.au>
References: <201504231434.WFmkfUGj%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42545 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbbDWGsN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Apr 2015 02:48:13 -0400
Content-Disposition: inline
In-Reply-To: <201504231434.WFmkfUGj%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 23, 2015 at 02:27:36PM +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   8a1a2b717e0d4d5f3e3bb59b7dee5079a15ab24b
> commit: 59afdc7b32143528524455039e7557a46b60e4c8 [42/56] crypto: api - Move module sig ifdef into accessor function
> config: xtensa-iss_defconfig (attached as .config)
> reproduce:
>   wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>   chmod +x ~/bin/make.cross
>   git checkout 59afdc7b32143528524455039e7557a46b60e4c8
>   # save the attached .config to linux build tree
>   make.cross ARCH=xtensa 
> 
> All error/warnings:
> 
>    crypto/algapi.c: In function 'crypto_check_module_sig':
> >> crypto/algapi.c:48:12: error: dereferencing pointer to incomplete type
>             mod->name);
>                ^

Thanks.  This patch should fix the problem.

---8<---
The commit 59afdc7b32143528524455039e7557a46b60e4c8 ("crypto:
api - Move module sig ifdef into accessor function") broke the
build when modules are completely disabled because we directly
dereference module->name.

This patch fixes this by using the accessor function module_name.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index c63836f..3103e6a 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -46,7 +46,7 @@ static inline void crypto_check_module_sig(struct module *mod)
 {
 	if (fips_enabled && mod && !module_sig_ok(mod))
 		panic("Module %s signature verification failed in FIPS mode\n",
-		      mod->name);
+		      module_name(mod));
 }
 
 static int crypto_check_alg(struct crypto_alg *alg)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
