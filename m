Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B45ECC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 02:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9541661074
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 02:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237824AbhJ0DBm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Oct 2021 23:01:42 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56352 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237816AbhJ0DBm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Oct 2021 23:01:42 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mfZ9o-00012X-3Z; Wed, 27 Oct 2021 10:59:16 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mfZ9l-0006OB-UT; Wed, 27 Oct 2021 10:59:13 +0800
Date:   Wed, 27 Oct 2021 10:59:13 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Simo Sorce <ssorce@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [v2 PATCH] crypto: api - Fix built-in testing dependency failures
Message-ID: <20211027025913.GB24480@gondor.apana.org.au>
References: <20210913071251.GA15235@gondor.apana.org.au>
 <20210917002619.GA6407@gondor.apana.org.au>
 <20211026163319.GA2785420@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026163319.GA2785420@roeck-us.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 26, 2021 at 09:33:19AM -0700, Guenter Roeck wrote:
>
> I can not explain it, but this patch causes a crash with one of my boot
> tests (riscv32 with riscv32 virt machine and e1000 network adapter):
> 
> [    9.948557] e1000 0000:00:01.0: enabling device (0000 -> 0003)
> [    9.968578] Unable to handle kernel paging request at virtual address 9e000000
> [    9.969207] Oops [#1]
> [    9.969325] Modules linked in:
> [    9.969619] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.15.0-rc6-next-20211025 #1
> [    9.969983] Hardware name: riscv-virtio,qemu (DT)
> [    9.970262] epc : e1000_io_write+0x10/0x1c
> [    9.970487]  ra : e1000_reset_hw+0xfa/0x312
> [    9.970639] epc : c07b3a44 ra : c07b5e4a sp : c258dcf0
> [    9.970792]  gp : c1d6cfa0 tp : c25b0040 t0 : c1f05b3c
> [    9.970941]  t1 : 04d6d7d4 t2 : 00001fff s0 : c258dd00
> [    9.971091]  s1 : c36a9990 a0 : c36a9990 a1 : 9e000000
> [    9.971240]  a2 : 00000000 a3 : 04000000 a4 : 00000002
> [    9.971389]  a5 : 9e000000 a6 : 00000000 a7 : 00006000
> [    9.971539]  s2 : c101b3ec s3 : c23aceb0 s4 : 04140240
> [    9.971692]  s5 : 00000000 s6 : c14a3550 s7 : c1d72000
> [    9.971872]  s8 : 00000000 s9 : c36a9000 s10: 00000000
> [    9.972037]  s11: 00000000 t3 : cb75ee6c t4 : 0000000c
> [    9.972200]  t5 : 000021cb t6 : c1f017a0
> [    9.972336] status: 00000120 badaddr: 9e000000 cause: 0000000f
> [    9.972570] [<c07b3a44>] e1000_io_write+0x10/0x1c
> [    9.973382] ---[ end trace 49388ec34793549e ]---
> [    9.973873] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> 
> Bisect log is attached. Reverting this patch fixes the problem. The problem
> is always seen with this patch applied, and is never seen with this patch
> reverted.
> 
> Any idea what might be going on, and how to debug the problem ?

Could you please send me the complete boot log, as well as the
kernel config file please?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
