From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC 1/7] crypto: Add GHASH digest algorithm for GCM
Date: Thu, 18 Jun 2009 10:43:49 +0800
Message-ID: <20090618024349.GA1936@gondor.apana.org.au>
References: <1244704226.5320.124.camel@yhuang-dev.sh.intel.com> <20090617200410.GB28694@Chamillionaire.breakpoint.cc> <1245290907.11965.201.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44177 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751962AbZFRCnv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jun 2009 22:43:51 -0400
Content-Disposition: inline
In-Reply-To: <1245290907.11965.201.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 18, 2009 at 10:08:27AM +0800, Huang Ying wrote:
>
> > Unless I'm mistaken, this is called once on allocation and this ctx is
> > allocated via kzalloc().
> 
> Yes. it is alloced via kzalloc. Can we just rely on this? Should we add
> that assumption to somewhere such as document of comments.

Yes you can rely on this.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
