Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42CFC433FE
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Nov 2022 10:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233551AbiKHKxp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Nov 2022 05:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233893AbiKHKxe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Nov 2022 05:53:34 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04754AE64
        for <linux-crypto@vger.kernel.org>; Tue,  8 Nov 2022 02:53:29 -0800 (PST)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 332CE6602976;
        Tue,  8 Nov 2022 10:53:27 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1667904807;
        bh=/iRS1EbfMebEbUdJBa097hdTJjvzRQMSeDwJ21kNf6E=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=WHwsrCKAOyUYYW2rJiZ3ppsuldIRKLe7RcTD/63hlYET7VwD65A5pFA9Qv1kSVyju
         R063pnt9Pp2yTX/fxIl/T5dEDD3IIguCFK4mK+l1n4tZ6Ggsu/dmYKzv4q1/Brds8O
         j1u3vle04droa86Wwz51rGTvrY8PR3t2hqPOUAlhgZaqdPhFG6Z8/4be+g39CfPs38
         Q1pRPn6fSnnAD8qRpPNgJJ5aoRw/ZoMvshvTq8HFvRDYoTCl1ucBDmNX4z/vjZDB1e
         ONCn8T+XAP7+E7ydugLY2AUezClKevkTJNyRZ6VAJMcx87GItoE1j6OH9Dedern0+1
         a8MoBgE8k+nEQ==
Message-ID: <1839f462-dccb-b926-1acd-f1bb5f5776ba@collabora.com>
Date:   Tue, 8 Nov 2022 11:53:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v3] hw_random: use add_hwgenerator_randomness() for early
 entropy
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc:     Dominik Brodowski <linux@dominikbrodowski.net>
References: <Y2fJy1akGIdQdH95@zx2c4.com>
 <20221106150243.150437-1-Jason@zx2c4.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20221106150243.150437-1-Jason@zx2c4.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Il 06/11/22 16:02, Jason A. Donenfeld ha scritto:
> Rather than calling add_device_randomness(), the add_early_randomness()
> function should use add_hwgenerator_randomness(), so that the early
> entropy can be potentially credited, which allows for the RNG to
> initialize earlier without having to wait for the kthread to come up.
> 
> This requires some minor API refactoring, by adding a `sleep_after`
> parameter to add_hwgenerator_randomness(), so that we don't hit a
> blocking sleep from add_early_randomness().
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> Herbert - it might be easiest for me to take this patch if you want? Or
> if this will interfere with what you have going on, you can take it. Let
> me know what you feel like. -Jason
> 
>   drivers/char/hw_random/core.c |  8 +++++---
>   drivers/char/random.c         | 12 ++++++------
>   include/linux/random.h        |  2 +-
>   3 files changed, 12 insertions(+), 10 deletions(-)
> 

Hello,

I tried booting next-20221108 on Acer Tomato Chromebook (MediaTek MT8195) but
this commit is producing a kernel panic.

Trace follows:

