From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev:master 147/175] DocBook:
 include/crypto/skcipher.h:135: warning: No description found for parameter
 'base'
Date: Tue, 19 Jul 2016 00:59:30 +0800
Message-ID: <20160718165930.GA16822@gondor.apana.org.au>
References: <201607182016.m8f2psvQ%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, linux-crypto@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51438 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbcGRQ7l (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jul 2016 12:59:41 -0400
Content-Disposition: inline
In-Reply-To: <201607182016.m8f2psvQ%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 18, 2016 at 08:25:17PM +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   c6335cbb0486f09b4c2ae86e84bf87efd667afa6
> commit: 4e6c3df4d729f85997cbf276bfa8ffd8579b8e77 [147/175] crypto: skcipher - Add low-level skcipher interface
> reproduce: make htmldocs
> 
> All warnings (new ones prefixed by >>):
> 
> >> include/crypto/skcipher.h:135: warning: No description found for parameter 'base'

Thanks for the report.

---8<---
Subject: crypto: skcipher - Add comment for skcipher_alg->base

This patch adds a missing comment for the base parameter in struct
skcipher_alg.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 59c8f6c..bb7db84 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -115,6 +115,7 @@ struct crypto_skcipher {
  *	    IV of exactly that size to perform the encrypt or decrypt operation.
  * @chunksize: Equal to the block size except for stream ciphers such as
  *	       CTR where it is set to the underlying block size.
+ * @base: Definition of a generic crypto algorithm.
  *
  * All fields except @ivsize are mandatory and must be filled.
  */
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
