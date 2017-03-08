From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: XTS Crypto Not Found In /proc/crypto Even After Compiled for
 4.10.1.
Date: Wed, 8 Mar 2017 19:45:42 +0200
Message-ID: <20170308174542.2rydwxmrb3oehyrc@kozik-lap>
References: <CALaQ_hpC4G6CaxZAFvwNG3gFjc5Dj1C7zB6b_WQjGeYhbArHKw@mail.gmail.com>
 <20170306173511.6w3e47v4vomu7yv4@kozik-lap>
 <CALaQ_hqhFjb60rJ2AgBnYgyNCPQ7fH5BdOOCeaMiankQR0VwqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
To: Nathan Royce <nroycea+kernel@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33316 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753986AbdCHRp4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Mar 2017 12:45:56 -0500
Content-Disposition: inline
In-Reply-To: <CALaQ_hqhFjb60rJ2AgBnYgyNCPQ7fH5BdOOCeaMiankQR0VwqQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 06, 2017 at 03:29:48PM -0600, Nathan Royce wrote:
> OK, I just tried 4.10.0 and the output is looking the same.
> 
> I can't say my setup is all that odd. The cryptographic use is only
> with the swap partition found in my original email (seen in Herbert's
> reply).

You have quite specific/customized config and compilation flags.
I doubt that it causes the issue but at least the config is unusable on
anything other then XU3/XU4.

Anyway I reproduced some of the issues with tcrypt on Odroid U3 on v4.10
and v4.11-rc1, with regular exynos defconfig plus some more crypto
algorithms:
1. Without my patch: the original warning.
2. With my patch:

[   95.170527] testing speed of async lrw(aes) (lrw(ecb-aes-s5p)) encryption
[   95.173990] tcrypt: test 0 (256 bit key, 16 byte blocks): 19007 operations in 1 seconds (304112 bytes)
[   96.175986] tcrypt: test 1 (256 bit key, 64 byte blocks): 15753 operations in 1 seconds (1008192 bytes)
[   97.176099] tcrypt: test 2 (256 bit key, 256 byte blocks): 14293 operations in 1 seconds (3659008 bytes)
[   98.176177] tcrypt: test 3 (256 bit key, 1024 byte blocks): 11906 operations in 1 seconds (12191744 bytes)
[   99.176407] tcrypt: test 4 (256 bit key, 8192 byte blocks):
[   99.177235] BUG: spinlock recursion on CPU#1, irq/84-10830000/89
[   99.188034]  lock: 0xeea99a68, .magic: dead4ead, .owner: irq/84-10830000/89, .owner_cpu: 1
[   99.196282] CPU: 1 PID: 89 Comm: irq/84-10830000 Not tainted 4.11.0-rc1-00001-g897ca6d0800d #559
[   99.205038] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[   99.211158] [<c010e1ec>] (unwind_backtrace) from [<c010ae1c>] (show_stack+0x10/0x14)
[   99.218863] [<c010ae1c>] (show_stack) from [<c03449c0>] (dump_stack+0x78/0x8c)
[   99.226060] [<c03449c0>] (dump_stack) from [<c015de68>] (do_raw_spin_lock+0x11c/0x120)
[   99.233962] [<c015de68>] (do_raw_spin_lock) from [<c0720110>] (_raw_spin_lock_irqsave+0x20/0x28)
[   99.242733] [<c0720110>] (_raw_spin_lock_irqsave) from [<c0572ca0>] (s5p_aes_crypt+0x2c/0xb4)
[   99.251240] [<c0572ca0>] (s5p_aes_crypt) from [<bf1d8aa4>] (do_encrypt+0x78/0xb0 [lrw])
[   99.259230] [<bf1d8aa4>] (do_encrypt [lrw]) from [<bf1d8b00>] (encrypt_done+0x24/0x54 [lrw])
[   99.267628] [<bf1d8b00>] (encrypt_done [lrw]) from [<c05732a0>] (s5p_aes_complete+0x60/0xcc)
[   99.276046] [<c05732a0>] (s5p_aes_complete) from [<c0573440>] (s5p_aes_interrupt+0x134/0x1a0)
[   99.284558] [<c0573440>] (s5p_aes_interrupt) from [<c01667c4>] (irq_thread_fn+0x1c/0x54)
[   99.292624] [<c01667c4>] (irq_thread_fn) from [<c0166a98>] (irq_thread+0x12c/0x1e0)
[   99.300269] [<c0166a98>] (irq_thread) from [<c0136a28>] (kthread+0x108/0x138)
[   99.307382] [<c0136a28>] (kthread) from [<c0107778>] (ret_from_fork+0x14/0x3c)

I will take a look into this.

Thanks for the report.

Best regards,
Krzysztof
