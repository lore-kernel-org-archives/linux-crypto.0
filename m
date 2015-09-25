From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v3 9/9] zram: use crypto decompress_noctx API
Date: Fri, 25 Sep 2015 14:48:52 +0900
Message-ID: <20150925054852.GI7158@js1304-P5Q-DELUXE>
References: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1442553564-3476-10-git-send-email-iamjoonsoo.kim@lge.com>
 <20150921052918.GA5313@swordfish>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from LGEAMRELO12.lge.com ([156.147.23.52]:43045 "EHLO
	lgeamrelo12.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbbIYFrs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Sep 2015 01:47:48 -0400
Content-Disposition: inline
In-Reply-To: <20150921052918.GA5313@swordfish>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 21, 2015 at 02:29:18PM +0900, Sergey Senozhatsky wrote:
> On (09/18/15 14:19), Joonsoo Kim wrote:
> > -/* Never return NULL, may sleep */
> > +/* May return NULL, may sleep */
> >  struct zcomp_strm *zcomp_decompress_begin(struct zcomp *comp)
> >  {
> > +	if (comp->tfm_noctx)
> > +		return NULL;
> > +
> >  	return zcomp_strm_find(comp);
> >  }
> >  
> > @@ -346,11 +349,18 @@ int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
> >  {
> >  	unsigned int size = PAGE_SIZE;
> >  
> > +	if (!zstrm) {
> > +		return crypto_comp_decompress_noctx(comp->tfm_noctx,
> > +						src, src_len, dst, &size);
> > +	}
> 
> unneeded braces.

It's more readable for me. But, if you don't like it, I will remove brace.

Thanks.
