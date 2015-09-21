From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: marvell: properly handle
 CRYPTO_TFM_REQ_MAY_BACKLOG-flagged requests
Date: Mon, 21 Sep 2015 23:04:32 +0800
Message-ID: <20150921150431.GA2703@gondor.apana.org.au>
References: <1442589936-18042-1-git-send-email-thomas.petazzoni@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	linux-arm-kernel@lists.infradead.org,
	Jason Cooper <jason@lakedaemon.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Vincent Donnefort <vdonnefort@gmail.com>,
	stable@vger.kernel.org
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34976 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865AbbIUPFG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Sep 2015 11:05:06 -0400
Content-Disposition: inline
In-Reply-To: <1442589936-18042-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 18, 2015 at 05:25:36PM +0200, Thomas Petazzoni wrote:
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

Applied to crypto.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
