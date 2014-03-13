From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 3/3 V2] crypto: Simplify the ahash_finup implementation
Date: Thu, 13 Mar 2014 02:21:47 +0100
Message-ID: <201403130221.47172.marex@denx.de>
References: <1389720829-5963-1-git-send-email-marex@denx.de> <1393806108-6374-3-git-send-email-marex@denx.de> <20140312121101.GB25881@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Tom Lendacky <thomas.lendacky@amd.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:35189 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbaCMBVt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Mar 2014 21:21:49 -0400
In-Reply-To: <20140312121101.GB25881@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday, March 12, 2014 at 01:11:01 PM, Herbert Xu wrote:
> On Mon, Mar 03, 2014 at 01:21:48AM +0100, Marek Vasut wrote:
> > -static void ahash_def_finup_done2(struct crypto_async_request *req, int
> > err) +static void ahash_def_finup_done2(struct crypto_async_request
> > *areq, int err)
> 
> Please keep the existing name to be consistent with the rest
> of the crypto API code.  You should also use the same name in
> your second patch for consistency.

Done.

Moreover, the original code this patch changes still has a bug I think. The 
invocation of areq->base.complete() is wrong in the original code here. I will 
post V3 of the patches where I explain the problem in detail.

Best regards,
Marek Vasut
