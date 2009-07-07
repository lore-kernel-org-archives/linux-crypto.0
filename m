From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [RFC 7/7] crypto: Add PCLMULQDQ accelerated GHASH
	implementation
Date: Tue, 7 Jul 2009 08:15:48 +0200
Message-ID: <20090707061548.GB20288@secunet.com>
References: <20090621135121.GA3153@gondor.apana.org.au> <1246937512.5282.99.camel@yhuang-dev.sh.intel.com> <20090707034548.GA28075@gondor.apana.org.au> <20090707040232.GA28257@gondor.apana.org.au> <20090707040341.GA28303@gondor.apana.org.au> <20090707060015.GA20288@secunet.com> <20090707060003.GA28886@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Huang Ying <ying.huang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:35899 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbZGGGNI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2009 02:13:08 -0400
Content-Disposition: inline
In-Reply-To: <20090707060003.GA28886@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 07, 2009 at 02:00:03PM +0800, Herbert Xu wrote:
> 
> Sure, maybe I could take some of your code as is.  My plan for
> hmac is to first convert it to shash, then convert the users to
> ahash, and finally convert hmac itself to ahash.
> 
> This way we don't have to convert all the users and hmac in one
> go.
> 

I see. authenc is already converted, yesterday I started to look into
ah4/ah6 ipsec. I'll post my hmac version to linux-crypto.
