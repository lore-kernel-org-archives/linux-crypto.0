From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH] crypto: caam - Fix job ring discovery in controller driver
Date: Fri, 7 Feb 2014 10:15:32 +0200
Message-ID: <52F49624.3070400@freescale.com>
References: <1390554205-19771-1-git-send-email-NiteshNarayanLal@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
To: Nitesh Lal <NiteshNarayanLal@freescale.com>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:9447 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751758AbaBGIPr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Feb 2014 03:15:47 -0500
Received: from mail56-va3 (localhost [127.0.0.1])	by mail56-va3-R.bigfish.com
 (Postfix) with ESMTP id 7C304360318	for <linux-crypto@vger.kernel.org>; Fri,
  7 Feb 2014 08:15:46 +0000 (UTC)
In-Reply-To: <1390554205-19771-1-git-send-email-NiteshNarayanLal@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 1/24/2014 11:03 AM, Nitesh Lal wrote:
> The SEC Controller driver creates platform devices for it's child job ring nodes.
> Currently the driver uses for_each_compatible routine which traverses
> the whole device tree to create the job rings for the platform device.
> The patch changes this to search for the compatible property of job ring
> only in the child nodes i.e., the job rings are created as per the number
> of children associated with the crypto node.
>
> Signed-off-by: Nitesh Lal <NiteshNarayanLal@freescale.com>
> ---
>   drivers/crypto/caam/ctrl.c | 25 ++++++-------------------
>   1 file changed, 6 insertions(+), 19 deletions(-)

Reviewed-by: Horia Geanta <horia.geanta@freescale.com>

Regards,
Horia
