From: Horia Geanta <horia.geanta@freescale.com>
Subject: Re: [PATCHv1] crypto-caam: added entry for P5040 in SEC-VID to SEC-ERA
 mapping table.
Date: Tue, 18 Sep 2012 12:18:28 +0300
Message-ID: <50583C64.9080908@freescale.com>
References: <1347867189-23716-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: Vakul Garg <vakul@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:56121
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755145Ab2IRJSU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Sep 2012 05:18:20 -0400
Received: from mail101-co1 (localhost [127.0.0.1])	by
 mail101-co1-R.bigfish.com (Postfix) with ESMTP id C8B3B3C016F	for
 <linux-crypto@vger.kernel.org>; Tue, 18 Sep 2012 09:18:19 +0000 (UTC)
Received: from CO1EHSMHS009.bigfish.com (unknown [10.243.78.240])	by
 mail101-co1.bigfish.com (Postfix) with ESMTP id 0FA825800B6	for
 <linux-crypto@vger.kernel.org>; Tue, 18 Sep 2012 09:18:18 +0000 (UTC)
In-Reply-To: <1347867189-23716-1-git-send-email-vakul@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 9/17/2012 10:33 AM, Vakul Garg wrote:
> On P5040, SEC-ERA does not print correctly. This is because SEC-VID to SEC-ERA
> mapping table does not contain information for P5040. This patch adds this
> information.
>
> Signed-off-by: Vakul Garg <vakul@freescale.com>
> ---

Please update the patch with the details provided by the HW design team.
Note that if you're adding details for SEC 6.x, you'll need to update 
the patch subject and description accordingly.

Thanks,
Horia

> Please ignore my previous patch which contained internal release prefixes.
>
>   drivers/crypto/caam/ctrl.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> index 414ba20..97ebf55 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -176,7 +176,8 @@ int caam_get_era(u64 caam_id)
>   		{0x0A14, 1, 3},
>   		{0x0A14, 2, 4},
>   		{0x0A16, 1, 4},
> -		{0x0A11, 1, 4}
> +		{0x0A11, 1, 4},
> +		{0x0A13, 1, 5}
>   	};
>   	int i;
>
>
