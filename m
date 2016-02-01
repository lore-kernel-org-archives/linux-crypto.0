From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] Introduce the cypto engine framework
Date: Mon, 1 Feb 2016 22:33:58 +0800
Message-ID: <20160201143358.GA11410@gondor.apana.org.au>
References: <cover.1453810716.git.baolin.wang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, broonie@kernel.org, linus.walleij@linaro.org,
	arnd@arndb.de, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Baolin Wang <baolin.wang@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36371 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418AbcBAOeO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2016 09:34:14 -0500
Content-Disposition: inline
In-Reply-To: <cover.1453810716.git.baolin.wang@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 26, 2016 at 08:25:37PM +0800, Baolin Wang wrote:
> Now block cipher engines need to implement and maintain their own queue/thread
> for processing requests, moreover currently helpers provided for only the queue
> itself (in crypto_enqueue_request() and crypto_dequeue_request()) but they
> don't help with the mechanics of driving the hardware (things like running the
> request immediately, DMA map it or providing a thread to process the queue in)
> even though a lot of that code really shouldn't vary that much from device to
> device.
> 
> This patch introduces the crypto engine framework to help the crypto hardware
> drivers to queue requests.

Very nice, all applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
