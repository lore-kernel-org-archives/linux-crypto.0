From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH] crypto: marvell: properly handle
 CRYPTO_TFM_REQ_MAY_BACKLOG-flagged requests
Date: Fri, 18 Sep 2015 17:40:32 +0200
Message-ID: <20150918174032.7bbd2b2a@bbrezillon>
References: <1442589936-18042-1-git-send-email-thomas.petazzoni@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Tawfik Bayouk <tawfik@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	linux-arm-kernel@lists.infradead.org,
	Jason Cooper <jason@lakedaemon.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Vincent Donnefort <vdonnefort@gmail.com>,
	<stable@vger.kernel.org>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:58112 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752342AbbIRPnZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2015 11:43:25 -0400
In-Reply-To: <1442589936-18042-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Thomas,

On Fri, 18 Sep 2015 17:25:36 +0200
Thomas Petazzoni <thomas.petazzoni@free-electrons.com> wrote:

> The mv_cesa_queue_req() function calls crypto_enqueue_request() to
> enqueue a request. In the normal case (i.e the queue isn't full), this
> function returns -EINPROGRESS. The current Marvell CESA crypto driver
> takes this into account and cleans up the request only if an error
> occured, i.e if the return value is not -EINPROGRESS.
> 
> Unfortunately this causes problems with
> CRYPTO_TFM_REQ_MAY_BACKLOG-flagged requests. When such a request is
> passed to crypto_enqueue_request() and the queue is full,
> crypto_enqueue_request() will return -EBUSY, but will keep the request
> enqueued nonetheless. This situation was not properly handled by the
> Marvell CESA driver, which was anyway cleaning up the request in such
> a situation. When later on the request was taken out of the backlog
> and actually processed, a kernel crash occured due to the internal
> driver data structures for this structure having been cleaned up.
> 
> To avoid this situation, this commit adds a
> mv_cesa_req_needs_cleanup() helper function which indicates if the
> request needs to be cleaned up or not after a call to
> crypto_enqueue_request(). This helper allows to do the cleanup only in
> the appropriate cases, and all call sites of mv_cesa_queue_req() are
> fixed to use this new helper function.
> 
> Reported-by: Vincent Donnefort <vdonnefort@gmail.com>
> Fixes: db509a45339fd ("crypto: marvell/cesa - add TDMA support")
> Cc: <stable@vger.kernel.org> # v4.2+
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> ---
>  drivers/crypto/marvell/cesa.h   | 27 +++++++++++++++++++++++++++
>  drivers/crypto/marvell/cipher.c |  7 +++----
>  drivers/crypto/marvell/hash.c   |  8 +++-----
>  3 files changed, 33 insertions(+), 9 deletions(-)
> 

[...]

>  
>  static inline void mv_cesa_req_dma_iter_init(struct mv_cesa_dma_iter *iter,
> diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
> index 0745cf3..3df2f4e 100644
> --- a/drivers/crypto/marvell/cipher.c
> +++ b/drivers/crypto/marvell/cipher.c
> @@ -189,7 +189,6 @@ static inline void mv_cesa_ablkcipher_prepare(struct crypto_async_request *req,
>  {
>  	struct ablkcipher_request *ablkreq = ablkcipher_request_cast(req);
>  	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(ablkreq);
> -

Nitpick, but you're removing an empty line, and this doesn't seem
related to the bug itself.

Anyway, Thanks for fixing that.

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
