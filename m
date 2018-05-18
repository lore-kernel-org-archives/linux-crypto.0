From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: cryptomgr_test / drbg_ctr: BUG: sleeping function called from invalid context
Date: Fri, 18 May 2018 10:36:04 +0200
Message-ID: <CAMuHMdW_4gvQYhCxcXR+sa6dhwAshyJnhXhc36=VC=hWKB-7Jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

After enabling CONFIG_CRYPTO_DRBG_CTR, I start seeing during kernel boot:

BUG: sleeping function called from invalid context at
include/crypto/algapi.h:416
in_atomic(): 1, irqs_disabled(): 0, pid: 203, name: cryptomgr_test
1 lock held by cryptomgr_test/203:
 #0:         (ptrval) (&drbg->drbg_mutex){+.+.}, at: drbg_kcapi_seed+0x128/0x4bc
CPU: 3 PID: 203 Comm: cryptomgr_test Not tainted
4.17.0-rc5-salvator-x-00509-g0ad2b9f404d6a668-dirty #1742
Hardware name: Renesas Salvator-X 2nd version board based on r8a7795 ES2.0+ (DT)
Call trace:
 dump_backtrace+0x0/0x140
 show_stack+0x14/0x1c
 dump_stack+0xb4/0xf0
 ___might_sleep+0x1fc/0x218
 skcipher_walk_done+0x2c8/0x38c
 ctr_encrypt+0x84/0x110
 simd_skcipher_encrypt+0xa4/0xb0
 drbg_kcapi_sym_ctr+0xb4/0x178
 drbg_ctr_update+0x17c/0x2c4
 drbg_seed+0x20c/0x26c
 drbg_kcapi_seed+0x458/0x4bc
 crypto_rng_reset+0x84/0xa8
 alg_test_drbg+0x12c/0x324
 alg_test.part.7+0x264/0x2bc
 alg_test+0x44/0x58
 cryptomgr_test+0x28/0x48
 kthread+0x11c/0x124
 ret_from_fork+0x10/0x18

I tried following the code path, but couldn't find where it went wrong.

mutex_lock(&drbg->drbg_mutex) is called from drbg_instantiate(), which is
inlined by the compiler into drbg_kcapi_seed().

Do you have a clue?
Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
