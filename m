From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] dcp: aes: Move the AES operation type from actx to rctx
Date: Sun, 9 Feb 2014 17:19:41 +0800
Message-ID: <20140209091941.GA19429@gondor.apana.org.au>
References: <1389720661-5820-1-git-send-email-marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Tom Lendacky <thomas.lendacky@amd.com>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:42355 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaBIJT7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 9 Feb 2014 04:19:59 -0500
Content-Disposition: inline
In-Reply-To: <1389720661-5820-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 14, 2014 at 06:31:01PM +0100, Marek Vasut wrote:
> Move the AES operation type and mode from async crypto context to
> crypto request context. This allows for recycling of the async crypto
> context for different kinds of operations.
> 
> I found this problem when I used dm-crypt, which uses the same async
> crypto context (actx) for both encryption and decryption requests.
> Since the requests are enqueued into the processing queue, immediatelly
> storing the type of operation into async crypto context (actx) caused
> corruption of this information when encryption and decryption operations
> followed imediatelly one after the other. When the first operation was
> dequeued, the second operation was already enqueued and overwritten the
> type of operation in actx, thus causing incorrect result of the first
> operation.
> 
> Fix this problem by storing the type of operation into the crypto request
> context.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Fabio Estevam <fabio.estevam@freescale.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
