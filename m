From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [RFC PATCH crypto] AES: Add support to Intel AES-NI
	instructions
Date: Mon, 15 Dec 2008 10:07:45 +0100
Message-ID: <20081215090745.GA4991@Chamillionaire.breakpoint.cc>
References: <1229054926.5936.160.camel@yhuang-dev.sh.intel.com> <20081212195722.GA24489@Chamillionaire.breakpoint.cc> <1229307542.5936.204.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"mingo@elte.hu" <mingo@elte.hu>,
	"tglx@linutronix.de" <tglx@linutronix.de>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:50529 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752692AbYLOJHx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Dec 2008 04:07:53 -0500
Content-Disposition: inline
In-Reply-To: <1229307542.5936.204.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Huang Ying | 2008-12-15 10:19:02 [+0800]:

>> Nice work. A few things:
>> - Did you rename the "old" x86 functions to avoid a clash?
>>   So you bypass the crypto layer in case you can't handle the operation.
>>   Does this improve the performace or just saves key strokes? Not sure
>>   what the best sollution could be....
>
>The general x86 implementation is used as the fall back for new AES-NI
>based implementation. Because AES-NI can not be used in kernel soft_irq
>context. If crypto layer is used to access general x86 implementation,
>we will have tfm_ctx alignment issue, because AES-NI need tfm_ctx to be
>16 byte aligned.
>
>> - unless I've read the code too fast, it does not work if someone sets the
>>   key in user context and starts an encryption in softirq context.
>
>Oh, I should use struct crypto_aes_ctx instead of define struct aes_ctx.
>The tfm_ctx definition is different. I will fix this. Except that, is
>there any other issue?
Now I see what you have done. You are sharing the same tfm between your
aes version and the "old" asm version. Both assume different private
data (aes_ctx vs crypto_aes_ctx) so this should not work.

>> - aes_ctx is somehow bad. You are using this for a function and a
>>   struct. An Intel prefix would be nice (in case of the struct). On a
>>   second thought, any reason why you can't use crypto_aes_ctx?
>
>Yes. I will use that. The only issue is that AES-NI need scheduled key
>to be 16 bytes aligned, so we need move key_length in struct
>crypto_aes_ctx to the end of the struct.
You have to it if you want to bypass the crypto layer and call asm
functions directly and I'm not sure whether bypassing the crypto layer
is a good thing. Both asm routines (the 32bit and 64bit) assume that
keylen ist at +0 followed by enc key, dec key. Ach and they don't do the
ALIGN thing.

Herbert what do you thing?

>> - Is this an Intel thing or is going to be part of X86 and also
>>   available to others (like mmx). In that case the Intel prefix may be
>>   "wrong".
>
>Now it is an Intel thing. But in the future it may become part of x86.
>Intel named it as AES-NI (AES New Instructions), but name like
>aes_ni_aes_set_key is not good too. Does aes_ni_set_key sound better?
The latter is fine. I just want to avoid having several and different
aes_set_key() around.

>> - does the cpu support more than just pure aes e.g. block modes? In case
>>   it does not, does the perfomance improve if you implement lets say
>>   cbc(aes) and do the xor with sse in order to save a few
>>   kernel_fpu_begin() calls? I'm just asking because I saw a similar
>>   thing and PowerPC and the AltiVec unit. Maybe it is cheap on x86 :)
>
>Yes. AES-NI can benefit not only block modes. And the pipeline
>implementation of AES-NI can benefit cbc(aes) decryption and ctr(aes)
>even more (described in detail in white paper). We will work on that.
Ah okay. So depending on how expensive kernel_fpu_begin() really is it
might be slower for just the cipher (i.e. in xts(aes) where xts calls
you for every 16bytes).

>
>Best Regards,
>Huang Ying
>

Sebastian
