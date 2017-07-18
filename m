From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Documentation/bindings: crypto: remove the dma-mask
 property
Date: Tue, 18 Jul 2017 18:35:09 +0800
Message-ID: <20170718103509.GB6479@gondor.apana.org.au>
References: <20170623145218.10795-1-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, arnd@arndb.de,
        linux-crypto@vger.kernel.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:33144 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751357AbdGRKfi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 06:35:38 -0400
Content-Disposition: inline
In-Reply-To: <20170623145218.10795-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 23, 2017 at 04:52:18PM +0200, Antoine Tenart wrote:
> The dma-mask property is broken and was removed in the device trees
> having a safexcel-eip197 node and in the safexcel cryptographic
> driver. This patch removes the dma-mask property from the documentation
> as well.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
