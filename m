From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: Re: [PATCH] crypto: caam - Add support for hashing export and
 import functions
Date: Sat, 17 Oct 2015 06:57:44 -0700
Message-ID: <20151017065744.8ef86a4edd0de0084ed8e5c6@freescale.com>
References: <1445037573-29667-1-git-send-email-vicki.milhoan@freescale.com>
	<20151017094300.GL32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	<horia.geanta@freescale.com>, <fabio.estevam@freescale.com>,
	<boris.brezillon@free-electrons.com>, <arno@natisbad.org>,
	<thomas.petazzoni@free-electrons.com>, <jason@lakedaemon.net>,
	<davem@davemloft.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0118.outbound.protection.outlook.com ([207.46.100.118]:21280
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752073AbbJQN6E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Oct 2015 09:58:04 -0400
In-Reply-To: <20151017094300.GL32532@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 17 Oct 2015 10:43:00 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Fri, Oct 16, 2015 at 04:19:33PM -0700, Victoria Milhoan wrote:
> > @@ -1569,6 +1601,10 @@ static int ahash_import(struct ahash_request *req, const void *in)
> >  	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
> >  	struct caam_hash_state *state = ahash_request_ctx(req);
> >  
> > +	/* Allocate new data buffers to use for this request */
> > +	state->buf_0 = kmalloc(CAAM_MAX_HASH_BLOCK_SIZE, GFP_KERNEL | GFP_DMA);
> > +	state->buf_1 = kmalloc(CAAM_MAX_HASH_BLOCK_SIZE, GFP_KERNEL | GFP_DMA);
> > +
> >  	memcpy(ctx, in, sizeof(struct caam_hash_ctx));
> >  	memcpy(state, in + sizeof(struct caam_hash_ctx),
> >  	       sizeof(struct caam_hash_state));
> 
> This is buggy.  You loose the reference to the two buffers you've just
> allocated because this memcpy() overwrites it.

Correct - this was apparently the wrong patch I pushed out. The one I'm actively
using has this fixed (this is the only difference). I will make this change in
v2 after reviewing your other comments.

> 
> -- 
> FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
> according to speedtest.net.


-- 
Victoria Milhoan <vicki.milhoan@freescale.com>
