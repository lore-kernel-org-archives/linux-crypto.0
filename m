Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E1F20DD4B
	for <linux-crypto@vger.kernel.org>; Wed,  2 Apr 2025 10:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743590548; cv=none; b=Rf2GeQ2mV8lG+yKq2kHKBRcD+ki8Y5Xu0fyKv2VEuOoDyTevStYRSCLNdAXm4Z4k1Y+/wbYIA18gR1fJpwLgbP2K2RCbEujW3oRbaaxFNwkf2BqtZZsuI/Sm50WPsMoZ8JiYZCouwjHNOkRl/NX/anmZNmagb91DnCWZUTW99Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743590548; c=relaxed/simple;
	bh=Cky/rYl3xwPjBW7aX8hMFh3ObFnrbQ5xFe1ukMx/RYs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=tc7WLUt6LYQgsl7cB7VkfRI+ly8SbuQXmpm/+CruByC0mjrIT+gQPVCsF/9ouy3rz6C5xdSItEs6SR9Rva9xYnBmbd/yBMbrFUxF/lPGJSy92TfCcu8qxyXnOBZBba1ZIvLwjNjJHB96S3DqGXpMHf1s4+HY0Yxr4HDx1Ne96Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tulloh.id.au; spf=pass smtp.mailfrom=tulloh.id.au; dkim=pass (2048-bit key) header.d=tulloh.id.au header.i=@tulloh.id.au header.b=ggGd2enX; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tulloh.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tulloh.id.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tulloh.id.au header.i=@tulloh.id.au header.b="ggGd2enX"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6ecfbf8fa76so72526756d6.0
        for <linux-crypto@vger.kernel.org>; Wed, 02 Apr 2025 03:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tulloh.id.au; s=google; t=1743590545; x=1744195345; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OFfnw04u5Qyxco2v8HB0TtHbj0u4FioJyLvy6f0YZ34=;
        b=ggGd2enXke3qVDrpu6L/dBfu7pebdHV6msMwGcwPYLikGceJfwj//vNJZDCmZsMriS
         0WXWqhaHr+KP/hZGBfyXNCRf5caS7FPVaEOLV9+vY1wc4rMsCDUvC/zcMQDMTF/vSL2E
         x31ojRxEs0NkTZUoR/YpG4uO4qd6GwVGnXAvM+nuU5PS6PojXjEAwnhXhzmjGUYWbGS1
         qzrtGR0NdFdyC4wfnJC421RgCfZldRi2uA2BzSeagBJ5KAqx9Dvg/DW/ZDHfx3ksw0wM
         YL7BcX6YGGpXzXN62pmnEks6VuqGzVwKCdo+4w2xcsYRIQSa96CHE5Evkw59DWjS+xWK
         ACeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743590545; x=1744195345;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OFfnw04u5Qyxco2v8HB0TtHbj0u4FioJyLvy6f0YZ34=;
        b=JhrA/Tow/asZrSYpuxzvnWJYLiHMXhK+qFjezFYzOSrmC++SYZHmoWiQudqgylzSTn
         fqThLyXFwBZQ9xQuduxnu/SkuZRAhugPNUB7jnQvNcbvxFMpP5RusTAVxuubHclTczh1
         2QiX+mbfXF1/i8F1NpqTYLUFvbWIOh+aeoJ+aXJrJ3omd3FlqVtXa/ExyKhOtjkBMaam
         raNjPew4Z88h+6tZfuiwmpfYXPWrJau04hm6Wa5BSjLsN0iWNoxzlWVMjt0sIEkWY5UU
         +scmTWswdvgEWdSPEe8aIeJizuTqLdslS/aHxhgCRMOJPgQCER/ZVhkUj/lY8kWIQdwM
         hypg==
X-Gm-Message-State: AOJu0YxjIYWJ8q6f4+B+t/yguFVEpWabEpQQPb/s71xb37btFYrZ2Hxs
	t43Ia05lNtbH+u6oRBYjA98oDEaWQMISKBeM7HV16Pt97IZsE0Rz5yN079W7fQPghR7YRyIKT3K
	zi/eDtGC5AH0bOPcizP/TsUfKgYWklBfAa4wbuVgN8xgHk60X
