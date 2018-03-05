From: Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH 2/4] crypto: omap-sham - Fix misleading indentation
Date: Mon, 5 Mar 2018 10:59:29 +0200
Message-ID: <fe1ae684-9f16-e31e-c88e-3e9df083e012@ti.com>
References: <1519937413-24468-1-git-send-email-krzk@kernel.org>
 <1519937413-24468-2-git-send-email-krzk@kernel.org>
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
In-Reply-To: <1519937413-24468-2-git-send-email-krzk@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 01/03/18 22:50, Krzysztof Kozlowski wrote:
> Commit 8043bb1ae03c ("crypto: omap-sham - convert driver logic to use
> sgs for data xmit") removed the if() clause leaving the statement as is.
> The intention was in that case to finish the request always so the goto
> instruction seems sensible.
> 
> Remove the indentation to fix Smatch warning:
>      drivers/crypto/omap-sham.c:1761 omap_sham_done_task() warn: inconsistent indenting
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

Acked-by: Tero Kristo <t-kristo@ti.com>

> ---
>   drivers/crypto/omap-sham.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
> index 7650b1b449bb..6cb6ab6f52c0 100644
> --- a/drivers/crypto/omap-sham.c
> +++ b/drivers/crypto/omap-sham.c
> @@ -1758,7 +1758,7 @@ static void omap_sham_done_task(unsigned long data)
>   		if (test_and_clear_bit(FLAGS_OUTPUT_READY, &dd->flags)) {
>   			/* hash or semi-hash ready */
>   			clear_bit(FLAGS_DMA_READY, &dd->flags);
> -				goto finish;
> +			goto finish;
>   		}
>   	}
>   
> 

--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
