From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH] crypto: caam - fix job ring cleanup code
Date: Wed, 27 Feb 2013 18:07:47 +0200
Message-ID: <512E2F53.7030305@freescale.com>
References: <1357815971-31462-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: Vakul Garg <vakul@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:20136
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993Ab3B0QH5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Feb 2013 11:07:57 -0500
Received: from mail153-ch1 (localhost [127.0.0.1])	by
 mail153-ch1-R.bigfish.com (Postfix) with ESMTP id 5C9DC2400F5	for
 <linux-crypto@vger.kernel.org>; Wed, 27 Feb 2013 16:07:56 +0000 (UTC)
Received: from CH1EHSMHS008.bigfish.com (snatpool2.int.messaging.microsoft.com
 [10.43.68.236])	by mail153-ch1.bigfish.com (Postfix) with ESMTP id
 4DD9E380043	for <linux-crypto@vger.kernel.org>; Wed, 27 Feb 2013 16:07:54
 +0000 (UTC)
In-Reply-To: <1357815971-31462-1-git-send-email-vakul@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 1/10/2013 1:06 PM, Vakul Garg wrote:
> The job ring init function creates a platform device for each job ring.
> While the job ring is shutdown, e.g. while module removal, its platform
> device was not being removed. This lead to failure while reinserting
> caam module again. Same problem appears while platform device for caam
> is bound, unbound and then bound again to caam platform driver.
>
> Signed-off-by: Vakul Garg <vakul@freescale.com>
> Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>

Not sure I understand the commit message. You seem to explain there are 
two problems, but I see only one: caam module being reinserted.

I guess a stack traceback in the commit message wouldn't hurt.

Regards,
Horia
