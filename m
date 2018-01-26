From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: inside-secure - make function
 safexcel_try_push_requests static
Date: Fri, 26 Jan 2018 23:44:03 +0800
Message-ID: <20180126154403.GB4002@gondor.apana.org.au>
References: <20180116074158.21571-1-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: colin.king@canonical.com, davem@davemloft.net,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:39606 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751730AbeAZQ2I (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jan 2018 11:28:08 -0500
Content-Disposition: inline
In-Reply-To: <20180116074158.21571-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 16, 2018 at 08:41:58AM +0100, Antoine Tenart wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The function safexcel_try_push_requests  is local to the source and does
> not need to be in global scope, so make it static.
> 
> Cleans up sparse warning:
> symbol 'safexcel_try_push_requests' was not declared. Should it be static?
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> [Antoine: fixed alignment]
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
