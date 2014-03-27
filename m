From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86/crypto: ghash: use C implementation for setkey()
Date: Thu, 27 Mar 2014 09:43:22 -0700
Message-ID: <5334552A.1020203@zytor.com>
References: <1395919740-20774-1-git-send-email-ard.biesheuvel@linaro.org>	<20140327113610.GA8402@gondor.apana.org.au> <CAKv+Gu8jgerfVGTLfu2+eNXnsbBGCzdd3jH+oTbBOr=Tm2sjPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:56858 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbaC0Qnr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Mar 2014 12:43:47 -0400
In-Reply-To: <CAKv+Gu8jgerfVGTLfu2+eNXnsbBGCzdd3jH+oTbBOr=Tm2sjPQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/27/2014 04:46 AM, Ard Biesheuvel wrote:
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
> 
> I agree that it makes little sense to call this from atomic context,
> but that still means (I think, but the x86 guys should confirm) that
> you are supposed to call kernel_fpu_begin() and kernel_fpu_end().
> 

Yes.  I'm suspecting calling kernel_fpu_begin() for a single GF
operation is probably not worth it, so I'm fine with reimplementing it
in integer logic.

Acked-by: H. Peter Anvin <hpa@linux.intel.com>

	-hpa