[    2.957452] cr50_i2c 3-0050: cr50 TPM 2.0 (i2c 0x50 irq 114 id 0x28)
[    3.047508] ------------[ cut here ]------------
[    3.052178] WARNING: CPU: 5 PID: 1 at kernel/kthread.c:75 
kthread_should_stop+0x2c/0x44
[    3.060270] Modules linked in:
[    3.063359] CPU: 5 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc4-next-20221108+ #111
[    3.071086] Hardware name: Acer Tomato (rev2) board (DT)
[    3.076447] pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    3.083473] pc : kthread_should_stop+0x2c/0x44
[    3.087962] lr : add_hwgenerator_randomness+0x6c/0x110
[    3.093152] sp : ffff80000808b570
[    3.096499] x29: ffff80000808b570 x28: 0000000000061a80 x27: 00000000000f4240
[    3.103707] x26: ffff030f3efe9d78 x25: ffffd855b3930000 x24: 0000000000000000
[    3.110915] x23: 0000000000000000 x22: ffffd855b2c00d08 x21: 0000000000000020
[    3.118122] x20: 0000000000000000 x19: ffffd855b2c00c90 x18: 000000000000001c
[    3.125328] x17: 000000005358439e x16: ffffd855b2c00d00 x15: 000000003be00b9b
[    3.132534] x14: 0000000088cee1a7 x13: 025733541e7bfbcb x12: 00000000000000d5
[    3.139741] x11: 000000009d2113cd x10: 000000009d2113cd x9 : ffffd855b059298c
[    3.146947] x8 : ffffd855b2dbf980 x7 : 0000000000000000 x6 : 0000000000000002
[    3.154154] x5 : 0000000000000000 x4 : 0000000000000002 x3 : 00000000000000d5
[    3.161359] x2 : ffff2ab984b5c000 x1 : 0000000000000040 x0 : ffff030e00290000
[    3.168565] Call trace:
[    3.171037]  kthread_should_stop+0x2c/0x44
[    3.175176]  add_early_randomness+0xb8/0x124
[    3.179490]  hwrng_register+0x174/0x220
[    3.183366]  tpm_chip_register+0xc4/0x290
[    3.187417]  tpm_cr50_i2c_probe+0x27c/0x2c0
[    3.191642]  i2c_device_probe+0x10c/0x360
[    3.195695]  really_probe+0xc8/0x3e0
[    3.199307]  __driver_probe_device+0x84/0x190
[    3.203706]  driver_probe_device+0x44/0x120
[    3.207929]  __device_attach_driver+0xc4/0x160
[    3.212415]  bus_for_each_drv+0x80/0xe0
[    3.216288]  __device_attach+0xb0/0x1f0
[    3.220162]  device_initial_probe+0x1c/0x30
[    3.224386]  bus_probe_device+0xa4/0xb0
[    3.228260]  device_add+0x3d0/0x8d0
[    3.231788]  device_register+0x28/0x40
[    3.235577]  i2c_new_client_device+0x15c/0x29c
[    3.240067]  of_i2c_register_device+0xc4/0xf0
[    3.244465]  of_i2c_register_devices+0x84/0x140
[    3.249040]  i2c_register_adapter+0x200/0x6dc
[    3.253442]  __i2c_add_numbered_adapter+0x68/0xc0
[    3.258194]  i2c_add_adapter+0xb0/0xe0
[    3.261982]  mtk_i2c_probe+0x4e8/0x660
[    3.265771]  platform_probe+0x70/0xe0
[    3.269471]  really_probe+0xc8/0x3e0
[    3.273082]  __driver_probe_device+0x84/0x190
[    3.277481]  driver_probe_device+0x44/0x120
[    3.281704]  __driver_attach+0xb8/0x230
[    3.285577]  bus_for_each_dev+0x78/0xdc
[    3.289450]  driver_attach+0x2c/0x3c
[    3.293061]  bus_add_driver+0x184/0x240
[    3.296935]  driver_register+0x80/0x13c
[    3.300809]  __platform_driver_register+0x30/0x3c
[    3.305559]  mtk_i2c_driver_init+0x24/0x30
[    3.309699]  do_one_initcall+0x7c/0x3d0
[    3.313574]  kernel_init_freeable+0x308/0x378
[    3.317977]  kernel_init+0x2c/0x140
[    3.321505]  ret_from_fork+0x10/0x20
[    3.325117] irq event stamp: 620756
[    3.328639] hardirqs last  enabled at (620755): [<ffffd855b0fc7cb4>] 
_raw_spin_unlock_irqrestore+0xa4/0xb0
[    3.338382] hardirqs last disabled at (620756): [<ffffd855b0fb9724>] 
el1_dbg+0x24/0x90
[    3.346373] softirqs last  enabled at (618152): [<ffffd855afc10be4>] 
__do_softirq+0x414/0x588
[    3.354973] softirqs last disabled at (618147): [<ffffd855afc171d8>] 
____do_softirq+0x18/0x24
[    3.363575] ---[ end trace 0000000000000000 ]---
[    3.368278] Unable to handle kernel NULL pointer dereference at virtual address 
0000000000000000
[    3.377165] Mem abort info:
[    3.380006]   ESR = 0x0000000096000004
[    3.383824]   EC = 0x25: DABT (current EL), IL = 32 bits
[    3.389203]   SET = 0, FnV = 0
[    3.392306]   EA = 0, S1PTW = 0
[    3.395494]   FSC = 0x04: level 0 translation fault
[    3.400432] Data abort info:
[    3.403359]   ISV = 0, ISS = 0x00000004
[    3.407261]   CM = 0, WnR = 0
[    3.410275] [0000000000000000] user address but active_mm is swapper
[    3.416720] Internal error: Oops: 0000000096000004 [#1] SMP
[    3.422290] Modules linked in:
[    3.425338] CPU: 5 PID: 1 Comm: swapper/0 Tainted: G        W 
6.1.0-rc4-next-20221108+ #111
[    3.434466] Hardware name: Acer Tomato (rev2) board (DT)
[    3.439772] pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    3.446728] pc : kthread_should_stop+0x38/0x44
[    3.451170] lr : add_hwgenerator_randomness+0x6c/0x110
[    3.456304] sp : ffff80000808b570
[    3.459611] x29: ffff80000808b570 x28: 0000000000061a80 x27: 00000000000f4240
[    3.466743] x26: ffff030f3efe9d78 x25: ffffd855b3930000 x24: 0000000000000000
[    3.473875] x23: 0000000000000000 x22: ffffd855b2c00d08 x21: 0000000000000020
[    3.481007] x20: 0000000000000000 x19: ffffd855b2c00c90 x18: 000000000000001c
[    3.488139] x17: 000000005358439e x16: ffffd855b2c00d00 x15: 000000003be00b9b
[    3.495270] x14: 0000000088cee1a7 x13: 025733541e7bfbcb x12: 00000000000000d5
[    3.502402] x11: 000000009d2113cd x10: 000000009d2113cd x9 : ffffd855b059298c
[    3.509533] x8 : ffffd855b2dbf980 x7 : 0000000000000000 x6 : 0000000000000002
[    3.516665] x5 : 0000000000000000 x4 : 0000000000000002 x3 : 00000000000000d5
[    3.523796] x2 : ffff2ab984b5c000 x1 : 0000000000000040 x0 : 0000000000000000
[    3.530927] Call trace:
[    3.533366]  kthread_should_stop+0x38/0x44
[    3.537459]  add_early_randomness+0xb8/0x124
[    3.541725]  hwrng_register+0x174/0x220
[    3.545557]  tpm_chip_register+0xc4/0x290
[    3.549562]  tpm_cr50_i2c_probe+0x27c/0x2c0
[    3.553739]  i2c_device_probe+0x10c/0x360
[    3.557746]  really_probe+0xc8/0x3e0
[    3.561316]  __driver_probe_device+0x84/0x190
[    3.565667]  driver_probe_device+0x44/0x120
[    3.569845]  __device_attach_driver+0xc4/0x160
[    3.574284]  bus_for_each_drv+0x80/0xe0
[    3.578115]  __device_attach+0xb0/0x1f0
[    3.581944]  device_initial_probe+0x1c/0x30
[    3.586122]  bus_probe_device+0xa4/0xb0
[    3.589952]  device_add+0x3d0/0x8d0
[    3.593437]  device_register+0x28/0x40
[    3.597183]  i2c_new_client_device+0x15c/0x29c
[    3.601623]  of_i2c_register_device+0xc4/0xf0
[    3.605974]  of_i2c_register_devices+0x84/0x140
[    3.610499]  i2c_register_adapter+0x200/0x6dc
[    3.614853]  __i2c_add_numbered_adapter+0x68/0xc0
[    3.619555]  i2c_add_adapter+0xb0/0xe0
[    3.623300]  mtk_i2c_probe+0x4e8/0x660
[    3.627044]  platform_probe+0x70/0xe0
[    3.630702]  really_probe+0xc8/0x3e0
[    3.634271]  __driver_probe_device+0x84/0x190
[    3.638622]  driver_probe_device+0x44/0x120
[    3.642800]  __driver_attach+0xb8/0x230
[    3.646631]  bus_for_each_dev+0x78/0xdc
[    3.650460]  driver_attach+0x2c/0x3c
[    3.654030]  bus_add_driver+0x184/0x240
[    3.657859]  driver_register+0x80/0x13c
[    3.661690]  __platform_driver_register+0x30/0x3c
[    3.666390]  mtk_i2c_driver_init+0x24/0x30
[    3.670483]  do_one_initcall+0x7c/0x3d0
[    3.674313]  kernel_init_freeable+0x308/0x378
[    3.678668]  kernel_init+0x2c/0x140
[    3.682153]  ret_from_fork+0x10/0x20
[    3.685725] Code: d65f03c0 d4210000 f9431c00 d50323bf (f9400000)
[    3.691813] ---[ end trace 0000000000000000 ]---
[    3.696984] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    3.704636] SMP: stopping secondary CPUs
[    3.708557] Kernel Offset: 0x5855a7c00000 from 0xffff800008000000
[    3.714644] PHYS_OFFSET: 0xfffffcf300000000
[    3.718820] CPU features: 0x30000,001700a4,6600720b
[    3.723691] Memory Limit: none
[    3.727265] ---[ end Kernel panic - not syncing: Attempted to kill init! 
exitcode=0x0000000b ]---


Regards,
Angelo
