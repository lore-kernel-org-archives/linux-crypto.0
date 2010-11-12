From: Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH v3] x86, crypto: ported aes-ni implementation to x86
Date: Sat, 13 Nov 2010 00:25:04 +0100
Message-ID: <3F97AFB7-CF6A-4C5A-B435-A6424FCF5C53@googlemail.com>
References: <1288818883-7620-1-git-send-email-minipli@googlemail.com> <1288823231.3016.25.camel@yhuang-mobile> <F67572F2-BFB5-4EB5-8CEB-FBB7AC30EFE3@googlemail.com> <1289521991.8719.1035.camel@yhuang-dev> <363861B5-35D6-4A01-9BF2-2EC1023BA0F2@googlemail.com> <1289547275.8719.1077.camel@yhuang-dev>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46221 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab0KLXZI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Nov 2010 18:25:08 -0500
Received: by bwz15 with SMTP id 15so3563438bwz.19
        for <linux-crypto@vger.kernel.org>; Fri, 12 Nov 2010 15:25:06 -0800 (PST)
In-Reply-To: <1289547275.8719.1077.camel@yhuang-dev>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12.11.2010, 08:34 Huang Ying wrote:
On Fri, 2010-11-12 at 15:30 +0800, Mathias Krause wrote:
>> On 12.11.2010, 01:33 Huang Ying wrote:
>>> Why the improvement of ECB is so small? I can not understand it. It
>>> should be as big as CBC.
>> 
>> I don't know why the ECB variant is so slow compared to the other variants.
>> But it is so even for the current x86-64 version. See the above values for
>> "x86-64 (old)". I setup dm-crypt for this test like this:
>> # cryptsetup -c aes-ecb-plain -d /dev/urandom create cfs /dev/loop0
>> 
>> What where the numbers you measured in your tests while developing the
>> x86-64 version?
> 
> Can't remember the number. Do you have interest to dig into the issue?

I looked at /proc/crypto while doing the tests again and noticed that ECB
isn't handled using cryptd, while all other modes, e.g. CBC and CTR, are.
The reason for that seems to be that for ECB, and only for ECB, the kernel
is using the synchronous block algorithm instead of the asynchronous one.
So the question is: Why is the ECB variant handled using the synchronous
cipher -- because of the missing iv handling in this mode?

Best regards,
Mathias
