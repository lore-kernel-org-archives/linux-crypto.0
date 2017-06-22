From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 4/4] crypto: ccp - Expand RSA support for a v5 ccp
Date: Thu, 22 Jun 2017 11:37:40 -0500
Message-ID: <3e10af8c-b4e8-c9a2-fd3b-f20b974d6580@amd.com>
References: <20170621224655.15132.20473.stgit@taos.amd.com>
 <20170621224810.15132.93382.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0063.outbound.protection.outlook.com ([104.47.34.63]:11080
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751156AbdFVQhq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2017 12:37:46 -0400
In-Reply-To: <20170621224810.15132.93382.stgit@taos.amd.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 6/21/2017 5:48 PM, Gary R Hook wrote:
> A V5 device can accommodate larger keys, as well as read the keys
> directly from memory instead of requiring them to be in a local
> storage block.

The previous patch already reads them from memory so just the first
part of this sentence is needed.

> 
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>
> ---
>   drivers/crypto/ccp/ccp-crypto-rsa.c |    5 ++++-
>   drivers/crypto/ccp/ccp-crypto.h     |    1 +
>   drivers/crypto/ccp/ccp-dev-v3.c     |    1 +
>   drivers/crypto/ccp/ccp-dev-v5.c     |    2 ++
>   drivers/crypto/ccp/ccp-dev.h        |    2 ++
>   drivers/crypto/ccp/ccp-ops.c        |    3 ++-
>   6 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-crypto-rsa.c b/drivers/crypto/ccp/ccp-crypto-rsa.c
> index 4a2a71463594..93e6b00ce34d 100644
> --- a/drivers/crypto/ccp/ccp-crypto-rsa.c
> +++ b/drivers/crypto/ccp/ccp-crypto-rsa.c
> @@ -43,7 +43,10 @@ static int ccp_rsa_complete(struct crypto_async_request *async_req, int ret)
>   
>   static unsigned int ccp_rsa_maxsize(struct crypto_akcipher *tfm)
>   {
> -	return CCP_RSA_MAXMOD;
> +	if (ccp_version() > CCP_VERSION(3, 0))
> +		return CCP5_RSA_MAXMOD;
> +	else
> +		return CCP_RSA_MAXMOD;

The ccp_check_key_length() function in this file has a hardcoded 4096
that should be changed to use vdata value.

Thanks,
Tom

>   }
>   
>   static int ccp_rsa_crypt(struct akcipher_request *req, bool encrypt)
> diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
> index 5d592ecc9af5..40598894113b 100644
> --- a/drivers/crypto/ccp/ccp-crypto.h
> +++ b/drivers/crypto/ccp/ccp-crypto.h
> @@ -255,6 +255,7 @@ struct ccp_rsa_req_ctx {
>   };
>   
>   #define	CCP_RSA_MAXMOD	(4 * 1024 / 8)
> +#define	CCP5_RSA_MAXMOD	(16 * 1024 / 8)
>   
>   /***** Common Context Structure *****/
>   struct ccp_ctx {
> diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
> index 367c2e30656f..9b159b0a891e 100644
> --- a/drivers/crypto/ccp/ccp-dev-v3.c
> +++ b/drivers/crypto/ccp/ccp-dev-v3.c
> @@ -592,4 +592,5 @@ static void ccp_destroy(struct ccp_device *ccp)
>   	.perform = &ccp3_actions,
>   	.bar = 2,
>   	.offset = 0x20000,
> +	.rsamax = CCP_RSA_MAX_WIDTH,
>   };
> diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
> index 632518efd685..6043552322fd 100644
> --- a/drivers/crypto/ccp/ccp-dev-v5.c
> +++ b/drivers/crypto/ccp/ccp-dev-v5.c
> @@ -1115,6 +1115,7 @@ static void ccp5other_config(struct ccp_device *ccp)
>   	.perform = &ccp5_actions,
>   	.bar = 2,
>   	.offset = 0x0,
> +	.rsamax = CCP5_RSA_MAX_WIDTH,
>   };
>   
>   const struct ccp_vdata ccpv5b = {
> @@ -1124,4 +1125,5 @@ static void ccp5other_config(struct ccp_device *ccp)
>   	.perform = &ccp5_actions,
>   	.bar = 2,
>   	.offset = 0x0,
> +	.rsamax = CCP5_RSA_MAX_WIDTH,
>   };
> diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
> index a70154ac7405..8242cf54d90f 100644
> --- a/drivers/crypto/ccp/ccp-dev.h
> +++ b/drivers/crypto/ccp/ccp-dev.h
> @@ -200,6 +200,7 @@
>   #define CCP_SHA_SB_COUNT		1
>   
>   #define CCP_RSA_MAX_WIDTH		4096
> +#define CCP5_RSA_MAX_WIDTH		16384
>   
>   #define CCP_PASSTHRU_BLOCKSIZE		256
>   #define CCP_PASSTHRU_MASKSIZE		32
> @@ -677,6 +678,7 @@ struct ccp_vdata {
>   	const struct ccp_actions *perform;
>   	const unsigned int bar;
>   	const unsigned int offset;
> +	const unsigned int rsamax;
>   };
>   
>   extern const struct ccp_vdata ccpv3;
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index 2cdd15a92178..ea5e4ede1eed 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -1737,7 +1737,8 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>   	unsigned int key_size_bytes;
>   	int ret;
>   
> -	if (rsa->key_size > CCP_RSA_MAX_WIDTH)
> +	/* Check against the maximum allowable size, in bits */
> +	if (rsa->key_size > cmd_q->ccp->vdata->rsamax)
>   		return -EINVAL;
>   
>   	if (!rsa->exp || !rsa->mod || !rsa->src || !rsa->dst)
> 
