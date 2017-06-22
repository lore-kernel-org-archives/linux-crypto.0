From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: cavium/nitrox - dma_mapping_error() returns bool
Date: Thu, 22 Jun 2017 17:00:31 +0800
Message-ID: <20170622090031.GE25859@gondor.apana.org.au>
References: <20170619105124.GA23831@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Srikanth Jampala <Jampala.Srikanth@cavium.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:34692 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752842AbdFVJBJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2017 05:01:09 -0400
Content-Disposition: inline
In-Reply-To: <20170619105124.GA23831@elgon.mountain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 19, 2017 at 01:51:25PM +0300, Dan Carpenter wrote:
> We want to return negative error codes here, but we're accidentally
> propogating the "true" return from dma_mapping_error().
> 
> Fixes: 14fa93cdcd9b ("crypto: cavium - Add support for CNN55XX adapters.")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
