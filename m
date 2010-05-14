From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: mv_cesa - Use resource_size
Date: Fri, 14 May 2010 14:58:17 +1000
Message-ID: <20100514045817.GB26117@gondor.apana.org.au>
References: <1273561064-3530-1-git-send-email-tklauser@distanz.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	kernel-janitors@vger.kernel.org
To: Tobias Klauser <tklauser@distanz.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:34966 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752332Ab0ENE6q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 May 2010 00:58:46 -0400
Content-Disposition: inline
In-Reply-To: <1273561064-3530-1-git-send-email-tklauser@distanz.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 11, 2010 at 08:57:44AM +0200, Tobias Klauser wrote:
> Use the resource_size function instead of manually calculating the
> resource size. This reduces the chance of introducing off-by-one errors.
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Patch applied.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
