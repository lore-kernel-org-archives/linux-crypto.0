From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: inside-secure - 2 extra fixes
Date: Fri, 5 Jan 2018 22:16:00 +1100
Message-ID: <20180105111600.GB16156@gondor.apana.org.au>
References: <20171226162117.4885-1-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:49986 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751002AbeAELQQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jan 2018 06:16:16 -0500
Content-Disposition: inline
In-Reply-To: <20171226162117.4885-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 26, 2017 at 05:21:15PM +0100, Antoine Tenart wrote:
> Hi Herbert,
> 
> This series contains two fixes for the Inside Secure SafeXcel crypto
> engine driver. The first one removes a warning when the DMA-API debug is
> activated and the second one is fixing an issue with the driver in
> certain cases where the input length is a multiple of a block size.
> 
> Thanks!
> Antoine
> 
> Antoine Tenart (2):
>   crypto: inside-secure - avoid unmapping DMA memory that was not mapped
>   crypto: inside-secure - fix hash when length is a multiple of a block
> 
>  drivers/crypto/inside-secure/safexcel_hash.c | 54 ++++++++++++++++++----------
>  1 file changed, 36 insertions(+), 18 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
