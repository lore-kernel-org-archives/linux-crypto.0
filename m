From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: XTS Crypto Not Found In /proc/crypto Even After Compiled for
 4.10.1.
Date: Mon, 6 Mar 2017 19:35:11 +0200
Message-ID: <20170306173511.6w3e47v4vomu7yv4@kozik-lap>
References: <CALaQ_hpC4G6CaxZAFvwNG3gFjc5Dj1C7zB6b_WQjGeYhbArHKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
To: Nathan Royce <nroycea+kernel@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:35193 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932273AbdCFSrV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Mar 2017 13:47:21 -0500
Content-Disposition: inline
In-Reply-To: <CALaQ_hpC4G6CaxZAFvwNG3gFjc5Dj1C7zB6b_WQjGeYhbArHKw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 06, 2017 at 10:18:45AM -0600, Nathan Royce wrote:
> I tried the patch you submitted, however it also fails for the most part.
> 
> "For the most part" because "xts" is now found.
> $ grep xts /proc/crypto
> name         : xts(aes)
> driver       : xts(ecb-aes-s5p)

Ah, so probably I did not fix the original issue but some other... or
maybe there are multiple issues.

Could you attach your config and any other essential reproduction steps (unusual settings?).

I saw you tried v4.10.1, could you try just v4.10?

Best regards,
Krzysztof

