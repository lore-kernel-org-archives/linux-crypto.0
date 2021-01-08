Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 376EEC433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 04:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C84B22A99
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 04:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbhAHEmW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Jan 2021 23:42:22 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:40306 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbhAHEmU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Jan 2021 23:42:20 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kxjaT-0006is-TZ; Fri, 08 Jan 2021 15:41:23 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 08 Jan 2021 15:41:21 +1100
Date:   Fri, 8 Jan 2021 15:41:21 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kirill Tkhai <ktkhai@virtuozzo.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Douglas Anderson <dianders@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] crypto: Fix divide error in do_xor_speed()
Message-ID: <20210108044121.GA12339@gondor.apana.org.au>
References: <160933061716.928967.463919628731790218.stgit@localhost.localdomain>
 <CAMj1kXHTzafF5ZZR5Ornusjt6cd0K-Lczb0Z0FK54jBTv9cKsA@mail.gmail.com>
 <30381b78-8721-5b4e-e075-300c5af3f9fa@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30381b78-8721-5b4e-e075-300c5af3f9fa@virtuozzo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 31, 2020 at 12:33:18AM +0300, Kirill Tkhai wrote:
> crypto: Fix divide error in do_xor_speed()
> 
> From: Kirill Tkhai <ktkhai@virtuozzo.com>
> 
> Latest (but not only latest) linux-next panics with divide
> error on my QEMU setup.
> 
> The patch at the bottom of this message fixes the problem.
> 
> xor: measuring software checksum speed
> divide error: 0000 [#1] PREEMPT SMP KASAN
> PREEMPT SMP KASAN
> CPU: 3 PID: 1 Comm: swapper/0 Not tainted 5.10.0-next-20201223+ #2177
> RIP: 0010:do_xor_speed+0xbb/0xf3
> Code: 41 ff cc 75 b5 bf 01 00 00 00 e8 3d 23 8b fe 65 8b 05 f6 49 83 7d 85 c0 75 05 e8
>  84 70 81 fe b8 00 00 50 c3 31 d2 48 8d 7b 10 <f7> f5 41 89 c4 e8 58 07 a2 fe 44 89 63 10 48 8d 7b 08
>  e8 cb 07 a2
> RSP: 0000:ffff888100137dc8 EFLAGS: 00010246
> RAX: 00000000c3500000 RBX: ffffffff823f0160 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000808 RDI: ffffffff823f0170
> RBP: 0000000000000000 R08: ffffffff8109c50f R09: ffffffff824bb6f7
> R10: fffffbfff04976de R11: 0000000000000001 R12: 0000000000000000
> R13: ffff888101997000 R14: ffff888101994000 R15: ffffffff823f0178
> FS:  0000000000000000(0000) GS:ffff8881f7780000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000000220e000 CR4: 00000000000006a0
> Call Trace:
>  calibrate_xor_blocks+0x13c/0x1c4
>  ? do_xor_speed+0xf3/0xf3
>  do_one_initcall+0xc1/0x1b7
>  ? start_kernel+0x373/0x373
>  ? unpoison_range+0x3a/0x60
>  kernel_init_freeable+0x1dd/0x238
>  ? rest_init+0xc6/0xc6
>  kernel_init+0x8/0x10a
>  ret_from_fork+0x1f/0x30
> ---[ end trace 5bd3c1d0b77772da ]---
> 
> Fixes: c055e3eae0f1 ("crypto: xor - use ktime for template benchmarking")
> Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> 
> v2: New Year resend :) Added fixes tag.
>  crypto/xor.c |    2 ++
>  1 file changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
