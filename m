From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v10 2/3] crypto: kpp - Add DH software implementation
Date: Wed, 22 Jun 2016 08:51:15 +0800
Message-ID: <20160622005115.GB27134@gondor.apana.org.au>
References: <1466541931-2875-1-git-send-email-salvatore.benedetto@intel.com>
 <1466541931-2875-3-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43248 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbcFVAvT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2016 20:51:19 -0400
Content-Disposition: inline
In-Reply-To: <1466541931-2875-3-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 21, 2016 at 09:45:30PM +0100, Salvatore Benedetto wrote:
>
> +
> +static int test_dh(struct crypto_kpp *tfm, struct kpp_testvec_dh *vecs,
> +		   unsigned int tcount)
> +{
> +	int ret, i;

Please make the kpp test function generic.  I'm trying to kill
the RSA-specific test function right now and I don't want to have
to do this again.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
