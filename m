From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: x509 parsing bug + fuzzing crypto in the userspace
Date: Fri, 24 Nov 2017 14:49:49 +0100
Message-ID: <CACT4Y+Zp39AMymVXB8ZdGA1VRYwRVsouuEXdhY3nmP5oawcfEQ@mail.gmail.com>
References: <CAG_fn=XJZG_MJXXgos5jZmOThKho=uSvwgfhkMSYONZ04PKKaw@mail.gmail.com>
 <CACT4Y+ZSUWEni6SdmM5K-CsZshq77CNGdZedC0tYhcv6p=7Qvg@mail.gmail.com>
 <CACT4Y+bMAH1zK2v5XgF2Zz72ghOYAoMbef3+CjLO5HfTEfAEzg@mail.gmail.com> <3132962.8EQ63lqCxc@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Eric Biggers <ebiggers@google.com>,
        Alexander Potapenko <glider@google.com>,
        linux-crypto@vger.kernel.org, Kostya Serebryany <kcc@google.com>,
        keyrings@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:36445 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753351AbdKXNuL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Nov 2017 08:50:11 -0500
Received: by mail-pg0-f53.google.com with SMTP id 199so3736136pgg.3
        for <linux-crypto@vger.kernel.org>; Fri, 24 Nov 2017 05:50:11 -0800 (PST)
In-Reply-To: <3132962.8EQ63lqCxc@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 23, 2017 at 1:35 PM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Donnerstag, 23. November 2017, 12:34:54 CET schrieb Dmitry Vyukov:
>
> Hi Dmitry,
>
>> Btw, I've started doing some minimal improvements, did not yet sorted
>> out alg types/names, and fuzzer started scratching surface:
>>
>> WARNING: kernel stack regs has bad 'bp' value 77 Nov 23 2017 12:29:36 CET
>> general protection fault in af_alg_free_areq_sgls 54 Nov 23 2017 12:23:30
>> CET general protection fault in crypto_chacha20_crypt 100 Nov 23 2017
>> 12:29:48 CET suspicious RCU usage at ./include/trace/events/kmem.h:LINE 88
>> Nov 23 2017 12:29:15 CET
>
> This all looks strange. Where would RCU come into play with
> af_alg_free_areq_sgls?
>
> Do you have a reproducer?
>>
>> This strongly suggests that we need to dig deeper.
>
> Absolutely. That is why I started my fuzzer that turned up already quite some
> issues.

I've cooked syzkaller change that teaches it to generate more
algorithm names. Probably not idea, but much better than was before:
https://github.com/google/syzkaller/blob/ddf7b3e0655cf6dfeacfe509e477c1486d2cc7db/sys/linux/alg.go
(if you see any obvious issues there, feedback is welcome, I still did
not figure out completely difference between e.g. HASH/AHASH,
BLKCIPHER/ABLKCIPHER as most of them seem to be interchangable; this
was mostly based on try and trial approach).

All bugs with details will soon be reported by syzbot
(https://goo.gl/tpsmEJ) to kernel mailing lists with all details.

Stephan, thanks for your help!
