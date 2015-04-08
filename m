From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3 01/16] crypto: sha1: implement base layer for SHA-1
Date: Wed, 8 Apr 2015 15:52:46 +0200
Message-ID: <CAKv+Gu9yynJyw95=Rc97Xnrrwrv7V6dTFQvEK26OwbjJKJTRAw@mail.gmail.com>
References: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
	<1428396724-19962-2-git-send-email-ard.biesheuvel@linaro.org>
	<20150408131916.GA29646@gondor.apana.org.au>
	<CAKv+Gu9gQqQEEXgJ=JhVf=7SURx9BfRiaJkakhGv1S9FsqujaQ@mail.gmail.com>
	<20150408133050.GB29646@gondor.apana.org.au>
	<CAKv+Gu-=obTKmviwH9B2wBi==LQa_-aAXVU9QPh1gUeYyopmVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"x86@kernel.org" <x86@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	Markus Stockhausen <stockhausen@collogia.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:35449 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbbDHNwr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Apr 2015 09:52:47 -0400
Received: by iggg4 with SMTP id g4so39708290igg.0
        for <linux-crypto@vger.kernel.org>; Wed, 08 Apr 2015 06:52:46 -0700 (PDT)
In-Reply-To: <CAKv+Gu-=obTKmviwH9B2wBi==LQa_-aAXVU9QPh1gUeYyopmVw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 8 April 2015 at 15:40, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 8 April 2015 at 15:30, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> On Wed, Apr 08, 2015 at 03:25:14PM +0200, Ard Biesheuvel wrote:
>>>
>>> Not having to call the function twice is the whole point. In the arm64
>>> case, all the SHA-256 round keys can be kept in registers (it has 32
>>> 16-byte SIMD registers), and that is what motivates this pattern. By
>>> passing a head block, a pointer to the source and the generic pointer
>>> (which arm64 uses to finalize the block, we can process all data in a
>>> single invocation of the block transform)
>>
>> Does this really make any difference? With IPsec the partial code
>> path is never even going to get executed.
>>
>
> This is not the partial code path, it is the .finup path, in fact.
> Anything that hashes data that is often a multiple of the block size
> (which is more likely for block based applications than for IPsec, I
> think) should benefit from this. But even if it is not, using a head
> block and a pointer to the src eliminates one call of the block
> transform.
>
> Note that, in the arm64 case, calling a SHA-256 block transform in
> non-process context involves:
> - stacking the contents of 28 SIMD registers (28 x 16 = 448 bytes)
> - loading the SHA-256 constants (16 x 16 = 256 bytes)
> - processing the data
> - unstacking the contents of 28 SIMD registers (448 bytes)
>
> so anything that can prevent needlessly calling these functions
> multiple times in quick successsion is going to help, and 'just
> calling it twice' just doesn't cut it.
>

OK, stacking/unstacking can be amortized over multiple invocations of
the block transform, only loading the round constants cannot.


>>> Do note that these are only used by static inline functions, so the
>>> unused arguments are all eliminated from the binary anyway. In fact,
>>> looking at the generated code, the function calls don't use function
>>> pointers at all anymore,
>>> but just call the block transform directly, so the typedef is only
>>> used as a prototype, really.
>>
>> It's not just the generated code.  The next guy that comes along
>> and writes a SHA implementation is going to go WTH is this p
>> argument.  I'm not going to add crap to the generic layer just
>> because ARM needs it.  In fact ARM doesn't even need it.
>>
>
> OK, so there are 2 pieces of crap [sic] in this proposed generic layer:
> - the head block
> - the generic pointer
>
> The generic pointer is used in the arm64 case to convey the
> information that the current invocation of the block transform is the
> final one, and the core code can apply the padding and finalize /and/
> pass back whether it has done so or not. (the latter can easily be
> done in the C code as well)  I used a generic pointer to allow other
> uses, but if you have a better idea for this particular use case, I'd
> be happy to hear it.
