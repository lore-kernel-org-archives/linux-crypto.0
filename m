From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev:master 144/146] drivers/crypto/nx/nx.h:153:39:
 warning: 'struct crypto_aead' declared inside parameter list
Date: Mon, 17 Aug 2015 18:04:17 +0800
Message-ID: <20150817100417.GA29395@gondor.apana.org.au>
References: <201508171729.dwidgvGn%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, linux-crypto@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54833 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbbHQKEZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Aug 2015 06:04:25 -0400
Content-Disposition: inline
In-Reply-To: <201508171729.dwidgvGn%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 17, 2015 at 05:52:31PM +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   58268e58e63550e24dee7d6125078ab2a2a22272
> commit: b0d955ba4688fcba8112884931aea1f1e6f50f03 [144/146] crypto: aead - Remove old AEAD interfaces
> config: powerpc-defconfig (attached as .config)
> reproduce:
>   wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>   chmod +x ~/bin/make.cross
>   git checkout b0d955ba4688fcba8112884931aea1f1e6f50f03
>   # save the attached .config to linux build tree
>   make.cross ARCH=powerpc 
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from drivers/crypto/nx/nx_debugfs.c:33:0:
> >> drivers/crypto/nx/nx.h:153:39: warning: 'struct crypto_aead' declared inside parameter list
>     int nx_crypto_ctx_aes_ccm_init(struct crypto_aead *tfm);
>                                           ^
> >> drivers/crypto/nx/nx.h:153:39: warning: its scope is only this definition or declaration, which is probably not what you want
>    drivers/crypto/nx/nx.h:154:39: warning: 'struct crypto_aead' declared inside parameter list
>     int nx_crypto_ctx_aes_gcm_init(struct crypto_aead *tfm);
>                                           ^
>    drivers/crypto/nx/nx.h:161:37: warning: 'struct crypto_aead' declared inside parameter list
>     void nx_crypto_ctx_aead_exit(struct crypto_aead *tfm);
>                                         ^

Oops, I don't know how I missed this warning.

---8<---
Subject: crypto: nx - Add forward declaration for struct crypto_aead

The file nx.h has function prototypes that use struct crypto_aead.
However, as crypto/aead.h is not included we don't have a definition
for it.  This patch adds a forward declaration to fix this.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/nx/nx.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/nx/nx.h b/drivers/crypto/nx/nx.h
index 591632d..9347878 100644
--- a/drivers/crypto/nx/nx.h
+++ b/drivers/crypto/nx/nx.h
@@ -149,6 +149,8 @@ struct nx_crypto_ctx {
 	} priv;
 };
 
+struct crypto_aead;
+
 /* prototypes */
 int nx_crypto_ctx_aes_ccm_init(struct crypto_aead *tfm);
 int nx_crypto_ctx_aes_gcm_init(struct crypto_aead *tfm);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
