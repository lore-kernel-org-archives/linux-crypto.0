Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8477D23534D
	for <linux-crypto@vger.kernel.org>; Wed,  2 Apr 2025 08:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743582353; cv=none; b=fO3QY0AuDinrio0MCoPJrFJVksCsG7w3xKCKk/ku0TE/TY7CIJuqskN+oCUdlt/SquCCCYM3VRmj9Yax7QxgK34q4eyOSXQt9DVOLpn69uuCQ+ZhUhLR1lXGideUanSJFo2e/3oWzW5k/O8nKYdBYzRJkHTB/Cw5FI20rHiHebQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743582353; c=relaxed/simple;
	bh=tqKa9bINw3Zf/Q95ForwIY+kHWrg7I3yopI8YZjG1Vs=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wq+Kw7W3eTplYzQDgYGdUBQq+azkxFs4LoYjya2TlilVFzZerHOKCd6BIjmc4ubI4Sc1GzNPp7HGNA1f0h16in5zgPqM2JSCPeXxPTrujGlE26eISscHDqFmjGg2274nU3KL4QvIbC5YPV2qx0Sd1u3IonYY/u5fYuUmwQzmgyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U4LUsYtX; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U4LUsYtX"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-39ac8e7688aso4915478f8f.2
        for <linux-crypto@vger.kernel.org>; Wed, 02 Apr 2025 01:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743582350; x=1744187150; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=17fO3+62k9LMIP7wP8MfvNordDtBbbaD8EcvcH0xJfw=;
        b=U4LUsYtX5+1KHKcfK4OBZ8YTBsgS9b8lPvZi87szR+1Yqo9t3rZLtU6BRpCCZI+K1c
         p83bgnl3lIbvvJjfJafEYP1VitqwsomA+mRuSf6qKsoMl2PaZmhj1AZFQKO1CSNJcF38
         HhWZYZihX5/LoARtv1b05NqwqiUoBTyuBrZbMJrF7j4GO4a6ethbd2KqDmAjT+EB+n8J
         4eD0CbXJmD5QjP7EOA7waG/Gg1Ha0lYY4WPhL0PZUv3cD7tDGI6GaK9nIP3X2yck5mnm
         /5f4L/pXNfwHhvf7UEKHWGi1ExJZpRYL6R2dxdrgiQysb0dx6BImyZUesTZAy0WDdNus
         PZbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743582350; x=1744187150;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=17fO3+62k9LMIP7wP8MfvNordDtBbbaD8EcvcH0xJfw=;
        b=TkHYo5S42Csxy3TKKYPehxxPxINUSvU5wgNR5mPwlEK980oeHDfF4wFVk8LGKIFD1K
         MJQmuXcbtxxe0SrBP6i2EorkD54eyTEZbu+f4W9Idtl3SJifwWlGo+4xCuibIo6hIOM5
         rIHqHQLFTauPC0Cbwsu/OxGRsMh/e3VxL9PlkA7IQFcKYMVtf9xcH0l9jOyybsPluwpy
         rlmbeMPrux11cablcloGZ4u/Fd2A0hfYSx9TJhKdR4y8fw5g6fXFFrUqrVY7xMVG+Eqz
         Mjsm49M0VSQhTaQSl1QybLUaul/6n7Hf2cVF8omehHQVXm5uC4yi6Lz5B3+peUon9H7B
         +W2A==
X-Gm-Message-State: AOJu0YzraURboL4xiMcRRmThq4LGXrCSbcE8qBfnN39gOxbAfiTn7pNo
	N3jdl/oYc5rh0kEaAorrjYUrH6/h9TqYXKKVg7PIv6A7mstm0ra4weDoyw==
X-Gm-Gg: ASbGncs01s8Vz8ZtNMgs04tdJuh+MOlvFODZ3pJ4LyaZQOzSqEP546aaHS8pGqQjC8T
	fINWBgz1MpeFNin3oICLm4hema3Y4nLBa8dpnuyERNbVB8x+1Sx4n88lgpXmDMUkgaOQFfr7jq9
	wrYPdRBC9p+F8xWsB/Cbbls5Tyh9AoBfNe6fAqM7+7frJ52gcKpS1rxoI3dsMXx1E+oWeDfPQoq
	GTSB4+tR6HNGtMkp7saNfyW1PfOiRhRIGtU2J58RmonOy5IkTKQcfzoiYn6yWL37wn+Cux9vjJM
	ql0PGLYqX6NwctpHHL76d4tTvlTt/ga+2BnaiwXLyueueVs0kQ6ssP49QHvorfIJkSLwP7YE+xH
	w
