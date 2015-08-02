From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6/8] crypto: qat - Convert to new AEAD interface
Date: Sun, 2 Aug 2015 09:23:54 +0800
Message-ID: <20150802012354.GB10055@gondor.apana.org.au>
References: <20150730094138.GA15941@gondor.apana.org.au>
 <E1ZKkWe-0004C6-SN@gondolin.me.apana.org.au>
 <55BBDD1F.4020208@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36312 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbbHBCAd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 1 Aug 2015 22:00:33 -0400
Content-Disposition: inline
In-Reply-To: <55BBDD1F.4020208@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 31, 2015 at 01:39:59PM -0700, Tadeusz Struk wrote:
> On 07/30/2015 02:53 AM, Herbert Xu wrote:
> > -}, {
> > +	.init = qat_alg_aead_sha512_init,
> > +	.exit = qat_alg_aead_exit,
> > +	.setkey = qat_alg_aead_setkey,
> > +	.decrypt = qat_alg_aead_dec,
> > +	.encrypt = qat_alg_aead_enc,
> > +	.ivsize = AES_BLOCK_SIZE,
> > +	.maxauthsize = SHA512_DIGEST_SIZE,
> 
> Hi Herbert,
> crypto_aead_encrypt() and crypto_aead_decrypt() work fine, but crypto_aead_givencrypt(),
> which is still supported on the API causes a crash. Should we also disable all the
> crypto_aead_giv* calls? I use it in my internal tests.

givencrypt will be removed once all drivers are converted across.
So it must not be used.

> Other that that looks ok:
> Tested-by: Tadeusz Struk <tadeusz.struk@intel.com>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
