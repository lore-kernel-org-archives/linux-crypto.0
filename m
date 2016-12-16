From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: marvell - Copy IVDIG before launching partial
 DMA ahash requests
Date: Fri, 16 Dec 2016 20:07:52 +0800
Message-ID: <20161216120752.GA20359@gondor.apana.org.au>
References: <20161214141507.19105-1-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: boris.brezillon@free-electrons.com, arno@natisbad.org,
        linux-crypto@vger.kernel.org, jason@lakedaemon.net, andrew@lunn.ch,
        sebastian.hesselbarth@gmail.com,
        gregory.clement@free-electrons.com,
        thomas.petazzoni@free-electrons.com, nadavh@marvell.com,
        oferh@marvell.com, radioconfusion@gmail.com,
        romain.perier@free-electrons.com, stable@vger.kernel.org
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45309 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753216AbcLPMI3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Dec 2016 07:08:29 -0500
Content-Disposition: inline
In-Reply-To: <20161214141507.19105-1-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Romain Perier <romain.perier@free-electrons.com> wrote:
> Currently, inner IV/DIGEST data are only copied once into the hash
> engines and not set explicitly before launching a request that is not a
> first frag. This is an issue especially when multiple ahash reqs are
> computed in parallel or chained with cipher request, as the state of the
> request being computed is not updated into the hash engine. It leads to
> non-deterministic corrupted digest results.
> 
> Fixes: commit 2786cee8e50b ("crypto: marvell - Move SRAM I/O operations to step functions")
> Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
> Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> Cc: <stable@vger.kernel.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
