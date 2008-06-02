From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: BUG in scatterlist.h when loading tcrypt
Date: Mon, 2 Jun 2008 11:08:59 +0200
Message-ID: <20080602090529.GA28838@alice>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59403 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750740AbYFBJJD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Jun 2008 05:09:03 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

i guess this shouldnt happen, got this
when loading the tcrypt module

[   60.113277] testing ecb(seed) decryption across pages (chunking)
[   60.113309] 
[   60.113311] testing cts(cbc(aes)) encryption
[   60.120984] test 1 (128 bit key):
[   60.121153] ------------[ cut here ]------------
[   60.121312] kernel BUG at include/linux/scatterlist.h:65!
[   60.121446] invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[   60.121828] Modules linked in: tcrypt(+)
[   60.122019] 
[   60.122019] Pid: 4100, comm: modprobe Not tainted
(2.6.26-rc4-00103-g1beee8d #7)
[   60.122019] EIP: 0060:[<c043feb0>] EFLAGS: 00010216 CPU: 0
[   60.122019] EIP is at cts_cbc_encrypt+0x2f0/0x300
[   60.122019] EAX: c11808e0 EBX: 00000010 ECX: c1002000 EDX: c11813c0
[   60.122019] ESI: cbd4a5a0 EDI: cbf47bc0 EBP: cbf47c7c ESP: cbf47b3c
[   60.122019]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   60.122019] Process modprobe (pid: 4100, ti=cbf47000 task=cbf0ef20
task.ti=cbf47000)
[   60.122019] Stack: 00000011 00000000 00000046 00000001 00000046
c0a2c4c0 00000000 cbf47b60 
[   60.122019]        c01464ad cbf47b9c 00000046 00000046 00000000
cbf47b8c c014048e cbf47ba4 
[   60.122019]        00014f76 6f772049 20646c75 656b696c 65687420
00000020 00000000 00000000 
[   60.122019] Call Trace:
[   60.122019]  [<c01464ad>] ? put_lock_stats+0xd/0x30
[   60.122019]  [<c014048e>] ? getnstimeofday+0x3e/0x100
[   60.122019]  [<c013e26e>] ? hrtimer_interrupt+0x15e/0x190
[   60.122019]  [<c01884c1>] ? check_bytes_and_report+0x21/0xc0
[   60.122019]  [<c01881a3>] ? slab_pad_check+0x73/0x110
[   60.122019]  [<c01898e3>] ? __slab_free+0x63/0x2e0
[   60.122019]  [<c043ff9e>] ? crypto_cts_encrypt+0xde/0x100
[   60.122019]  [<c0433085>] ? setkey+0xc5/0xf0
[   60.122019]  [<c0433978>] ? async_encrypt+0x38/0x50
[   60.122019]  [<d0aab5a5>] ? test_cipher+0x215/0x840 [tcrypt]
[   60.122019]  [<c014048e>] ? getnstimeofday+0x3e/0x100
[   60.122019]  [<c0143649>] ? clockevents_program_event+0x99/0x110
[   60.122019]  [<c0144622>] ? tick_program_event+0x42/0x70
[   60.122019]  [<c013e26e>] ? hrtimer_interrupt+0x15e/0x190
[   60.122019]  [<c0103e57>] ? restore_nocheck+0x12/0x15
[   60.122019]  [<d0abea40>] ? tcrypt_mod_init+0x1a40/0x1bf4 [tcrypt]
[   60.122019]  [<c013ef6a>] ? blocking_notifier_call_chain+0x1a/0x20
[   60.122019]  [<c0150cfe>] ? sys_init_module+0xee/0x18e0
[   60.122019]  [<c0167e44>] ? unlock_page+0x24/0x30
[   60.122019]  [<c018ad10>] ? __kmalloc+0x0/0x100
[   60.122019]  [<c0103d6d>] ? sysenter_past_esp+0x6a/0xb1
[   60.122019]  =======================
[   60.122019] Code: 0b eb fe 0f 0b eb fe 8d 74 26 00 0f 0b eb fe 0f 0b
eb fe 0f 0b eb fe 8d 74 26 00 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 8d 74
26 00 <0f> 0b eb fe 8d b6 00 00 00 00 8d bf 00 00 00 00 55 89 e5 83 ec 
[   60.122019] EIP: [<c043feb0>] cts_cbc_encrypt+0x2f0/0x300 SS:ESP
0068:cbf47b3c
[   60.174099] ---[ end trace 4865479eed551e02 ]---

