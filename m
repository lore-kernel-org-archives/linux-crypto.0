From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC PATCH] arm64: add support for AES in CCM mode using Crypto Extensions
Date: Tue, 25 Feb 2014 08:21:22 +0100
Message-ID: <CAKv+Gu_A_04P=nOoPfxhJMC3bbEPTcpgZO0Ldw2H4BV7T_gTbw@mail.gmail.com>
References: <1392106905-28709-1-git-send-email-ard.biesheuvel@linaro.org>
	<20140225070252.GB9934@gondor.apana.org.au>
	<CAKv+Gu-HnTk5RCLRoCnae7-HH7C-Tq2YJF57Nc-hOEykdY52XA@mail.gmail.com>
	<20140225071626.GA10524@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Will Deacon <will.deacon@arm.com>,
	Nicolas Pitre <nico@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:53635 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaBYHVY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Feb 2014 02:21:24 -0500
Received: by mail-lb0-f171.google.com with SMTP id w7so339473lbi.30
        for <linux-crypto@vger.kernel.org>; Mon, 24 Feb 2014 23:21:22 -0800 (PST)
In-Reply-To: <20140225071626.GA10524@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 25 February 2014 08:16, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Feb 25, 2014 at 08:12:36AM +0100, Ard Biesheuvel wrote:
>>
>> Do you have any comments specifically about using an inner blkcipher
>> instance to implement the aead?
>
> Indeed, the inner block cipher looks superfluous since it's only
> used once by ccm and there is no nesting similar to aesni-intel.
>
> Inner algorithms are only needed if you want to nest it, e.g.,
> through fpu().  Otherwise I don't see any difference vs. calling
> the underlying functions directly, especially since you seem to
> be calling them directly anyway.
>

Well, the problem is that aead does not provide the blkcipher walk
API, which means it is up to the caller to map/unmap the scatterlists
and keep track of the in and out pointers etc.

For the authenticate-only data, this is manageable as you are only
dealing with input, but when dealing with both in- and output, as in
the core of CCM, it becomes very tedious.
So instead, I have opted for an inner blkcipher instance which takes
care of all of that. Could you suggest another approach that if
preferable?

Thanks,
Ard.
