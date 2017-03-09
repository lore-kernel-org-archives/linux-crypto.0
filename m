From: Nathan Royce <nroycea+kernel@gmail.com>
Subject: Re: XTS Crypto Not Found In /proc/crypto Even After Compiled for 4.10.1.
Date: Thu, 9 Mar 2017 05:16:35 -0600
Message-ID: <CALaQ_hrikH8Q8ug9WTgnYR3UwSCip1DZtkkjj2NCLJVqcKQdZA@mail.gmail.com>
References: <CALaQ_hpC4G6CaxZAFvwNG3gFjc5Dj1C7zB6b_WQjGeYhbArHKw@mail.gmail.com>
 <20170306173511.6w3e47v4vomu7yv4@kozik-lap> <CALaQ_hqhFjb60rJ2AgBnYgyNCPQ7fH5BdOOCeaMiankQR0VwqQ@mail.gmail.com>
 <20170308174542.2rydwxmrb3oehyrc@kozik-lap> <20170308211543.euqexxlhdgpfcdjk@kozik-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:33804 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752441AbdCILRw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Mar 2017 06:17:52 -0500
In-Reply-To: <20170308211543.euqexxlhdgpfcdjk@kozik-lap>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Gave it a try on 4.10.1, but still to no avail:
*****
[    8.516138] raid6: using intx1 recovery algorithm
[ [0;32m  OK   [0m] Started Flush Journal to Persistent Storage.
[    9.692091] Unable to handle kernel NULL pointer dereference at
virtual address 00000004
[    9.698896] pgd = c0004000
[    9.701489] [00000004] *pgd=00000000
[    9.705055] Internal error: Oops: 17 [#1] SMP ARM
[    9.709677] Modules linked in: xor_neon zlib_deflate aes_arm
raid6_pq nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
ip_tables x_tables
[    9.719177] xor: measuring software checksum speed
[    9.727455] CPU: 2 PID: 121 Comm: irq/69-10830000 Not tainted 4.10.1-dirty #1
[    9.728911]    arm4regs  :   304.000 MB/sec
[    9.738707] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[    9.738913]    8regs     :   224.000 MB/sec
[    9.748924]    32regs    :   208.000 MB/sec
[    9.753095] task: edc80b00 task.stack: edd08000
[    9.757626] PC is at post_crypt+0x1b4/0x1c4
[    9.758914]    neon      :   316.000 MB/sec
[    9.758927] xor: using function: neon (316.000 MB/sec)
[    9.771040] LR is at post_crypt+0x1a8/0x1c4
[    9.775197] pc : [<c0335c68>]    lr : [<c0335c5c>]    psr: 200c0013
[    9.775197] sp : edd09e90  ip : edcd64f4  fp : 02cfca75
[    9.786670] r10: 3df4074e  r9 : c0c0540c  r8 : edcd6400
[    9.791831] r7 : 00000000  r6 : 00000400  r5 : 00000000  r4 : 00000000
[    9.798333] r3 : ef4a775a  r2 : 00000200  r1 : 00000200  r0 : 00000000
[    9.804834] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[    9.811901] Control: 10c5387d  Table: 6c61c06a  DAC: 00000051
[    9.817618] Process irq/69-10830000 (pid: 121, stack limit = 0xedd08218)
[    9.824291] Stack: (0xedd09e90 to 0xedd0a000)
[    9.828624] 9e80:                                     ef4a7758
ecca6200 ef4a7758 ecca6200
[    9.836781] 9ea0: edcd65dc 00000400 00000000 00000000 00000400
00000000 eea8f810 00000002
[    9.844926] 9ec0: 00000000 00000000 00000000 00000000 00000000
00000000 00000010 00000010
[    9.853072] 9ee0: 0000000f 00040a01 ee958390 edcd6400 ee9583bc
0000000c ee9583e8 00000000
[    9.861217] 9f00: 00000000 600c0013 ee889d20 c033608c ee958390
c05a7ea8 00000000 00000001
[    9.869363] 9f20: ee957b40 eea8a400 eea8a400 ee957b40 c016ee68
c0c0540c 00000000 c016ee84
[    9.877508] 9f40: edd08000 ee957b64 eea8a400 c016f198 ee957b80
00000000 c016ef7c 00040a01
[    9.885653] 9f60: 00000000 eea21380 edd08000 00000000 ee957b80
ee957b40 c016f04c eea213a8
[    9.893800] 9f80: ee889d20 c0138710 edd08000 ee957b80 c0138608
00000000 00000000 00000000
[    9.901944] 9fa0: 00000000 00000000 00000000 c0107a38 00000000
00000000 00000000 00000000
[    9.910089] 9fc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[    9.918235] 9fe0: 00000000 00000000 00000000 00000000 00000013
00000000 00000000 00000000
[    9.926399] [<c0335c68>] (post_crypt) from [<c033608c>]
(decrypt_done+0x4c/0x54)
[    9.933761] [<c033608c>] (decrypt_done) from [<c05a7ea8>]
(s5p_aes_interrupt+0x1bc/0x208)
[    9.941908] [<c05a7ea8>] (s5p_aes_interrupt) from [<c016ee84>]
(irq_thread_fn+0x1c/0x54)
[    9.949956] [<c016ee84>] (irq_thread_fn) from [<c016f198>]
(irq_thread+0x14c/0x204)
[    9.957585] [<c016f198>] (irq_thread) from [<c0138710>] (kthread+0x108/0x138)
[    9.964681] [<c0138710>] (kthread) from [<c0107a38>]
(ret_from_fork+0x14/0x3c)
[    9.971871] Code: eb0114aa e598c118 e58d001c e1a04000 (e5906004)
[    9.977963] ---[ end trace 8c160bf6676cfe1c ]---
[    9.982560] genirq: exiting task "irq/69-10830000" (121) is an
active IRQ thread (irq 69)
[   11.715339] Btrfs loaded, crc32c=crc32c-generic
*****

Also for the sake of testing, I did not add any FLAGS for compilation this time.

On Wed, Mar 8, 2017 at 3:15 PM, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> On Wed, Mar 08, 2017 at 07:45:42PM +0200, Krzysztof Kozlowski wrote:
> I sent a fix. At least for spin lock recursion in tcrypt.
>
> Could you give it a try?
>
> Best regards,
> Krzysztof
