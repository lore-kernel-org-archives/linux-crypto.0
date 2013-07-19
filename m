From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH] crypto: remove double execution of the same test suite
Date: Fri, 19 Jul 2013 09:48:47 +0300
Message-ID: <51E8E14F.8080603@freescale.com>
References: <1374163027-17201-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.hengli.com.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: Cristian Stoica <cristian.stoica@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:59678
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759633Ab3GSGtG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Jul 2013 02:49:06 -0400
In-Reply-To: <1374163027-17201-1-git-send-email-cristian.stoica@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 7/18/2013 6:57 PM, Cristian Stoica wrote:
> This patch removes redundant execution of the same test suite in cases
> where alg and driver variables are the same (e.g. when alg_test is
> called from tcrypt_test)
>
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>

Reviewed-by: Horia Geanta <horia.geanta@freescale.com>

> ---
>   crypto/testmgr.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 2f00607..e091ef6 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -3234,7 +3234,7 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
>   	if (i >= 0)
>   		rc |= alg_test_descs[i].test(alg_test_descs + i, driver,
>   					     type, mask);
> -	if (j >= 0)
> +	if (j >= 0 && j != i)
>   		rc |= alg_test_descs[j].test(alg_test_descs + j, driver,
>   					     type, mask);
>
>
