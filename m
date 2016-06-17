From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v2 08/10] crypto: marvell: Add load balancing between
 engines
Date: Fri, 17 Jun 2016 15:22:21 +0200
Message-ID: <20160617152221.636efa28@bbrezillon>
References: <1466162649-29911-1-git-send-email-romain.perier@free-electrons.com>
	<1466162649-29911-9-git-send-email-romain.perier@free-electrons.com>
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
Received: from down.free-electrons.com ([37.187.137.238]:52323 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753559AbcFQNWX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jun 2016 09:22:23 -0400
In-Reply-To: <1466162649-29911-9-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 17 Jun 2016 13:24:07 +0200
Romain Perier <romain.perier@free-electrons.com> wrote:

> This commits adds support for fine grained load balancing on
> multi-engine IPs. The engine is pre-selected based on its current load
> and on the weight of the crypto request that is about to be processed.
> The global crypto queue is also moved to each engine. These changes are
> required to allow chaining crypto requests at the DMA level. By using
> a crypto queue per engine, we make sure that we keep the state of the
> tdma chain synchronized with the crypto queue. We also reduce contention
> on 'cesa_dev->lock' and improve parallelism.
> 
> Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
> ---
> 
> Changes in v2:
> 
>   - Reworded the commit message
>   - Moved the code about SRAM I/O operations from this commit to
>     a separated commit (see PATCH 07/10).
> 
>  drivers/crypto/marvell/cesa.c   | 30 ++++++++++------------
>  drivers/crypto/marvell/cesa.h   | 29 +++++++++++++++++----
>  drivers/crypto/marvell/cipher.c | 57 ++++++++++++++++++-----------------------
>  drivers/crypto/marvell/hash.c   | 50 ++++++++++++++----------------------
>  4 files changed, 82 insertions(+), 84 deletions(-)
> 
> diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
> index af96426..f9e6688 100644
> --- a/drivers/crypto/marvell/cesa.c
> +++ b/drivers/crypto/marvell/cesa.c
> @@ -45,11 +45,9 @@ static void mv_cesa_dequeue_req_unlocked(struct mv_cesa_engine *engine)

This function should be renamed mv_cesa_dequeue_req_locked(). I see
you're doing it in patch 9, but it should be done here.

>  	struct crypto_async_request *req, *backlog;
>  	struct mv_cesa_ctx *ctx;
>  
> -	spin_lock_bh(&cesa_dev->lock);
> -	backlog = crypto_get_backlog(&cesa_dev->queue);
> -	req = crypto_dequeue_request(&cesa_dev->queue);
> +	backlog = crypto_get_backlog(&engine->queue);
> +	req = crypto_dequeue_request(&engine->queue);
>  	engine->req = req;
> -	spin_unlock_bh(&cesa_dev->lock);
>  
>  	if (!req)
>  		return;
