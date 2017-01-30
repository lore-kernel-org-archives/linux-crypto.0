From: Gary R Hook <ghook@amd.com>
Subject: Re: [PATCH 2/4] crypto: ccp - Set the start-of-command bit
Date: Mon, 30 Jan 2017 11:59:23 -0600
Message-ID: <a8e26c2b-2311-0d51-edc7-101034067b6e@amd.com>
References: <20170130142414.8459.71539.stgit@taos>
 <20170130142834.8459.15278.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
To: Gary R Hook <gary.hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0077.outbound.protection.outlook.com ([104.47.40.77]:49671
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751406AbdA3R7x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Jan 2017 12:59:53 -0500
In-Reply-To: <20170130142834.8459.15278.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It turns out that this change will negatively impact performance. Please 
ignore.
I will submit a V2 patch set.

On 01/30/2017 08:28 AM, Gary R Hook wrote:
> The start-of-command bit should be set for every sha
> operation.
>
> Signed-off-by: Gary R Hook <gary.hook@amd.com>
> ---
>  drivers/crypto/ccp/ccp-ops.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index 50fae44..1a27af3 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -1077,6 +1077,7 @@ static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>  		case CCP_SHA_TYPE_1:
>  		case CCP_SHA_TYPE_224:
>  		case CCP_SHA_TYPE_256:
> +			op.soc = 1;
>  			memcpy(ctx.address + ioffset, init, ctx_size);
>  			break;
>  		default:
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
This is my day job. Follow me at:
IG/Twitter/Facebook: @grhookphoto
IG/Twitter/Facebook: @grhphotographer
