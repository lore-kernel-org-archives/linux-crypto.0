From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [RFC] [crypto] padlock-aes loadkey ondemand
Date: Wed, 2 Apr 2008 08:26:59 +0200
Message-ID: <20080402062659.GA32234@Chamillionaire.breakpoint.cc>
References: <20080328223333.GB24018@Chamillionaire.breakpoint.cc> <E1Jgw4g-0008Uc-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: stefan@the2masters.de, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46152 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751732AbYDBG1D (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Apr 2008 02:27:03 -0400
Content-Disposition: inline
In-Reply-To: <E1Jgw4g-0008Uc-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2008-04-02 14:03:54 [+0800]:

>Sebastian Siewior <linux-crypto@ml.breakpoint.cc> wrote:
>>
>> @@ -205,14 +208,22 @@ static inline u8 *padlock_xcrypt_cbc(const u8 *input, u8 *output, void *key,
>> static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>> {
>>        struct aes_ctx *ctx = aes_ctx(tfm);
>> -       padlock_reset_key();
>> +
>> +       if (last_key != ctx) {
>> +               last_key = ctx;
>> +               padlock_reset_key();
>> +       }
>
>What if user-space invokes the padlock when xts is preempted?

>From VIA's programming guide:
|- EFLAGS:30 is set to 0 by any x86 instruction, interrupt, exception,
|task switch, etc. operation that causes EFLAGS to be stored (even if
|executed in 16-bit mode). Centaue Technology recommends using the
|instruction sequence PUSHFL; POPFL; prior to any REP XCRYPT instruction
|which uses a different key than the previous REP XCRYPT instruction.
|- EFLAGS:30 cannot be set to 1 by any x86 instruction that causes EFLAGS
|to be loaded. Only REP XCRYPT instructions set this bit to 1.

In that case we are safe aren't we? If we get preempted and user
space is invoked (or any other kernel thread) then the EFLAGS of the
task are restored what sets EFLAGS:30 to zero. Or did I misinterprete
it?

Sebastian
