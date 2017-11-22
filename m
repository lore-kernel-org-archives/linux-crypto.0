From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: x509 parsing bug + fuzzing crypto in the userspace
Date: Wed, 22 Nov 2017 11:44:51 +0100
Message-ID: <CACT4Y+bX-apiqnObwXJ2YsYDsW9vN0zUAzMRp+yZNwy=v9L6fw@mail.gmail.com>
References: <CAG_fn=XJZG_MJXXgos5jZmOThKho=uSvwgfhkMSYONZ04PKKaw@mail.gmail.com>
 <20171120214257.GB61394@google.com> <CACT4Y+b5n-G_+mjYHMzaibrMKAwXZ=SqsnK3f+Qu=uT8VN1yMQ@mail.gmail.com>
 <20171121204628.GA56006@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Alexander Potapenko <glider@google.com>,
        linux-crypto@vger.kernel.org, Kostya Serebryany <kcc@google.com>,
        keyrings@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pl0-f54.google.com ([209.85.160.54]:38579 "EHLO
        mail-pl0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751863AbdKVKpN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Nov 2017 05:45:13 -0500
Received: by mail-pl0-f54.google.com with SMTP id s10so504399plj.5
        for <linux-crypto@vger.kernel.org>; Wed, 22 Nov 2017 02:45:13 -0800 (PST)
In-Reply-To: <20171121204628.GA56006@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 21, 2017 at 9:46 PM, Eric Biggers <ebiggers@google.com> wrote:
> On Tue, Nov 21, 2017 at 09:00:26AM +0100, Dmitry Vyukov wrote:
>> >
>> > Note that separate from asymmetric_keys (which you can think of as being
>> > in-between the keyrings subsystem and the crypto subsystem) there is also the
>> > userspace interface to cryptographic algorithms, AF_ALG.  It might be possible
>> > to port a lot of the crypto API to userspace, but it would require a lot of work
>> > to stub things out.  Maybe a simpler improvement would be to teach syzkaller to
>> > more thoroughly test AF_ALG.  For example it could be made aware of algorithm
>> > templates so that it could try combining them in unusual ways.  (Example:
>> > https://marc.info/?l=linux-crypto-vger&m=148063683310477&w=2 was a NULL pointer
>> > dereference bug that occurred if you asked to use the algorithm "mcryptd(md5)",
>> > i.e. the mcryptd template wrapping md5.)  Also,
>> > CONFIG_CRYPTO_MANAGER_DISABLE_TESTS should be unset, so that the crypto
>> > self-tests are enabled.
>>
>>
>> Can you please outline all uncovered by the current syzkaller
>> descriptions parts? We should add least TODO's for them. Or maybe we
>> could just resolve them right away.
>>
>
> Just focusing on the algorithm names, the syzkaller descriptions currently use a
> fixed set of algorithm names:
>
>         salg_name = "cmac(aes)", "ecb(aes)", "cbc(aes)", "hmac(sha1)", [...]
>
> But algorithm names are not just fixed strings; you can create "new" algorithms
> by composing templates.  For example "cmac(aes)" indicates the "cmac" template
> instantiated using "aes" as the underlying block cipher.  But it could also be
> "cmac(des)", "cmac(blowfish)", etc.  Templates can even take multiple arguments,
> e.g. "gcm_base(ctr(aes),ghash)".
>
> So ideally the descriptions would contain the list of all templates which might
> be available in addition to all "primitive" algorithm names, then express that
> an algorithm name has a syntax like:
>
>         alg_name -> primitive_alg_name | template_name(alg_name[,alg_name]*)
>
> To get the list of all "primitive" algorithm names which might be available you
> can run:
>
>         git grep -E '\.cra_(driver_)?name' | grep -o '".*"' | sort | uniq
>
> It's a long list, though it doesn't distinguish between the different types of
> algorithm (hash, symmetric cipher, AEAD, etc.), and not all are actually
> accessible through AF_ALG.  Note that it still includes names with parentheses
> because a module may directly implement an algorithm like "xts(aes)", which then
> may be used instead of the template version.
>
> And to get the list of templates which might be available you can run:
>
>         git grep -A5 'struct crypto_template.*{' | grep '\.name' | grep -o '".*"' | sort
>
> (There is probably more to improve for AF_ALG besides the algorithm names; this
> is just what I happened to notice for now.)


Thanks! I think we can incorporate this into syzkaller.

One question: what's the relation between alg names and type ("aead",
"hash", "rng", "skcipher")? I remember I already looked at it before
and could not figure it out. Are all algorithms and templates
partitioned between types? Or they are orthogonal?
