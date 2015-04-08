From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3 01/16] crypto: sha1: implement base layer for SHA-1
Date: Wed, 8 Apr 2015 16:18:56 +0200
Message-ID: <CAKv+Gu8_GQuYakxGkqcxh1hX3Ly0gKEqheuh0dgs3SGU-z9Ofw@mail.gmail.com>
References: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
	<1428396724-19962-2-git-send-email-ard.biesheuvel@linaro.org>
	<20150408131916.GA29646@gondor.apana.org.au>
	<CAKv+Gu9gQqQEEXgJ=JhVf=7SURx9BfRiaJkakhGv1S9FsqujaQ@mail.gmail.com>
	<20150408133050.GB29646@gondor.apana.org.au>
	<CAKv+Gu-=obTKmviwH9B2wBi==LQa_-aAXVU9QPh1gUeYyopmVw@mail.gmail.com>
	<20150408140633.GA30047@gondor.apana.org.au>
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
Received: from mail-ie0-f177.google.com ([209.85.223.177]:35174 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbbDHOS5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Apr 2015 10:18:57 -0400
Received: by iejt8 with SMTP id t8so2984663iej.2
        for <linux-crypto@vger.kernel.org>; Wed, 08 Apr 2015 07:18:56 -0700 (PDT)
In-Reply-To: <20150408140633.GA30047@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 8 April 2015 at 16:06, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Apr 08, 2015 at 03:40:56PM +0200, Ard Biesheuvel wrote:
>>
>> This is not the partial code path, it is the .finup path, in fact.
>> Anything that hashes data that is often a multiple of the block size
>> (which is more likely for block based applications than for IPsec, I
>> think) should benefit from this. But even if it is not, using a head
>> block and a pointer to the src eliminates one call of the block
>> transform.
>
> This would only ever happen if you call update on a partial block
> which should be the slow path anyway.
>
> IPsec only calls digest so it can never do a partial block update
> unless you have a badly fragmented skb.
>

OK, so using digest() (which uses finup()), there will never be any
data stashed in the struct::buf[], so the possible invocations of the
block transform are
- first call with all data
- second call with the unaligned chunk at the end + padding
- third call with the end of the padding + count

where the second call is only made in a minority of cases where there
is no room for the count and single padding byte after the data.
And the head block only helps with partial data, not with reducing the
potential number of invocations done for padding and count etc.

> Incidentally if you did want to deal with such cases in light
> of the high overhead that you have you may want to switch over
> to ahash which would allow you to do the saving and restoring
> once per operation rather than once per SG entry.
>

OK I will look into that.

>> OK, so there are 2 pieces of crap [sic] in this proposed generic layer:
>> - the head block
>> - the generic pointer
>
> Yes your patches look great otherwise.  I just want to keep things
> simple because you're creating a template for all future SHA authors.
>
>> The generic pointer is used in the arm64 case to convey the
>> information that the current invocation of the block transform is the
>> final one, and the core code can apply the padding and finalize /and/
>> pass back whether it has done so or not. (the latter can easily be
>> done in the C code as well)  I used a generic pointer to allow other
>> uses, but if you have a better idea for this particular use case, I'd
>> be happy to hear it.
>
> As I said in the original email, this appears to be equivalent to
>
>         (sctx->count + len) % SHA1_BLOCK_SIZE != 0
>
> So why not just do that check in C? It'll get compiled into a
> simple mask so it should be no slower than a branch on finalize.
>
> In fact if your assembly function always updates sctx->count
> then you could simplify that to
>
>         sctx->count % SHA1_BLOCK_SIZE != 0
>

The problem is that the block transform needs to be informed of the
fact that the current invocation is the final one, and it can perform
the padding, add the count etc. The C code can figure out by looking
at the count whether the asm code has applied the padding or not, but
it cannot really tell the asm code whether it should apply the padding
without an additional argument.

So what about

> +typedef void (sha1_block_fn)(int blocks, u8 const *src, u32 *state,
> +                          bool final);

?
