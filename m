From: Stephan Mueller <smueller@chronox.de>
Subject: Re: x509 parsing bug + fuzzing crypto in the userspace
Date: Thu, 23 Nov 2017 13:35:33 +0100
Message-ID: <3132962.8EQ63lqCxc@tauon.chronox.de>
References: <CAG_fn=XJZG_MJXXgos5jZmOThKho=uSvwgfhkMSYONZ04PKKaw@mail.gmail.com> <CACT4Y+ZSUWEni6SdmM5K-CsZshq77CNGdZedC0tYhcv6p=7Qvg@mail.gmail.com> <CACT4Y+bMAH1zK2v5XgF2Zz72ghOYAoMbef3+CjLO5HfTEfAEzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Eric Biggers <ebiggers@google.com>,
        Alexander Potapenko <glider@google.com>,
        linux-crypto@vger.kernel.org, Kostya Serebryany <kcc@google.com>,
        keyrings@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42420 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751968AbdKWMff (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Nov 2017 07:35:35 -0500
In-Reply-To: <CACT4Y+bMAH1zK2v5XgF2Zz72ghOYAoMbef3+CjLO5HfTEfAEzg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 23. November 2017, 12:34:54 CET schrieb Dmitry Vyukov:

Hi Dmitry,

> Btw, I've started doing some minimal improvements, did not yet sorted
> out alg types/names, and fuzzer started scratching surface:
> 
> WARNING: kernel stack regs has bad 'bp' value 77 Nov 23 2017 12:29:36 CET
> general protection fault in af_alg_free_areq_sgls 54 Nov 23 2017 12:23:30
> CET general protection fault in crypto_chacha20_crypt 100 Nov 23 2017
> 12:29:48 CET suspicious RCU usage at ./include/trace/events/kmem.h:LINE 88
> Nov 23 2017 12:29:15 CET

This all looks strange. Where would RCU come into play with 
af_alg_free_areq_sgls?

Do you have a reproducer?
> 
> This strongly suggests that we need to dig deeper.

Absolutely. That is why I started my fuzzer that turned up already quite some 
issues.
> --
> To unsubscribe from this list: send the line "unsubscribe keyrings" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



Ciao
Stephan
