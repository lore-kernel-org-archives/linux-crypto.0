From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH] crypto: mv_cesa: remove NO_IRQ reference
Date: Sat, 3 Sep 2016 08:54:27 +0200
Message-ID: <20160903085427.1e0285de@bbrezillon>
References: <20160902232648.2119621-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Romain Perier <romain.perier@free-electrons.com>,
        Arnaud Ebalard <arno@natisbad.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160902232648.2119621-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat,  3 Sep 2016 01:26:40 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> Drivers should not use NO_IRQ, as we are trying to get rid of that.
> In this case, the call to irq_of_parse_and_map() is both wrong
> (as it returns '0' on failure, not NO_IRQ) and unnecessary
> (as platform_get_irq() does the same thing)
> 
> This removes the call to irq_of_parse_and_map() and checks for
> the error code correctly.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> ---
>  drivers/crypto/mv_cesa.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> It would be good if someone could test this on a machine that boots
> from DT to ensure the conversion was correct.
> 
> diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
> index e6b658faef63..104e9ce9400a 100644
> --- a/drivers/crypto/mv_cesa.c
> +++ b/drivers/crypto/mv_cesa.c
> @@ -1091,11 +1091,8 @@ static int mv_probe(struct platform_device *pdev)
>  
>  	cp->max_req_size = cp->sram_size - SRAM_CFG_SPACE;
>  
> -	if (pdev->dev.of_node)
> -		irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
> -	else
> -		irq = platform_get_irq(pdev, 0);
> -	if (irq < 0 || irq == NO_IRQ) {
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
>  		ret = irq;
>  		goto err;
>  	}
