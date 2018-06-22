From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: inside-secure - increase minimum transfer size
Date: Fri, 22 Jun 2018 23:21:59 +0800
Message-ID: <20180622152158.2asusm2roaw5vuan@gondor.apana.org.au>
References: <20180528090327.16844-1-antoine.tenart@bootlin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, Ofer Heifetz <oferh@marvell.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, igall@marvell.com
To: Antoine Tenart <antoine.tenart@bootlin.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180528090327.16844-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, May 28, 2018 at 11:03:27AM +0200, Antoine Tenart wrote:
> From: Ofer Heifetz <oferh@marvell.com>
> 
> The token size was increased for AEAD support. Occasional authentication
> fails arise since the result descriptor overflows. This is because the
> token size and the engine minimal thresholds must be in sync.
> 
> Signed-off-by: Ofer Heifetz <oferh@marvell.com>
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
