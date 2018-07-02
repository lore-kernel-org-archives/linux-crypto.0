From: Kees Cook <keescook@chromium.org>
Subject: Re: [dm-devel] [PATCH v3 9/9] crypto: shash: Remove VLA usage in
 unaligned hashing
Date: Mon, 2 Jul 2018 10:34:46 -0700
Message-ID: <CAGXu5jK1Tn1wXN1+hLxVJxTFb2QusCXLzmQJPKwzvAF_AEEZEQ@mail.gmail.com>
References: <20180629002843.31095-1-keescook@chromium.org> <20180629002843.31095-10-keescook@chromium.org>
 <20180630070301.GA1706@sol.localdomain> <CAGXu5jJ9eqETPdrvUZrV9bhnNQA6LwBuk+V5MeQrAS_M=_VX+Q@mail.gmail.com>
 <20180701172058.GA26715@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        qat-linux@intel.com, LKML <linux-kernel@vger.kernel.org>,
        dm-devel@redhat.com, linux-crypto <linux-crypto@vger.kernel.org>,
        Lars Persson <larper@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>,
        Rabin Vincent <rabinv@axis.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180701172058.GA26715@sol.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Jul 1, 2018 at 10:20 AM, Eric Biggers <ebiggers3@gmail.com> wrote:
> On Sun, Jul 01, 2018 at 10:04:59AM -0700, Kees Cook wrote:
>> On Sat, Jun 30, 2018 at 12:03 AM, Eric Biggers <ebiggers3@gmail.com> wrote:
>> > On Thu, Jun 28, 2018 at 05:28:43PM -0700, Kees Cook wrote:
>> >> @@ -88,11 +81,13 @@ static int shash_update_unaligned(struct shash_desc *desc, const u8 *data,
>> >>       unsigned long alignmask = crypto_shash_alignmask(tfm);
>> >>       unsigned int unaligned_len = alignmask + 1 -
>> >>                                    ((unsigned long)data & alignmask);
>> >> -     u8 ubuf[shash_align_buffer_size(unaligned_len, alignmask)]
>> >> -             __aligned_largest;
>> >> +     u8 ubuf[MAX_ALGAPI_ALIGNMASK + 1];
>> >>       u8 *buf = PTR_ALIGN(&ubuf[0], alignmask + 1);
>> >>       int err;
>> >>
>> >> +     if (WARN_ON(buf + unaligned_len > ubuf + sizeof(ubuf)))
>> >> +             return -EINVAL;
>> >> +
>> >
>> > How is 'ubuf' guaranteed to be large enough?  You removed the __aligned
>> > attribute, so 'ubuf' can have any alignment.  So the aligned pointer 'buf' may
>> > be as high as '&ubuf[alignmask]'.  Then, up to 'alignmask' bytes of data will be
>> > copied into 'buf'... resulting in up to '2 * alignmask' bytes needed in 'ubuf'.
>> > But you've only guaranteed 'alignmask + 1' bytes.
>>
>> Hm, good point. Adding __aligned(MAX_ALGAPI_ALIGNMASK + 1) looks to
>> fix this, yes?
>>
>> Also, if __aligned() is used here, can't PTR_ALIGN() be dropped? (I
>> think you pointed this out earlier.)
>
> Sure, I'm just not sure whether __aligned() with such a large alignment is
> guaranteed to work on stack variables on all architectures.  See e.g.
> https://patchwork.kernel.org/patch/9507697/.

That's terrible. :( That seems like a compiler bug, but okay.

>> Also, is "unaligned_len" being calculated correctly? Let's say
>> alignmask is 63. If data is binary ...111111, then unaligned_len will
>> be 64 - 63 == 1, which is fine: we copy 1 byte out, bump the address
>> by 1, and we're happily aligned to ...000000. If data is ...000000,
>> then unaligned_len will be 64. But it should be 0. Shouldn't this be:
>>
>> unsigned int unaligned_len;
>>
>> unaligned_len = (unsigned long)data & alignmask;
>> if (unaligned_len)
>>     unaligned_len = alignmask + 1 - unaligned_len;
>>
>> And then ubuf only needs to be MAX_ALGAPI_ALIGNMASK, without the +1?
>
> shash_update_unaligned() is only called when 'data & alignmask'.
> Similarly with shash_final_unaligned().

Ah! I see that now.

> Though, calculating 'unaligned_len' could be simplified to
>
>         unsigned int unaligned_len = -(unsigned long)data & alignmask;
>
> which works either way.

So, since we can't depend on __aligned() working, I'll just keep the
PTR_ALIGN and add MAX_ALGAPI_ALIGNMASK to each array. That'll be less
memory-efficient, but it'll actually get aligned correctly.

-Kees

-- 
Kees Cook
Pixel Security
