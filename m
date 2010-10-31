From: Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH] x86, crypto: ported aes-ni implementation to x86
Date: Sun, 31 Oct 2010 20:32:51 +0100
Message-ID: <24C59B90-1F93-4929-BBC2-1D7864250462@googlemail.com>
References: <20101029221541.GA12822@gondor.apana.org.au>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48391 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab0JaTdL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 31 Oct 2010 15:33:11 -0400
Received: by fxm16 with SMTP id 16so4434600fxm.19
        for <linux-crypto@vger.kernel.org>; Sun, 31 Oct 2010 12:33:10 -0700 (PDT)
In-Reply-To: <20101029221541.GA12822@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 30.10.2010, 00:15 Herbert Xu wrote:
> Mathias Krause <minipli@googlemail.com> wrote:
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
> Oh and those CBC numbers look out of whack.  I'd expect CBC to be
> way faster as it's done directly by the hardware unlike the
> other modes.  What numbers do you get in 64-bit before/after
> your patch?
> 
> If the hardware CBC is really so much slower then maybe we should
> stop using it.

Today I build and measured a 64-bit version without my changes and got 
results for the above tests at around 60 to 66 MB/s which is ridiculous! 
So I ran the test again and again and noticed that _sometimes_ I got 
results for _some_ algorithms at 150 to 160 MB/s. That's weird!

Testing the 32-bit version again (with my patch) I even got 151 MB/s for 
the CBC mode, albeit now other algorithms were down to 58 - 67 MB/s. 
Strange. Looks like I was just lucky with my first measurement. :/

I don't know why the numbers do vary that much. Maybe it's some magic in 
the processor deactivating some cores and the kernel scheduling work to 
the wrong core. Nevertheless my system under test was otherwise idle. I 
booted a minimal initramfs based system with no services at all but the 
ability to load the tcrypt module.

Maybe Huang Ying can give us some insight why the numbers do vary that 
much? My test case was 'modprobe tcrypt mode=200 sec=10' (for latter 
tests I reduces the sec parameter to 1 in favor of doing multiple runs). 
If that's an inappropriate test for the Intel AES instructions maybe 
somebody can tell me how to do better? Maybe dd to a cryptoloop device?

Regards,
Mathias
