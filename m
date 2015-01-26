From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH] crypto: omap: Free memory in error path
Date: Mon, 26 Jan 2015 06:45:23 +0100
Message-ID: <54C5D473.4060204@wanadoo.fr>
References: <1422250858-22516-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1422250858-22516-1-git-send-email-christophe.jaillet@wanadoo.fr>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Oups,

should be:
      free_pages((unsigned long)buf_out, pages);
      free_pages((unsigned long)buf_in, pages);


CJ

Le 26/01/2015 06:40, Christophe Jaillet a =E9crit :
> If only one of the 2 __get_free_pages fails, then there is a memory l=
eak
>
> Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
> ---
>   drivers/crypto/omap-aes.c | 2 ++
>   drivers/crypto/omap-des.c | 2 ++
>   2 files changed, 4 insertions(+)
>
> diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
> index f79dd41..c2f9333 100644
> --- a/drivers/crypto/omap-aes.c
> +++ b/drivers/crypto/omap-aes.c
> @@ -577,6 +577,8 @@ static int omap_aes_copy_sgs(struct omap_aes_dev =
*dd)
>   	buf_out =3D (void *)__get_free_pages(GFP_ATOMIC, pages);
>  =20
>   	if (!buf_in || !buf_out) {
> +		free_page((unsigned long)buf_out);
> +		free_page((unsigned long)buf_in);
>   		pr_err("Couldn't allocated pages for unaligned cases.\n");
>   		return -1;
>   	}
> diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
> index 0b8dcf5..a2f6ca1 100644
> --- a/drivers/crypto/omap-des.c
> +++ b/drivers/crypto/omap-des.c
> @@ -570,6 +570,8 @@ static int omap_des_copy_sgs(struct omap_des_dev =
*dd)
>   	buf_out =3D (void *)__get_free_pages(GFP_ATOMIC, pages);
>  =20
>   	if (!buf_in || !buf_out) {
> +		free_page((unsigned long)buf_out);
> +		free_page((unsigned long)buf_in);
>   		pr_err("Couldn't allocated pages for unaligned cases.\n");
>   		return -1;
>   	}

--
To unsubscribe from this list: send the line "unsubscribe kernel-janito=
rs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
