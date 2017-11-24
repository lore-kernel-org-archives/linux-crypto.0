From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: x509 parsing bug + fuzzing crypto in the userspace
Date: Fri, 24 Nov 2017 16:53:26 +0100
Message-ID: <CACT4Y+bJP=XWK=kvs03R7OV9fL1BYmGo9fw+e7N2GzQGb7wTAQ@mail.gmail.com>
References: <CAG_fn=XJZG_MJXXgos5jZmOThKho=uSvwgfhkMSYONZ04PKKaw@mail.gmail.com>
 <2631912.1nF8QvS07C@tauon.chronox.de> <CACT4Y+bk4an+8RgyCOeQvGug_qXSktfgHyk3NKF7OgbVrS8kyw@mail.gmail.com>
 <1748580.hh6WObTt7s@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Eric Biggers <ebiggers@google.com>,
        Alexander Potapenko <glider@google.com>,
        linux-crypto@vger.kernel.org, Kostya Serebryany <kcc@google.com>,
        keyrings@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:37636 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753520AbdKXPxs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Nov 2017 10:53:48 -0500
Received: by mail-pg0-f50.google.com with SMTP id m4so5606120pgc.4
        for <linux-crypto@vger.kernel.org>; Fri, 24 Nov 2017 07:53:47 -0800 (PST)
In-Reply-To: <1748580.hh6WObTt7s@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 24, 2017 at 4:13 PM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Freitag, 24. November 2017, 15:55:59 CET schrieb Dmitry Vyukov:
>
> Hi Dmitry,
>
>> On Fri, Nov 24, 2017 at 3:36 PM, Stephan Mueller <smueller@chronox.de>
> wrote:
>> > Am Freitag, 24. November 2017, 14:49:49 CET schrieb Dmitry Vyukov:
>> >
>> > Hi Dmitry,
>> >
>> >> On Thu, Nov 23, 2017 at 1:35 PM, Stephan Mueller <smueller@chronox.de>
>> >
>> > wrote:
>> >> > Am Donnerstag, 23. November 2017, 12:34:54 CET schrieb Dmitry Vyukov:
>> >> >
>> >> > Hi Dmitry,
>> >> >
>> >> >> Btw, I've started doing some minimal improvements, did not yet sorted
>> >> >> out alg types/names, and fuzzer started scratching surface:
>> >> >>
>> >> >> WARNING: kernel stack regs has bad 'bp' value 77 Nov 23 2017 12:29:36
>> >> >> CET
>> >> >> general protection fault in af_alg_free_areq_sgls 54 Nov 23 2017
>> >> >> 12:23:30
>> >> >> CET general protection fault in crypto_chacha20_crypt 100 Nov 23 2017
>> >> >> 12:29:48 CET suspicious RCU usage at
>> >> >> ./include/trace/events/kmem.h:LINE
>> >> >> 88
>> >> >> Nov 23 2017 12:29:15 CET
>> >> >
>> >> > This all looks strange. Where would RCU come into play with
>> >> > af_alg_free_areq_sgls?
>> >> >
>> >> > Do you have a reproducer?
>> >> >
>> >> >> This strongly suggests that we need to dig deeper.
>> >> >
>> >> > Absolutely. That is why I started my fuzzer that turned up already
>> >> > quite
>> >> > some issues.
>> >>
>> >> I've cooked syzkaller change that teaches it to generate more
>> >> algorithm names. Probably not idea, but much better than was before:
>> >> https://github.com/google/syzkaller/blob/ddf7b3e0655cf6dfeacfe509e477c148
>> >> 6d2 cc7db/sys/linux/alg.go (if you see any obvious issues there, feedback
>> >> is welcome,
>> >
>> > I will peek into that code shortly.
>> >
>> >> I still did not figure out completely difference between e.g.
>> >> HASH/AHASH,
>> >
>> > AHASH is the asynchronous hash. I.e. the implementation can sleep.
>> >
>> > HASH == SHASH and is the synchronous hash. I.e. that implementation will
>> > never sleep.
>> >
>> > An SHASH can be turned into an AHASH by using cryptd().
>> >
>> > An AHASH can never be turned into an SHASH.
>> >
>> > To use SHASH implementations, you use the *_shash API calls. This API does
>> > not require a request structure.
>> >
>> > To use AHASH implementations, you use the *_ahash API calls. This API
>> > requires the use of ahash_request_* calls. By transparently employing
>> > cryptd(), the kernel allows the use of SHASH implementations with the
>> > AHASH API.
>> >
>> > Currently there is only one real AHASH implementation outside specific
>> > hardware drivers: sha1_mb and sha2*_mb found in arch/x86/crypto/. This
>> > implementation can only be used with the AHASH API. All (other) SHASH
>> > implementations can be used with either the shash or the ahash API,
>> > because
>> > when using it as AHASH, the kernel automatically uses the cryptd() under
>> > the hood.
>>
>> I am interested solely in user-space API because that's what fuzzer
>> uses. *_shash, ahash_request_* are of little help.
>> Your last sentence above means that there is _no_ difference between
>> HASH and AHASH from user-space?
>
> Correct.
>
>> I thrown all HASH/AHASH algs into a single bucket here:
>> https://github.com/google/syzkaller/blob/ddf7b3e0655cf6dfeacfe509e477c1486d2
>> cc7db/sys/linux/alg.go And similarly for BLKCIPHER/ABLKCIPHER.
>
> This approach is correct.
>>
>>
>> Few additional questions:
>>
>> 1. just to double check: compress algs are not accessible from
>> user-space, right?
>
> Right, because there is no algif_acomp (yet).
>>
>> 2. There is some setup for algorithms (ALG_SET_KEY,
>> ALG_SET_AEAD_AUTHSIZE setsockopts and ALG_SET_IV, ALG_SET_OP,
>> ALG_SET_AEAD_ASSOCLEN control messages are the ones that was able to
>> find).
>
> ... and do not forget that you need to call the setup calls *before* the
> accept() call for an operation to work correctly.


I will hand it off to fuzzer, it should be able to do it both ways (+
calling both before and after, calling concurrently, etc).


>> Now if I chain something complex like
>> gcm_base(ctr(aes-aesni),ghash-generic) (I don't know if algorithms
>> there require setup or not, but let's assume they do).
>
> All ciphers always require setup:
>
> - skciphers: IV (excluding ECB of course) and key
>
> - AEAD: IV, key, authsize and assoclen
>
> - hashes: key (only for the MACs)
>
> Your example of gcm_base is an AEAD.
>
>
>> How do I setup
>> inner algorithms parameters (e.g. aes-aesni in this case)?
>
> You cannot access the inner ciphers. For the interface, you only have *one*
> cipher, i.e. an AEAD. The name only tells the kernel how to construct the
> cipher. But once it is constructed, it takes the aforementioned parameters.
> Though, some ciphers may be more restrictive on some parameters than others
> (e.g. the authsize or assoclen may be restricted for some AEAD ciphers).
>
>> Is there a
>> way to call setsockopt effectively on a particular inner alg?
>
> You cannot do that and you do not want to do that.
>
>> Or pass
>> control messages to an inner alg? Maybe I am asking non-sense, but
>> that's what comes to my mind looking at the api.
>
> You cannot talk to the inner ciphers. You only talk to one cipher that you
> referred to with the name. Remember, the name is ONLY used to tell the kernel
> which parts to put together during allocation. After the allocation, you have
> only one cipher and interact with only one cipher of the given type.

I see. Makes sense. I guess an outer template can transitively setup
inner algorithms if necessary.
