From: Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH v3] x86, crypto: ported aes-ni implementation to x86
Date: Fri, 12 Nov 2010 08:42:46 +0100
Message-ID: <AC97D607-78DA-449C-AC3A-06FBDA185801@googlemail.com>
References: <1288818883-7620-1-git-send-email-minipli@googlemail.com> <1288823231.3016.25.camel@yhuang-mobile> <F67572F2-BFB5-4EB5-8CEB-FBB7AC30EFE3@googlemail.com> <1289521991.8719.1035.camel@yhuang-dev> <363861B5-35D6-4A01-9BF2-2EC1023BA0F2@googlemail.com> <1289547275.8719.1077.camel@yhuang-dev>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63224 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab0KLHmv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Nov 2010 02:42:51 -0500
Received: by fxm16 with SMTP id 16so2040384fxm.19
        for <linux-crypto@vger.kernel.org>; Thu, 11 Nov 2010 23:42:50 -0800 (PST)
In-Reply-To: <1289547275.8719.1077.camel@yhuang-dev>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12.11.2010, 08:34 Huang Ying wrote:
On Fri, 2010-11-12 at 15:30 +0800, Mathias Krause wrote:
>> On 12.11.2010, 01:33 Huang Ying wrote:
>>> Hi, Mathias,
>>> 
>>> On Fri, 2010-11-12 at 06:18 +0800, Mathias Krause wrote:
>>>> All test were run five times in a row using a 256 bit key and doing i/o
>>>> to the block device in chunks of 1MB. The numbers are MB/s.
>>>> 
>>>> x86 (i586 variant):
>>>>       1. run  2. run  3. run  4. run  5. run    mean
>>>> ECB:      93.9    93.9    94.0    93.5    93.8    93.8
>>>> CBC:      84.9    84.8    84.9    84.9    84.8    84.8
>>>> XTS:     108.2   108.3   109.6   108.3   108.9   108.6
>>>> LRW:     105.0   105.0   105.1   105.1   105.1   105.0
>>>> 
>>>> x86 (AES-NI), v3 of the patch:
>>>>       1. run  2. run  3. run  4. run  5. run    mean
>>>> ECB:     124.8   120.8   124.5   120.6   124.5   123.0
>>>> CBC:     112.6   109.6   112.6   110.7   109.4   110.9 
>>>> XTS:     221.6   221.1   220.9   223.5   224.4   222.3
>>>> LRW:     206.2   209.7   207.4   203.7   209.3   207.2
>>>> 
>>>> x86 (AES-NI), v4 of the patch:
>>>>       1. run  2. run  3. run  4. run  5. run    mean
>>>> ECB:     122.5   121.2   121.6   125.7   125.5   123.3
>>>> CBC:     259.5   259.2   261.2   264.0   267.6   262.3 
>>>> XTS:     225.1   230.7   220.6   217.9   216.3   222.1
>>>> LRW:     202.7   202.8   210.6   208.9   202.7   205.5
>>>> 
>>>> Comparing the values for the CBC variant between v3 and v4 of the patch
>>>> shows that porting the CBC variant to x86 more then doubled the
>>>> performance so the little bit ugly #ifdefed code is worth the effort.
>>>> 
>>>> x86-64 (old):
>>>>       1. run  2. run  3. run  4. run  5. run    mean
>>>> ECB:     121.4   120.9   121.1   121.2   120.9   121.1
>>>> CBC:     282.5   286.3   281.5   282.0   294.5   285.3
>>>> XTS:     263.6   260.3   263.0   267.0   264.6   263.7
>>>> LRW:     249.6   249.8   250.5   253.4   252.2   251.1
>>>> 
>>>> x86-64 (new):
>>>>       1. run  2. run  3. run  4. run  5. run    mean
>>>> ECB:     122.1   122.0   122.0   127.0   121.9   123.0
>>>> CBC:     291.2   286.2   295.6   291.4   289.9   290.8
>>>> XTS:     263.3   264.4   264.5   264.2   270.4   265.3
>>>> LRW:     254.9   252.3   253.6   258.2   257.5   255.3
>>>> 
>>>> Comparing the mean values gives us:
>>>> 
>>>> x86:     i586   aes-ni    delta
>>>> ECB:     93.8    123.3   +31.4%
>>> 
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

Sure. Increasing performance is always a good thing to do. :)

Best regards,
Mathias