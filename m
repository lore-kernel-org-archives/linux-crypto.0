From: Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH 1/4] crypto: omap-sham: Remove useless check for non-null
 request
Date: Mon, 5 Mar 2018 10:58:57 +0200
Message-ID: <4062df04-e605-60c1-0cab-2d519efdc4b1@ti.com>
References: <1519937413-24468-1-git-send-email-krzk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
To: Krzysztof Kozlowski <krzk@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1519937413-24468-1-git-send-email-krzk@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 01/03/18 22:50, Krzysztof Kozlowski wrote:
> ahash_request 'req' argument passed by the caller
> omap_sham_handle_queue() cannot be NULL here because it is obtained from
> non-NULL pointer via container_of().
> 
> This fixes smatch warning:
>      drivers/crypto/omap-sham.c:812 omap_sham_prepare_request() warn: variable dereferenced before check 'req' (see line 805)
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

Acked-by: Tero Kristo <t-kristo@ti.com>

> ---
>   drivers/crypto/omap-sham.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
> index 86b89ace836f..7650b1b449bb 100644
> --- a/drivers/crypto/omap-sham.c
> +++ b/drivers/crypto/omap-sham.c
> @@ -809,9 +809,6 @@ static int omap_sham_prepare_request(struct ahash_request *req, bool update)
>   	bool final = rctx->flags & BIT(FLAGS_FINUP);
>   	int xmit_len, hash_later;
>   
> -	if (!req)
> -		return 0;
> -
>   	bs = get_block_size(rctx);
>   
>   	if (update)
> 

--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
