From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch 2/2 v2] crypto: img-hash - shift wrapping bug in
 img_hash_hw_init()
Date: Mon, 23 Mar 2015 22:09:23 +1100
Message-ID: <20150323110923.GB13736@gondor.apana.org.au>
References: <72BC0C8BD7BB6F45988A99382E5FBAE54446CD50@hhmail02.hh.imgtec.org>
 <20150323110355.GB10964@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: James Hartley <james.hartley@imgtec.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:50889 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbbCWLJe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Mar 2015 07:09:34 -0400
Content-Disposition: inline
In-Reply-To: <20150323110355.GB10964@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 23, 2015 at 02:03:55PM +0300, Dan Carpenter wrote:
> "hdev->req->nbytes" is an unsigned int so we so we lose the upper 3 bits
> to the shift wrap bug.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Both patches applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
