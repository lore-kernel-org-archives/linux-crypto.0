From: Gupta Ruchika-R66431 <R66431@freescale.com>
Subject: RE: [PATCH] crypto: remove double execution of the same test suite
Date: Fri, 19 Jul 2013 06:52:43 +0000
Message-ID: <B2B5EF0D8FDD10429C8DE6C4C2B38282093EE905@039-SN2MPN1-022.039d.mgd.msft.net>
References: <1374163027-17201-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Geanta Neag Horia Ioan-B05471 <B05471@freescale.com>,
	Stoica Cristian-B18196 <B18196@freescale.com>
To: Stoica Cristian-B18196 <B18196@freescale.com>,
	"herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:10421
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759681Ab3GSGwr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Jul 2013 02:52:47 -0400
In-Reply-To: <1374163027-17201-1-git-send-email-cristian.stoica@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Reviewed-by: Ruchika Gupta <ruchika.gupta@freescale.com>

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
> owner@vger.kernel.org] On Behalf Of Cristian Stoica
> Sent: Thursday, July 18, 2013 9:27 PM
> To: herbert@gondor.hengli.com.au
> Cc: davem@davemloft.net; linux-crypto@vger.kernel.org; linux-
> kernel@vger.kernel.org; Geanta Neag Horia Ioan-B05471; Stoica Cristian-
> B18196
> Subject: [PATCH] crypto: remove double execution of the same test suite
> 
> This patch removes redundant execution of the same test suite in cases where
> alg and driver variables are the same (e.g. when alg_test is called from
> tcrypt_test)
> 
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
> ---
>  crypto/testmgr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c index 2f00607..e091ef6
> 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -3234,7 +3234,7 @@ int alg_test(const char *driver, const char *alg, u32
> type, u32 mask)
>  	if (i >= 0)
>  		rc |= alg_test_descs[i].test(alg_test_descs + i, driver,
>  					     type, mask);
> -	if (j >= 0)
> +	if (j >= 0 && j != i)
>  		rc |= alg_test_descs[j].test(alg_test_descs + j, driver,
>  					     type, mask);
> 
> --
> 1.8.1.5
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
