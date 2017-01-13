From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Fri, 13 Jan 2017 16:42:51 +0800
Message-ID: <20170113084251.GD22022@gondor.apana.org.au>
References: <CALCETrVb-NyKJajGEsLOrQqQrQ7cRm4sqLRxNr_yVE2-mjiDrg@mail.gmail.com>
 <20170112140215.rh247gwk55fjzmg7@treble>
 <CA+55aFxP+V6Wbq5Xw_NOksiWouEMg4gjBJgeGa-qFyxDMnTmcA@mail.gmail.com>
 <CALCETrVz-wEFVUwrpS8-Ln9SWnsF5KxkqJC-Br6wJ+e0LGM9UA@mail.gmail.com>
 <20170112201511.yj5ekqmj76r2yv6t@treble>
 <CALCETrXom8aY2XhpAyOtAwQQYF7wftBHJE_px1xr0iRmcYEJoA@mail.gmail.com>
 <20170113031107.mgitq54fmjnrvi6f@treble>
 <CALCETrUFCFn-rKnr+NG3SU7J78ree9siJC=Kz8f_Bk6eG2HyPA@mail.gmail.com>
 <20170113042758.whof5fk6eu7myctq@treble>
 <CA+55aFzRrSwGxxfZk-RUEnsz=xhcSmOwE1CenfCPBWtsS9MwDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josh Poimboeuf <jpoimboe@redhat.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46073 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750822AbdAMIn3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 03:43:29 -0500
Content-Disposition: inline
In-Reply-To: <CA+55aFzRrSwGxxfZk-RUEnsz=xhcSmOwE1CenfCPBWtsS9MwDw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 12, 2017 at 08:37:18PM -0800, Linus Torvalds wrote:
>
> So then the compiler actually needs to start adding useless instructions
> just to keep the stack 16-byte aligned.

Which it does.  Of course most of the time no extra instructions
are required because there are stack variables, so it's just matter
of adding 8 to the value you're subtracting from rsp.  But it is
probably why gcc assumes that the stack is 16-byte aligned which
triggered my original crash.

Here is an example from the function that was involved in the crash,
without frame pointers:

00000000000001b0 <chacha20_simd>:
 1b0:   41 54                   push   %r12
 1b2:   55                      push   %rbp
 1b3:   48 81 ec f8 00 00 00    sub    $0xf8,%rsp

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
