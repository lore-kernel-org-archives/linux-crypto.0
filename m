From: leroy christophe <christophe.leroy@c-s.fr>
Subject: Re: [patch -next] crypto: talitos - fix size calculation in talitos_edesc_alloc()
Date: Mon, 11 May 2015 15:35:12 +0200
Message-ID: <5550B010.60008@c-s.fr>
References: <20150511101009.GA12395@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:53706 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbbEKNfP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 09:35:15 -0400
In-Reply-To: <20150511101009.GA12395@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



Le 11/05/2015 12:10, Dan Carpenter a =E9crit :
> The + operation has higher precedence than ?: so we need parentheses
> here.  Otherwise we may end up allocating a max of only one "cryptlen=
"
> instead of two.
>
> Fixes: 6f65f6ac5fb3 ('crypto: talitos - implement scatter/gather copy=
 for SEC1')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Christophe Leroy <christophe.leroy@c-s.fr>
>
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index c04074d..273942c 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -1335,8 +1335,8 @@ static struct talitos_edesc *talitos_edesc_allo=
c(struct device *dev,
>   	alloc_len =3D sizeof(struct talitos_edesc);
>   	if (assoc_nents || src_nents || dst_nents) {
>   		if (is_sec1)
> -			dma_len =3D src_nents ? cryptlen : 0 +
> -				  dst_nents ? cryptlen : 0;
> +			dma_len =3D (src_nents ? cryptlen : 0) +
> +				  (dst_nents ? cryptlen : 0);
>   		else
>   			dma_len =3D (src_nents + dst_nents + 2 + assoc_nents) *
>   				  sizeof(struct talitos_ptr) + authsize;
>
