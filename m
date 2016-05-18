From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [patch] crypto: omap-sham - potential Oops on error in probe
Date: Wed, 18 May 2016 13:42:36 +0300
Message-ID: <21712178-666f-e2e2-24f3-fb0c513acc83@ti.com>
References: <20160518103905.GA10470@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "David S. Miller" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20160518103905.GA10470@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 05/18/16 13:39, Dan Carpenter wrote:
> This if statement is reversed so we end up either leaking or Oopsing =
on
> error.

Oops, sorry for that.
Probably the other omap-* crypto drivers have the same issue? Can you s=
end a
patch for them or should I do it?

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> Fixes: dbe246209bc1 ('crypto: omap-sham - Use dma_request_chan() for =
requesting DMA channel')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>=20
> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
> index 6eefaa2..63464e8 100644
> --- a/drivers/crypto/omap-sham.c
> +++ b/drivers/crypto/omap-sham.c
> @@ -1986,7 +1986,7 @@ err_algs:
>  					&dd->pdata->algs_info[i].algs_list[j]);
>  err_pm:
>  	pm_runtime_disable(dev);
> -	if (dd->polling_mode)
> +	if (!dd->polling_mode)
>  		dma_release_channel(dd->dma_lch);
>  data_err:
>  	dev_err(dev, "initialization failed.\n");
>=20


--=20
P=E9ter
--
To unsubscribe from this list: send the line "unsubscribe kernel-janito=
rs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
