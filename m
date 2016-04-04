From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: gcm.c:undefined reference to `crypto_aead_setauthsize'
Date: Mon, 4 Apr 2016 22:00:05 +0800
Message-ID: <20160404140004.GA4006@gondor.apana.org.au>
References: <201604012329.Nnqft6lQ%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sabrina Dubroca <sd@queasysnail.net>, kbuild-all@01.org,
	linux-kernel@vger.kernel.org,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44047 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281AbcDDOAb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Apr 2016 10:00:31 -0400
Content-Disposition: inline
In-Reply-To: <201604012329.Nnqft6lQ%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 01, 2016 at 03:02:30PM +0000, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   6ddf37da05cd71bf9e43349d607e810b43c9008a
> commit: c09440f7dcb304002dfced8c0fea289eb25f2da0 macsec: introduce IEEE 802.1AE driver
> date:   3 weeks ago
> config: x86_64-randconfig-s3-04012139 (attached as .config)
> reproduce:
>         git checkout c09440f7dcb304002dfced8c0fea289eb25f2da0
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All errors (new ones prefixed by >>):
> 
>    crypto/built-in.o: In function `gcm_enc_copy_hash':
> >> gcm.c:(.text+0x278): undefined reference to `crypto_xor'

GCM is y but AEAD is only m, yet GCM selects AEAD.  Perhaps a kbuild
bug?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
