From: Richard Purdie <rpurdie@openedhand.com>
Subject: Re: [PATCH 5/5] crypto: Add LZO compression support to the crypto
	interface
Date: Fri, 04 May 2007 09:39:23 +0100
Message-ID: <1178267963.5839.10.camel@localhost.localdomain>
References: <1178030843.5883.57.camel@localhost.localdomain>
	 <a781481a0705040109r45cbf472i4094dd2ebf7841e8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	herbert@gondor.apana.org.au,
	linux-mtd <linux-mtd@lists.infradead.org>,
	linux-crypto@vger.kernel.org
To: Satyam Sharma <satyam.sharma@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:42286 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932840AbXEDIjm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 May 2007 04:39:42 -0400
In-Reply-To: <a781481a0705040109r45cbf472i4094dd2ebf7841e8@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 2007-05-04 at 13:39 +0530, Satyam Sharma wrote:
> On 5/1/07, Richard Purdie <rpurdie@openedhand.com> wrote:
> > +static int lzo_init(struct crypto_tfm *tfm)
> > +{
> > +       struct lzo_ctx *ctx = crypto_tfm_ctx(tfm);
> > +
> > +       ctx->lzo_mem = vmalloc(LZO1X_MEM_COMPRESS);
> > +
> > +       if (!ctx->lzo_mem) {
> > +               vfree(ctx->lzo_mem);
> 
> Heh. What's (why's) this? You _can_ {k, v}free NULL but doing so after
> explicitly checking for it is ... ... insane!

True, there used to be two buffers allocated there and I've missed a
sensible cleanup when I removed one. I'll fix it, thanks.

Cheers,

Richard
