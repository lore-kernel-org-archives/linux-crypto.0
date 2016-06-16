From: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Subject: Re: [PATCH 1/2] Crypto: Add SHA-3 hash algorithm
Date: Thu, 16 Jun 2016 21:39:17 +0530
Message-ID: <CAAFb_vqubPdy4g0NsM02JaUN-YL8V17kYbVMHWSTv9CByZ3XRA@mail.gmail.com>
References: <1465983719-8313-1-git-send-email-raveendra.padasalagi@broadcom.com>
	<8163378.RZGaC46RvE@tauon.atsec.com>
	<CAAFb_vq0dGbQP6gY-t0hDCqa1pBQZGeQy00RFoUww0_Gvw=kUg@mail.gmail.com>
	<1704146.ryraC2p2Bb@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jon Mason <jonmason@broadcom.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Anup Patel <anup.patel@broadcom.com>,
	Ray Jui <rjui@broadcom.com>,
	Scott Branden <sbranden@broadcom.com>,
	Pramod Kumar <pramod.kumar@broadcom.com>,
	bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
	Jeff Garzik <jeff@garzik.org>, Jeff Garzik <jgarzik@redhat.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:32814 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbcFPQJS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Jun 2016 12:09:18 -0400
Received: by mail-yw0-f173.google.com with SMTP id g20so47340848ywb.0
        for <linux-crypto@vger.kernel.org>; Thu, 16 Jun 2016 09:09:17 -0700 (PDT)
In-Reply-To: <1704146.ryraC2p2Bb@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

Yes, I was initially thinking of to put it as FIPS but looked at the
existing "crypto/Kconfig"
for other algorithms and found it to be using DFIPS. So kept this also
the same :)

I need some clarification to address your comment

"Shouldn't there be a priority here?"

What I know regarding priority value for an algorithm
is higher the priority value it will be get selected for execution.

For example, let's say for software implementation of the algorithm if
priority value
is specified as 100 and hardware driver implementation of the same
algorithm uses
the priority value of 300 then hardware algo is what selected for execution.

I just had a look at priority value specified for other hash
algorithm's and none of the
software implementation specify any value, So it will be 0.

I think it's okay to not to specify any priority value for software
implementation,
as hardware implementation can use non zero value if it needs higher priority.

What's your opinion ?


Regards,
Raveendra










On Thu, Jun 16, 2016 at 9:10 PM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Donnerstag, 16. Juni 2016, 14:44:57 schrieb Raveendra Padasalagi:
>
> Hi Raveendra,
>
>> > Typo DFIPS?
>>
>> It's not typo, DFIPS mean here Draft FIPS 202.
>> Do you want me to put it in another way ?
>
> I have never seen DFIPS. Besides, most FIPS standards are drafts (including of
> FIPS 140-2 :-) ), because it would require a signature from some ministry big-
> wig in the US govt to "release" it. Hence, I expect that it would retain its
> draft state for a long time :-)
>
> But if DFIPS is what you think is right, leave it :-)
>
> Ciao
> Stephan
