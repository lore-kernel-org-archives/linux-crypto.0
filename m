From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: marvell/cesa - forward devm_ioremap_resource()
 error code
Date: Thu, 17 Mar 2016 19:13:31 +0800
Message-ID: <20160317111331.GB5658@gondor.apana.org.au>
References: <1458208031-13463-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Romain Perier <romain.perier@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458208031-13463-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Mar 17, 2016 at 10:47:10AM +0100, Boris Brezillon wrote:
> Forward devm_ioremap_resource() error code instead of returning
> -ENOMEM.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> Reported-by: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Fixes: f63601fd616a ("crypto: marvell/cesa - add a new driver for Marvell's CESA")
> Cc: <stable@vger.kernel.org> # 4.2+

All three patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
