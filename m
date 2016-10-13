From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 2/6] crypto: ccp - Remove unneeded sign-extension support
Date: Thu, 13 Oct 2016 14:57:29 -0500
Message-ID: <540d7690-1a2b-173c-3a54-99c24ee1935f@amd.com>
References: <20161013144542.19759.6924.stgit@taos>
 <20161013145300.19759.14061.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: Gary R Hook <gary.hook@amd.com>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0079.outbound.protection.outlook.com ([104.47.42.79]:21017
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753761AbcJNDfO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2016 23:35:14 -0400
In-Reply-To: <20161013145300.19759.14061.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/13/2016 09:53 AM, Gary R Hook wrote:
> The reverse-get/set functions can be simplified by
> eliminating unused code.
> 
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>
> ---
>  drivers/crypto/ccp/ccp-ops.c |  145 +++++++++++++++++-------------------------
>  1 file changed, 59 insertions(+), 86 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index 8fedb14..82cc637 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -198,62 +198,46 @@ static void ccp_get_dm_area(struct ccp_dm_workarea *wa, unsigned int wa_offset,
>  }
>  
>  static int ccp_reverse_set_dm_area(struct ccp_dm_workarea *wa,
> +				   unsigned int wa_offset,
>  				   struct scatterlist *sg,
> -				   unsigned int len, unsigned int se_len,
> -				   bool sign_extend)
> +				   unsigned int sg_offset,
> +				   unsigned int len)
>  {
> -	unsigned int nbytes, sg_offset, dm_offset, sb_len, i;
> -	u8 buffer[CCP_REVERSE_BUF_SIZE];
> -
> -	if (WARN_ON(se_len > sizeof(buffer)))
> -		return -EINVAL;
> -
> -	sg_offset = len;
> -	dm_offset = 0;
> -	nbytes = len;
> -	while (nbytes) {
> -		sb_len = min_t(unsigned int, nbytes, se_len);
> -		sg_offset -= sb_len;
> -
> -		scatterwalk_map_and_copy(buffer, sg, sg_offset, sb_len, 0);
> -		for (i = 0; i < sb_len; i++)
> -			wa->address[dm_offset + i] = buffer[sb_len - i - 1];
> -
> -		dm_offset += sb_len;
> -		nbytes -= sb_len;
> -
> -		if ((sb_len != se_len) && sign_extend) {
> -			/* Must sign-extend to nearest sign-extend length */
> -			if (wa->address[dm_offset - 1] & 0x80)
> -				memset(wa->address + dm_offset, 0xff,
> -				       se_len - sb_len);
> -		}
> +	u8 *p, *q;
> +
> +	ccp_set_dm_area(wa, wa_offset, sg, sg_offset, len);
> +
> +	p = wa->address + wa_offset;
> +	q = p + len - 1;
> +	while (p < q) {
> +		*p = *p ^ *q;
> +		*q = *p ^ *q;
> +		*p = *p ^ *q;
> +		p++;
> +		q--;
>  	}
> -
>  	return 0;
>  }
>  
>  static void ccp_reverse_get_dm_area(struct ccp_dm_workarea *wa,
> +				    unsigned int wa_offset,
>  				    struct scatterlist *sg,
> +				    unsigned int sg_offset,
>  				    unsigned int len)
>  {
> -	unsigned int nbytes, sg_offset, dm_offset, sb_len, i;
> -	u8 buffer[CCP_REVERSE_BUF_SIZE];
> -
> -	sg_offset = 0;
> -	dm_offset = len;
> -	nbytes = len;
> -	while (nbytes) {
> -		sb_len = min_t(unsigned int, nbytes, sizeof(buffer));
> -		dm_offset -= sb_len;
> -
> -		for (i = 0; i < sb_len; i++)
> -			buffer[sb_len - i - 1] = wa->address[dm_offset + i];
> -		scatterwalk_map_and_copy(buffer, sg, sg_offset, sb_len, 1);
> -
> -		sg_offset += sb_len;
> -		nbytes -= sb_len;
> +	u8 *p, *q;
> +
> +	p = wa->address + wa_offset;
> +	q = p + len - 1;
> +	while (p < q) {
> +		*p = *p ^ *q;
> +		*q = *p ^ *q;
> +		*p = *p ^ *q;
> +		p++;
> +		q--;
>  	}
> +
> +	ccp_get_dm_area(wa, wa_offset, sg, sg_offset, len);
>  }
>  
>  static void ccp_free_data(struct ccp_data *data, struct ccp_cmd_queue *cmd_q)
> @@ -1294,7 +1278,9 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>  	struct ccp_data dst;
>  	struct ccp_op op;
>  	unsigned int sb_count, i_len, o_len;
> -	int ret;
> +	unsigned int dm_offset;
> +	int i = 0;

Is "dm_offset" and "i" used anywhere?  I don't see them used in this
function...

> +	int ret = 0;

No need to change this, is there?

Thanks,
Tom
