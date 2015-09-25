From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH v3 8/9] zram: use crypto API for compression
Date: Fri, 25 Sep 2015 16:50:15 +0900
Message-ID: <20150925075015.GB865@swordfish>
References: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1442553564-3476-9-git-send-email-iamjoonsoo.kim@lge.com>
 <20150921051903.GB863@swordfish>
 <20150925054326.GE7158@js1304-P5Q-DELUXE>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36142 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbbIYHta (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Sep 2015 03:49:30 -0400
Content-Disposition: inline
In-Reply-To: <20150925054326.GE7158@js1304-P5Q-DELUXE>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On (09/25/15 14:43), Joonsoo Kim wrote:
[..]
> > >  /* dynamic per-device compression frontend */
> > >  struct zcomp {
> > >  	void *stream;
> > > -	struct zcomp_backend *backend;
> > > +	const char *backend;
> > 
> > 	^^ what for?
> 
> Will remove.


I think that was my mistake, I realized why do you keep it
later -- to allocate new zstreams. let's keep it.

	-ss
