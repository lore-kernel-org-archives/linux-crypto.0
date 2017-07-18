From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: mxc-scc: fix error code in mxc_scc_probe()
Date: Tue, 18 Jul 2017 18:36:35 +0800
Message-ID: <20170718103635.GK6479@gondor.apana.org.au>
References: <20170630064212.GA13371@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:33228 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752194AbdGRKhC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 06:37:02 -0400
Content-Disposition: inline
In-Reply-To: <20170630064212.GA13371@embeddedgus>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 30, 2017 at 01:42:12AM -0500, Gustavo A. R. Silva wrote:
> Print and propagate the return value of platform_get_irq on failure.
> 
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
