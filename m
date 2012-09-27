From: Horia Geanta <horia.geanta@freescale.com>
Subject: Re: [PATCH 0/3] crypto: talitos fixes for 3.6-rc7
Date: Thu, 27 Sep 2012 11:42:15 +0300
Message-ID: <50641167.9010308@freescale.com>
References: <1348080820-22250-1-git-send-email-horia.geanta@freescale.com> <20120927052539.GA22160@gondor.apana.org.au> <506407EE.50406@freescale.com> <20120927081425.GB23122@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:4834
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751725Ab2I0Imb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Sep 2012 04:42:31 -0400
In-Reply-To: <20120927081425.GB23122@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 9/27/2012 11:14 AM, Herbert Xu wrote:
> On Thu, Sep 27, 2012 at 11:01:50AM +0300, Horia Geanta wrote:
>>
>> Again, this patch (e46e9a) is not the culprit, it merely exposes the
>> deficiencies in the talitos driver.
>> AFAICT, these cases (zero assoc data, noncontiguous iv and assoc
>> data) have never been handled correctly in the driver.
>
> OK, without the patches does the driver crash the self-test or
> merely fail the self-test?

It fails.
Crash occurs when setting the fips=1 boot param.
