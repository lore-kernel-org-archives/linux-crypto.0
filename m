From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Tue, 10 Jan 2017 09:05:28 -0800
Message-ID: <CA+55aFyuUCr3aUBhFt6T3vKyZOskLyH8Kd_2jeFkPYxxvEaXEg@mail.gmail.com>
References: <20170110143340.GA3787@gondor.apana.org.au> <20170110143913.GA3822@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:36410 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757974AbdAJRFa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Jan 2017 12:05:30 -0500
In-Reply-To: <20170110143913.GA3822@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 10, 2017 at 6:39 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> BTW this is with Debian gcc 4.7.2 which does not allow an 8-byte
> stack alignment as attempted by the Makefile:

I'm pretty sure we have random asm code that may not maintain a
16-byte stack alignment when it calls other code (including, in some
cases, calling C code).

So I'm not at all convinced that this is a good idea. We shouldn't
expect 16-byte alignment to be something trustworthy.

                 Linus
