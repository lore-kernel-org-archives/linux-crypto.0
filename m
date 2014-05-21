From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH 1/6] crypto: SHA1 multibuffer map scatter gather walk's
 buffer address directly for x86_64
Date: Wed, 21 May 2014 15:18:45 -0700
Message-ID: <1400710725.2970.315.camel@schen9-DESK>
References: <cover.1399990803.git.tim.c.chen@linux.intel.com>
	 <1400023182.2970.238.camel@schen9-DESK>
	 <20140513233410.GA28134@gondor.apana.org.au>
	 <1400024458.2970.247.camel@schen9-DESK>
	 <20140513235813.GA28455@gondor.apana.org.au>
	 <1400177523.2970.267.camel@schen9-DESK>
	 <20140521130504.GA24401@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48188 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbaEUWUp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 May 2014 18:20:45 -0400
In-Reply-To: <20140521130504.GA24401@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2014-05-21 at 21:05 +0800, Herbert Xu wrote:
> On Thu, May 15, 2014 at 11:12:03AM -0700, Tim Chen wrote:
> >
> > > In which case your patch would basically do kmap if ASYNC and
> > > kmap_atomic otherwise.
> > > 
> > > I'll try to make such a patch.
> 
> Please see attached.

> > It will be nice if scatterwalk_map and unmap can also be made
> > async aware. Right now it also uses kmap_atomic.
> > This will allow multi-buffer encryption to make use of it.  
> 
> Is this for ciphers? Could you use ablkcipher_walk since it doesn't
> actually map anything meaning that you can map it yourself?
> 
> commit 75ecb231ff45b54afa9f4ec9137965c3c00868f4
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Wed May 21 20:56:12 2014 +0800
> 
>     crypto: hash - Add real ahash walk interface
>     
>     Although the existing hash walk interface has already been used
>     by a number of ahash crypto drivers, it turns out that none of
>     them were really asynchronous.  They were all essentially polling
>     for completion.
>     
>     That's why nobody has noticed until now that the walk interface
>     couldn't work with a real asynchronous driver since the memory
>     is mapped using kmap_atomic.
>     
>     As we now have a use-case for a real ahash implementation on x86,
>     this patch creates a minimal ahash walk interface.  Basically it
>     just calls kmap instead of kmap_atomic and does away with the
>     crypto_yield call.  Real ahash crypto drivers don't need to yield
>     since by definition they won't be hogging the CPU.
>     
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 


Herbert,

Thanks for the patch.  I'll test it out for multi-buffer sha1
and then send out an update of the patch series.

Tim
