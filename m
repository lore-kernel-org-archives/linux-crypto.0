From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: Re: [PATCH] crypto: atmel: fix 64-bit warnings
Date: Tue, 17 Nov 2015 12:21:54 +0100
Message-ID: <564B0DD2.5040103@atmel.com>
References: <4444008.DmhAgm3J77@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "David S. Miller" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>,
	Leilei Zhao <leilei.zhao@atmel.com>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	Nicolas Royer <nicolas@eukrea.com>,
	<linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
To: Arnd Bergmann <arnd@arndb.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4444008.DmhAgm3J77@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Arnd,

I add my Acked-by to your patch.
By the way, I'm currently reworking this whole driver. So I take your
modifications into account for the new version as many parts of the sou=
rce code
such as the part dealing with DMA transfers have changed a lot.

The new version fixes the 16 or 32bit counter overflow for the CTR mode=
,
adds support to the GCM mode and should increase the global performance=
s
(the work is still in progress). For the GCM mode, it relies on the lat=
est
updates from Herbert in linux-next to AEAD algorithms.
The tcrypt module was used to validate the new implementation of CTR an=
d GCM
modes.


Updates in the Atmel SHA driver are also likely to follow.

Thanks for your contribution!

Best regards,

Cyrille

Le 17/11/2015 10:22, Arnd Bergmann a =E9crit :
> The atmel AES driver assumes that 'int' and 'size_t' are the same
> type in multiple locations, which the compiler warns about when
> building it for 64-bit systems:
>=20
> In file included from ../drivers/crypto/atmel-aes.c:17:0:
> drivers/crypto/atmel-aes.c: In function 'atmel_aes_sg_copy':
> include/linux/kernel.h:724:17: warning: comparison of distinct pointe=
r types lacks a cast
> drivers/crypto/atmel-aes.c:448:11: note: in expansion of macro 'min'
>=20
> drivers/crypto/atmel-aes.c: In function 'atmel_aes_crypt_dma_stop':
> include/linux/kern_levels.h:4:18: warning: format '%u' expects argume=
nt of type 'unsigned int', but argument 2 has type 'size_t {aka long un=
signed int}' [-Wformat=3D]
>=20
> This changes the format strings to use the %z modifier when printing
> a size_t, and makes sure that we use the correct size_t type where
> needed. In case of sg_dma_len(), the type of the result depends
> on CONFIG_NEED_SG_DMA_LENGTH, so we have to use min_t to get it to
> work in all configurations.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
>=20
> diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
> index fb16d812c8f5..bfb1f799bf56 100644
> --- a/drivers/crypto/atmel-aes.c
> +++ b/drivers/crypto/atmel-aes.c
> @@ -184,7 +184,7 @@ static int atmel_aes_sg_length(struct ablkcipher_=
request *req,
>  static int atmel_aes_sg_copy(struct scatterlist **sg, size_t *offset=
,
>  			void *buf, size_t buflen, size_t total, int out)
>  {
> -	unsigned int count, off =3D 0;
> +	size_t count, off =3D 0;
> =20
>  	while (buflen && total) {
>  		count =3D min((*sg)->length - *offset, total);
> @@ -444,8 +444,8 @@ static int atmel_aes_crypt_dma_start(struct atmel=
_aes_dev *dd)
> =20
> =20
>  	if (fast)  {
> -		count =3D min(dd->total, sg_dma_len(dd->in_sg));
> -		count =3D min(count, sg_dma_len(dd->out_sg));
> +		count =3D min_t(size_t, dd->total, sg_dma_len(dd->in_sg));
> +		count =3D min_t(size_t, count, sg_dma_len(dd->out_sg));
> =20
>  		err =3D dma_map_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
>  		if (!err) {
> @@ -639,7 +639,7 @@ static int atmel_aes_crypt_dma_stop(struct atmel_=
aes_dev *dd)
>  				dd->buf_out, dd->buflen, dd->dma_size, 1);
>  			if (count !=3D dd->dma_size) {
>  				err =3D -EINVAL;
> -				pr_err("not all data converted: %u\n", count);
> +				pr_err("not all data converted: %zu\n", count);
>  			}
>  		}
>  	}
> @@ -666,7 +666,7 @@ static int atmel_aes_buff_init(struct atmel_aes_d=
ev *dd)
>  	dd->dma_addr_in =3D dma_map_single(dd->dev, dd->buf_in,
>  					dd->buflen, DMA_TO_DEVICE);
>  	if (dma_mapping_error(dd->dev, dd->dma_addr_in)) {
> -		dev_err(dd->dev, "dma %d bytes error\n", dd->buflen);
> +		dev_err(dd->dev, "dma %zd bytes error\n", dd->buflen);
>  		err =3D -EINVAL;
>  		goto err_map_in;
>  	}
> @@ -674,7 +674,7 @@ static int atmel_aes_buff_init(struct atmel_aes_d=
ev *dd)
>  	dd->dma_addr_out =3D dma_map_single(dd->dev, dd->buf_out,
>  					dd->buflen, DMA_FROM_DEVICE);
>  	if (dma_mapping_error(dd->dev, dd->dma_addr_out)) {
> -		dev_err(dd->dev, "dma %d bytes error\n", dd->buflen);
> +		dev_err(dd->dev, "dma %zd bytes error\n", dd->buflen);
>  		err =3D -EINVAL;
>  		goto err_map_out;
>  	}
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypt=
o" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