X-Google-Smtp-Source: AGHT+IEvxc07UgSoL6qe3QzUrTj6TJdB002h/WQbyXMFsvqaXY5NQd97jTcQigVsdlfUZQdcxYKp2g==
X-Received: by 2002:a5d:64c9:0:b0:39c:1f10:ba54 with SMTP id ffacd0b85a97d-39c29769561mr1194985f8f.35.1743582349465;
        Wed, 02 Apr 2025 01:25:49 -0700 (PDT)
Received: from Ansuel-XPS. (93-34-88-225.ip49.fastwebnet.it. [93.34.88.225])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43eb5fc688fsm13382365e9.4.2025.04.02.01.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 01:25:49 -0700 (PDT)
Message-ID: <67ecf48d.050a0220.193cef.366e@mx.google.com>
X-Google-Original-Message-ID: <Z-z0igPJ7BTkMAYh@Ansuel-XPS.>
Date: Wed, 2 Apr 2025 10:25:46 +0200
From: Christian Marangi <ansuelsmth@gmail.com>
To: David Tulloh <david@tulloh.id.au>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [BUG] : EIP-93 module crash, unable to handle kernel paging
 request
References: <CAOP4N=-42N6bzXtWYCSAmZekwh+FqRBnYnBPwoPX_SuHTBVavA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOP4N=-42N6bzXtWYCSAmZekwh+FqRBnYnBPwoPX_SuHTBVavA@mail.gmail.com>