easily reproducible, but stack strace looks a bit different

[  353.926510] 
[  353.926512] testing ecb(seed) decryption across pages (chunking)
[  353.926540] 
[  353.926542] testing cts(cbc(aes)) encryption
[  353.930471] test 1 (128 bit key):
[  353.930603] ------------[ cut here ]------------
[  353.930758] kernel BUG at include/linux/scatterlist.h:65!
[  353.930890] invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[  353.931017] Modules linked in: tcrypt(+)
[  353.931017] 
[  353.931017] Pid: 4391, comm: modprobe Not tainted
(2.6.26-rc4-00103-g1beee8d #7)
[  353.931017] EIP: 0060:[<c043feb0>] EFLAGS: 00010216 CPU: 0
[  353.931017] EIP is at cts_cbc_encrypt+0x2f0/0x300
[  353.931017] EAX: c1181f00 EBX: 00000010 ECX: c1002000 EDX: c113a600
[  353.931017] ESI: cf3fb480 EDI: cbff8bc0 EBP: cbff8c7c ESP: cbff8b3c
[  353.931017]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  353.931017] Process modprobe (pid: 4391, ti=cbff8000 task=cbecafa0
task.ti=cbff8000)
[  353.931017] Stack: 00000011 00000000 37318b74 39333034 c08a4261
cfae50b8 0000005a 00000008 
[  353.931017]        c09b7160 cbff8b74 00000001 c11f7c80 cfae4c90
c11f7c80 cbff8bac c0189336 
[  353.931017]        00000001 6f772049 20646c75 656b696c 65687420
00000020 00000000 00000000 
[  353.931017] Call Trace:
[  353.931017]  [<c0189336>] ? __slab_alloc+0x86/0x5d0
[  353.931017]  [<c0755579>] ? _spin_unlock_irqrestore+0x39/0x70
[  353.931017]  [<c0127bcb>] ? release_console_sem+0x1bb/0x1e0
[  353.931017]  [<c01884c1>] ? check_bytes_and_report+0x21/0xc0
[  353.931017]  [<c01881a3>] ? slab_pad_check+0x73/0x110
[  353.931017]  [<c01898e3>] ? __slab_free+0x63/0x2e0
[  353.931017]  [<c043ff9e>] ? crypto_cts_encrypt+0xde/0x100
[  353.931017]  [<c0433085>] ? setkey+0xc5/0xf0
[  353.931017]  [<c0433978>] ? async_encrypt+0x38/0x50
[  353.931017]  [<d0aab5a5>] ? test_cipher+0x215/0x840 [tcrypt]
[  353.931017]  [<d0aaa55a>] ? test_hash+0x1fa/0x4f0 [tcrypt]
[  353.931017]  [<d0abea40>] ? tcrypt_mod_init+0x1a40/0x1bf4 [tcrypt]
[  353.931017]  [<c013ef6a>] ? blocking_notifier_call_chain+0x1a/0x20
[  353.931017]  [<c0150cfe>] ? sys_init_module+0xee/0x18e0
[  353.931017]  [<c0167e44>] ? unlock_page+0x24/0x30
[  353.931017]  [<c018ad10>] ? __kmalloc+0x0/0x100
[  353.931017]  [<c0103d6d>] ? sysenter_past_esp+0x6a/0xb1
[  353.931017]  =======================
[  353.931017] Code: 0b eb fe 0f 0b eb fe 8d 74 26 00 0f 0b eb fe 0f 0b
eb fe 0f 0b eb fe 8d 74 26 00 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 8d 74
26 00 <0f> 0b eb fe 8d b6 00 00 00 00 8d bf 00 00 00 00 55 89 e5 83 ec 
[  353.931017] EIP: [<c043feb0>] cts_cbc_encrypt+0x2f0/0x300 SS:ESP
0068:cbff8b3c
[  353.963393] ---[ end trace c587ad3c4d33078a ]---

Some corresponding .config variables

root@whiterabbit:~# grep _CTS /usr/src/linux/.config
CONFIG_CRYPTO_CTS=y
root@whiterabbit:~# grep _CBC /usr/src/linux/.config
CONFIG_CRYPTO_CBC=y
root@whiterabbit:~# grep _AES /usr/src/linux/.config
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y


Greetings, Eric