> 
> Fail:
> *****
> [   21.057756] xor: using function: neon (352.000 MB/sec)
> [   21.064243] Unable to handle kernel NULL pointer dereference at
> virtual address 00000004
> [   21.070966] pgd = c0004000
> [   21.073599] [00000004] *pgd=00000000
> [   21.077165] Internal error: Oops: 17 [#1] SMP ARM
> [   21.081836] Modules linked in: xor aes_arm xor_neon zlib_deflate
> raid6_pq nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
> ip_tables x_tables
> [   21.095239] CPU: 5 PID: 121 Comm: irq/69-10830000 Not tainted 4.10.1-dirty #1
> [   21.102288] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
> [   21.108355] task: ee3e3700 task.stack: edcf6000
> [   21.112821] PC is at post_crypt+0x1b4/0x1c4
> [   21.116972] LR is at post_crypt+0x1a8/0x1c4
> [   21.121131] pc : [<c0335c68>]    lr : [<c0335c5c>]    psr: 200c0093
> [   21.121131] sp : edcf7e68  ip : ec59dcf4  fp : 117ce9ac
> [   21.132576] r10: 244525e3  r9 : c0c0540c  r8 : ec59dc00
> [   21.137768] r7 : 00000000  r6 : 00000400  r5 : 00000000  r4 : 00000000
> [   21.144267] r3 : ef49fcde  r2 : 00000200  r1 : 00000200  r0 : 00000000
> [   21.150768] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
> Segment none
> [   21.157964] Control: 10c5387d  Table: 6618c06a  DAC: 00000051
> [   21.163677] Process irq/69-10830000 (pid: 121, stack limit = 0xedcf6218)
> [   21.170350] Stack: (0xedcf7e68 to 0xedcf8000)
> [   21.174684] 7e60:                   ef49fcdc ec93f200 ef49fcdc
> ec93f200 ec59dddc 00000400
> [   21.182853] 7e80: 00000000 00000000 00000400 00000000 ef49fcdc
> c01100fc 00000000 00000000
> [   21.190983] 7ea0: 00000000 00000000 00000000 c0110f80 00000010
> 00000010 0000000f 00040a01
> [   21.199128] 7ec0: 00000000 ec59dc00 c0c0540c 00000000 00000000
> 600c0013 00000002 00000000
> [   21.207274] 7ee0: ee889d20 c033608c eea21c90 c05a80d0 eea21ce8
> eea21c90 0000000c 00040a01
> [   21.215418] 7f00: eea21ce8 eea21c90 0000000c 00000000 eea21ce8
> c05a8290 00000000 00000001
> [   21.223564] 7f20: eea2a600 eea8a400 eea8a400 eea2a600 c016ee68
> c0c0540c 00000000 c016ee84
> [   21.231710] 7f40: edcf6000 eea2a624 eea8a400 c016f198 eea2a640
> 00000000 c016ef7c 00040a01
> [   21.239868] 7f60: 00000000 eeb58280 edcf6000 00000000 eea2a640
> eea2a600 c016f04c eeb582a8
> [   21.248000] 7f80: ee889d20 c0138710 edcf6000 eea2a640 c0138608
> 00000000 00000000 00000000
> [   21.256145] 7fa0: 00000000 00000000 00000000 c0107a38 00000000
> 00000000 00000000 00000000
> [   21.264291] 7fc0: 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000 00000000
> [   21.272428] 7fe0: 00000000 00000000 00000000 00000000 00000013
> 00000000 00000000 00000000
> [   21.280580] [<c0335c68>] (post_crypt) from [<c033608c>]
> (decrypt_done+0x4c/0x54)
> [   21.287946] [<c033608c>] (decrypt_done) from [<c05a80d0>]
> (s5p_aes_complete+0x70/0xfc)
> [   21.295845] [<c05a80d0>] (s5p_aes_complete) from [<c05a8290>]
> (s5p_aes_interrupt+0x134/0x1a0)
> [   21.304323] [<c05a8290>] (s5p_aes_interrupt) from [<c016ee84>]
> (irq_thread_fn+0x1c/0x54)
> [   21.312378] [<c016ee84>] (irq_thread_fn) from [<c016f198>]
> (irq_thread+0x14c/0x204)
> [   21.320004] [<c016f198>] (irq_thread) from [<c0138710>] (kthread+0x108/0x138)
> [   21.327109] [<c0138710>] (kthread) from [<c0107a38>]
> (ret_from_fork+0x14/0x3c)
> [   21.334300] Code: eb0114aa e598c118 e58d001c e1a04000 (e5906004)
> [   21.340363] ---[ end trace e87f375304ecdd42 ]---
> [   21.344961] genirq: exiting task "irq/69-10830000" (121) is an
> active IRQ thread (irq 69)
> [   21.870157] irq 69: nobody cared (try booting with the "irqpoll" option)
> [   21.875435] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G      D
> 4.10.1-dirty #1
> [   21.883027] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
> [   21.889134] [<c010eb54>] (unwind_backtrace) from [<c010b408>]
> (show_stack+0x10/0x14)
> [   21.896826] [<c010b408>] (show_stack) from [<c036c34c>]
> (dump_stack+0x84/0x98)
> [   21.904015] [<c036c34c>] (dump_stack) from [<c01706cc>]
> (__report_bad_irq+0x2c/0xcc)
> [   21.911716] [<c01706cc>] (__report_bad_irq) from [<c0170ad0>]
> (note_interrupt+0x28c/0x2dc)
> [   21.919948] [<c0170ad0>] (note_interrupt) from [<c016dd20>]
> (handle_irq_event_percpu+0x5c/0x7c)
> [   21.928614] [<c016dd20>] (handle_irq_event_percpu) from
> [<c016dd78>] (handle_irq_event+0x38/0x5c)
> [   21.937451] [<c016dd78>] (handle_irq_event) from [<c0171470>]
> (handle_fasteoi_irq+0xb8/0x190)
> [   21.945944] [<c0171470>] (handle_fasteoi_irq) from [<c016cf70>]
> (generic_handle_irq+0x24/0x34)
> [   21.954522] [<c016cf70>] (generic_handle_irq) from [<c016d48c>]
> (__handle_domain_irq+0x5c/0xb4)
> [   21.963188] [<c016d48c>] (__handle_domain_irq) from [<c01014e8>]
> (gic_handle_irq+0x38/0x74)
> [   21.971505] [<c01014e8>] (gic_handle_irq) from [<c010bf8c>]
> (__irq_svc+0x6c/0x90)
> [   21.978953] Exception stack(0xc0c01e68 to 0xc0c01eb0)
> [   21.983975] 1e60:                   00200102 c0c5cec0 00000000
> 00000000 00000040 00000000
> [   21.992127] 1e80: c0c00000 00000001 c0c02080 c0c00000 00000000
> efffc7c0 c0c01f00 c0c01eb8
> [   22.000271] 1ea0: c0120b58 c01206d4 600e0113 ffffffff
> [   22.005299] [<c010bf8c>] (__irq_svc) from [<c01206d4>]
> (__do_softirq+0x90/0x21c)
> [   22.012667] [<c01206d4>] (__do_softirq) from [<c0120b58>]
> (irq_exit+0xd8/0x140)
> [   22.019945] [<c0120b58>] (irq_exit) from [<c016d490>]
> (__handle_domain_irq+0x60/0xb4)
> [   22.027743] [<c016d490>] (__handle_domain_irq) from [<c01014e8>]
> (gic_handle_irq+0x38/0x74)
> [   22.036061] [<c01014e8>] (gic_handle_irq) from [<c010bf8c>]
> (__irq_svc+0x6c/0x90)
> [   22.043510] Exception stack(0xc0c01f38 to 0xc0c01f80)
> [   22.048529] 1f20:
>     00000001 00000000
> [   22.056685] 1f40: 00000000 c0114e60 c0c00000 c0c05490 c0c0542c
> c0b4ff88 c0c01f90 00000000
> [   22.064832] 1f60: 00000000 efffc7c0 600e0013 c0c01f88 c0108480
> c0108484 600e0013 ffffffff
> [   22.072978] [<c010bf8c>] (__irq_svc) from [<c0108484>]
> (arch_cpu_idle+0x38/0x3c)
> [   22.080347] [<c0108484>] (arch_cpu_idle) from [<c015da70>]
> (do_idle+0x164/0x1f8)
> [   22.087708] [<c015da70>] (do_idle) from [<c015dda0>]
> (cpu_startup_entry+0x18/0x1c)
> [   22.095258] [<c015dda0>] (cpu_startup_entry) from [<c0b00c74>]
> (start_kernel+0x374/0x394)
> [   22.103389] handlers:
> [   22.105635] [<c016dde8>] irq_default_primary_handler threaded
> [<c05a815c>] s5p_aes_interrupt
> [   22.114046] Disabling IRQ #69
> [   23.496638] Btrfs loaded, crc32c=crc32c-generic
> *****
> Do I need to add "irqpoll" to my u-boot boot config now?
> 
> Yeah, the mailing list bounced my original email because I wasn't
> using plain-text, but my full post shows in Herbert's reply.
> 
> On Sun, Mar 5, 2017 at 11:16 AM, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > On Fri, Mar 03, 2017 at 12:02:10PM +0800, Herbert Xu wrote:
> >> On Thu, Mar 02, 2017 at 05:35:30PM -0600, Nathan Royce wrote:
> >> > ARM ODroid XU4
> >> >
> >> > $ cat /proc/config.gz | gunzip | grep XTS
> >> > CONFIG_CRYPTO_XTS=y
> >> >
> >> > $ grep xts /proc/crypto
> >> > //4.9.13
> >> > name         : xts(aes)
> >> > driver       : xts(aes-generic)
> >> > //4.10.1
> >> > <blank>
> >> > //cbc can be found though
> >> >
> >> > CRYPTTAB:
> >> > cryptswap1 UUID=<sanitized> /dev/urandom
> >> > swap,offset=2048,cipher=aes-xts-plain64:sha512,size=512,nofail
> >> >
> >> > FSTAB:
> >> > /dev/mapper/cryptswap1 none swap sw 0 0
> >> >
> >> > Boot Log:
> >> > [   10.535985] ------------[ cut here ]------------
> >> > [   10.539252] WARNING: CPU: 0 PID: 0 at crypto/skcipher.c:430
> >> > skcipher_walk_first+0x13c/0x14c
> >> > [   10.547542] Modules linked in: xor xor_neon aes_arm zlib_deflate
> >> > dm_crypt raid6_pq nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
> >> > ip_tables x_tables
> >> > [   10.561716] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.10.1-dirty #1
> >> > [   10.568049] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
> >> > [   10.574171] [<c010eb54>] (unwind_backtrace) from [<c010b408>]
> >> > (show_stack+0x10/0x14)
> >> > [   10.581893] [<c010b408>] (show_stack) from [<c036772c>]
> >> > (dump_stack+0x84/0x98)
> >> > [   10.589073] [<c036772c>] (dump_stack) from [<c011bb20>]
> >> > (__warn+0xe8/0x100)
> >> > [   10.595975] [<c011bb20>] (__warn) from [<c011bc30>]
> >> > (warn_slowpath_null+0x20/0x28)
> >> > [   10.603546] [<c011bc30>] (warn_slowpath_null) from [<c0329a48>]
> >> > (skcipher_walk_first+0x13c/0x14c)
> >> > [   10.612390] [<c0329a48>] (skcipher_walk_first) from [<c0329b30>]
> >> > (skcipher_walk_virt+0x1c/0x38)
> >> > [   10.621056] [<c0329b30>] (skcipher_walk_virt) from [<c0330ed0>]
> >> > (post_crypt+0x38/0x1c4)
> >> > [   10.629022] [<c0330ed0>] (post_crypt) from [<c0331470>]
> >> > (decrypt_done+0x4c/0x54)
> >> > [   10.636389] [<c0331470>] (decrypt_done) from [<c05a03f0>]
> >> > (s5p_aes_complete+0x70/0xfc)
> >> > [   10.644274] [<c05a03f0>] (s5p_aes_complete) from [<c05a05b0>]
> >> > (s5p_aes_interrupt+0x134/0x1a0)
> >> > [   10.652771] [<c05a05b0>] (s5p_aes_interrupt) from [<c016dc3c>]
> >> > (__handle_irq_event_percpu+0x9c/0x124)
> >>
> >> This looks like a bug in the s5p driver.  It's calling the completion
> >> function straight from the IRQ handler, which is triggering the
> >> sanity check in skcipher_walk_first.
> >>
> >> The s5p driver needs to schedule a tasklet to call the completion
> >> function.
> >
> > Tasklet... or threaded IRQ handler maybe? I sent a fix.
> >
> > BTW, I subscribe the crypto list but I could not find the original email
> > there.
> >
> > Best regards,
> > Krzysztof
> >