On Wed, Apr 02, 2025 at 07:21:42PM +1100, David Tulloh wrote:
> Hi,
> 
> I decided to try out the recently merged EIP-93 module on my MediaTek
> MT7621. Ran into this kernel crash "Unable to handle kernel paging
> request", full trace is included below.
> 
> I'm happy to dig into this a little, but have no idea what I'm doing in
> kernel land so I thought I would post first in case it was super obvious to
> skilled eyes.
> 
> 
> I enabled the hardware by adding the following block to mt7621.dtsi:
> 
>     crypto: crypto@1e004000 {
>         status = "okay";
> 
>         compatible = "airoha,en7581-eip93",
> "inside-secure,safexcel-eip93ies";
>         reg = <0x1e004000 0x1000>;
> 
>         interrupt-parent = <&gic>;
>         interrupts = <GIC_SHARED 19 IRQ_TYPE_LEVEL_HIGH>;
>     };
> 
> Basic testing seemed to show it was working. I ran `cryptsetup benchmark`
> without issue and it showed the desired speed increases.
> 
> Mounting an encrypted disk caused the displayed crash, this is repeatable.
> The drive had been previously set up and encrypted before enabling the
> module.
> 
> Attempting to rmmod the module also caused a crash, I have included its
> trace too.
> 
> 
> Thanks for your time,
> 
> 
> David
> 
> 
> Mount trace:
> 
> [  +0.018390] XFS (dm-0): Mounting V4 Filesystem
> a4050634-7a5c-4a58-bc17-aefaa71d6dc9
> [61754.391252] CPU 0 Unable to handle kernel paging request at virtual
> address 00000010, epc == c017c19c,
> ra == c017a268
> [61754.412500] Oops[#1]:
> [61754.417036] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.14.0 #2
> [61754.430035] Hardware name: GnuBee GB-PC2
> [61754.437842] $ 0   : 00000000 00000001 c017c174 000f0000
> [61754.448278] $ 4   : 00000000 00000070 00000000 8280fea0
> [61754.458708] $ 8   : 87eb86dc 80a70000 8280fe9c 87eb86d4
> [61754.469140] $12   : 0000ffe4 87eb86dc fffffffd 00000000
> [61754.479572] $16   : 00000000 00000108 00000070 00000000
> [61754.490002] $20   : 87eb86d0 00000002 00000000 c017a950
> [61754.500432] $24   : fffffffc 00000000
> [61754.510862] $28   : 80a56000 8280fe98 00000000 c017a268
> [61754.521297] Hi    : 0000001f
> [61754.527038] Lo    : 00000002
> [61754.532766] epc   : c017c19c eip93_skcipher_handle_result+0x28/0x8c
> [crypto_hw_eip93]
> [61754.548384] ra    : c017a268 eip93_done_task+0x25c/0x29c
> [crypto_hw_eip93]
> [61754.562084] Status: 11000403 KERNEL EXL IE
> [61754.570432] Cause : 40800008 (ExcCode 02)
> [61754.578412] BadVA : 00000010
> [61754.584141] PrId  : 0001992f (MIPS 1004Kc)
> [61754.592293] Modules linked in: essiv dm_crypt mt7530_mdio
> crypto_hw_eip93 libdes fuse ip_tables x_table
> s autofs4 dm_mod raid456 async_raid6_recov async_memcpy async_pq async_xor
> async_tx xor raid6_pq leds_gpio
>  evdev gpio_keys input_core usb_storage xhci_mtk_hcd xhci_hcd usbcore
> usb_common
> [61754.643378] Process swapper/0 (pid: 0, threadinfo=f12d9e27,
> task=ac21a255, tls=00000000)
> [61754.659504] Stack : 579efe26 00000000 00000000 9ed681b3 80a5c08c
> 87eb8e80 00000108 c017a000
> [61754.676192]         00000000 c017a268 00000007 0000000a 80a5c020
> 8008a184 c017a000 808546ec
> [61754.692876]         8085492c 00000001 87eb8680 8201f254 00000006
> 00000000 00000007 0000000a
> [61754.709558]         00000040 80a5a058 00000100 80039e4c 87812000
> 8280ff30 00000000 80039ee4
> [61754.726243]         80a70000 80a68538 81a48420 04200002 80a5a040
> 80039870 00000013 804b61d0
> [61754.742927]         ...
> [61754.747811] Call Trace:
> [61754.752678] [<c017c19c>] eip93_skcipher_handle_result+0x28/0x8c
> [crypto_hw_eip93]
> [61754.767602] [<c017a268>] eip93_done_task+0x25c/0x29c [crypto_hw_eip93]
> [61754.780616] [<80039e4c>] tasklet_action_common+0xa4/0xe8
> [61754.791210] [<80039870>] handle_softirqs+0x278/0x2c0
> [61754.801103] [<80039af4>] __irq_exit_rcu+0x90/0x124
> [61754.810649] [<80039c80>] irq_exit+0x10/0x1c
> [61754.818984] [<804b599c>] plat_irq_dispatch+0xbc/0xc8
> [61754.828897] [<800140d0>] except_vec_vi_end+0xc4/0xd0
> [61754.838793] [<8006ed50>] do_idle+0xfc/0x130
> [61754.847132] [<8006f00c>] cpu_startup_entry+0x30/0x38
> [61754.857024] [<8084cfac>] kernel_init+0x0/0x118
> [61754.865882]
> [61754.868847] Code: 00808025  afb10018  02402825 <8c820010> 8c87fffc
>  8c86fff8  8c510080  3c02c018  2442b488
> [61754.888312]
> [61754.891373] ---[ end trace 0000000000000000 ]---
> [61754.900652] Kernel panic - not syncing: Fatal exception in interrupt
> [61754.913337] ------------[ cut here ]------------
> [61754.922543] WARNING: CPU: 0 PID: 0 at kernel/smp.c:815
> smp_call_function_many_cond+0xa8/0x45c
> [61754.939575] Modules linked in: essiv dm_crypt mt7530_mdio
> crypto_hw_eip93 libdes fuse ip_tables x_tables autofs4 dm_mod raid456
> async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq
> leds_gpio evdev gpio_keys input_core usb_storage xhci_mtk_hcd xhci_hcd
> usbcore usb_common
> [61754.990843] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Tainted: G      D
>      6.14.0 #2
> [61755.006799] Tainted: [D]=DIE
> [61755.012536] Hardware name: GnuBee GB-PC2
> [61755.020352] Stack : 00000225 00000004 80a70000 80a70000 8280fb9c
> 8083ba08 00010000 9ed681b3
> [61755.037111]         00000000 80a70000 00000000 00000000 00000000
> 00000001 8280fb40 9ed681b3
> [61755.053865]         00000000 00000000 8099627c 8280f9c0 00000020
> 8084b43c 00000000 00000000
> [61755.070618]         00000000 8280f814 0000000f 00000000 80a70000
> 8099627c 800c3014 8098e99c
> [61755.087372]         00000009 0000032f 800c3014 00000009 00000000
> 8052a780 00000001 008e002f
> [61755.104125]         ...
> [61755.109022] Call Trace:
> [61755.113892] [<80019438>] show_stack+0x84/0x120
> [61755.122784] [<80010ee0>] dump_stack_lvl+0x74/0xbc
> [61755.132195] [<80034f88>] __warn+0xac/0x110
> [61755.140385] [<800350b0>] warn_slowpath_fmt+0xc4/0x13c
> [61755.150470] [<800c3014>] smp_call_function_many_cond+0xa8/0x45c
> [61755.162293] [<800c33dc>] smp_call_function_many+0x14/0x20
> [61755.173073] [<800c3408>] smp_call_function+0x20/0x2c
> [61755.182987] [<8000233c>] panic+0x14c/0x370
> [61755.191162] [<800196b4>] die+0xec/0x108
> [61755.198829] [<80026548>] do_page_fault+0x468/0x4a0
> [61755.208388] [<8002a6f8>] tlb_do_page_fault_0+0x118/0x120
> [61755.218999] [<c017a268>] eip93_done_task+0x25c/0x29c [crypto_hw_eip93]
> [61755.232048]
> [61755.235018] ---[ end trace 0000000000000000 ]---
> [61755.244241] Rebooting in 1 seconds..
> 
> 
> 
> modprobe -r crypto_hw_eip93 trace: (rmmod gave a similar crash)
> 
> gnubee-n1 login: [  222.999205] eip93: remove called
> [  223.005751] CPU 1 Unable to handle kernel paging request at virtual
> address 00000180, epc == 803b62a8,
> ra == 803b6350
> [  223.026942] Oops[#1]:
> [  223.031472] CPU: 1 UID: 0 PID: 1549 Comm: modprobe Not tainted 6.14.0 #2
> [  223.044825] Hardware name: GnuBee GB-PC2
> [  223.052635] $ 0   : 00000000 00000001 00000001 00000000
> [  223.063061] $ 4   : 00000180 87405dcc c01871a4 00000000
> [  223.073490] $ 8   : 87405d6c c0187180 c0187188 000114a3
> [  223.083923] $12   : 00000000 87405a9c 00000027 00000000
> [  223.094353] $16   : 00000180 80a70000 80ae0000 00000080
> [  223.104785] $20   : c018c4e4 c018c464 803c0000 fffffff5
> [  223.115215] $24   : 00000000 00000000
> [  223.125642] $28   : 87404000 87405db0 7f7f8d78 803b6350
> [  223.136071] Hi    : 0000012c
> [  223.141796] Lo    : 3d34c000
> [  223.147518] epc   : 803b62a8 crypto_remove_alg+0x0/0x5c
> [  223.157941] ra    : 803b6350 crypto_unregister_alg+0x4c/0xf4
> [  223.169214] Status: 1100fc03 KERNEL EXL IE
> [  223.177561] Cause : 40800008 (ExcCode 02)
> [  223.185539] BadVA : 00000180
> [  223.191265] PrId  : 0001992f (MIPS 1004Kc)
> [  223.199409] Modules linked in: crypto_hw_eip93(-) mt7530_mdio libdes
> fuse ip_tables x_tables autofs4 dm
> _mod raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor
> raid6_pq leds_gpio evdev gpio_
> keys input_core usb_storage xhci_mtk_hcd xhci_hcd usbcore usb_common
> [  223.248372] Process modprobe (pid: 1549, threadinfo=2cabad0a,
> task=8ca9785b, tls=77e9ac80)
> [  223.264837] Stack : 00010000 eaa75b3d 00000000 80a70000 80ae19f8
> c0184014 c0184014 87405dcc
> [  223.281526]         87405dcc eaa75b3d fffffff5 c018c4c4 803b88ec
> 803b73d0 00000080 c0181b54
> [  223.298213]         87405e24 8022760c c0184014 80003138 84747c80
> 80ae19f8 c0184014 c0184014
> [  223.314898]         87405ed0 00000000 ffffffef c0181c2c 00000000
> 00000000 8280d6bc 80a10000
> [  223.331582]         828d5610 8053d8dc c0184014 80a020e8 00000000
> 8053c490 00000000 828d5610
> [  223.348266]         ...
> [  223.353140] Call Trace:
> [  223.357998] [<803b62a8>] crypto_remove_alg+0x0/0x5c
> [  223.367722] [<803b6350>] crypto_unregister_alg+0x4c/0xf4
> [  223.378313] [<c0181b54>] eip93_unregister_algs+0xd4/0xdc
> [crypto_hw_eip93]
> [  223.392031] [<c0181c2c>] eip93_crypto_remove+0x38/0x54 [crypto_hw_eip93]
> [  223.405390] [<8053d8dc>] device_release_driver_internal+0xb8/0x114
> [  223.417709] [<8053d9f4>] driver_detach+0xa4/0xc0
> [  223.426909] [<8053bca8>] bus_remove_driver+0xb0/0xf4
> [  223.436799] [<800a524c>] sys_delete_module+0x240/0x27c
> [  223.447040] [<8002324c>] syscall_common+0x34/0x58
> [  223.456430]
> [  223.459390] Code: 8fb00024  03e00008  27bd0040 <8c860000> 10860013
>  00000000  8c830010  27bdffe8  00801
> 025
> [  223.478849]
> [  223.481894] ---[ end trace 0000000000000000 ]---
> [  223.491133] Kernel panic - not syncing: Fatal exception
> [  223.501571] Rebooting in 1 seconds..

(ignore the other email, sorry for top post)

Can you provide easy repro step?

On rmmod the module, you were doing tests?

-- 
	Ansuel
