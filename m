From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC 2/7] crypto: Use GHASH digest algorithm in GCM
Date: Mon, 22 Jun 2009 10:03:05 +0800
Message-ID: <20090622020305.GA7843@gondor.apana.org.au>
References: <20090621134635.GA2980@gondor.apana.org.au> <1245634876.22246.320.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:50297 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751983AbZFVCDF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Jun 2009 22:03:05 -0400
Content-Disposition: inline
In-Reply-To: <1245634876.22246.320.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 22, 2009 at 09:41:16AM +0800, Huang Ying wrote:
>
> Can crypto_alloc_ahash("ghash",...) select among different ghash
> implementation automatically based on priority? I think
> crypto_alloc_ablkcipher("cbc(aes)",...) can select among different AES
> implementation automatically. They are different?

Yes it will select the highest priority implementation of ghash.
Adding it as an extra parameter would allow the user to specify
an implementation that is not necessarily the one with the highest
priority.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
