From: Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 3/5] crypto: sunxi-ss: fix dev_dbg()
 output type
Date: Thu, 24 Dec 2015 13:56:25 +0100
Message-ID: <567BEB79.7050201@gmail.com>
References: <1450787267-26836-1-git-send-email-andre.przywara@arm.com>
 <1450787267-26836-4-git-send-email-andre.przywara@arm.com>
Reply-To: clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: marc.zyngier-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org,
 linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
 "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andre Przywara <andre.przywara-5wv7dgnIgG8@public.gmane.org>,
 Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
 Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org
Return-path: <linux-sunxi+bncBD7YLCN32UNBBCOX56ZQKGQEAUYRJ3A-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1450787267-26836-4-git-send-email-andre.przywara-5wv7dgnIgG8@public.gmane.org>
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

Le 22/12/2015 13:27, Andre Przywara a =C3=A9crit :
> The length parameter in this dev_dbg() call is actually a size_t,
> so use the proper type to avoid warnings when compiling for 64-bit
> architectures.
>=20
> Signed-off-by: Andre Przywara <andre.przywara-5wv7dgnIgG8@public.gmane.org>
> ---
>  drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/s=
unxi-ss/sun4i-ss-cipher.c
> index b3bc7bd..af2690c 100644
> --- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> +++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> @@ -251,7 +251,7 @@ static int sun4i_ss_cipher_poll(struct ablkcipher_req=
uest *areq)
>  		spaces =3D readl(ss->base + SS_FCSR);
>  		rx_cnt =3D SS_RXFIFO_SPACES(spaces);
>  		tx_cnt =3D SS_TXFIFO_SPACES(spaces);
> -		dev_dbg(ss->dev, "%x %u/%u %u/%u cnt=3D%u %u/%u %u/%u cnt=3D%u %u %u\n=
",
> +		dev_dbg(ss->dev, "%x %u/%zu %u/%u cnt=3D%u %u/%zu %u/%u cnt=3D%u %u %u=
\n",
>  			mode,
>  			oi, mi.length, ileft, areq->nbytes, rx_cnt,
>  			oo, mo.length, oleft, areq->nbytes, tx_cnt,
>=20

Acked-by: LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--=20
You received this message because you are subscribed to the Google Groups "=
linux-sunxi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to linux-sunxi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit https://groups.google.com/d/optout.