X-Gm-Gg: ASbGncu9iTphRcJTRKF37DlaauO0edjmUGPrkff+OOR7kIlLsDQ7+H2CMOVNBK3QpuC
	7+LwwPWzKQJoRdeUECs/Oz7iq9XAqE4GlQgSI5WrK0PMb/RiXcesBL/Y0M71BkZdoYrddhWprSj
	7mxrU/RcpyKjRq48X7trrMM+K8fkQ=
X-Google-Smtp-Source: AGHT+IHzOGuU2GGdTQmuwlVuXx5mV0/2LL15gAbhXoZxh4Nq8vcpEZW81x2ONDmhmFGqQgsl59jCnJT52deedyXLijE=
X-Received: by 2002:a05:6214:2267:b0:6d8:aba8:837b with SMTP id
 6a1803df08f44-6eed629e85amr236653336d6.41.1743590544541; Wed, 02 Apr 2025
 03:42:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: David Tulloh <david@tulloh.id.au>
Date: Wed, 2 Apr 2025 21:42:03 +1100
X-Gm-Features: AQ5f1JqUhVgILgKHLmgPI8P7nhrNpbR8HA_W8W1JyO3WRNseGYadm3csC9Rc74I
Message-ID: <CAOP4N=-3a=eFf3XkX1i36rr3gr9=_BZGBDah89BE6GPvh65akg@mail.gmail.com>
Subject: [BUG] : EIP-93 module crash, unable to handle kernel paging request
To: linux-crypto@vger.kernel.org
Cc: "ansuelsmth@gmail.com" <ansuelsmth@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi,

I decided to try out the recently merged EIP-93 module on my MediaTek
MT7621. Ran into this kernel crash "Unable to handle kernel paging
request", full trace is included below.

I'm happy to dig into this a little, but have no idea what I'm doing in
kernel land so I thought I would post first in case it was super obvious to
skilled eyes.


I enabled the hardware by adding the following block to mt7621.dtsi:

    crypto: crypto@1e004000 {
        status = "okay";

        compatible = "airoha,en7581-eip93",
"inside-secure,safexcel-eip93ies";
        reg = <0x1e004000 0x1000>;

        interrupt-parent = <&gic>;
        interrupts = <GIC_SHARED 19 IRQ_TYPE_LEVEL_HIGH>;
    };

Basic testing seemed to show it was working. I ran `cryptsetup benchmark`
without issue and it showed the desired speed increases.

Mounting an encrypted disk caused the displayed crash, this is repeatable.
The drive had been previously set up and encrypted before enabling the
module.

Attempting to rmmod the module also caused a crash, I have included its
trace too.

Thanks for your time,


David

(Sorry for the confusion, first email got bounced for including html format)


Mount trace:

