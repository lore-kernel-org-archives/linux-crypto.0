From: Gary R Hook <ghook@amd.com>
Subject: Re: [PATCH] crypto: constify ccp_actions structure
Date: Mon, 2 May 2016 08:58:34 -0500
Message-ID: <57275D0A.3030208@amd.com>
References: <1462103575-21705-1-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	<kernel-janitors@vger.kernel.org>, Gary Hook <gary.hook@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	<linux-kernel@vger.kernel.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>, <linux-crypto@vger.kernel.org>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1462103575-21705-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 05/01/2016 06:52 AM, Julia Lawall wrote:
> The ccp_actions structure is never modified, so declare it as const.
>
> Done with the help of Coccinelle.
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Acked-by: Gary Hook <gary.hook@amd.com>

> ---
>   drivers/crypto/ccp/ccp-dev-v3.c |    2 +-
>   drivers/crypto/ccp/ccp-dev.h    |    2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
> index 597fc50..d7a7103 100644
> --- a/drivers/crypto/ccp/ccp-dev-v3.c
> +++ b/drivers/crypto/ccp/ccp-dev-v3.c
> @@ -526,7 +526,7 @@ static irqreturn_t ccp_irq_handler(int irq, void *data)
>   	return IRQ_HANDLED;
>   }
>   
> -static struct ccp_actions ccp3_actions = {
> +static const struct ccp_actions ccp3_actions = {
>   	.perform_aes = ccp_perform_aes,
>   	.perform_xts_aes = ccp_perform_xts_aes,
>   	.perform_sha = ccp_perform_sha,
> diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
> index 5d986c9..bd41ffce 100644
> --- a/drivers/crypto/ccp/ccp-dev.h
> +++ b/drivers/crypto/ccp/ccp-dev.h
> @@ -162,7 +162,7 @@ struct ccp_actions {
>   /* Structure to hold CCP version-specific values */
>   struct ccp_vdata {
>   	unsigned int version;
> -	struct ccp_actions *perform;
> +	const struct ccp_actions *perform;
>   };
>   
>   extern struct ccp_vdata ccpv3;
>

