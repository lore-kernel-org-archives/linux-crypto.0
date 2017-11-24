From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: x509 parsing bug + fuzzing crypto in the userspace
Date: Fri, 24 Nov 2017 17:18:08 +0100
Message-ID: <CACT4Y+YLfRhvOL=XDq_46JuwcBv6DMaD1AntitP_G+GTJ3oUHQ@mail.gmail.com>
References: <CAG_fn=XJZG_MJXXgos5jZmOThKho=uSvwgfhkMSYONZ04PKKaw@mail.gmail.com>
 <3132962.8EQ63lqCxc@tauon.chronox.de> <CACT4Y+Zp39AMymVXB8ZdGA1VRYwRVsouuEXdhY3nmP5oawcfEQ@mail.gmail.com>
 <2926823.qMJ9kpMUtP@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Eric Biggers <ebiggers@google.com>,
        Alexander Potapenko <glider@google.com>,
        linux-crypto@vger.kernel.org, Kostya Serebryany <kcc@google.com>,
        keyrings@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:46691 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753535AbdKXQSa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Nov 2017 11:18:30 -0500
Received: by mail-pg0-f41.google.com with SMTP id z184so15574873pgd.13
        for <linux-crypto@vger.kernel.org>; Fri, 24 Nov 2017 08:18:30 -0800 (PST)
In-Reply-To: <2926823.qMJ9kpMUtP@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 24, 2017 at 4:03 PM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Freitag, 24. November 2017, 14:49:49 CET schrieb Dmitry Vyukov:
>
> Hi Dmitry,
>
>> I've cooked syzkaller change that teaches it to generate more
>> algorithm names. Probably not idea, but much better than was before:
>> https://github.com/google/syzkaller/blob/ddf7b3e0655cf6dfeacfe509e477c1486d2
>> cc7db/sys/linux/alg.go
>
> I am not as fluent in GO, so I may miss a point here:
>
>                 {"authencesn", []int{ALG_HASH, ALG_BLKCIPHER}},
>                 {"authenc", []int{ALG_HASH, ALG_BLKCIPHER}},
>
> These both are templates to form an AEAD cipher. They allow you to specify the
> block cipher and the hash type.


Most of this works the way you describe. This is effectively production grammar.
authencesn is a template produces AEAD and consumes 2 args: ALG_HASH
and ALG_BLKCIPHER.



>                 {"rfc7539esp", []int{ALG_BLKCIPHER, ALG_HASH}},
>                 {"rfc7539", []int{ALG_BLKCIPHER, ALG_HASH}},
>                 {"rfc4543", []int{ALG_AEAD}},
>                 {"rfc4106", []int{ALG_AEAD}},
>
> These are no ciphers per se, but simply formatting mechanisms. For example, to
> make use of rfc4106, you must split the IV: the first four bytes need to be
> appended to the key and the trailing 8 bytes are used as the IV. Any other
> formatting should cause an error. Besides, these implementations should only
> work with some AEAD ciphers like GCM.



So rfc4543 consumes AEAD and itself is a AEAD (can be passed whenever
AEAD is requried), right? If yes, then it works the way you described
(minus the part that is works only with _some_ AEAD ciphers, fuzzer
will try to blindly combine it with all of them).

rfc7539 consumes 2 args, not 1, right? I figured out that it consumes
BLKCIPHER and HASH.



>
>
>                 {"pcrypt", []int{ALG_AEAD}},
>                 {"rfc4309", []int{ALG_AEAD}},
>                 {"gcm", []int{ALG_CIPHER}},
>                 {"gcm_base", []int{ALG_BLKCIPHER, ALG_HASH}},
>                 {"ccm", []int{ALG_CIPHER}},
>                 {"ccm_base", []int{ALG_BLKCIPHER, ALG_HASH}},
>
>
>
>
>                 {"echainiv", []int{ALG_AEAD}},
> {"seqiv", []int{ALG_AEAD}},
>
> These are IV generators and should be used with an AEAD cipher to internally
> generate IVs. Note, the use of IV generators have changed with 4.2 (see my
> script I sent you as part of this thread).
>
>
>
>                 {"gcm(aes)", nil},
>
> gcm() is also a template that can consume any block cipher, including aes-
> generic, serpent, ...
>
>                 {"gcm_base(ctr(aes-aesni),ghash-generic)", nil},
>
> Again, ctr() is a template that can consume other block ciphers.
>
>                 {"generic-gcm-aesni", nil},
>
> Does this exist?

I can create it:

strcpy(addr.salg_type, "aead");
strcpy(addr.salg_name, "generic-gcm-aesni");

bind(3, {sa_family=0x26 /* AF_??? */,
sa_data="aead\0\0\0\0\0\0\0\0\0\0"}, 88) = 0



>
>                 {"rfc4106(gcm(aes))", nil},
>
> rfc... is a template that can consume AEAD ciphers.
>
>                 {"rfc4106-gcm-aesni", nil},
>                 {"__gcm-aes-aesni", nil},
> {"__driver-gcm-aes-aesni", nil},
>
> Please specifically test that __driver_... names should NEVER be allocatable
> from user space.
>
>
>
>         // algorithms:
>                 {"cbc(aes)", nil},
>
> cbc() is a template
>
>
>                 {"cbc(aes-aesni)", nil},
>                 {"chacha20", nil},
>                 {"chacha20-simd", nil},
>                 {"pcbc(aes)", nil},
>                 {"pcbc-aes-aesni", nil},
>                 {"fpu(pcbc(__aes))", nil},
>                 {"fpu(pcbc(__aes-aesni))", nil},
>                 {"pcbc(__aes)", nil},
>                 {"pcbc(__aes-aesni)", nil},
>
> They are all templates.
>
>                 {"xts(aes)", nil},
>
> xts() is a template.
>
> Note, starting with 4.9, you must use xts(ecb(aes)).

"xts(aes)" also works on upstream (4.15):

strcpy(addr.salg_type, "skcipher");
strcpy(addr.salg_name, "xts(aes)");

bind(3, {sa_family=0x26 /* AF_??? */, sa_data="skcipher\0\0\0\0\0\0"}, 88) = 0



>                 {"xts-aes-aesni", nil},
> {"ctr(aes)", nil},
>
> ctr() is a template
>
>
>
> In general, I would rather suggest:
>
> 1. identify all templates and mark them what they can consume (other
> templates, AEAD, skcipher, hash, ...)
>
> 2. identify all ciphers (aes, aes-generic, aes-aesni, ...) and identify their
> types (skcipher, hash)
>
> 3. mix-n-match templates with the ciphers according to what templates can
> consume
>
>
> Start another test where you arbitrarily mix-n-match templates and ciphers or
> even bogus names, NULL, etc.
>
>
> One word of warning: some cipher names may look like templates, but they are
> not: gcm(aes) in arch/x86/crypto/ is a complete cipher and not consisting of
> templates. Thus, I would always use the driver names (gcm-aes-aesni for the
> given example) to ensure you test exactly the cipher you had in mind.
>
> Word of warning II: There is a bug in the kernel crypto API: if you allocate a
> cipher using the driver name that was not registered before, this cipher will
> never be available using its "name". /proc/crypto shows you the reason: the
> "name" is then identical to the driver name.
>
> Ciao
> Stephan
