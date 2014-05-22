From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/7] crypto: geode: Don't use tfm->__crt_alg->cra_name
 directly
Date: Thu, 22 May 2014 21:09:02 +0800
Message-ID: <20140522130902.GC3598@gondor.apana.org.au>
References: <1400060463-11644-1-git-send-email-marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:49781 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaEVNJE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 May 2014 09:09:04 -0400
Content-Disposition: inline
In-Reply-To: <1400060463-11644-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 14, 2014 at 11:40:57AM +0200, Marek Vasut wrote:
> Use a standard accessor instead of directly digging into a structure.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

All applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
