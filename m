From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH 00/10] CAAM - DMA API fixes
Date: Sat, 19 Jul 2014 03:07:20 +0300
Message-ID: <53C9B6B8.9070007@freescale.com>
References: <1405082095-30146-1-git-send-email-horia.geanta@freescale.com>
 <20140718180413.2f70940e9cbaa4605188c3c4@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	Vakul Garg <vakul@freescale.com>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:12666
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750790AbaGSAHa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Jul 2014 20:07:30 -0400
In-Reply-To: <20140718180413.2f70940e9cbaa4605188c3c4@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 7/19/2014 2:04 AM, Kim Phillips wrote:
> On Fri, 11 Jul 2014 15:34:45 +0300
> Horia Geanta <horia.geanta@freescale.com> wrote:
>
> Hi Horia,
>
>> Enabling DMA-API debugging reveals quite a lot of problems in CAAM module.
>> Patches below fix them - tested on P3041DS QorIQ platform. Please apply.
>
> In an attempt to try and test these patches on a t4240qds, I get:
>
> caam ffe300000.crypto: failed to acquire DECO 0
>
> even on the existing cryptodev master.  Any ideas?

Could you revert commit
17157c90a8abf9323ee2a3daac7ad9f696642dda
("crypto: caam - Configuration for platforms with virtualization enabled 
in CAAM")
and let me know whether things improve?

Thanks,
Horia
