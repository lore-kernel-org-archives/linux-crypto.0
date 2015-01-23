From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] crypto: ccp: terminate ccp_support array with empty element
Date: Fri, 23 Jan 2015 09:11:45 -0600
Message-ID: <54C264B1.5090508@amd.com>
References: <1421852791-29679-1-git-send-email-a.ryabinin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Ryabinin <a.ryabinin@samsung.com>,
	<linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"open list:AMD CRYPTOGRAPHIC..." <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0140.outbound.protection.outlook.com ([157.56.111.140]:16716
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752593AbbAWPML (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 Jan 2015 10:12:11 -0500
In-Reply-To: <1421852791-29679-1-git-send-email-a.ryabinin@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/21/2015 09:06 AM, Andrey Ryabinin wrote:
> x86_match_cpu() expects array of x86_cpu_ids terminated
> with empty element.
>
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   drivers/crypto/ccp/ccp-dev.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
> index c6e6171..ca29c12 100644
> --- a/drivers/crypto/ccp/ccp-dev.c
> +++ b/drivers/crypto/ccp/ccp-dev.c
> @@ -583,6 +583,7 @@ bool ccp_queues_suspended(struct ccp_device *ccp)
>   #ifdef CONFIG_X86
>   static const struct x86_cpu_id ccp_support[] = {
>   	{ X86_VENDOR_AMD, 22, },
> +	{ },
>   };
>   #endif
>
>
