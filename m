From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/2] crypto: inside-secure - fix invalidation check in
 hmac_sha1_setkey
Date: Thu, 3 Aug 2017 14:10:33 +0800
Message-ID: <20170803061033.GC12039@gondor.apana.org.au>
References: <20170719090231.9949-1-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:58342 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751079AbdHCGKp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2017 02:10:45 -0400
Content-Disposition: inline
In-Reply-To: <20170719090231.9949-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 19, 2017 at 11:02:30AM +0200, Antoine Tenart wrote:
> The safexcel_hmac_sha1_setkey function checks if an invalidation command
> should be issued, i.e. when the context ipad/opad change. This checks is
> done after filling the ipad/opad which and it can't be true. The patch
> fixes this by moving the check before the ipad/opad memcpy operations.
> 
> Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto engine driver")
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
