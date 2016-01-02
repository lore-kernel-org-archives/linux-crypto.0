From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v2] crypto: algif_skcipher - Require setkey before
 accept(2)
Date: Sat, 2 Jan 2016 15:41:34 +0100
Message-ID: <5687E19E.2070801@gmail.com>
References: <CACT4Y+YOwOfRHOwJ=FA9aaL2cZ-PRhTvd_mCzxx2nnN_L3tygw@mail.gmail.com>
 <20151225074005.GA14690@gondor.apana.org.au> <5687BA0F.3020104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: syzkaller@googlegroups.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kcc@google.com, glider@google.com, edumazet@google.com,
	sasha.levin@oracle.com, keescook@google.com,
	Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37264 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbcABOli (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 2 Jan 2016 09:41:38 -0500
In-Reply-To: <5687BA0F.3020104@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/02/2016 12:52 PM, Milan Broz wrote:
> On 12/25/2015 08:40 AM, Herbert Xu wrote:
>> Dmitry Vyukov <dvyukov@google.com> wrote:
>>>
>>> I am testing with your two patches:
>>> crypto: algif_skcipher - Use new skcipher interface
>>> crypto: algif_skcipher - Require setkey before accept(2)
>>> on top of a88164345b81292b55a8d4829fdd35c8d611cd7d (Dec 23).
>>
>> You sent the email to everyone on the original CC list except me.
>> Please don't do that.
>>
>>> Now the following program causes a bunch of use-after-frees and them
>>> kills kernel:
>>
>> Yes there is an obvious bug in the patch that Julia Lawall has
>> responded to in another thread.  Here is a fixed version.
>>
>> ---8<--
>> Some cipher implementations will crash if you try to use them
>> without calling setkey first.  This patch adds a check so that
>> the accept(2) call will fail with -ENOKEY if setkey hasn't been
>> done on the socket yet.
> 
> 
> Hi Herbert,
> 
> this patch breaks userspace in cryptsetup...
> 
> We use algif_skcipher in cryptsetup (for years, even before
> there was Stephan's library) and with this patch applied
> I see fail in ALG_SET_IV call (patch from your git).

(Obviously this was because of failing accept() call here, not set_iv.)

> 
> I can fix it upstream, but for thousands of installations it will
> be broken (for LUKS there is a fallback, cor TrueCrypt compatible devices
> it will be unusable. Also people who configured kernel crypto API as default
> backend will have non-working cryptsetup).
> 
> Is it really thing for stable branch?

Also how it is supposed to work for cipher_null, where there is no key?
Why it should call set_key if it is noop? (and set key length 0 is not possible).

(We are using cipher_null for testing and for offline re-encryption tool
to create temporary "fake" header for not-yet encrypted device...)

Milan
