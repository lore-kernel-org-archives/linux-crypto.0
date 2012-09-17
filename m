From: Garg Vakul-B16394 <B16394@freescale.com>
Subject: RE: [PATCH][1.3][SEC] Added entry for P5040 in SEC-VID to SEC-ERA
 mapping table.
Date: Mon, 17 Sep 2012 08:32:11 +0000
Message-ID: <065BBB7616BCE543832A2EF096986B940F4F87@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1347866443-22469-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Garg Vakul-B16394 <B16394@freescale.com>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:16880
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754940Ab2IQIcR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Sep 2012 04:32:17 -0400
Received: from mail103-co1 (localhost [127.0.0.1])	by
 mail103-co1-R.bigfish.com (Postfix) with ESMTP id 26BBB560163	for
 <linux-crypto@vger.kernel.org>; Mon, 17 Sep 2012 08:32:17 +0000 (UTC)
Received: from CO1EHSMHS026.bigfish.com (unknown [10.243.78.249])	by
 mail103-co1.bigfish.com (Postfix) with ESMTP id B3D1C18005C	for
 <linux-crypto@vger.kernel.org>; Mon, 17 Sep 2012 08:32:14 +0000 (UTC)
In-Reply-To: <1347866443-22469-1-git-send-email-vakul@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Please ignore this patch.
I have sent another patch which supersedes this.


> -----Original Message-----
> From: Garg Vakul-B16394
> Sent: Monday, September 17, 2012 12:51 PM
> To: linux-crypto@vger.kernel.org
> Cc: Garg Vakul-B16394
> Subject: [PATCH][1.3][SEC] Added entry for P5040 in SEC-VID to SEC-ERA
> mapping table.
> 
> On P5040, SEC-ERA does not print correctly. This is because SEC-VID to
> SEC-ERA mapping table does not contain information for P5040. This patch
> adds this information.
> 
> Signed-off-by: Vakul Garg <vakul@freescale.com>
> ---
>  drivers/crypto/caam/ctrl.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> index b3fecfa..81ed4bc 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -176,7 +176,8 @@ int caam_get_era(u64 caam_id)
>  		{0x0A14, 1, 3},
>  		{0x0A14, 2, 4},
>  		{0x0A16, 1, 4},
> -		{0x0A11, 1, 4}
> +		{0x0A11, 1, 4},
> +		{0x0A13, 1, 5}
>  	};
>  	int i;
> 
> --
> 1.7.7.6
