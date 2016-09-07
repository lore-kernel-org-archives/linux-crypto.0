From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: mv_cesa: remove NO_IRQ reference
Date: Wed, 7 Sep 2016 21:21:48 +0800
Message-ID: <20160907132148.GK17176@gondor.apana.org.au>
References: <20160902232648.2119621-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Romain Perier <romain.perier@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Arnaud Ebalard <arno@natisbad.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160902232648.2119621-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Sep 03, 2016 at 01:26:40AM +0200, Arnd Bergmann wrote:
> Drivers should not use NO_IRQ, as we are trying to get rid of that.
> In this case, the call to irq_of_parse_and_map() is both wrong
> (as it returns '0' on failure, not NO_IRQ) and unnecessary
> (as platform_get_irq() does the same thing)
> 
> This removes the call to irq_of_parse_and_map() and checks for
> the error code correctly.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
