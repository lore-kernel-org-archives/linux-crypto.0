From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: vmalloced stacks and scatterwalk_map_and_copy()
Date: Sun, 20 Nov 2016 18:19:48 -0800
Message-ID: <CALCETrXg5ytkLHBpKMJG7fBea+xy2wz6kSm2XK5c8K7_Hr9UuA@mail.gmail.com>
References: <20161103181624.GA63852@google.com> <CALCETrUPuunBT1Zo25wyOwqaWJ=rm9R-WMZGN-7u4-dsdokAnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lutomirski <luto@kernel.org>
To: Eric Biggers <ebiggers@google.com>, regressions@leemhuis.info
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUPuunBT1Zo25wyOwqaWJ=rm9R-WMZGN-7u4-dsdokAnQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[Adding Thorsten to help keep this from getting lost]

On Thu, Nov 3, 2016 at 1:30 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Nov 3, 2016 at 11:16 AM, Eric Biggers <ebiggers@google.com> wrote:
>> Hello,
>>
>> I hit the BUG_ON() in arch/x86/mm/physaddr.c:26 while testing some crypto code
>> in an x86_64 kernel with CONFIG_DEBUG_VIRTUAL=y and CONFIG_VMAP_STACK=y:
>>
>>         /* carry flag will be set if starting x was >= PAGE_OFFSET */
>>         VIRTUAL_BUG_ON((x > y) || !phys_addr_valid(x));
>>
>> The problem is the following code in scatterwalk_map_and_copy() in
>> crypto/scatterwalk.c, which tries to determine if the buffer passed in aliases
>> the physical memory of the first segment of the scatterlist:
>>
>>         if (sg_page(sg) == virt_to_page(buf) &&
>>             sg->offset == offset_in_page(buf))
>>                 return;
>
> ...
>
>>
>> Currently I think the best solution would be to require that callers to
>> scatterwalk_map_and_copy() do not alias their source and destination.  Then the
>> alias check could be removed.  This check has only been there since v4.2 (commit
>> 74412fd5d71b6), so I'd hope not many callers rely on the behavior.  I'm not sure
>> exactly which ones do, though.
>>
>> Thoughts on this?
>
> The relevant commit is:
>
> commit 74412fd5d71b6eda0beb302aa467da000f0d530c
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Thu May 21 15:11:12 2015 +0800
>
>     crypto: scatterwalk - Check for same address in map_and_copy
>
>     This patch adds a check for in scatterwalk_map_and_copy to avoid
>     copying from the same address to the same address.  This is going
>     to be used for IV copying in AEAD IV generators.
>
>     There is no provision for partial overlaps.
>
>     This patch also uses the new scatterwalk_ffwd instead of doing
>     it by hand in scatterwalk_map_and_copy.
>
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> Herbert, can you clarify this?  The check seems rather bizarre --
> you're doing an incomplete check for aliasing and skipping the whole
> copy if the beginning aliases.  In any event the stack *can't*
> reasonably alias the scatterlist because a scatterlist can't safely
> point to the stack.  Is there any code that actually relies on the
> aliasing-detecting behavior?
>
> Also, Herbert, it seems like the considerable majority of the crypto
> code is acting on kernel virtual memory addresses and does software
> processing.  Would it perhaps make sense to add a kvec-based or
> iov_iter-based interface to the crypto code?  I bet it would be quite
> a bit faster and it would make crypto on stack buffers work directly.


Ping, everyone!

It's getting quite close to 4.9 release time.  Is there an actual bug
here?  Because, if so, we need to fix it.  My preference is to just
delete the weird aliasing check, but it would be really nice to know
if that check is needed for some reason.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
