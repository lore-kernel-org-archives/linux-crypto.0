From: Stephan Mueller <smueller@chronox.de>
Subject: Re: x509 parsing bug + fuzzing crypto in the userspace
Date: Fri, 24 Nov 2017 17:19:18 +0100
Message-ID: <1838350.iOjUKSrnbm@tauon.chronox.de>
References: <CAG_fn=XJZG_MJXXgos5jZmOThKho=uSvwgfhkMSYONZ04PKKaw@mail.gmail.com> <2926823.qMJ9kpMUtP@tauon.chronox.de> <CACT4Y+brBwNCaiKvt9i_J485xkXf832_4i2iezFyO1bJ_rfqhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Eric Biggers <ebiggers@google.com>,
        Alexander Potapenko <glider@google.com>,
        linux-crypto@vger.kernel.org, Kostya Serebryany <kcc@google.com>,
        keyrings@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42478 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753561AbdKXQTU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Nov 2017 11:19:20 -0500
In-Reply-To: <CACT4Y+brBwNCaiKvt9i_J485xkXf832_4i2iezFyO1bJ_rfqhg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 24. November 2017, 17:10:59 CET schrieb Dmitry Vyukov:

Hi Dmitry,

> That's more-or-less what I did. Here:
> 
> var allAlgs = map[int][]algDesc{
>   ALG_AEAD: []algDesc{
>     // templates:
>     {"authencesn", []int{ALG_HASH, ALG_BLKCIPHER}},
>     {"gcm", []int{ALG_CIPHER}},
> 
> ALG_AEAD means that all of these names produce ALG_AEAD as the result.
> Names that has arguments after them (authencesn, gcm) are templates,
> and the list of arguments denote number and types of arguments for the
> template.
> 
> So here authencesn is a template that produces AEAD and has 2
> arguments: first is ALG_HASH, second is ALG_BLKCIPHER.
> Similarly, gsm is template that produces AEAD and has 1 argument of type
> CIPHER.
> 
> ...
>     // algorithms:
>     {"gcm(aes)", nil},
>     {"__gcm-aes-aesni", nil},
> 
> If second value is nil, that's a complete algorithm (also of type
> AEAD). I pulled in all registered implementations, so the contain the
> specialized implementations like "gcm(aes)", but note that gsm is also
> described as template above so fuzzer can use other inner ALG_CIPHER
> algorithms with gsm.

Thanks for the clarification -- as said, I am not very fluent in GO yet. :-)
> 
> > Start another test where you arbitrarily mix-n-match templates and ciphers
> > or even bogus names, NULL, etc.
> > 
> > 
> > One word of warning: some cipher names may look like templates, but they
> > are not: gcm(aes) in arch/x86/crypto/ is a complete cipher and not
> > consisting of templates. Thus, I would always use the driver names
> > (gcm-aes-aesni for the given example) to ensure you test exactly the
> > cipher you had in mind.
> I've pulled all registered algs from kernel with the following code:
> 
> void crypto_dumb(void)
> {
>     struct crypto_alg *alg;
>     const char *type;
> 
>     down_write(&crypto_alg_sem);
>     list_for_each_entry(alg, &crypto_alg_list, cra_list) {
>         pr_err("name=%s driver=%s async=%d type=%d\n",
>             alg->cra_name, alg->cra_driver_name,
>             !!(alg->cra_flags & CRYPTO_ALG_ASYNC),
>             alg->cra_flags & CRYPTO_ALG_TYPE_MASK);
>     }
>     up_write(&crypto_alg_sem);
> }

I would not obtain the list from a running kernel. Many ciphers are 
implemented in modules that are loaded on demand (or sometimes even manually). 
This list therefore is not complete per definition. Thus, I would rather grep 
through the code and search for cra_driver_name.

And once you get to templates, it is even more imperative to grep the code: 
Only full ciphers are listed in the given list. A template itself is never a 
cipher and will not show up there. Only once a template is combined into a 
full cipher, it will be registered in the list at runtime.

Note, the traversed list is what forms /proc/crypto.

Thus, after a boot, you will not see, say, rfc4106(gcm(aes)) in /proc/crypto 
(or that list). But after one allocation of that cipher, it suddenly pops up 
in /proc/crypto or that list.
> 
> so I've got these "gcm(aes)" as well. Which is why you see
> {"gcm(aes)", nil} in algorithms section.
> 
> However, the name was actually "__gcm-aes-aesni", not "gcm-aes-aesni".
> But kernel does not let me allocate neither of them (EINVAL in both
> cases).

Very good. Please leave such test, because they must not be allocatable.

Ciao
Stephan
