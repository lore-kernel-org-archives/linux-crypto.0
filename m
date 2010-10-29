From: Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH] x86, crypto: ported aes-ni implementation to x86
Date: Sat, 30 Oct 2010 00:51:34 +0200
Message-ID: <14A7481C-0E2C-4E68-8065-701B0D9DA317@googlemail.com>
References: <20101029221541.GA12822@gondor.apana.org.au>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57238 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980Ab0J2Wvu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Oct 2010 18:51:50 -0400
Received: by bwz11 with SMTP id 11so3016842bwz.19
        for <linux-crypto@vger.kernel.org>; Fri, 29 Oct 2010 15:51:49 -0700 (PDT)
In-Reply-To: <20101029221541.GA12822@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 30.10.2010, 00:15 Herbert Xu wrote:
> Mathias Krause <minipli@googlemail.com> wrote:
>> The AES-NI instructions are also available in legacy mode so the x86
>> architecture may profit from those, too.
>> 
>> To illustrate the performance gain here's a short summary of the tcrypt
>> speed test on a Core i5 M 520 running at 2.40GHz comparing both
>> assembler implementations:
>> 
>>                            aes-i586   aes-ni-i586   delta
>> 256 bit, 8kB blocks, ECB:  46.81 MB/s   164.46 MB/s   +251%
>> 256 bit, 8kB blocks, CBC:  43.89 MB/s    62.18 MB/s    +41%
>> 384 bit, 8kB blocks, LRW:  42.24 MB/s   142.90 MB/s   +238%
>> 512 bit, 8kB blocks, XTS:  43.41 MB/s   148.67 MB/s   +242%
>> 
>> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> 
> Nice work :)
> 
> I have to say though that I'll love this een more if we could
> avoid duplicating those assembly files somehow.  Is this possible?

I thought about that too but found it more easy to split those files.
The different calling conventions of the architectures and the limited 
register set on the 32-bit version made me make some not so nice 
#ifdef-able changes to the code so it'll work with less registers.

> Oh and those CBC numbers look out of whack.  I'd expect CBC to be
> way faster as it's done directly by the hardware unlike the
> other modes.

Well, actually the 32-bit assembler implementation has specialized 
algorithms for ECB and CBC. But the latter must be implemented a 
little different than the 64-bit version because I didn't have enough 
xmm registers to make a 1:1 port. So I reused some registers for 
loading memory values and used direct memory references to make 
aesni_cbc_dec() work with the limited amount of registers.

I'll look into it if we can do better, but if not, maybe leaving this 
one out for the 32-bit version might be the best option. Doing so may
even make it easier to combine the two assembler files again.

Btw., because of the limited register set I wasn't able to port the 
CTR mode version, yet. It uses even more registers -- xmm and general 
purpose. :(

>  What numbers do you get in 64-bit before/after
> your patch?

Haven't yet build a 64-bit kernel but will try that tomorrow.

> If the hardware CBC is really so much slower then maybe we should
> stop using it.

This must be related to the changes I made to the code. I would guess 
it doesn't like the additional memory loads.

There's even more potential for optimization since I've still a 
general purpose register left. ;)

See this version as a first version to get feedback, especially from 
Huang Ying. But it's already quite fast. :)


Regards,
Mathias

> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
