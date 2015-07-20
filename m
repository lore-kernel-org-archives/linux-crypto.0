From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: crypto: qat - Add support for RSA algorithm
Date: Mon, 20 Jul 2015 18:12:36 +0300
Message-ID: <20150720151236.GA5464@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: qat-linux@intel.com, linux-crypto@vger.kernel.org
To: tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28130 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932385AbbGTPKR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jul 2015 11:10:17 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Tadeusz Struk,

The patch a990532023b9: "crypto: qat - Add support for RSA algorithm"
from Jul 15, 2015, leads to the following Smatch warning:

	drivers/crypto/qat/qat_common/qat_asym_algs.c:446 qat_rsa_get_n()
	warn: was && intended here instead of ||?

drivers/crypto/qat/qat_common/qat_asym_algs.c
   444          ret = -EINVAL;
   445          /* In FIPS mode only allow key size 2K & 3K */
   446          if (fips_enabled && (ctx->key_sz != 256 || ctx->key_sz != 384)) {
                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Looks like the static checker is correct.

   447                  pr_err("QAT: RSA: key size not allowed in FIPS mode\n");
   448                  goto err;
   449          }
   450          /* invalid key size provided */
   451          if (!qat_rsa_enc_fn_id(ctx->key_sz))
   452                  goto err;
   453  
   454          ret = -ENOMEM;
   455          ctx->n = dma_zalloc_coherent(dev, ctx->key_sz, &ctx->dma_n, GFP_KERNEL);
   456          if (!ctx->n)
   457                  goto err;
   458  
   459          memcpy(ctx->n, ptr, ctx->key_sz);
   460          return 0;
   461  err:
   462          ctx->key_sz = 0;
   463          ctx->n = NULL;
   464          return ret;
   465  }

regards,
dan carpenter
