From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v2] crypto: algif_skcipher - Require setkey before
 accept(2)
Date: Sat, 2 Jan 2016 21:18:30 +0100
Message-ID: <56883096.1020009@gmail.com>
References: <CACT4Y+YOwOfRHOwJ=FA9aaL2cZ-PRhTvd_mCzxx2nnN_L3tygw@mail.gmail.com>
 <5687BA0F.3020104@gmail.com> <5687E19E.2070801@gmail.com>
 <1647086.cdlVYfuqk1@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Dmitry Vyukov <dvyukov@google.com>, syzkaller@googlegroups.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kcc@google.com, glider@google.com,
	edumazet@google.com, sasha.levin@oracle.com, keescook@google.com
To: Stephan Mueller <smueller@chronox.de>,
	Milan Broz <gmazyland@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37256 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbcABUSe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 2 Jan 2016 15:18:34 -0500
In-Reply-To: <1647086.cdlVYfuqk1@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/02/2016 09:03 PM, Stephan Mueller wrote:
> Am Samstag, 2. Januar 2016, 15:41:34 schrieb Milan Broz:
> 
> Hi Milan,
> 

...
>>> Hi Herbert,
>>>
>>> this patch breaks userspace in cryptsetup...
>>>
>>> We use algif_skcipher in cryptsetup (for years, even before
>>> there was Stephan's library) and with this patch applied
>>> I see fail in ALG_SET_IV call (patch from your git).
>>
>> (Obviously this was because of failing accept() call here, not set_iv.)
>>
>>> I can fix it upstream, but for thousands of installations it will
>>> be broken (for LUKS there is a fallback, cor TrueCrypt compatible devices
>>> it will be unusable. Also people who configured kernel crypto API as
>>> default backend will have non-working cryptsetup).
>>>
>>> Is it really thing for stable branch?
>>
>> Also how it is supposed to work for cipher_null, where there is no key?
>> Why it should call set_key if it is noop? (and set key length 0 is not
>> possible).
>>
>> (We are using cipher_null for testing and for offline re-encryption tool
>> to create temporary "fake" header for not-yet encrypted device...)
> 
> The change implies that any setkey or set IV operations (i.e. any operations 
> on the tfmfd) are done before the opfd(s) are created with one or more accept 
> calls.
> 
> Thus, after a bind that returns the tfmfd, the setkey and setiv operations 
> shall be called. This is followed by accept. If you change the order of 
> invocations in your code, it should work.

Hi,

I already changed it in cryptsetup upstream this way.

But I cannot change thousands of cryptsetup installations that are actively using that code.
This is clear userspace breakage which should not happen this way.

(Moreover it still doesn't work for cipher_null that has min/max key size 0.)

Milan
