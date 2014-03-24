From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH v3] crypto: caam - power management support for caam job-ring
Date: Mon, 24 Mar 2014 14:33:24 +0200
Message-ID: <53302614.7040804@freescale.com>
References: <1395341456-60542-1-git-send-email-yashpal.dutta@freescale.com> <1395505456.2770.70.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ben Hutchings <ben@decadent.org.uk>,
	<linux-crypto@vger.kernel.org>, <vakul@freescale.com>,
	<ruchika.gupta@freescale.com>, <stable@vger.kernel.org>
To: Yashpal Dutta <yashpal.dutta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:12675
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752754AbaCXMdm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Mar 2014 08:33:42 -0400
In-Reply-To: <1395505456.2770.70.camel@deadeye.wl.decadent.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 3/22/2014 6:24 PM, Ben Hutchings wrote:
> On Fri, 2014-03-21 at 00:35 +0545, Yashpal Dutta wrote:
>> Job ring is suspended gracefully and resume afresh.
>>
>> Both Sleep (where device will remain powered-on) and Deep-sleep (where
>> device will be powered-down are handled gracefully. Persistance sessions
>> are not supported across deep-sleep.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Yashpal Dutta <yashpal.dutta@freescale.com>
>> ---
>>   drivers/crypto/caam/intern.h |   2 +
>>   drivers/crypto/caam/jr.c     | 257 +++++++++++++++++++++++++++++++------------
>>   2 files changed, 190 insertions(+), 69 deletions(-)
> [...]
>
> This is too big for stable; is a simpler fix possible?
>

Besides size, I'd also question whether this is a bug fix or a feature.
 From Documentation/stable_kernel_rules.txt:
  - It must fix a problem that causes a build error (but not for things
    marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
    security issue, or some "oh, that's not good" issue.  In short,
something critical.

On top of that - does it apply cleanly && has it been tested with 
-stable kernels?

Regards,
Horia
