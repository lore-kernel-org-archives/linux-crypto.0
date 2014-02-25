From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC PATCH] arm64: add support for AES in CCM mode using Crypto Extensions
Date: Tue, 25 Feb 2014 08:12:36 +0100
Message-ID: <CAKv+Gu-HnTk5RCLRoCnae7-HH7C-Tq2YJF57Nc-hOEykdY52XA@mail.gmail.com>
References: <1392106905-28709-1-git-send-email-ard.biesheuvel@linaro.org>
	<20140225070252.GB9934@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Will Deacon <will.deacon@arm.com>,
	Nicolas Pitre <nico@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:63871 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaBYHMi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Feb 2014 02:12:38 -0500
Received: by mail-la0-f52.google.com with SMTP id c6so6692552lan.25
        for <linux-crypto@vger.kernel.org>; Mon, 24 Feb 2014 23:12:36 -0800 (PST)
In-Reply-To: <20140225070252.GB9934@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 25 February 2014 08:02, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Feb 11, 2014 at 09:21:45AM +0100, Ard Biesheuvel wrote:
>> This adds support for a synchronous implementation of AES in CCM mode
>> using ARMv8 Crypto Extensions, using NEON registers q0 - q5.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>> Hi all,
>>
>> I am posting this for review/RFC. The main topic for feedback is the way
>> I have used an inner blkcipher instance to process the encrypted + authenticated
>> data.
>>
>> The point of having a dedicated module for synchronous ccm(aes) is the fact that
>> mac80211 uses it for WPA2 CCMP en-/decryption, where it runs entirely in soft
>> IRQ context. In this case, the performance improvement offered by dedicated AES
>> instructions is likely wasted on stacking and unstacking the NEON register file,
>> as the generic CCM operates on a single AES block at a time.
>>
>> Instead, this implementation interleaves the CTR and CBC modes at the round
>> level, eliminating 50% of both the input and round key loads and (hopefully)
>> eliminating pipeline stalls by operating on two AES blocks at a time.
>>
>> Tested with tcrypt, no performance numbers yet.
>
> I think your idea definitely make sense, since we do the same
> thing in aesni-intel.
>
> It'll be interesting to see some numbers, especially if we could
> compare this against the generic version that we talked about
> earlier.
>

Hi Herbert,

Thanks for taking a look.

I will definitely come back with performance numbers as soon as I
manage to produce any.
Do you have any comments specifically about using an inner blkcipher
instance to implement the aead?

Thanks,
Ard.
