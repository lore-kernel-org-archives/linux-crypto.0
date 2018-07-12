From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v4 11/14] treewide: Prepare to remove VLA usage for AHASH_REQUEST_ON_STACK
Date: Thu, 12 Jul 2018 13:17:30 -0700
Message-ID: <CAGXu5jKiJkypPKXrSjnXOgkZZT=Sm=fLK0sAL_U9A40GVRFZBg@mail.gmail.com>
References: <20180711203619.1020-1-keescook@chromium.org> <20180711203619.1020-12-keescook@chromium.org>
 <CAK8P3a3356dbruUfS_+fj9f+X-0jbNE8WMe5sWhJmuRY9Nvcbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Eric Biggers <ebiggers@google.com>,
        Alasdair Kergon <agk@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, qat-linux@intel.com,
        dm-devel@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a3356dbruUfS_+fj9f+X-0jbNE8WMe5sWhJmuRY9Nvcbg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 12, 2018 at 9:02 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wed, Jul 11, 2018 at 10:36 PM, Kees Cook <keescook@chromium.org> wrote:
>> Several uses of AHASH_REQUEST_ON_STACK() will trigger FRAME_WARN warnings
>> (when less than 2048) once the VLA is no longer hidden from the check:
>>
>> drivers/block/drbd/drbd_worker.c:325:1: warning: the frame size of 1112 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>> drivers/block/drbd/drbd_worker.c:352:1: warning: the frame size of 1120 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>> crypto/ccm.c:235:1: warning: the frame size of 1184 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>> drivers/md/dm-crypt.c:353:1: warning: the frame size of 1096 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>> drivers/net/ppp/ppp_mppe.c:158:1: warning: the frame size of 1168 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>> net/wireless/lib80211_crypt_tkip.c:537:1: warning: the frame size of 1136 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>> drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c:528:1: warning: the frame size of 1136 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>> drivers/staging/rtl8192e/rtllib_crypt_tkip.c:531:1: warning: the frame size of 1136 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>>
>> This bumps the affected objects by 20% to silence the warnings while still
>> providing coverage is anything grows even more.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> I think this is a dangerous precedent, I wouldn't really want any of
> those functions to
> ever take more than 1024 bytes, even that is really too much, but we
> can't easily
> lower the global limit.

The issue is that these are _already_ able to use this much stack
because of the VLA. It was just hidden from the FRAME_WARN checks.

> You are patching all users of AHASH_REQUEST_ON_STACK with the exception of
> arch/x86/power/hibernate_64.c here (which is always used on 64-bit and has
> a larger limit already), which in turn suggests that the AHASH_REQUEST_ON_STACK
> macro using bytes is just fundamentally broken by requiring that much space
> (808 bytes for the context, plus 8 pointers for struct ahash_request, plus
> CRYPTO_MINALIGN_ATTR).

Yes -- it's huge. That's always been true, unfortunately.

> How did you come up with that 808 byte number? I see a total of 39 callers
> of crypto_ahash_set_reqsize(), did you check all of those individually?
> If 808 bytes is the worst case, what are the next 5 ones? If there are only
> a few of them that are badly written, maybe we can fix the drivers instead
> and lower that number to something more reasonable.

That was discussed a bit (maybe not enough?) in the next patch:
https://patchwork.kernel.org/patch/10520407/

I used tcrypt (which examines all sane combinations) and sha512
produces the 808 number. I had done an earlier manual evaluation of
all crypto_ahash_set_reqsize() callers but Herbert and Eric pointed
out issues with my methodology (namely that things can be recursively
stacked (I had calculated too low) but some things will never be
stacked together (so some pathological conditions will never happen)).
So I moved to the tcrypt instrumentation approach, which tests
real-world combinations.

For example, reaching this 808 size is trivially easy to do right now
by just asking for dm-crypt to use a cipher of
capi:cbc(aes)-essiv:sha512.

> Looking through some of the drivers, I found this interesting one:
>
> #define SHA_BUFFER_LEN          (PAGE_SIZE / 16)
> struct atmel_sha_reqctx {
> ...
>         u8 buffer[SHA_BUFFER_LEN + SHA512_BLOCK_SIZE] __aligned(sizeof(u32));
> };
>
> which would result in overrunning the kernel stack immediately if ever
> used with 64k PAGE_SIZE (we fortunately don't support that driver on
> any architectures with 64k pages yet).

Right -- the large page size isn't reachable there. But we don't
overrun the kernel stack because of the check I added in
crypto_ahash_set_reqsize() in the above mentioned patch.

> The other ones I looked at seem to all be well under 400 bytes (which is
> still a lot to put on the stack, but probably ok).

I wish sha512 was "rare", but it's not. :(

So: mainly the crypto VLA removal is about exposing all these giant
stack usages. We can work to fix them, but I want to get these fixed
so we can add -Wvla to the kernel to avoid more being added (we've had
at least 2 added during this linux-next cycle already).

IMO, we're much better off with this stack usage _actually_ being
checked (even with a 20% bump) than staying entirely hidden (as it's
been).

-Kees

-- 
Kees Cook
Pixel Security
