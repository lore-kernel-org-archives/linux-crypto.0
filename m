From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: crypto4xx - fix an error code
Date: Tue, 20 Jun 2017 11:33:43 +0800
Message-ID: <20170620033343.GA17764@gondor.apana.org.au>
References: <20170610125433.26294-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:60848 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750733AbdFTDeL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 23:34:11 -0400
Content-Disposition: inline
In-Reply-To: <20170610125433.26294-1-christophe.jaillet@wanadoo.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jun 10, 2017 at 02:54:33PM +0200, Christophe JAILLET wrote:
> If 'kzalloc' fails, we return 0 which means success.
> return -ENOMEM instead as already done a few lines above.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
