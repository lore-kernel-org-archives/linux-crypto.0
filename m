From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - Switch to new rsa_helper functions
Date: Fri, 1 Jul 2016 18:08:50 +0800
Message-ID: <20160701100850.GA13758@gondor.apana.org.au>
References: <1467305947-4666-1-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52551 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbcGAKJE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 Jul 2016 06:09:04 -0400
Content-Disposition: inline
In-Reply-To: <1467305947-4666-1-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 30, 2016 at 05:59:07PM +0100, Salvatore Benedetto wrote:
> Drop all asn1 related code in qat and use the new rsa_helper
> functions rsa_parse_[pub|priv]_key for parsing the key
> 
> Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
> ---
>  crypto/testmgr.c                                  |  1 +
>  drivers/crypto/qat/Kconfig                        |  2 +-
>  drivers/crypto/qat/qat_common/Makefile            | 10 -----
>  drivers/crypto/qat/qat_common/qat_asym_algs.c     | 49 +++++++++--------------
>  drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1 | 11 -----
>  drivers/crypto/qat/qat_common/qat_rsapubkey.asn1  |  4 --
>  6 files changed, 22 insertions(+), 55 deletions(-)
>  delete mode 100644 drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1
>  delete mode 100644 drivers/crypto/qat/qat_common/qat_rsapubkey.asn1
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 537fdc3..b52a81c 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -1941,6 +1941,7 @@ static int do_test_rsa(struct crypto_akcipher *tfm,
>  	if (err)
>  		goto free_req;
>  
> +	err = -ENOMEM;
>  	out_len_max = crypto_akcipher_maxsize(tfm);
>  	outbuf_enc = kzalloc(out_len_max, GFP_KERNEL);
>  	if (!outbuf_enc)

This should go into a separate patch.  Please also rebase it on
my RSA patch series and do_test_rsa no longer exists.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
