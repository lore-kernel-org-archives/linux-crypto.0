From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] x86/crypto: ghash: use C implementation for setkey()
Date: Thu, 27 Mar 2014 12:47:54 +0100
Message-ID: <CAKv+Gu-Em_BDdfVBbT+mB9UHAfWGZh9MVZONno3v6YKNC6n8qQ@mail.gmail.com>
References: <1395919740-20774-1-git-send-email-ard.biesheuvel@linaro.org>
	<20140327113610.GA8402@gondor.apana.org.au>
	<CAKv+Gu8jgerfVGTLfu2+eNXnsbBGCzdd3jH+oTbBOr=Tm2sjPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"hpa@zytor.com" <hpa@zytor.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:38582 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaC0Lr4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Mar 2014 07:47:56 -0400
Received: by mail-la0-f51.google.com with SMTP id pv20so2504403lab.38
        for <linux-crypto@vger.kernel.org>; Thu, 27 Mar 2014 04:47:54 -0700 (PDT)
In-Reply-To: <CAKv+Gu8jgerfVGTLfu2+eNXnsbBGCzdd3jH+oTbBOr=Tm2sjPQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 27 March 2014 12:46, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 27 March 2014 12:36, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> On Thu, Mar 27, 2014 at 12:29:00PM +0100, Ard Biesheuvel wrote:
>>> The GHASH setkey() function uses SSE registers but fails to call
>>> kernel_fpu_begin()/kernel_fpu_end(). Instead of adding these calls, and
>>> then having to deal with the restriction that they cannot be called from
>>> interrupt context, move the setkey() implementation to the C domain.
>>
>> Note that setkey cannot be called from interrupt context since
>> allocation/setkey is supposed to be slow-path material.
>>
>> But your approach is fine by me.
>>
>
> I agree that it makes little sense to call this from atomic context,
> but that still means (I think, but the x86 guys should confirm) that
> you are supposed to call kernel_fpu_begin() and kernel_fpu_end().
>
>>> Note that setkey() does not use any particular SSE features and is not
>>> expected to become a performance bottleneck.
>>>
>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>> ---
>>>
>>> I suppose this should be marked for stable as well?
>>
>> Sure I'll add the cc.
>>
>
> Perhaps wait for an ack from team x86?
>

... oh, and I noticed that I forgot to remove the forward declaration
of clmul_ghash_setkey() as well.

Sorry.

-- 
Ard.
