From: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC 2/7] crypto: Use GHASH digest algorithm in GCM
Date: Mon, 22 Jun 2009 10:07:27 +0800
Message-ID: <1245636447.22246.323.camel@yhuang-dev.sh.intel.com>
References: <20090621134635.GA2980@gondor.apana.org.au>
	 <1245634876.22246.320.camel@yhuang-dev.sh.intel.com>
	 <20090622020305.GA7843@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19826 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbZFVCH0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Jun 2009 22:07:26 -0400
In-Reply-To: <20090622020305.GA7843@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2009-06-22 at 10:03 +0800, Herbert Xu wrote:
> On Mon, Jun 22, 2009 at 09:41:16AM +0800, Huang Ying wrote:
> >
> > Can crypto_alloc_ahash("ghash",...) select among different ghash
> > implementation automatically based on priority? I think
> > crypto_alloc_ablkcipher("cbc(aes)",...) can select among different AES
> > implementation automatically. They are different?
> 
> Yes it will select the highest priority implementation of ghash.
> Adding it as an extra parameter would allow the user to specify
> an implementation that is not necessarily the one with the highest
> priority.

Oh, I see. I will do this.

Best Regards,
Huang Ying

