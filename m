From: Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH v3] x86, crypto: ported aes-ni implementation to x86
Date: Thu, 18 Nov 2010 08:38:38 +0100
Message-ID: <CD0CDB5F-7FDE-4A2D-88A1-8FC7E4AD0B01@googlemail.com>
References: <1288818883-7620-1-git-send-email-minipli@googlemail.com> <1288823231.3016.25.camel@yhuang-mobile> <F67572F2-BFB5-4EB5-8CEB-FBB7AC30EFE3@googlemail.com> <1289521991.8719.1035.camel@yhuang-dev> <363861B5-35D6-4A01-9BF2-2EC1023BA0F2@googlemail.com> <1289547275.8719.1077.camel@yhuang-dev> <3F97AFB7-CF6A-4C5A-B435-A6424FCF5C53@googlemail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Huang Ying <ying.huang@intel.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38096 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab0KRHip convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Nov 2010 02:38:45 -0500
Received: by bwz15 with SMTP id 15so2471981bwz.19
        for <linux-crypto@vger.kernel.org>; Wed, 17 Nov 2010 23:38:43 -0800 (PST)
In-Reply-To: <3F97AFB7-CF6A-4C5A-B435-A6424FCF5C53@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 13.11.2010, 00:25 Mathias Krause wrote:
> On 12.11.2010, 08:34 Huang Ying wrote:
> On Fri, 2010-11-12 at 15:30 +0800, Mathias Krause wrote:
>>> On 12.11.2010, 01:33 Huang Ying wrote:
>>>> Why the improvement of ECB is so small? I can not understand it. It
>>>> should be as big as CBC.
>>> 
>>> I don't know why the ECB variant is so slow compared to the other variants.
>>> But it is so even for the current x86-64 version. See the above values for
>>> "x86-64 (old)". I setup dm-crypt for this test like this:
>>> # cryptsetup -c aes-ecb-plain -d /dev/urandom create cfs /dev/loop0
>>> 
>>> What where the numbers you measured in your tests while developing the
>>> x86-64 version?
>> 
>> Can't remember the number. Do you have interest to dig into the issue?
> 
> I looked at /proc/crypto while doing the tests again and noticed that ECB
> isn't handled using cryptd, while all other modes, e.g. CBC and CTR, are.
> The reason for that seems to be that for ECB, and only for ECB, the kernel
> is using the synchronous block algorithm instead of the asynchronous one.
> So the question is: Why is the ECB variant handled using the synchronous
> cipher -- because of the missing iv handling in this mode?

Herbert, any idea why this is the case?

Regards,
Mathias
