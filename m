From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH] crypto: marvell/cesa - forward devm_ioremap_resource()
 error code
Date: Thu, 17 Mar 2016 10:49:34 +0100
Message-ID: <20160317104934.63e9e396@bbrezillon>
References: <1458208031-13463-1-git-send-email-boris.brezillon@free-electrons.com>
	<1458208031-13463-2-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Lior Amsalem <alior@marvell.com>,
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
	<stable@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1458208031-13463-2-git-send-email-boris.brezillon@free-electrons.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Sorry for the noise, just sent twice the same patch :-/.
Please ignore this one.

On Thu, 17 Mar 2016 10:47:11 +0100
Boris Brezillon <boris.brezillon@free-electrons.com> wrote:

> Forward devm_ioremap_resource() error code instead of returning
> -ENOMEM.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> Reported-by: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Fixes: f63601fd616a ("crypto: marvell/cesa - add a new driver for Marvell's CESA")
> Cc: <stable@vger.kernel.org> # 4.2+
> ---
>  drivers/crypto/marvell/cesa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
> index c0656e7..80239ae 100644
> --- a/drivers/crypto/marvell/cesa.c
> +++ b/drivers/crypto/marvell/cesa.c
> @@ -420,7 +420,7 @@ static int mv_cesa_probe(struct platform_device *pdev)
>  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
>  	cesa->regs = devm_ioremap_resource(dev, res);
>  	if (IS_ERR(cesa->regs))
> -		return -ENOMEM;
> +		return PTR_ERR(cesa->regs);
>  
>  	ret = mv_cesa_dev_dma_init(cesa);
>  	if (ret)



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
