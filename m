From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 1/5] random: fix crng_ready() test
Date: Wed, 2 May 2018 18:18:13 +0200
Message-ID: <CAMuHMdWxU=gtLTDY-W0YCMD6eE4gSnjhFo5CRTqwq_Q=yH-zZA@mail.gmail.com>
References: <20180413013046.404-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        stable <stable@kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180413013046.404-1-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Ted,

On Fri, Apr 13, 2018 at 3:30 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> The crng_init variable has three states:
>
> 0: The CRNG is not initialized at all
> 1: The CRNG has a small amount of entropy, hopefully good enough for
>    early-boot, non-cryptographical use cases
> 2: The CRNG is fully initialized and we are sure it is safe for
>    cryptographic use cases.
>
> The crng_ready() function should only return true once we are in the
> last state.
>
> Reported-by: Jann Horn <jannh@google.com>
> Fixes: e192be9d9a30 ("random: replace non-blocking pool...")
> Cc: stable@kernel.org # 4.8+
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Reviewed-by: Jann Horn <jannh@google.com>

Since commit 43838a23a05fbd13 ("random: fix crng_ready() test"),
all (few) remaining users of %p are printing too early, leading to "(ptrval)"
strings instead of actual hashed pointer values.

Sample timings on two platforms (arm / arm64) booting with lots of
debug ingo:

[   28.521158] random: crng init done
[   17.792705] random: crng init done

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
