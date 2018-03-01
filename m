From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [PATCH 3/3] crypto: ccp - protect RSA implementation from too
 large input data
Date: Wed, 28 Feb 2018 18:35:07 -0600
Message-ID: <49db7800-b052-79e8-8d8d-24ddc6382e48@amd.com>
References: <4af6c02f-db3f-3d82-9685-367913c684ff@maciej.szmigiero.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Howells <dhowells@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4af6c02f-db3f-3d82-9685-367913c684ff@maciej.szmigiero.name>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 02/24/2018 10:03 AM, Maciej S. Szmigiero wrote:
> CCP RSA implementation uses a hardware input buffer which size depends only
> on the current RSA key length. Key modulus and a message to be processed
> is then copied to this buffer based on their own lengths.
> 
> Since the price for providing too long input data is a buffer overflow and
> there already has been a case when this has happened let's better reject
> such oversized input data and log an error message in this case so we know
> what is going on.
> 
> Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
> ---
>   drivers/crypto/ccp/ccp-ops.c | 24 ++++++++++++++++++++----
>   1 file changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index 406b95329b3d..517aeee30abf 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -1770,10 +1770,6 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>   	if (!rsa->exp || !rsa->mod || !rsa->src || !rsa->dst)
>   		return -EINVAL;
>   
> -	memset(&op, 0, sizeof(op));
> -	op.cmd_q = cmd_q;
> -	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
> -
>   	/* The RSA modulus must precede the message being acted upon, so
>   	 * it must be copied to a DMA area where the message and the
>   	 * modulus can be concatenated.  Therefore the input buffer
> @@ -1785,6 +1781,26 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>   	o_len = 32 * ((rsa->key_size + 255) / 256);
>   	i_len = o_len * 2;
>   
> +	if (rsa->mod_len > o_len) {
> +		dev_err(cmd_q->ccp->dev,
> +			"RSA modulus of %u bytes too large for key size of %u bits\n",
> +			(unsigned int)rsa->mod_len,
> +			(unsigned int)rsa->key_size);
> +		return -EINVAL;
> +	}
> +
> +	if (rsa->src_len > o_len) {
> +		dev_err(cmd_q->ccp->dev,
> +			"RSA data of %u bytes too large for key size of %u bits\n",
> +			(unsigned int)rsa->src_len,
> +			(unsigned int)rsa->key_size);
> +		return -EINVAL;
> +	}

We've talked about this, and we believe that a more central fix is 
warranted. I intend to post another patch tomorrow that should address
this problem.

> +
> +	memset(&op, 0, sizeof(op));
> +	op.cmd_q = cmd_q;
> +	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
> +
>   	sb_count = 0;
>   	if (cmd_q->ccp->vdata->version < CCP_VERSION(5, 0)) {
>   		/* sb_count is the number of storage block slots required
> 
