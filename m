From: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC 2/7] crypto: Use GHASH digest algorithm in GCM
Date: Mon, 22 Jun 2009 09:41:16 +0800
Message-ID: <1245634876.22246.320.camel@yhuang-dev.sh.intel.com>
References: <20090621134635.GA2980@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57299 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbZFVBlP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Jun 2009 21:41:15 -0400
In-Reply-To: <20090621134635.GA2980@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 2009-06-21 at 21:46 +0800, Herbert Xu wrote:
> Huang Ying <ying.huang@intel.com> wrote:
> >
> > +       ghash = crypto_alloc_ahash("ghash", 0, 0);
> > +       if (IS_ERR(ghash))
> > +               return PTR_ERR(ghash);
> 
> We should add this as an extra parameter to gcm_base.  This is
> so that the user can select an alternative ghash implementation.

Can crypto_alloc_ahash("ghash",...) select among different ghash
implementation automatically based on priority? I think
crypto_alloc_ablkcipher("cbc(aes)",...) can select among different AES
implementation automatically. They are different?

Best Regards,
Huang Ying


