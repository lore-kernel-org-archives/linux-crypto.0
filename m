From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] crypto: sha256-mb - cleanup a || vs | typo
Date: Thu, 30 Jun 2016 10:50:56 +0300
Message-ID: <20160630075056.GR32247@mwanda>
References: <20160629144242.GE22818@mwanda>
 <8538242a-eab7-127e-e47e-26027fee4f6d@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Megha Dey <megha.dey@intel.com>,
	"Wang, Rui Y" <rui.y.wang@intel.com>,
	Denys Vlasenko <dvlasenk@redhat.com>,
	Xiaodong Liu <xiaodong.liu@intel.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21704 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbcF3HvS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jun 2016 03:51:18 -0400
Content-Disposition: inline
In-Reply-To: <8538242a-eab7-127e-e47e-26027fee4f6d@zytor.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 29, 2016 at 10:05:53AM -0700, H. Peter Anvin wrote:
> On 06/29/16 07:42, Dan Carpenter wrote:
> > || and | behave basically the same here but || is intended.  It causes a
> > static checker warning to mix up bitwise and logical operations.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > diff --git a/arch/x86/crypto/sha256-mb/sha256_mb.c b/arch/x86/crypto/sha256-mb/sha256_mb.c
> > index c9d5dcc..4ec895a 100644
> > --- a/arch/x86/crypto/sha256-mb/sha256_mb.c
> > +++ b/arch/x86/crypto/sha256-mb/sha256_mb.c
> > @@ -299,7 +299,7 @@ static struct sha256_hash_ctx *sha256_ctx_mgr_submit(struct sha256_ctx_mgr *mgr,
> >  	 * Or if the user's buffer contains less than a whole block,
> >  	 * append as much as possible to the extra block.
> >  	 */
> > -	if ((ctx->partial_block_buffer_length) | (len < SHA256_BLOCK_SIZE)) {
> > +	if ((ctx->partial_block_buffer_length) || (len < SHA256_BLOCK_SIZE)) {
> >  		/* Compute how many bytes to copy from user buffer into
> >  		 * extra block
> >  		 */
> > 
> 
> As far as I know the | was an intentional optimization, so you may way
> to look at the generated code.

I know how the rules work.  I just thought it looked more like a typo
than an optimization.  It's normally a typo.  It's hard to tell the
intent.

I think I'll modify my static checker to ignore these since the typo is
harmless.

regards,
dan carpenter
