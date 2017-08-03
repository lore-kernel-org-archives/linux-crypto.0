From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 2/2] crypto: inside-secure - fix the sha state length
 in hmac_sha1_setkey
Date: Thu, 3 Aug 2017 14:10:41 +0800
Message-ID: <20170803061041.GD12039@gondor.apana.org.au>
References: <20170719090231.9949-1-antoine.tenart@free-electrons.com>
 <20170719090231.9949-2-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:58352 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751230AbdHCGKv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2017 02:10:51 -0400
Content-Disposition: inline
In-Reply-To: <20170719090231.9949-2-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 19, 2017 at 11:02:31AM +0200, Antoine Tenart wrote:
> A check is performed on the ipad/opad in the safexcel_hmac_sha1_setkey
> function, but the index used by the loop doing it is wrong. It is
> currently the size of the state array while it should be the size of a
> sha1 state. This patch fixes it.
> 
> Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto engine driver")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
