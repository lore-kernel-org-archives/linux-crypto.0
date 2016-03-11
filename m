From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] crypto: ccp - Use different flag vars for nested locks
Date: Fri, 11 Mar 2016 17:01:34 -0600
Message-ID: <56E34E4E.6040504@amd.com>
References: <20160311163942.4791.47157.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: Gary R Hook <gary.hook@amd.com>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0085.outbound.protection.outlook.com ([157.56.110.85]:43900
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750980AbcCLAfD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Mar 2016 19:35:03 -0500
In-Reply-To: <20160311163942.4791.47157.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/11/2016 10:40 AM, Gary R Hook wrote:
> This patch fixes a coccinelle warning about reusing a flags
> variable in nested lock acquisition.
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/ccp-dev.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
> index 336e5b7..9c7bce8 100644
> --- a/drivers/crypto/ccp/ccp-dev.c
> +++ b/drivers/crypto/ccp/ccp-dev.c
> @@ -120,7 +120,7 @@ void ccp_del_device(struct ccp_device *ccp)
>  
>  static struct ccp_device *ccp_get_device(void)
>  {
> -	unsigned long flags;
> +	unsigned long flags, rrflags;
>  	struct ccp_device *dp = NULL;
>  
>  	/* We round-robin through the unit list.
> @@ -128,14 +128,14 @@ static struct ccp_device *ccp_get_device(void)
>  	 */
>  	read_lock_irqsave(&ccp_unit_lock, flags);
>  	if (!list_empty(&ccp_units)) {
> -		write_lock_irqsave(&ccp_rr_lock, flags);
> +		write_lock_irqsave(&ccp_rr_lock, rrflags);
>  		dp = ccp_rr;
>  		if (list_is_last(&ccp_rr->entry, &ccp_units))
>  			ccp_rr = list_first_entry(&ccp_units, struct ccp_device,
>  						  entry);
>  		else
>  			ccp_rr = list_next_entry(ccp_rr, entry);
> -		write_unlock_irqrestore(&ccp_rr_lock, flags);
> +		write_unlock_irqrestore(&ccp_rr_lock, rrflags);
>  	}
>  	read_unlock_irqrestore(&ccp_unit_lock, flags);
>  
> 
