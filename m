From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH v4 7/8] zram: use crypto contextless compression API to
 (de)compress
Date: Thu, 15 Oct 2015 10:53:32 +0900
Message-ID: <20151015015332.GD1735@swordfish>
References: <1444808304-29320-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1444808304-29320-8-git-send-email-iamjoonsoo.kim@lge.com>
 <20151015003841.GC1735@swordfish>
 <20151015010732.GB4900@js1304-P5Q-DELUXE>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34595 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbbJOBwm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 21:52:42 -0400
Content-Disposition: inline
In-Reply-To: <20151015010732.GB4900@js1304-P5Q-DELUXE>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On (10/15/15 10:07), Joonsoo Kim wrote:
[..]
> > >  	if (error) {
> > > +		crypto_free_ccomp(comp->tfm);
> > >  		kfree(comp);
> > 
> > hm... zcomp_destroy(comp) ?
> 
> It's not possible to use zcomp_destroy() here. It tries to access
> field of comp->stream which could be NULL.

ah, yep. my bad.

	-ss
