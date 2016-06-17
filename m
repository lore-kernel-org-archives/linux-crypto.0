From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v2 09/10] crypto: marvell: Add support for chaining
 crypto requests in TDMA mode
Date: Fri, 17 Jun 2016 15:27:33 +0200
Message-ID: <20160617152733.74d44ca4@bbrezillon>
References: <1466162649-29911-1-git-send-email-romain.perier@free-electrons.com>
	<1466162649-29911-10-git-send-email-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Arnaud Ebalard <arno@natisbad.org>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:52499 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752665AbcFQN1f (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jun 2016 09:27:35 -0400
In-Reply-To: <1466162649-29911-10-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 17 Jun 2016 13:24:08 +0200
Romain Perier <romain.perier@free-electrons.com> wrote:

> The Cryptographic Engines and Security Accelerators (CESA) supports the
> Multi-Packet Chain Mode. With this mode enabled, multiple tdma requests
> can be chained and processed by the hardware without software
> intervention. This mode was already activated, however the crypto
> requests were not chained together. By doing so, we reduce significantly
> the number of IRQs. Instead of being interrupted at the end of each
> crypto request, we are interrupted at the end of the last cryptographic
> request processed by the engine.
> 
> This commits re-factorizes the code, changes the code architecture and
> adds the required data structures to chain cryptographic requests
> together before sending them to an engine (stopped or possibly already
> running).
> 
> Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
> ---
> 
> Changes in v2:
> 
>   - Reworded the commit message
>   - Fixed cosmetic changes: coding styles issues, missing blank lines
>   - Reworked mv_cesa_rearm_engine: lock handling is simpler
>   - Removed the call to the complete operation in mv_cesa_std_process,
>     in case of errors (not required)
>   - Squashed the removal of the '.prepare' fields (cipher.c, hash.c)
>     into another commit (see PATCH 08/10).
>   - In mv_cesa_tdma_process only treat the status argument for the last
>     request, use 'normal' status for the other ones.
>   - Added a comment for explaining how the errors are notified to the
>     cesa core.
> 
>  drivers/crypto/marvell/cesa.c   | 115 +++++++++++++++++++++++++++++++---------
>  drivers/crypto/marvell/cesa.h   |  39 +++++++++++++-
>  drivers/crypto/marvell/cipher.c |   2 +-
>  drivers/crypto/marvell/hash.c   |   6 +++
>  drivers/crypto/marvell/tdma.c   |  88 ++++++++++++++++++++++++++++++
>  5 files changed, 223 insertions(+), 27 deletions(-)
> 

[...]

> +void
> +mv_cesa_tdma_chain(struct mv_cesa_engine *engine, struct mv_cesa_req *dreq)

void mv_cesa_tdma_chain(struct mv_cesa_engine *engine,
			struct mv_cesa_req *dreq)

> +{
> +	if (engine->chain.first == NULL && engine->chain.last == NULL) {
> +		engine->chain.first = dreq->chain.first;
> +		engine->chain.last  = dreq->chain.last;
> +	} else {
> +		struct mv_cesa_tdma_desc *last;
> +
> +		last = engine->chain.last;
> +		last->next = dreq->chain.first;
> +		engine->chain.last = dreq->chain.last;
> +
> +		if (!(last->flags & CESA_TDMA_BREAK_CHAIN))
> +			last->next_dma = dreq->chain.first->cur_dma;
> +	}
> +}
> +
> +int
> +mv_cesa_tdma_process(struct mv_cesa_engine *engine, u32 status)

int mv_cesa_tdma_process(struct mv_cesa_engine *engine, u32 status)

> +{
> +	struct crypto_async_request *req = NULL;
> +	struct mv_cesa_tdma_desc *tdma = NULL, *next = NULL;
> +	dma_addr_t tdma_cur;
> +	int res = 0;
> +
> +	tdma_cur = readl(engine->regs + CESA_TDMA_CUR);
> +
> +	for (tdma = engine->chain.first; tdma; tdma = next) {
> +		spin_lock_bh(&engine->lock);
> +		next = tdma->next;
> +		spin_unlock_bh(&engine->lock);
> +
> +		if (tdma->flags & CESA_TDMA_END_OF_REQ) {
> +			struct crypto_async_request *backlog = NULL;
> +			struct mv_cesa_ctx *ctx;
> +			u32 current_status;
> +
> +			spin_lock_bh(&engine->lock);
> +			/*
> +			 * if req is NULL, this means we're processing the
> +			 * request in engine->req.
> +			 */
> +			if (!req)
> +				req = engine->req;
> +			else
> +				req = mv_cesa_dequeue_req_locked(engine,
> +								 &backlog);
> +
> +			/* Re-chaining to the next request */
> +			engine->chain.first = tdma->next;
> +			tdma->next = NULL;
> +
> +			/* If this is the last request, clear the chain */
> +			if (engine->chain.first == NULL)
> +				engine->chain.last  = NULL;
> +			spin_unlock_bh(&engine->lock);
> +
> +			ctx = crypto_tfm_ctx(req->tfm);
> +			current_status = (tdma->cur_dma == tdma_cur) ?
> +					  status : CESA_SA_INT_ACC0_IDMA_DONE;
> +			res = ctx->ops->process(req, current_status);
> +			ctx->ops->complete(req);
> +
> +			if (res == 0)
> +				mv_cesa_engine_enqueue_complete_request(engine,
> +									req);
> +
> +			if (backlog)
> +				backlog->complete(backlog, -EINPROGRESS);
> +		}
> +
> +		if (res || tdma->cur_dma == tdma_cur)
> +			break;
> +	}
> +
> +	/* Save the last request in error to engine->req, so that the core
> +	 * knows which request was fautly */
> +	if (res) {
> +		spin_lock_bh(&engine->lock);
> +		engine->req = req;
> +		spin_unlock_bh(&engine->lock);
> +	}
> +
> +	return res;
> +}
> +
> +

Extra blank line.

>  static struct mv_cesa_tdma_desc *
>  mv_cesa_dma_add_desc(struct mv_cesa_tdma_chain *chain, gfp_t flags)
>  {
