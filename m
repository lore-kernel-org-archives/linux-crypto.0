From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 2/4] crypto: niagara: Use precalculated hash from
 headers
Date: Thu, 17 Dec 2015 16:51:41 +0800
Message-ID: <20151217085141.GA9390@gondor.apana.org.au>
References: <1450184423-31155-1-git-send-email-clabbe.montjoie@gmail.com>
 <1450184423-31155-3-git-send-email-clabbe.montjoie@gmail.com>
 <20151217084018.GA9166@gondor.apana.org.au>
 <20151217084824.GA20217@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43923 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbbLQIvo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Dec 2015 03:51:44 -0500
Content-Disposition: inline
In-Reply-To: <20151217084824.GA20217@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 17, 2015 at 09:48:24AM +0100, LABBE Corentin wrote:
>
> You are right, I missed it also in ccp/ux500.

I think you need it for all three drivers.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
