From: Gurucharan Shetty <gurucharan.shetty@gmail.com>
Subject: Kernel crashes while using aesni_intel
Date: Mon, 24 Sep 2012 14:43:58 -0700
Message-ID: <CA+sc+0QR2PH00=CQoyHQ57XYFZvm+7B2QshY06JmB2tC_wjrjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Neil Horman <nhorman@tuxdriver.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:48226 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab2IXVoT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Sep 2012 17:44:19 -0400
Received: by weyt9 with SMTP id t9so500790wey.19
        for <linux-crypto@vger.kernel.org>; Mon, 24 Sep 2012 14:44:18 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello All,

(I have got a couple of bounces from the mail server for the list -
linux-crypto@vger.kernel.org. If you have already received this mail,
please ignore.)

I have been seeing a bunch of kernel crashes while using aesni_intel
module and IPSEC.

I have so far reproduced the kernel crashes while using the AES-GCM
encryption algorithms(I am using strongswan). It is very easily
reproducible in the 3.2 kernel (stable branch). It is also
reproducible in 3.3, 3.4 and 3.5 kernel stable branches (The
reproduction is a little harder with newer kernels. I have seen 2-3
kernel crashes in Linux 3.5 after running netperf traffic for over
week.)

In the 3.2 kernel, the crash happens once every 15 minutes(average) of
netperf TCP traffic.

I have seen this with both Intel (82599EB 10-Gigabit) and Broadcom
(BCM57711 10-Gigabit PCIe) NICs. I am using ubuntu 12.04 distribution
and my machine is x86_64.
I can provide more information if anyone needs it.

Here is the backtrace as seen in the crash utility.
---------------------
PID: 125    TASK: ffff880bee255bc0  CPU: 3   COMMAND: "kworker/3:1"
 #0 [ffff880c0fc63710] machine_kexec at ffffffff8103842a
 #1 [ffff880c0fc63780] crash_kexec at ffffffff810b4448
 #2 [ffff880c0fc63850] oops_end at ffffffff8165ab68
 #3 [ffff880c0fc63880] die at ffffffff810168d8
 #4 [ffff880c0fc638b0] do_general_protection at ffffffff8165a6e2
 #5 [ffff880c0fc638e0] general_protection at ffffffff8165a105
    [exception RIP: crypto_enqueue_request+43]
    RIP: ffffffff812dd77b  RSP: ffff880c0fc63990  RFLAGS: 00010206
    RAX: 00000000ffffff8d  RBX: ffff8817d74e3a08  RCX: 0000000000000000
    RDX: dead000000200200  RSI: ffff8817d74e3a60  RDI: ffffe8f3cfc61ef0
    RBP: ffff880c0fc63990   R8: 0000000000000000   R9: ffff8817d74e3b18
    R10: 000000007b3dc352  R11: 0000000000000001  R12: 0000000000000003
    R13: ffffe8f3cfc61ef0  R14: ffff880bc6ff3800  R15: 0000000000000001
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #6 [ffff880c0fc63998] cryptd_enqueue_request at ffffffffa02d9106 [cryptd]
 #7 [ffff880c0fc639c8] cryptd_aead_decrypt_enqueue at ffffffffa02d92c0 [cryptd]
 #8 [ffff880c0fc639d8] rfc4106_decrypt at ffffffffa02ec2bf [aesni_intel]
 #9 [ffff880c0fc63a08] esp_input at ffffffffa029da65 [esp4]
