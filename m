From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [v4 PATCH 1/3] crypto: algif_skcipher - Do not assume that req is
 unchanged
Date: Wed, 3 Feb 2016 10:57:05 -0800
Message-ID: <56B24D81.5@intel.com>
References: <20160203133648.GA29251@gondor.apana.org.au>
 <E1aQxeW-0007dX-Uj@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:46564 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965207AbcBCTBG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Feb 2016 14:01:06 -0500
In-Reply-To: <E1aQxeW-0007dX-Uj@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/03/2016 05:39 AM, Herbert Xu wrote:
> The async path in algif_skcipher assumes that the crypto completion
> function will be called with the original request.  This is not
> necessarily the case.  In fact there is no need for this anyway
> since we already embed information into the request with struct
> skcipher_async_req.
> 
> This patch adds a pointer to that struct and then passes it as
> the data to the callback function.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  crypto/algif_skcipher.c |   60 ++++++++++++++++++++++--------------------------
>  1 file changed, 28 insertions(+), 32 deletions(-)

Tested-by: Tadeusz Struk <tadeusz.struk@intel.com>

Thanks,
-- 
TS