[  +0.018390] XFS (dm-0): Mounting V4 Filesystem
a4050634-7a5c-4a58-bc17-aefaa71d6dc9
[61754.391252] CPU 0 Unable to handle kernel paging request at virtual
address 00000010, epc == c017c19c,
ra == c017a268
[61754.412500] Oops[#1]:
[61754.417036] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.14.0 #2
[61754.430035] Hardware name: GnuBee GB-PC2
[61754.437842] $ 0   : 00000000 00000001 c017c174 000f0000
[61754.448278] $ 4   : 00000000 00000070 00000000 8280fea0
[61754.458708] $ 8   : 87eb86dc 80a70000 8280fe9c 87eb86d4
[61754.469140] $12   : 0000ffe4 87eb86dc fffffffd 00000000
[61754.479572] $16   : 00000000 00000108 00000070 00000000
[61754.490002] $20   : 87eb86d0 00000002 00000000 c017a950
[61754.500432] $24   : fffffffc 00000000
[61754.510862] $28   : 80a56000 8280fe98 00000000 c017a268
[61754.521297] Hi    : 0000001f
[61754.527038] Lo    : 00000002
[61754.532766] epc   : c017c19c eip93_skcipher_handle_result+0x28/0x8c
[crypto_hw_eip93]
[61754.548384] ra    : c017a268 eip93_done_task+0x25c/0x29c
[crypto_hw_eip93]
[61754.562084] Status: 11000403 KERNEL EXL IE
[61754.570432] Cause : 40800008 (ExcCode 02)
[61754.578412] BadVA : 00000010
[61754.584141] PrId  : 0001992f (MIPS 1004Kc)
[61754.592293] Modules linked in: essiv dm_crypt mt7530_mdio
crypto_hw_eip93 libdes fuse ip_tables x_table
s autofs4 dm_mod raid456 async_raid6_recov async_memcpy async_pq async_xor
async_tx xor raid6_pq leds_gpio
 evdev gpio_keys input_core usb_storage xhci_mtk_hcd xhci_hcd usbcore
usb_common
[61754.643378] Process swapper/0 (pid: 0, threadinfo=f12d9e27,
task=ac21a255, tls=00000000)
[61754.659504] Stack : 579efe26 00000000 00000000 9ed681b3 80a5c08c
87eb8e80 00000108 c017a000
[61754.676192]         00000000 c017a268 00000007 0000000a 80a5c020
8008a184 c017a000 808546ec
[61754.692876]         8085492c 00000001 87eb8680 8201f254 00000006
00000000 00000007 0000000a
[61754.709558]         00000040 80a5a058 00000100 80039e4c 87812000
8280ff30 00000000 80039ee4
[61754.726243]         80a70000 80a68538 81a48420 04200002 80a5a040
80039870 00000013 804b61d0
[61754.742927]         ...
[61754.747811] Call Trace:
[61754.752678] [<c017c19c>] eip93_skcipher_handle_result+0x28/0x8c
[crypto_hw_eip93]
[61754.767602] [<c017a268>] eip93_done_task+0x25c/0x29c [crypto_hw_eip93]
[61754.780616] [<80039e4c>] tasklet_action_common+0xa4/0xe8
[61754.791210] [<80039870>] handle_softirqs+0x278/0x2c0
[61754.801103] [<80039af4>] __irq_exit_rcu+0x90/0x124
[61754.810649] [<80039c80>] irq_exit+0x10/0x1c
[61754.818984] [<804b599c>] plat_irq_dispatch+0xbc/0xc8
[61754.828897] [<800140d0>] except_vec_vi_end+0xc4/0xd0
[61754.838793] [<8006ed50>] do_idle+0xfc/0x130
[61754.847132] [<8006f00c>] cpu_startup_entry+0x30/0x38
[61754.857024] [<8084cfac>] kernel_init+0x0/0x118
[61754.865882]
[61754.868847] Code: 00808025  afb10018  02402825 <8c820010> 8c87fffc
 8c86fff8  8c510080  3c02c018  2442b488
[61754.888312]
[61754.891373] ---[ end trace 0000000000000000 ]---
[61754.900652] Kernel panic - not syncing: Fatal exception in interrupt
[61754.913337] ------------[ cut here ]------------
[61754.922543] WARNING: CPU: 0 PID: 0 at kernel/smp.c:815
smp_call_function_many_cond+0xa8/0x45c
[61754.939575] Modules linked in: essiv dm_crypt mt7530_mdio
crypto_hw_eip93 libdes fuse ip_tables x_tables autofs4 dm_mod raid456
async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq
leds_gpio evdev gpio_keys input_core usb_storage xhci_mtk_hcd xhci_hcd
usbcore usb_common
[61754.990843] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Tainted: G      D
     6.14.0 #2
[61755.006799] Tainted: [D]=DIE
[61755.012536] Hardware name: GnuBee GB-PC2
[61755.020352] Stack : 00000225 00000004 80a70000 80a70000 8280fb9c
8083ba08 00010000 9ed681b3
[61755.037111]         00000000 80a70000 00000000 00000000 00000000
00000001 8280fb40 9ed681b3
[61755.053865]         00000000 00000000 8099627c 8280f9c0 00000020
8084b43c 00000000 00000000
[61755.070618]         00000000 8280f814 0000000f 00000000 80a70000
8099627c 800c3014 8098e99c
[61755.087372]         00000009 0000032f 800c3014 00000009 00000000
8052a780 00000001 008e002f
[61755.104125]         ...
[61755.109022] Call Trace:
[61755.113892] [<80019438>] show_stack+0x84/0x120
[61755.122784] [<80010ee0>] dump_stack_lvl+0x74/0xbc
[61755.132195] [<80034f88>] __warn+0xac/0x110
[61755.140385] [<800350b0>] warn_slowpath_fmt+0xc4/0x13c
[61755.150470] [<800c3014>] smp_call_function_many_cond+0xa8/0x45c
[61755.162293] [<800c33dc>] smp_call_function_many+0x14/0x20
[61755.173073] [<800c3408>] smp_call_function+0x20/0x2c
[61755.182987] [<8000233c>] panic+0x14c/0x370
[61755.191162] [<800196b4>] die+0xec/0x108
[61755.198829] [<80026548>] do_page_fault+0x468/0x4a0
[61755.208388] [<8002a6f8>] tlb_do_page_fault_0+0x118/0x120
[61755.218999] [<c017a268>] eip93_done_task+0x25c/0x29c [crypto_hw_eip93]
[61755.232048]
[61755.235018] ---[ end trace 0000000000000000 ]---
[61755.244241] Rebooting in 1 seconds..



modprobe -r crypto_hw_eip93 trace: (rmmod gave a similar crash)

gnubee-n1 login: [  222.999205] eip93: remove called
[  223.005751] CPU 1 Unable to handle kernel paging request at virtual
address 00000180, epc == 803b62a8,
ra == 803b6350
[  223.026942] Oops[#1]:
[  223.031472] CPU: 1 UID: 0 PID: 1549 Comm: modprobe Not tainted 6.14.0 #2
[  223.044825] Hardware name: GnuBee GB-PC2
[  223.052635] $ 0   : 00000000 00000001 00000001 00000000
[  223.063061] $ 4   : 00000180 87405dcc c01871a4 00000000
[  223.073490] $ 8   : 87405d6c c0187180 c0187188 000114a3
[  223.083923] $12   : 00000000 87405a9c 00000027 00000000
[  223.094353] $16   : 00000180 80a70000 80ae0000 00000080
[  223.104785] $20   : c018c4e4 c018c464 803c0000 fffffff5
[  223.115215] $24   : 00000000 00000000
[  223.125642] $28   : 87404000 87405db0 7f7f8d78 803b6350
[  223.136071] Hi    : 0000012c
[  223.141796] Lo    : 3d34c000
[  223.147518] epc   : 803b62a8 crypto_remove_alg+0x0/0x5c
[  223.157941] ra    : 803b6350 crypto_unregister_alg+0x4c/0xf4
[  223.169214] Status: 1100fc03 KERNEL EXL IE
[  223.177561] Cause : 40800008 (ExcCode 02)
[  223.185539] BadVA : 00000180
[  223.191265] PrId  : 0001992f (MIPS 1004Kc)
[  223.199409] Modules linked in: crypto_hw_eip93(-) mt7530_mdio libdes
fuse ip_tables x_tables autofs4 dm
_mod raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor
raid6_pq leds_gpio evdev gpio_
keys input_core usb_storage xhci_mtk_hcd xhci_hcd usbcore usb_common
[  223.248372] Process modprobe (pid: 1549, threadinfo=2cabad0a,
task=8ca9785b, tls=77e9ac80)
[  223.264837] Stack : 00010000 eaa75b3d 00000000 80a70000 80ae19f8
c0184014 c0184014 87405dcc
[  223.281526]         87405dcc eaa75b3d fffffff5 c018c4c4 803b88ec
803b73d0 00000080 c0181b54
[  223.298213]         87405e24 8022760c c0184014 80003138 84747c80
80ae19f8 c0184014 c0184014
[  223.314898]         87405ed0 00000000 ffffffef c0181c2c 00000000
00000000 8280d6bc 80a10000
[  223.331582]         828d5610 8053d8dc c0184014 80a020e8 00000000
8053c490 00000000 828d5610
[  223.348266]         ...
[  223.353140] Call Trace:
[  223.357998] [<803b62a8>] crypto_remove_alg+0x0/0x5c
[  223.367722] [<803b6350>] crypto_unregister_alg+0x4c/0xf4
[  223.378313] [<c0181b54>] eip93_unregister_algs+0xd4/0xdc
[crypto_hw_eip93]
[  223.392031] [<c0181c2c>] eip93_crypto_remove+0x38/0x54 [crypto_hw_eip93]
[  223.405390] [<8053d8dc>] device_release_driver_internal+0xb8/0x114
[  223.417709] [<8053d9f4>] driver_detach+0xa4/0xc0
[  223.426909] [<8053bca8>] bus_remove_driver+0xb0/0xf4
[  223.436799] [<800a524c>] sys_delete_module+0x240/0x27c
[  223.447040] [<8002324c>] syscall_common+0x34/0x58
[  223.456430]
[  223.459390] Code: 8fb00024  03e00008  27bd0040 <8c860000> 10860013
 00000000  8c830010  27bdffe8  00801
025
[  223.478849]
[  223.481894] ---[ end trace 0000000000000000 ]---
[  223.491133] Kernel panic - not syncing: Fatal exception
[  223.501571] Rebooting in 1 seconds..
