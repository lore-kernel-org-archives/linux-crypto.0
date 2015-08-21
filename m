From: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@freescale.com>
Subject: Re: [PATCH 4/4] crypto: caam: ctrl: Use devm_kcalloc()
Date: Fri, 21 Aug 2015 18:42:53 +0300
Message-ID: <55D746FD.8090200@freescale.com>
References: <1440168570-13635-1-git-send-email-festevam@gmail.com>
 <1440168570-13635-4-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <vicki.milhoan@freescale.com>, <linux-crypto@vger.kernel.org>,
	"Fabio Estevam" <fabio.estevam@freescale.com>
To: Fabio Estevam <festevam@gmail.com>, <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0118.outbound.protection.outlook.com ([157.56.110.118]:17488
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752177AbbHUPnK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Aug 2015 11:43:10 -0400
In-Reply-To: <1440168570-13635-4-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 8/21/2015 5:49 PM, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
>>From Documentation/CodingStyle:
> 
> "The preferred form for allocating a zeroed array is the following:
> 
> 	p = kcalloc(n, sizeof(...), ...); "
> 
> , so do as suggested.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

While here, you could also address the following:
drivers/crypto/caam/caamalg.c:4317
drivers/crypto/caam/caamhash.c:1844
drivers/crypto/caam/caamrng.c:354
drivers/crypto/caam/jr.c:413
drivers/crypto/caam/jr.c:418
drivers/crypto/caam/jr.c:423
drivers/crypto/caam/jr.c:482
(and any other place that I might've missed).

Since related, I guess the changes (3/4, 4/4 and above) could live in a
single patch.

Thanks,
Horia
