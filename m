From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: cryptomgr_test / drbg_ctr: BUG: sleeping function called from
 invalid context
Date: Tue, 26 Jun 2018 12:33:48 +0200
Message-ID: <CAMuHMdXfn6YuG9imLKd5nEdxhT4gWu-V8bn1LRt+M3bESaUAkA@mail.gmail.com>
References: <CAMuHMdW_4gvQYhCxcXR+sa6dhwAshyJnhXhc36=VC=hWKB-7Jw@mail.gmail.com>
 <14009987.cibGRJrWdm@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <14009987.cibGRJrWdm@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Stephan,

On Sun, May 20, 2018 at 9:54 PM Stephan Müller <smueller@chronox.de> wrote:
> Am Freitag, 18. Mai 2018, 10:36:04 CEST schrieb Geert Uytterhoeven:
> > I tried following the code path, but couldn't find where it went wrong.
> >
> > mutex_lock(&drbg->drbg_mutex) is called from drbg_instantiate(), which is
> > inlined by the compiler into drbg_kcapi_seed().
> >
> > Do you have a clue?
>
> It is the first time I hear from such an issue. Yes, the DRBG should not be
> called in atomic context. But I do not see where we have an atomic context
> (either a spin_lock or in an interrupt handler) when we are executing the test
> manager.
>
> I will keep looking.

Issue is gone. I assume due to commit 6e88f01206edab0e ("crypto: arm64/aes-blk
- fix and move skcipher_walk_done out of kernel_neon_begin, _end").

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
