Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6309C433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Nov 2021 05:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9B08601FA
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Nov 2021 05:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhKEFoZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Nov 2021 01:44:25 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56566 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhKEFoZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Nov 2021 01:44:25 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1miryz-00039c-4v; Fri, 05 Nov 2021 13:41:45 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1miryr-0003GL-SD; Fri, 05 Nov 2021 13:41:37 +0800
Date:   Fri, 5 Nov 2021 13:41:37 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: crashes in crypto_shash_update()
Message-ID: <20211105054137.GA12470@gondor.apana.org.au>
References: <ac79dba2-c527-783b-6d0f-b879908bb5b6@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac79dba2-c527-783b-6d0f-b879908bb5b6@roeck-us.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 04, 2021 at 10:35:41PM -0700, Guenter Roeck wrote:
> Hi all,
> 
> I see the following pretty widespread crash in crypto_shash_update().
> 
> [    1.574992] Unable to handle kernel paging request at virtual address ffffffffffffffc8
> [    1.575611] Oops [#1]
> [    1.575698] Modules linked in:
> [    1.575866] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W         5.15.0-10159-gb8c4a6bfae4e-dirty #1
> [    1.576120] Hardware name: riscv-virtio,qemu (DT)
> [    1.576281] epc : crypto_shash_update+0xa/0x2e
> [    1.576437]  ra : crc32c+0x2c/0x58
> [    1.576553] epc : ffffffff80358b6c ra : ffffffff80395382 sp : ffffffd00021bc00
> [    1.576760]  gp : ffffffff81513898 tp : ffffffe001aa8040 t0 : ffffffe001d10568
> [    1.576966]  t1 : 000000006a138faa t2 : 0000000000000000 s0 : ffffffd00021bc10
> [    1.577173]  s1 : ffffffff8149e500 a0 : ffffffd00021bc10 a1 : ffffffff81077e70
> [    1.577378]  a2 : 0000000000000011 a3 : 0000000000000000 a4 : ffffffffffffffb0
> [    1.577584]  a5 : ffffffffffffffb0 a6 : 0000000000000000 a7 : 0000000028292846
> [    1.577797]  s2 : ffffffff81077e70 s3 : ffffffff81514008 s4 : ffffffff80c004e0
> [    1.578005]  s5 : ffffffff81514038 s6 : ffffffff80c10910 s7 : ffffffff80c004a0
> [    1.578212]  s8 : ffffffff811669a8 s9 : 0000000000000008 s10: ffffffff80a000ac
> [    1.578421]  s11: 0000000000000000 t3 : 0000000000000009 t4 : 0000000042300000
> [    1.578628]  t5 : 0000000000000000 t6 : ffffffe003075000
> [    1.578785] status: 0000000000000120 badaddr: ffffffffffffffc8 cause: 000000000000000d
> [    1.579010] [<ffffffff80358b6c>] crypto_shash_update+0xa/0x2e
> [    1.579186] [<ffffffff80395382>] crc32c+0x2c/0x58
> [    1.579332] [<ffffffff80a1459a>] btrfs_props_init+0x32/0x70
> [    1.579505] [<ffffffff80a13e26>] init_btrfs_fs+0x12/0x16a
> [    1.579670] [<ffffffff800020da>] do_one_initcall+0x36/0x15e
> [    1.579838] [<ffffffff80a00f5c>] kernel_init_freeable+0x1a6/0x20a
> [    1.580023] [<ffffffff808d6648>] kernel_init+0x1e/0x104
> [    1.580181] [<ffffffff80002ffa>] ret_from_exception+0x0/0xc
> [    1.580700] ---[ end trace 4bfa11496ef965ab ]---
> 
> 
> The problem boils down to crypto_alloc_shash() returning -80 (-ELLIBBAD).
> 
> Before I spend time analyzing this further, is anyone already looking
> into the problem ?

Can you confirm that CRYPTO_MANAGER is unset in your config? If
so I'm aware of the problem and working on a fix.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
