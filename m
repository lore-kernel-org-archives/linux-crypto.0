From: Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH v3] x86, crypto: ported aes-ni implementation to x86
Date: Thu, 4 Nov 2010 08:38:23 +0100
Message-ID: <FE9298C4-BBD4-472A-946D-0E804B128831@googlemail.com>
References: <1288818883-7620-1-git-send-email-minipli@googlemail.com> <1288823231.3016.25.camel@yhuang-mobile>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58879 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab0KDHis (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Nov 2010 03:38:48 -0400
Received: by fxm16 with SMTP id 16so1201372fxm.19
        for <linux-crypto@vger.kernel.org>; Thu, 04 Nov 2010 00:38:47 -0700 (PDT)
In-Reply-To: <1288823231.3016.25.camel@yhuang-mobile>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03.11.2010, 23:27 Huang Ying wrote:
> On Wed, 2010-11-03 at 14:14 -0700, Mathias Krause wrote:
>> The AES-NI instructions are also available in legacy mode so the 32-bit
>> architecture may profit from those, too.
>> 
>> To illustrate the performance gain here's a short summary of the tcrypt
>> speed test on a Core i7 M620 running at 2.67GHz comparing both assembler
>> implementations:
>> 
>> x86:                              i568       aes-ni   delta
>> 256 bit, 8kB blocks, ECB:  125.94 MB/s  187.09 MB/s  +48.6%
> 
> Which method do you used for speed testing?
> 
> modprobe tcrypt mode=200 sec=<?>

Yes. I used: modprobe tcrypt mode=200 sec=1

> That actually does not work very well for AES-NI. Because AES-NI
> blkcipher is tested in synchronous mode, and in that mode,
> kernel_fpu_begin/end() must be called for every block, and
> kernel_fpu_begin/end() is quite slow.

That's what I figured, too. Can this slowdown be avoided by saving and 
restoring the used FPU registers within the assembler implementation or 
would this be even slower?

> At the same time, some further
> optimization for AES-NI can not be tested (such as "ecb-aes-aesni"
> driver) in that mode, because they are only available in asynchronous
> mode.

After finding the bug in the second version of the patch I noticed this, 
too.

> When developing AES-NI for x86_64, I uses dm-crypt + AES-NI for speed
> testing, where AES-NI blkcipher will be tested in asynchronous mode, and
> kernel_fpu_begin/end() is called for every page. Can you use that to
> test?

But wouldn't this be even slower than the above measurement? I took the 
results for 8kB blocks and a page would only be 4kB ... well, depends on 
what kind of pages you took. IIRC x86-64 not only supports 2MB but also 
1GB pages ;)

> Or you can add test_acipher_speed (similar with test_ahash_speed) to
> test cipher in asynchronous mode.

Maybe I'll try this approach, since it looks like just a minor 
modification of the tcrypt module.
Thanks for the hints!

Best regards,
Mathias

> 
> Best Regards,
> Huang Ying
