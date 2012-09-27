From: Horia Geanta <horia.geanta@freescale.com>
Subject: Re: [PATCH 0/3] crypto: talitos fixes for 3.6-rc7
Date: Thu, 27 Sep 2012 11:01:50 +0300
Message-ID: <506407EE.50406@freescale.com>
References: <1348080820-22250-1-git-send-email-horia.geanta@freescale.com> <20120927052539.GA22160@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:56039
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752288Ab2I0ICR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Sep 2012 04:02:17 -0400
In-Reply-To: <20120927052539.GA22160@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 9/27/2012 8:25 AM, Herbert Xu wrote:
> On Wed, Sep 19, 2012 at 09:53:37PM +0300, Horia Geanta wrote:
>> Hi Herbert,
>>
>> I know these patches come late and might not be included in 3.6.
>> But two of them are already sitting in cryptodev tree for some time.
>> (Don't know where my head was :/).
>
> I'm hesitant to put these patches in at this stage.  For the

That's understandable.

> problems fixed by them do we have simpler fixes for 3.6? For
> example, by reverting changesets that introduced the issue if

Reverting
e46e9a crypto: testmgr - add aead cbc aes hmac sha1,256,512 test vectors
(added in 3.6-rc2) would also do fine.

Of course, it would be added back in during 3.7 merge window, with the 
other talitos-specific patches currently sitting in cryptodev.

What I'm trying to say here is that allowing the patch to go in 3.6 
without all the other is incorrect. Sorry for not posting all of them as 
a patchset.

Again, this patch (e46e9a) is not the culprit, it merely exposes the 
deficiencies in the talitos driver.
AFAICT, these cases (zero assoc data, noncontiguous iv and assoc data) 
have never been handled correctly in the driver.

> it's a regression, or disabling the buggy functionality?

Don't think so, it's core functionality.

>
> Thanks,
>
