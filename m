From: "Li, Weigang" <weigang.li@intel.com>
Subject: RE: [PATCH] crypto: add asynchronous compression support
Date: Wed, 21 Oct 2015 07:59:58 +0000
Message-ID: <929511EA6367314D8E32364A24D45FA612FED34B@shsmsx102.ccr.corp.intel.com>
References: <1445008260-39367-1-git-send-email-weigang.li@intel.com>
 <20151016151354.GA16648@gondor.apana.org.au>
 <929511EA6367314D8E32364A24D45FA612FE85D3@shsmsx102.ccr.corp.intel.com>
 <000e01d10a12$9e381660$daa84320$@lge.com> <20151019084905.GE963@bbox>
 <20151021073322.GA31901@swordfish>
 <20151021073418.GA14479@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Minchan Kim <minchan@kernel.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Dan Streetman <ddstreet@ieee.org>,
	Seth Jennings <sjennings@variantweb.net>,
	"Struk, Tadeusz" <tadeusz.struk@intel.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:26336 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbbJUIAH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Oct 2015 04:00:07 -0400
In-Reply-To: <20151021073418.GA14479@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> -----Original Message-----
> From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> Sent: Wednesday, October 21, 2015 3:34 PM
> To: Sergey Senozhatsky
> Cc: Minchan Kim; Joonsoo Kim; Dan Streetman; Seth Jennings; Li, Weigang;
> Struk, Tadeusz
> Subject: Re: [PATCH] crypto: add asynchronous compression support
> 
> On Wed, Oct 21, 2015 at 04:33:22PM +0900, Sergey Senozhatsky wrote:
> >
> > the thing is -- I still want to have/use SW compressors; and they [the
> > existing S/W algorithms] want virtual addresses. so we need to
> > kmap_atomic pages in every SW algorithm? isn't it simpler to keep
> > kmap_atomic_to_page around?
> 
> The Crypto API will do it for you.  Have a look at how we handle it for aead
> and ahash for example.
> 
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Adding the "linux-crypto" list back to the latest discussion.