#10 [ffff880c0fc63a98] xfrm_input at ffffffff815cb9c4
#11 [ffff880c0fc63b08] xfrm4_rcv_encap at ffffffff815c148c
#12 [ffff880c0fc63b18] xfrm4_rcv at ffffffff815c14b4
#13 [ffff880c0fc63b28] ip_local_deliver_finish at ffffffff815749ed
#14 [ffff880c0fc63b58] ip_local_deliver at ffffffff81574d58
#15 [ffff880c0fc63b88] ip_rcv_finish at ffffffff815746c1
#16 [ffff880c0fc63bb8] ip_rcv at ffffffff81574f95
#17 [ffff880c0fc63bf8] __netif_receive_skb at ffffffff81540523
#18 [ffff880c0fc63c58] netif_receive_skb at ffffffff81541300
#19 [ffff880c0fc63c88] napi_skb_finish at ffffffff81541450
#20 [ffff880c0fc63ca8] napi_gro_receive at ffffffff81541a55
#21 [ffff880c0fc63ce8] bnx2x_rx_int at ffffffffa01850c8 [bnx2x]
#22 [ffff880c0fc63e18] bnx2x_poll at ffffffffa0187409 [bnx2x]
#23 [ffff880c0fc63e68] net_rx_action at ffffffff81541ca4
#24 [ffff880c0fc63ed8] __do_softirq at ffffffff8106ea58
#25 [ffff880c0fc63f48] call_softirq at ffffffff8166422c
#26 [ffff880c0fc63f60] do_softirq at ffffffff81015305
#27 [ffff880c0fc63f80] irq_exit at ffffffff8106ee3e
#28 [ffff880c0fc63f90] smp_apic_timer_interrupt at ffffffff81664bce
#29 [ffff880c0fc63fb0] apic_timer_interrupt at ffffffff81662a9e
--- <IRQ stack> ---
#30 [ffff880bedd939f0] apic_timer_interrupt at ffffffff81662a9e
    RIP: ffffffffffffff10  RSP: 0000000000000202  RFLAGS: 00000010
    RAX: 00007ffffffff000  RBX: ffff880bedd93ac8  RCX: ffff880bee255bc0
    RDX: 0000000000000000  RSI: 0000000000000000  RDI: 0000000000000001
    RBP: ffffffff8103dcf9   R8: 000000000000007d   R9: 0000000000000000
   R10: 0000000000000011  R11: ffffffff81659c5e  R12: ffff880bedd93a18
    R13: 0044b82fa09b5a53  R14: ffff880bedd93a3e  R15: 000000000000003a
    ORIG_RAX: ffff880bedd41888  CS: ffffffff810b2a4f  SS: ffff880bedd93aa8
--------------------------------------------------

Here is the relevant section from "log" (dmesg):
----------------------------
 3673.932301] kernel tried to execute NX-protected page - exploit
