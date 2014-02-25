From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC PATCH] arm64: add support for AES in CCM mode using Crypto Extensions
Date: Tue, 25 Feb 2014 11:11:21 +0100
Message-ID: <CAKv+Gu97c46dxQK2vhbHUgD8i7x3OA5BhXbS=AdobB8_2ViTEg@mail.gmail.com>
References: <1392106905-28709-1-git-send-email-ard.biesheuvel@linaro.org>
	<20140225070252.GB9934@gondor.apana.org.au>
	<CAKv+Gu-HnTk5RCLRoCnae7-HH7C-Tq2YJF57Nc-hOEykdY52XA@mail.gmail.com>
	<20140225071626.GA10524@gondor.apana.org.au>
	<CAKv+Gu_A_04P=nOoPfxhJMC3bbEPTcpgZO0Ldw2H4BV7T_gTbw@mail.gmail.com>
	<20140225090835.GA11135@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Will Deacon <will.deacon@arm.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Nicolas Pitre <nico@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:61127 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaBYKLW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Feb 2014 05:11:22 -0500
Received: by mail-lb0-f182.google.com with SMTP id n15so828128lbi.27
        for <linux-crypto@vger.kernel.org>; Tue, 25 Feb 2014 02:11:21 -0800 (PST)
In-Reply-To: <20140225090835.GA11135@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 25 February 2014 10:08, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Feb 25, 2014 at 08:21:22AM +0100, Ard Biesheuvel wrote:
>>
>> For the authenticate-only data, this is manageable as you are only
>> dealing with input, but when dealing with both in- and output, as in
>> the core of CCM, it becomes very tedious.
>> So instead, I have opted for an inner blkcipher instance which takes
>> care of all of that. Could you suggest another approach that if
>> preferable?
>
> I don't think the walk helper actually needs the tfm apart from
> getting a couple of parameters out of it, so perhaps we can just
> change the helper to not depend on a tfm.
>

That seems like a less hacky approach.

I'll cook something up and put it on the list.

Cheers,
Ard.
