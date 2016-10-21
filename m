From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 0/2] Improve DMA chaining for ahash requests
Date: Fri, 21 Oct 2016 11:13:17 +0800
Message-ID: <20161021031317.GE22979@gondor.apana.org.au>
References: <20161005075633.12711-1-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Arnaud Ebalard <arno@natisbad.org>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Ofer Heifetz <oferh@marvell.com>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52927 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752814AbcJUDNf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Oct 2016 23:13:35 -0400
Content-Disposition: inline
In-Reply-To: <20161005075633.12711-1-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 05, 2016 at 09:56:31AM +0200, Romain Perier wrote:
> This series contain performance improvement regarding ahash requests.
> So far, ahash requests were systematically not chained at the DMA level.
> However, in some case, like this is the case by using IPSec, some ahash
> requests can be processed directly by the engine, and don't have
> intermediaire partial update states.
> 
> This series firstly re-work the way outer IVs are copied from the SRAM
> into the dma pool. To do so, we introduce a common dma pool for all type
> of requests that contains outer results (like IV or digest). Then, for
> ahash requests that can be processed directly by the engine, outer
> results are copied from the SRAM into the common dma pool. These requests
> are then allowed to be chained at the DMA level.
> 
> 
> Benchmarking results with iperf throught IPSec
> ==============================================
> 		ESP			AH
> 
> Before		343 Mbits/s		492 Mbits/s
> After		422 Mbits/s		577 Mbits/s
> Improvement	+23%			+17%
> 
> Romain Perier (2):
>   crypto: marvell - Use an unique pool to copy results of requests
>   crypto: marvell - Don't break chain for computable last ahash requests
> 
>  drivers/crypto/marvell/cesa.c   |  4 ---
>  drivers/crypto/marvell/cesa.h   |  5 ++--
>  drivers/crypto/marvell/cipher.c |  8 +++--
>  drivers/crypto/marvell/hash.c   | 65 +++++++++++++++++++++++++++++++----------
>  drivers/crypto/marvell/tdma.c   | 28 +++++++++---------
>  5 files changed, 70 insertions(+), 40 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
