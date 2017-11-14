From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] crypto/nx: fix spelling mistake: "availavle" ->
 "available"
Date: Tue, 14 Nov 2017 14:45:08 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1711141444320.2874@hadrien>
References: <20171114133346.17697-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Haren Myneni <haren@us.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20171114133346.17697-1-colin.king@canonical.com>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On Tue, 14 Nov 2017, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
>
> Trivial fix to spelling mistake in pr_err error message text
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/crypto/nx/nx-842-powernv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
> index f2246a5abcf6..9c01d11f255a 100644
> --- a/drivers/crypto/nx/nx-842-powernv.c
> +++ b/drivers/crypto/nx/nx-842-powernv.c
> @@ -744,7 +744,7 @@ static int nx842_open_percpu_txwins(void)
>
>  		if (!per_cpu(cpu_txwin, i)) {
>  			/* shoudn't happen, Each chip will have NX engine */

It could be nice to fix the comment as well: shoud -> should

julia

> -			pr_err("NX engine is not availavle for CPU %d\n", i);
> +			pr_err("NX engine is not available for CPU %d\n", i);
>  			return -EINVAL;
>  		}
>  	}
> --
> 2.14.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