attempt? (uid: 0)
[ 3673.932351] BUG: unable to handle kernel paging request at ffffe8f3cfc61ef0
[ 3673.932463] IP: [<ffffe8f3cfc61ef0>] 0xffffe8f3cfc61eef
[ 3673.932541] PGD bee3af067 PUD 17f024c067 PMD bee3ae067 PTE 8000000bef7f6163
[ 3673.932719] Oops: 0011 [#1] SMP
[ 3673.932823] CPU 3
[ 3673.932860] Modules linked in: seqiv xfrm4_mode_transport
aesni_intel cryptd aes_x86_64 xfrm_user xfrm4_tunnel tunnel4 ipcomp
xfrm_ipcomp esp4 ah4 deflate ctr twofish_generic twofish_x86_64_3way
twofish_x86_64 twofish_common camellia serpent blowfish_generic
blowfish_x86_64 blowfish_common cast5 des_generic xcbc rmd160
sha512_generic crypto_null af_key psmouse serio_raw joydev ioatdma dca
i7core_edac edac_core mac_hid lp parport usbhid hid bnx2x megaraid_sas
mdio btrfs e1000e zlib_deflate libcrc32c
[ 3673.934649]
[ 3673.934686] Pid: 125, comm: kworker/3:1 Not tainted
3.2.0-26-generic #41-Ubuntu iXsystems iX22X4-TTH6RF/X8DTT-H
[ 3673.934837] RIP: 0010:[<ffffe8f3cfc61ef0>]  [<ffffe8f3cfc61ef0>]
0xffffe8f3cfc61eef
[ 3673.934946] RSP: 0018:ffff880bedd93dd8  EFLAGS: 00010246
[ 3673.935003] RAX: ffffe8f3cfc61ef0 RBX: 0000000000000000 RCX: dead000000200200
[ 3673.935063] RDX: dead000000100100 RSI: 0000000000000000 RDI: ffffe8f3cfc61ef0
[ 3673.935123] RBP: ffff880bedd93e00 R08: ffffe8f3cfc61f18 R09: ffff880c0fc7aa58
[ 3673.935183] R10: ffff880bc6ff4c00 R11: ffff880bc6ff4d78 R12: ffffe8f3cfc61f10
[ 3673.935243] R13: ffffe8f3cfc61ef0 R14: ffff880c0fc6e480 R15: ffffffffa02d9af0
[ 3673.935304] FS:  0000000000000000(0000) GS:ffff880c0fc60000(0000)
knlGS:0000000000000000
[ 3673.935380] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3673.935438] CR2: ffffe8f3cfc61ef0 CR3: 0000000bc5cbd000 CR4: 00000000000006e0
[ 3673.935499] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 3673.935559] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 3673.935620] Process kworker/3:1 (pid: 125, threadinfo
ffff880bedd92000, task ffff880bee255bc0)
[ 3673.935697] Stack:
[ 3673.935747]  ffffffffa02d9b46 ffff880bedd93e60 ffffe8f3cfc61f10
ffff880bee3e1200
[ 3673.935954]  ffff880c0fc7aa00 ffff880bedd93e70 ffffffff81084f9a
ffff880bedd93fd8
[ 3673.936161]  0000000000013780 ffff880bee2916f0 ffff880bee255bc0
ffff880c0fc7aa05
[ 3673.936367] Call Trace:
[ 3673.936421]  [<ffffffffa02d9b46>] ? cryptd_queue_worker+0x56/0x80 [cryptd]
[ 3673.936486]  [<ffffffff81084f9a>] process_one_work+0x11a/0x480
[ 3673.936546]  [<ffffffff81085d44>] worker_thread+0x164/0x370
[ 3673.936605]  [<ffffffff81085be0>] ? manage_workers.isra.29+0x130/0x130
[ 3673.936666]  [<ffffffff8108a59c>] kthread+0x8c/0xa0
[ 3673.936725]  [<ffffffff81664134>] kernel_thread_helper+0x4/0x10
[ 3673.936785]  [<ffffffff8108a510>] ? flush_kthread_worker+0xa0/0xa0
[ 3673.936844]  [<ffffffff81664130>] ? gs_change+0x13/0x13
[ 3673.936901] Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08 00 00 00
04 00 00 00 <00> 01 10 00 00 00 ad de 00 02 20 00 00 00 ad de f0 1e c6
cf f3
[ 3673.939138] RIP  [<ffffe8f3cfc61ef0>] 0xffffe8f3cfc61eef
[ 3673.939228]  RSP <ffff880bedd93dd8>
[ 3673.939281] CR2: ffffe8f3cfc61ef0
[ 3673.939336] ---[ end trace e116502e32f4d8d6 ]---
[ 3673.939506] general protection fault: 0000 [#2] SMP
[ 3673.939630] CPU 3
[ 3673.939667] Modules linked in: seqiv xfrm4_mode_transport
aesni_intel cryptd aes_x86_64 xfrm_user xfrm4_tunnel tunnel4 ipcomp
xfrm_ipcomp esp4 ah4 deflate ctr twofish_generic twofish_x86_64_3way
twofish_x86_64 twofish_common camellia serpent blowfish_generic
blowfish_x86_64 blowfish_common cast5 des_generic xcbc rmd160
sha512_generic crypto_null af_key psmouse serio_raw joydev ioatdma dca
i7core_edac edac_core mac_hid lp parport usbhid hid bnx2x megaraid_sas
mdio btrfs e1000e zlib_deflate libcrc32c
[ 3673.941587]
[ 3673.941637] Pid: 125, comm: kworker/3:1 Tainted: G      D
3.2.0-26-generic #41-Ubuntu iXsystems iX22X4-TTH6RF/X8DTT-H
[ 3673.941816] RIP: 0010:[<ffffffff812dd77b>]  [<ffffffff812dd77b>]
crypto_enqueue_request+0x2b/0x50
[ 3673.941930] RSP: 0018:ffff880c0fc63990  EFLAGS: 00010206
[ 3673.941987] RAX: 00000000ffffff8d RBX: ffff8817d74e3a08 RCX: 0000000000000000
[ 3673.942048] RDX: dead000000200200 RSI: ffff8817d74e3a60 RDI: ffffe8f3cfc61ef0
[ 3673.942109] RBP: ffff880c0fc63990 R08: 0000000000000000 R09: ffff8817d74e3b18
[ 3673.942170] R10: 000000007b3dc352 R11: 0000000000000001 R12: 0000000000000003
[ 3673.942230] R13: ffffe8f3cfc61ef0 R14: ffff880bc6ff3800 R15: 0000000000000001
[ 3673.942291] FS:  0000000000000000(0000) GS:ffff880c0fc60000(0000)
knlGS:0000000000000000
[ 3673.942367] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3673.942424] CR2: ffffe8f3cfc61ef0 CR3: 0000000bc5cbd000 CR4: 00000000000006e0
[ 3673.942485] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 3673.942545] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 3673.942607] Process kworker/3:1 (pid: 125, threadinfo
ffff880bedd92000, task ffff880bee255bc0)
[ 3673.942683] Stack:
[ 3673.942734]  ffff880c0fc639c0 ffffffffa02d9106 ffff880b000005b8
ffff8817d74e3a08
[ 3673.942940]  ffff880bc6ff1060 ffff8817d74e3b18 ffff880c0fc639d0
ffffffffa02d92c0
[ 3673.943145]  ffff880c0fc63a00 ffffffffa02ec2bf ffff880c0fc63a00
ffff8817d74e3a08
[ 3673.943351] Call Trace:
[ 3673.943402]  <IRQ>
[ 3673.943488]  [<ffffffffa02d9106>] cryptd_enqueue_request+0x36/0x60 [cryptd]
[ 3673.943549]  [<ffffffffa02d92c0>]
cryptd_aead_decrypt_enqueue+0x30/0x40 [cryptd]
[ 3673.943626]  [<ffffffffa02ec2bf>] rfc4106_decrypt+0x18f/0x270 [aesni_intel]
[ 3673.943688]  [<ffffffffa029da65>] esp_input+0x1b5/0x310 [esp4]
[ 3673.943750]  [<ffffffff815cb9c4>] xfrm_input+0x464/0x4b0
[ 3673.943808]  [<ffffffff815c148c>] xfrm4_rcv_encap+0x1c/0x20
[ 3673.943866]  [<ffffffff815c14b4>] xfrm4_rcv+0x24/0x30
[ 3673.943926]  [<ffffffff815749ed>] ip_local_deliver_finish+0xdd/0x280
[ 3673.943986]  [<ffffffff81574d58>] ip_local_deliver+0x88/0x90
[ 3673.944045]  [<ffffffff815746c1>] ip_rcv_finish+0x131/0x380
[ 3673.944103]  [<ffffffff81574f95>] ip_rcv+0x235/0x300
[ 3673.944160]  [<ffffffff81574d58>] ? ip_local_deliver+0x88/0x90
[ 3673.944222]  [<ffffffff81540523>] __netif_receive_skb+0x4b3/0x520
[ 3673.944282]  [<ffffffff81532e5b>] ? __alloc_skb+0x4b/0x240
[ 3673.944340]  [<ffffffff81532e5b>] ? __alloc_skb+0x4b/0x240
[ 3673.944398]  [<ffffffff81541300>] netif_receive_skb+0x80/0x90
[ 3673.944457]  [<ffffffff81541709>] ? dev_gro_receive+0x1b9/0x2c0
[ 3673.944517]  [<ffffffff81541450>] napi_skb_finish+0x50/0x70
[ 3673.944576]  [<ffffffff81541a55>] napi_gro_receive+0xf5/0x140
[ 3673.944647]  [<ffffffffa01850c8>] bnx2x_rx_int+0x428/0xae0 [bnx2x]
[ 3673.944708]  [<ffffffff81326980>] ? map_single+0x60/0x60
[ 3673.944774]  [<ffffffffa0187409>] bnx2x_poll+0xa9/0x2e0 [bnx2x]
[ 3673.944833]  [<ffffffff81541ca4>] net_rx_action+0x134/0x290
[ 3673.944893]  [<ffffffff8106ea58>] __do_softirq+0xa8/0x210
[ 3673.944952]  [<ffffffff8101a779>] ? read_tsc+0x9/0x20
[ 3673.945010]  [<ffffffff8109c1c4>] ? tick_program_event+0x24/0x30
[ 3673.945069]  [<ffffffff8166422c>] call_softirq+0x1c/0x30
[ 3673.945129]  [<ffffffff81015305>] do_softirq+0x65/0xa0
[ 3673.945186]  [<ffffffff8106ee3e>] irq_exit+0x8e/0xb0
[ 3673.945244]  [<ffffffff81664bce>] smp_apic_timer_interrupt+0x6e/0x99
[ 3673.945304]  [<ffffffff81662a9e>] apic_timer_interrupt+0x6e/0x80
[ 3673.945362]  <EOI>
[ 3673.945448]  [<ffffffff81659c5e>] ? _raw_spin_lock_irqsave+0x2e/0x40
[ 3673.945510]  [<ffffffff810b2a4f>] ? acct_collect+0x17f/0x1c0
[ 3673.945568]  [<ffffffff810b2a49>] ? acct_collect+0x179/0x1c0
[ 3673.945627]  [<ffffffff8106bd0c>] do_exit+0x34c/0x420
[ 3673.945685]  [<ffffffff8165ab60>] oops_end+0xb0/0xf0
[ 3673.945744]  [<ffffffff8163fe4b>] no_context+0x150/0x15d
[ 3673.945803]  [<ffffffff81640021>] __bad_area_nosemaphore+0x1c9/0x1e8
[ 3673.945864]  [<ffffffff810570fb>] ? check_preempt_wakeup+0x15b/0x230
[ 3673.945924]  [<ffffffff8163f6cd>] ? pmd_offset+0x1f/0x25
[ 3673.945982]  [<ffffffff81640053>] bad_area_nosemaphore+0x13/0x15
[ 3673.946042]  [<ffffffff8165d7b6>] do_page_fault+0x426/0x520
[ 3673.946101]  [<ffffffff815749ed>] ? ip_local_deliver_finish+0xdd/0x280
[ 3673.946161]  [<ffffffff81574d58>] ? ip_local_deliver+0x88/0x90
[ 3673.946220]  [<ffffffff815c1590>] ? xfrm4_transport_finish+0xb0/0x110
[ 3673.946280]  [<ffffffffa02d9af0>] ? cryptd_free+0x60/0x60 [cryptd]
[ 3673.946340]  [<ffffffff8165a135>] page_fault+0x25/0x30
[ 3673.946397]  [<ffffffffa02d9af0>] ? cryptd_free+0x60/0x60 [cryptd]
[ 3673.946458]  [<ffffffffa02d9b46>] ? cryptd_queue_worker+0x56/0x80 [cryptd]
[ 3673.946519]  [<ffffffff81084f9a>] process_one_work+0x11a/0x480
[ 3673.946578]  [<ffffffff81085d44>] worker_thread+0x164/0x370
[ 3673.946637]  [<ffffffff81085be0>] ? manage_workers.isra.29+0x130/0x130
[ 3673.946697]  [<ffffffff8108a59c>] kthread+0x8c/0xa0
[ 3673.946754]  [<ffffffff81664134>] kernel_thread_helper+0x4/0x10
[ 3673.946813]  [<ffffffff8108a510>] ? flush_kthread_worker+0xa0/0xa0
[ 3673.946873]  [<ffffffff81664130>] ? gs_change+0x13/0x13
[ 3673.946929] Code: 55 48 89 e5 66 66 66 66 90 8b 57 18 3b 57 1c 73
1f b8 8d ff ff ff 83 c2 01 89 57 18 48 8b 57 08 48 89 77 08 48 89 3e
48 89 56 08 <48> 89 32 5d c3 f6 46 29 04 b8 f0 ff ff ff 74 f3 48 39 7f
10 75
[ 3673.949161] RIP  [<ffffffff812dd77b>] crypto_enqueue_request+0x2b/0x50
[ 3673.949254]  RSP <ffff880c0fc63990>

-----------------------------------------



Thanks,
Guru
