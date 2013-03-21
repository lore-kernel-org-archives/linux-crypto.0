From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] crypto: picoxcell_crypto: Use of_match_ptr() macro
Date: Thu, 21 Mar 2013 17:55:25 +0800
Message-ID: <20130321095525.GG26931@gondor.apana.org.au>
References: <1363256218-26326-1-git-send-email-sachin.kamat@linaro.org>
 <20130315095405.GI6473@sycamore.jamieiles.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
	linux-crypto@vger.kernel.org, davem@davemloft.net
To: Jamie Iles <jamie@jamieiles.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:58939 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753252Ab3CUJzd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Mar 2013 05:55:33 -0400
Content-Disposition: inline
In-Reply-To: <20130315095405.GI6473@sycamore.jamieiles.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 15, 2013 at 09:54:05AM +0000, Jamie Iles wrote:
> Thanks Sachin!
> 
> On Thu, Mar 14, 2013 at 03:46:58PM +0530, Sachin Kamat wrote:
> > This eliminates having an #ifdef returning NULL for the case
> > when OF is disabled.
> > 
> > Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> 
> Acked-by: Jamie Iles <jamie@jamieiles.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
