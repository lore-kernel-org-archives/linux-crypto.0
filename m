From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch] crypto: caam - ARRAY_SIZE() vs sizeof()
Date: Wed, 23 Mar 2011 21:22:19 +0800
Message-ID: <20110323132219.GC4374@gondor.apana.org.au>
References: <20110315065955.GP2008@bicker> <20110315172037.f212db80.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Carpenter <error27@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Steve Cornelius <sec@pobox.com>, linux-crypto@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:45948 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600Ab1CWNW2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Mar 2011 09:22:28 -0400
Content-Disposition: inline
In-Reply-To: <20110315172037.f212db80.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 15, 2011 at 05:20:37PM -0500, Kim Phillips wrote:
> On Tue, 15 Mar 2011 09:59:55 +0300
> Dan Carpenter <error27@gmail.com> wrote:
> 
> > ARRAY_SIZE() was intended here instead of sizeof().  sizeof() is four
> > times larger than ARRAY_SIZE().  outstr is normally 256 chars so 
> > printing garbage to it could overfill the buffer and corrupt memory.
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> Acked-by: Kim Phillips <kim.phillips@freescale.com>

Also applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
