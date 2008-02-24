From: Stefan Hellermann <stefan@the2masters.de>
Subject: Via Padlock Bug with LRW/XTS
Date: Sun, 24 Feb 2008 21:07:03 +0100
Message-ID: <47C1CE67.70804@the2masters.de>
References: <1203850864-16681-1-git-send-email-sebastian@breakpoint.cc> <47C15AEC.5040705@the2masters.de> <20080224125117.GA17076@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020307080402080708040504"
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp11.unit.tiscali.de ([213.205.33.47]:33810 "EHLO
	smtp11.unit.tiscali.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbYBXUHX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 24 Feb 2008 15:07:23 -0500
In-Reply-To: <20080224125117.GA17076@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020307080402080708040504
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

okay, I pulled current linus git and build it with attached config. Then I tried the
following:

# rmmod padlock-aes
# cryptsetup -c aes-xts-plain -s 256 luksFormat /dev/sda1
.... works
# modprobe padlock-aes
padlock: Using VIA PadLock ACE for AES algorithm.
# cryptsetup -c aes-xts-plain -s 256 luksFormat /dev/sda1

general protection fault: 0000 [#1]
Modules linked in: padlock_aes xts gf128mul cifs [last unloaded: padlock_aes]

Pid: 988, comm: kcryptd Not tainted (2.6.25-rc2-via #121)
EIP: 0060:[<f881d801>] EFLAGS: 00010206 CPU: 0
EIP is at aes_encrypt+0x31/0x60 [padlock_aes]
EAX: f7468af0 EBX: f7616860 ECX: 00000001 EDX: f7616830
ESI: f7468500 EDI: f762de88 EBP: f762de88 ESP: f762de64
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process kcryptd (pid: 988, ti=f762c000 task=f746eff0 task.ti=f762c000)
Stack: f75e3770 fffb6000 fffb7e00 00000200 f88280a3 f75e3770 f762debc f762df04
       00000010 00000000 00000000 00000000 00000000 f7616400 f881d7d0 f75e3770
       f75c0600 f7468500 c048ab44 f8828272 f881d7d0 f881d7d0 c2b4bf20 fffb7e00
Call Trace:
 [<f88280a3>] crypt+0x83/0x110 [xts]
 [<f881d7d0>] aes_encrypt+0x0/0x60 [padlock_aes]
 [<f8828272>] encrypt+0x42/0x50 [xts]
 [<f881d7d0>] aes_encrypt+0x0/0x60 [padlock_aes]
 [<f881d7d0>] aes_encrypt+0x0/0x60 [padlock_aes]
 [<c021b05b>] async_encrypt+0x3b/0x50
 [<c02fcce9>] crypt_convert+0x1b9/0x270
 [<c02fcf4d>] kcryptd_crypt+0x1ad/0x220
 [<c02fcda0>] kcryptd_crypt+0x0/0x220
 [<c012ae6b>] run_workqueue+0xab/0x140
 [<c012b5e0>] worker_thread+0x0/0x90
 [<c012b639>] worker_thread+0x59/0x90
 [<c012e100>] autoremove_wake_function+0x0/0x40
 [<c012b5e0>] worker_thread+0x0/0x90
 [<c012dd22>] kthread+0x42/0x70
 [<c012dce0>] kthread+0x0/0x70
 [<c010437b>] kernel_thread_helper+0x7/0x1c
 =======================
Code: 0c 89 d7 8d 50 3f 89 74 24 08 83 e2 f0 89 ce 89 5c 24 04 9c 9d 89 c8 35 f0 0f 00 00
a9 ff 0f 00 00 8d 5a 30 74 19 b9 01 00 00 00 <f3> 0f a7 c8 8b 5c 24 04 8b 74 24 08 8b 7c
24 0c 83 c4 10 c3 89
EIP: [<f881d801>] aes_encrypt+0x31/0x60 [padlock_aes] SS:ESP 0068:f762de64
---[ end trace 526de21aa54fb137 ]---
note: kcryptd[988] exited with preempt_count 2
------------[ cut here ]------------
kernel BUG at arch/x86/mm/highmem_32.c:87!
invalid opcode: 0000 [#2]
Modules linked in: padlock_aes xts gf128mul cifs [last unloaded: padlock_aes]

Pid: 990, comm: udevd Tainted: G      D  (2.6.25-rc2-via #121)
EIP: 0060:[<c01177bb>] EFLAGS: 00010286 CPU: 0
EIP is at kmap_atomic_prot+0xbb/0xd0
EAX: da5f9163 EBX: c2b4bae0 ECX: 00000163 EDX: 00000003
ESI: fffff000 EDI: 0000000c EBP: 00000003 ESP: f76a1dec
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process udevd (pid: 990, ti=f76a0000 task=f7608000 task.ti=f76a0000)
Stack: f76a1e58 f7530c80 00000080 f76a1e7c 00000080 c0140dfb 00000000 c2b4bae0
       f76a1e78 00000080 00000000 c2b4bae0 00000000 f799a3f8 c014305f 00001000
       c0173a73 f799a360 00000000 00000000 f75e83c4 f76a1ef4 f76a1eac f75e8380
Call Trace:
 [<c0140dfb>] file_read_actor+0xcb/0x100
 [<c014305f>] generic_file_aio_read+0x2df/0x590
 [<c0173a73>] dput+0x13/0xb0
 [<c0177d8b>] mntput_no_expire+0x1b/0x70
 [<c0163ce5>] do_sync_read+0xd5/0x120
 [<c012e100>] autoremove_wake_function+0x0/0x40
 [<c0162240>] __dentry_open+0x160/0x1b0
 [<c0214b8c>] security_file_permission+0xc/0x10
 [<c0163d8e>] rw_verify_area+0x5e/0xd0
 [<c0163c10>] do_sync_read+0x0/0x120
 [<c016459d>] vfs_read+0x9d/0x140
 [<c0152653>] insert_vm_struct+0x53/0xa0
 [<c01679ed>] kernel_read+0x3d/0x60
 [<c0167abf>] prepare_binprm+0xaf/0xe0
 [<c0168fe5>] do_execve+0x115/0x1b0
 [<c0101c3f>] sys_execve+0x2f/0x60
 [<c0103780>] sysenter_past_esp+0x6d/0xa5
 =======================
Code: 2c b0 54 c0 8b 14 24 29 f8 e8 02 d4 ff ff 90 e8 3c d5 ff ff 83 e8 01 74 17 8d 45 45
83 c4 04 c1 e0 0c 29 c6 89 f0 5b 5e 5f 5d c3 <0f> 0b eb fe 90 8d b6 00 00 00 00 8d b6 00
00 00 00 eb db 66 90
EIP: [<c01177bb>] kmap_atomic_prot+0xbb/0xd0 SS:ESP 0068:f76a1dec
---[ end trace 526de21aa54fb137 ]---
note: udevd[990] exited with preempt_count 1
BUG: scheduling while atomic: udevd/990/0x10000001
Pid: 990, comm: udevd Tainted: G      D  2.6.25-rc2-via #121
 [<c03abacb>] schedule+0x1eb/0x250
 [<c011a073>] __cond_resched+0x13/0x30
 [<c03abbf7>] _cond_resched+0x27/0x30
 [<c011e916>] put_files_struct+0x96/0xb0
 [<c011fa2e>] do_exit+0x11e/0x6b0
 [<c011d84b>] printk+0x1b/0x20
 [<c0104cd2>] die+0x152/0x160
 [<c0105070>] do_invalid_op+0x0/0x90
 [<c01050f1>] do_invalid_op+0x81/0x90
 [<c01177bb>] kmap_atomic_prot+0xbb/0xd0
 [<c016c8b5>] __link_path_walk+0x915/0xbf0
 [<c037b258>] rpcauth_lookup_credcache+0x68/0x1b0
 [<c037b066>] rpcauth_lookupcred+0x56/0xa0
 [<c037b258>] rpcauth_lookup_credcache+0x68/0x1b0
 [<c03acdf2>] error_code+0x6a/0x70
 [<c01177bb>] kmap_atomic_prot+0xbb/0xd0
 [<c0140dfb>] file_read_actor+0xcb/0x100
 [<c014305f>] generic_file_aio_read+0x2df/0x590
 [<c0173a73>] dput+0x13/0xb0
 [<c0177d8b>] mntput_no_expire+0x1b/0x70
 [<c0163ce5>] do_sync_read+0xd5/0x120
 [<c012e100>] autoremove_wake_function+0x0/0x40
 [<c0162240>] __dentry_open+0x160/0x1b0
 [<c0214b8c>] security_file_permission+0xc/0x10
 [<c0163d8e>] rw_verify_area+0x5e/0xd0
 [<c0163c10>] do_sync_read+0x0/0x120
 [<c016459d>] vfs_read+0x9d/0x140
 [<c0152653>] insert_vm_struct+0x53/0xa0
 [<c01679ed>] kernel_read+0x3d/0x60
 [<c0167abf>] prepare_binprm+0xaf/0xe0
 [<c0168fe5>] do_execve+0x115/0x1b0
 [<c0101c3f>] sys_execve+0x2f/0x60
 [<c0103780>] sysenter_past_esp+0x6d/0xa5
 =======================
------------[ cut here ]------------
kernel BUG at arch/x86/mm/highmem_32.c:87!
invalid opcode: 0000 [#3]
Modules linked in: padlock_aes xts gf128mul cifs [last unloaded: padlock_aes]

Pid: 172, comm: udevd Tainted: G      D  (2.6.25-rc2-via #121)
EIP: 0060:[<c01177bb>] EFLAGS: 00010286 CPU: 0
EIP is at kmap_atomic_prot+0xbb/0xd0
EAX: da5f9163 EBX: c2b4fb80 ECX: 00000163 EDX: 00000003
ESI: fffff000 EDI: 0000000c EBP: 00000003 ESP: f7433ee8
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process udevd (pid: 172, ti=f7432000 task=f746eaa0 task.ti=f7432000)
Stack: f7681200 00000000 f7fb51b4 00000000 c2b4fb80 c014dbac f7433f1c bf93c578
       f74782c0 f7fb5180 c2b4c900 00000000 000004f0 f7fb51b4 da7dc065 f747e4f0
       c014f2b8 f747e4f0 f7405bf8 f7fb51c0 da7dc065 da7dc065 c0130c62 00000001
Call Trace:
 [<c014dbac>] do_wp_page+0x9c/0x4d0
 [<c014f2b8>] handle_mm_fault+0x508/0x690
 [<c0130c62>] enqueue_hrtimer+0x72/0x100
 [<c0115d5c>] do_page_fault+0x11c/0x6f0
 [<c0119b23>] hrtick_set+0x83/0x100
 [<c0115c40>] do_page_fault+0x0/0x6f0
 [<c03acdf2>] error_code+0x6a/0x70
 =======================
Code: 2c b0 54 c0 8b 14 24 29 f8 e8 02 d4 ff ff 90 e8 3c d5 ff ff 83 e8 01 74 17 8d 45 45
83 c4 04 c1 e0 0c 29 c6 89 f0 5b 5e 5f 5d c3 <0f> 0b eb fe 90 8d b6 00 00 00 00 8d b6 00
00 00 00 eb db 66 90
EIP: [<c01177bb>] kmap_atomic_prot+0xbb/0xd0 SS:ESP 0068:f7433ee8
---[ end trace 526de21aa54fb137 ]---
note: udevd[172] exited with preempt_count 1
BUG: scheduling while atomic: udevd/172/0x10000001
Pid: 172, comm: udevd Tainted: G      D  2.6.25-rc2-via #121
 [<c03abacb>] schedule+0x1eb/0x250
 [<c011a073>] __cond_resched+0x13/0x30
 [<c03abbf7>] _cond_resched+0x27/0x30
 [<c011e916>] put_files_struct+0x96/0xb0
 [<c011fa2e>] do_exit+0x11e/0x6b0
 [<c011d84b>] printk+0x1b/0x20
 [<c0104cd2>] die+0x152/0x160
 [<c0105070>] do_invalid_op+0x0/0x90
 [<c01050f1>] do_invalid_op+0x81/0x90
 [<c01177bb>] kmap_atomic_prot+0xbb/0xd0
 [<c03acdf2>] error_code+0x6a/0x70
 [<c01177bb>] kmap_atomic_prot+0xbb/0xd0
 [<c014dbac>] do_wp_page+0x9c/0x4d0
 [<c014f2b8>] handle_mm_fault+0x508/0x690
 [<c0130c62>] enqueue_hrtimer+0x72/0x100
 [<c0115d5c>] do_page_fault+0x11c/0x6f0
 [<c0119b23>] hrtick_set+0x83/0x100
 [<c0115c40>] do_page_fault+0x0/0x6f0
 [<c03acdf2>] error_code+0x6a/0x70
 =======================
BUG: scheduling while atomic: udevd/990/0x10000001
Pid: 990, comm: udevd Tainted: G      D  2.6.25-rc2-via #121
 [<c03abacb>] schedule+0x1eb/0x250
 [<c011a073>] __cond_resched+0x13/0x30
 [<c03abbf7>] _cond_resched+0x27/0x30
 [<c011e916>] put_files_struct+0x96/0xb0
 [<c011fa2e>] do_exit+0x11e/0x6b0
 [<c011d84b>] printk+0x1b/0x20
 [<c0104cd2>] die+0x152/0x160
 [<c0105070>] do_invalid_op+0x0/0x90
 [<c01050f1>] do_invalid_op+0x81/0x90
 [<c01177bb>] kmap_atomic_prot+0xbb/0xd0
 [<c016c8b5>] __link_path_walk+0x915/0xbf0
 [<c037b258>] rpcauth_lookup_credcache+0x68/0x1b0
 [<c037b066>] rpcauth_lookupcred+0x56/0xa0
 [<c037b258>] rpcauth_lookup_credcache+0x68/0x1b0
 [<c03acdf2>] error_code+0x6a/0x70
 [<c01177bb>] kmap_atomic_prot+0xbb/0xd0
 [<c0140dfb>] file_read_actor+0xcb/0x100
 [<c014305f>] generic_file_aio_read+0x2df/0x590
 [<c0173a73>] dput+0x13/0xb0
 [<c0177d8b>] mntput_no_expire+0x1b/0x70
 [<c0163ce5>] do_sync_read+0xd5/0x120
 [<c012e100>] autoremove_wake_function+0x0/0x40
 [<c0162240>] __dentry_open+0x160/0x1b0
 [<c0214b8c>] security_file_permission+0xc/0x10
 [<c0163d8e>] rw_verify_area+0x5e/0xd0
 [<c0163c10>] do_sync_read+0x0/0x120
 [<c016459d>] vfs_read+0x9d/0x140
 [<c0152653>] insert_vm_struct+0x53/0xa0
 [<c01679ed>] kernel_read+0x3d/0x60
 [<c0167abf>] prepare_binprm+0xaf/0xe0
 [<c0168fe5>] do_execve+0x115/0x1b0
 [<c0101c3f>] sys_execve+0x2f/0x60
 [<c0103780>] sysenter_past_esp+0x6d/0xa5
 =======================
------------[ cut here ]------------
kernel BUG at arch/x86/mm/highmem_32.c:87!
invalid opcode: 0000 [#4]
Modules linked in: padlock_aes xts gf128mul cifs [last unloaded: padlock_aes]

Pid: 989, comm: udevd Tainted: G      D  (2.6.25-rc2-via #121)
EIP: 0060:[<c01177bb>] EFLAGS: 00010286 CPU: 0
EIP is at kmap_atomic_prot+0xbb/0xd0
EAX: da5f9163 EBX: c2b6b560 ECX: 00000163 EDX: 00000003
ESI: fffff000 EDI: 0000000c EBP: 00000003 ESP: f762fe84
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process udevd (pid: 989, ti=f762e000 task=f7608550 task.ti=f762e000)
Stack: f7817ad0 c2b6b560 c2b6b560 00000000 00000000 c01461e7 00000002 00000044
       c017429b 00000000 c04755e4 c04755c8 00000002 00000000 001280d2 c0475b3c
       00000002 00000001 00000000 00000000 c04755c8 f7608550 001280d2 00000000
Call Trace:
 [<c01461e7>] get_page_from_freelist+0x257/0x460
 [<c017429b>] d_lookup+0x1b/0x40
 [<c0146449>] __alloc_pages+0x59/0x350
 [<c012e7c7>] posix_cpu_timers_exit_group+0x57/0x70
 [<c014f04b>] handle_mm_fault+0x29b/0x690
 [<c0115d5c>] do_page_fault+0x11c/0x6f0
 [<c011f801>] sys_wait4+0x81/0xb0
 [<c0115c40>] do_page_fault+0x0/0x6f0
 [<c03acdf2>] error_code+0x6a/0x70
 =======================
Code: 2c b0 54 c0 8b 14 24 29 f8 e8 02 d4 ff ff 90 e8 3c d5 ff ff 83 e8 01 74 17 8d 45 45
83 c4 04 c1 e0 0c 29 c6 89 f0 5b 5e 5f 5d c3 <0f> 0b eb fe 90 8d b6 00 00 00 00 8d b6 00
00 00 00 eb db 66 90
EIP: [<c01177bb>] kmap_atomic_prot+0xbb/0xd0 SS:ESP 0068:f762fe84
---[ end trace 526de21aa54fb137 ]---
note: udevd[989] exited with preempt_count 1
BUG: scheduling while atomic: udevd/989/0x10000001
Pid: 989, comm: udevd Tainted: G      D  2.6.25-rc2-via #121
 [<c03abacb>] schedule+0x1eb/0x250
 [<c011a073>] __cond_resched+0x13/0x30
 [<c03abbf7>] _cond_resched+0x27/0x30
 [<c011e916>] put_files_struct+0x96/0xb0
 [<c011fa2e>] do_exit+0x11e/0x6b0
 [<c011d84b>] printk+0x1b/0x20
 [<c0104cd2>] die+0x152/0x160
 [<c0105070>] do_invalid_op+0x0/0x90
 [<c01050f1>] do_invalid_op+0x81/0x90
 [<c01177bb>] kmap_atomic_prot+0xbb/0xd0
 [<c023284e>] number+0x31e/0x330
 [<c014620c>] get_page_from_freelist+0x27c/0x460
 [<c03acdf2>] error_code+0x6a/0x70
 [<c01177bb>] kmap_atomic_prot+0xbb/0xd0
 [<c01461e7>] get_page_from_freelist+0x257/0x460
 [<c017429b>] d_lookup+0x1b/0x40
 [<c0146449>] __alloc_pages+0x59/0x350
 [<c012e7c7>] posix_cpu_timers_exit_group+0x57/0x70
 [<c014f04b>] handle_mm_fault+0x29b/0x690
 [<c0115d5c>] do_page_fault+0x11c/0x6f0
 [<c011f801>] sys_wait4+0x81/0xb0
 [<c0115c40>] do_page_fault+0x0/0x6f0
 [<c03acdf2>] error_code+0x6a/0x70
 =======================






here the cryptsetup tool seems to be frozen, after I tried to start "top" in another
console I got this:





------------[ cut here ]------------
kernel BUG at arch/x86/mm/highmem_32.c:87!
invalid opcode: 0000 [#5]
Modules linked in: padlock_aes xts gf128mul cifs [last unloaded: padlock_aes]

Pid: 949, comm: bash Tainted: G      D  (2.6.25-rc2-via #121)
EIP: 0060:[<c01177bb>] EFLAGS: 00010286 CPU: 0
EIP is at kmap_atomic_prot+0xbb/0xd0
EAX: da5f9163 EBX: c2b4fbc0 ECX: 00000163 EDX: 00000003
ESI: fffff000 EDI: 0000000c EBP: 00000003 ESP: f75ffe84
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process bash (pid: 949, ti=f75fe000 task=f74deaa0 task.ti=f75fe000)
Stack: f759f000 c2b4fbc0 c2b4fbc0 00000000 00000000 c01461e7 00000002 00000044
       f7480000 00000000 c04755e4 c04755c8 00000002 00000000 001280d2 c0475b3c
       00000002 00000001 00000000 00000000 c04755c8 f74deaa0 001280d2 00000000
Call Trace:
 [<c01461e7>] get_page_from_freelist+0x257/0x460
 [<c0146449>] __alloc_pages+0x59/0x350
 [<c014f04b>] handle_mm_fault+0x29b/0x690
 [<c0115d5c>] do_page_fault+0x11c/0x6f0
 [<c0125c5e>] sys_rt_sigaction+0x6e/0xa0
 [<c0115c40>] do_page_fault+0x0/0x6f0
 [<c03acdf2>] error_code+0x6a/0x70
 =======================
Code: 2c b0 54 c0 8b 14 24 29 f8 e8 02 d4 ff ff 90 e8 3c d5 ff ff 83 e8 01 74 17 8d 45 45
83 c4 04 c1 e0 0c 29 c6 89 f0 5b 5e 5f 5d c3 <0f> 0b eb fe 90 8d b6 00 00 00 00 8d b6 00
00 00 00 eb db 66 90
EIP: [<c01177bb>] kmap_atomic_prot+0xbb/0xd0 SS:ESP 0068:f75ffe84
---[ end trace 526de21aa54fb137 ]---
note: bash[949] exited with preempt_count 1
BUG: scheduling while atomic: bash/949/0x10000001
Pid: 949, comm: bash Tainted: G      D  2.6.25-rc2-via #121
 [<c03abacb>] schedule+0x1eb/0x250
 [<c011a073>] __cond_resched+0x13/0x30
 [<c03abbf7>] _cond_resched+0x27/0x30
 [<c011e916>] put_files_struct+0x96/0xb0
 [<c011fa2e>] do_exit+0x11e/0x6b0
 [<c011d84b>] printk+0x1b/0x20
 [<c0104cd2>] die+0x152/0x160
 [<c0105070>] do_invalid_op+0x0/0x90
 [<c01050f1>] do_invalid_op+0x81/0x90
 [<c01177bb>] kmap_atomic_prot+0xbb/0xd0
 [<c026dfa6>] tty_wait_until_sent+0x26/0xd0
 [<c02753f2>] scrup+0xd2/0xe0
 [<c0131d47>] atomic_notifier_call_chain+0x17/0x20
 [<c03acdf2>] error_code+0x6a/0x70
 [<c01177bb>] kmap_atomic_prot+0xbb/0xd0
 [<c01461e7>] get_page_from_freelist+0x257/0x460
 [<c0146449>] __alloc_pages+0x59/0x350
 [<c014f04b>] handle_mm_fault+0x29b/0x690
 [<c0115d5c>] do_page_fault+0x11c/0x6f0
 [<c0125c5e>] sys_rt_sigaction+0x6e/0xa0
 [<c0115c40>] do_page_fault+0x0/0x6f0
 [<c03acdf2>] error_code+0x6a/0x70
 =======================
------------[ cut here ]------------
kernel BUG at arch/x86/mm/highmem_32.c:87!
invalid opcode: 0000 [#6]
Modules linked in: padlock_aes xts gf128mul cifs [last unloaded: padlock_aes]

Pid: 901, comm: login Tainted: G      D  (2.6.25-rc2-via #121)
EIP: 0060:[<c01177bb>] EFLAGS: 00010286 CPU: 0
EIP is at kmap_atomic_prot+0xbb/0xd0
EAX: da5f9163 EBX: c2b595e0 ECX: 00000163 EDX: 00000003
ESI: fffff000 EDI: 0000000c EBP: 00000003 ESP: f7437d34
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process login (pid: 901, ti=f7436000 task=f75ae000 task.ti=f7436000)
Stack: c01413f0 f7437dc8 c2b595e0 00000180 00000680 c0140add fffffff4 00000180
       005c5680 00000000 00000980 c01420d4 00000180 00000000 00000180 00000000
       f7437ddc f7437dd8 00000000 f7437ee0 f75e8680 f78ad888 c03bece0 f78ad7f0
Call Trace:
 [<c01413f0>] __grab_cache_page+0x20/0xc0
 [<c0140add>] iov_iter_copy_from_user_atomic+0x2d/0x80
 [<c01420d4>] generic_file_buffered_write+0x134/0x620
 [<c0102789>] __switch_to+0x89/0x140
 [<c014283d>] __generic_file_aio_write_nolock+0x27d/0x4d0
 [<c0374152>] rpc_release_client+0x32/0x60
 [<c0142af2>] generic_file_aio_write+0x62/0xd0
 [<c01c739e>] nfs_update_inode+0xfe/0x740
 [<c01c64d5>] nfs_file_write+0xa5/0x170
 [<c01c7e21>] __nfs_revalidate_inode+0xc1/0x270
 [<c0163bc5>] do_sync_write+0xd5/0x120
 [<c012e100>] autoremove_wake_function+0x0/0x40
 [<c0173350>] fcntl_setlk+0x40/0x230
 [<c0214b8c>] security_file_permission+0xc/0x10
 [<c0163d8e>] rw_verify_area+0x5e/0xd0
 [<c0163af0>] do_sync_write+0x0/0x120
 [<c016445f>] vfs_write+0x9f/0x140
 [<c01637dc>] vfs_llseek+0x3c/0x50
 [<c0164a21>] sys_write+0x41/0x70
 [<c0103780>] sysenter_past_esp+0x6d/0xa5
 =======================
Code: 2c b0 54 c0 8b 14 24 29 f8 e8 02 d4 ff ff 90 e8 3c d5 ff ff 83 e8 01 74 17 8d 45 45
83 c4 04 c1 e0 0c 29 c6 89 f0 5b 5e 5f 5d c3 <0f> 0b eb fe 90 8d b6 00 00 00 00 8d b6 00
00 00 00 eb db 66 90
EIP: [<c01177bb>] kmap_atomic_prot+0xbb/0xd0 SS:ESP 0068:f7437d34
---[ end trace 526de21aa54fb137 ]---
note: login[901] exited with preempt_count 2
BUG: scheduling while atomic: login/901/0x10000002
Pid: 901, comm: login Tainted: G      D  2.6.25-rc2-via #121
 [<c03abacb>] schedule+0x1eb/0x250
 [<c011a073>] __cond_resched+0x13/0x30
 [<c03abbf7>] _cond_resched+0x27/0x30
 [<c011e916>] put_files_struct+0x96/0xb0
 [<c011fa2e>] do_exit+0x11e/0x6b0
 [<c011d84b>] printk+0x1b/0x20
 [<c0104cd2>] die+0x152/0x160
 [<c0105070>] do_invalid_op+0x0/0x90
 [<c01050f1>] do_invalid_op+0x81/0x90
 [<c01177bb>] kmap_atomic_prot+0xbb/0xd0
 [<c012e100>] autoremove_wake_function+0x0/0x40
 [<c037abcc>] rpcauth_unwrap_resp+0x6c/0xa0
 [<c0373922>] call_decode+0x192/0x7b0
 [<c03acdf2>] error_code+0x6a/0x70
 [<c01177bb>] kmap_atomic_prot+0xbb/0xd0
 [<c01413f0>] __grab_cache_page+0x20/0xc0
 [<c0140add>] iov_iter_copy_from_user_atomic+0x2d/0x80
 [<c01420d4>] generic_file_buffered_write+0x134/0x620
 [<c0102789>] __switch_to+0x89/0x140
 [<c014283d>] __generic_file_aio_write_nolock+0x27d/0x4d0
 [<c0374152>] rpc_release_client+0x32/0x60
 [<c0142af2>] generic_file_aio_write+0x62/0xd0
 [<c01c739e>] nfs_update_inode+0xfe/0x740
 [<c01c64d5>] nfs_file_write+0xa5/0x170
 [<c01c7e21>] __nfs_revalidate_inode+0xc1/0x270
 [<c0163bc5>] do_sync_write+0xd5/0x120
 [<c012e100>] autoremove_wake_function+0x0/0x40
 [<c0173350>] fcntl_setlk+0x40/0x230
 [<c0214b8c>] security_file_permission+0xc/0x10
 [<c0163d8e>] rw_verify_area+0x5e/0xd0
 [<c0163af0>] do_sync_write+0x0/0x120
 [<c016445f>] vfs_write+0x9f/0x140
 [<c01637dc>] vfs_llseek+0x3c/0x50
 [<c0164a21>] sys_write+0x41/0x70
 [<c0103780>] sysenter_past_esp+0x6d/0xa5
 =======================
BUG: scheduling while atomic: login/901/0x00000002
Pid: 901, comm: login Tainted: G      D  2.6.25-rc2-via #121
 [<c03abacb>] schedule+0x1eb/0x250
 [<c0379d44>] rpc_wait_bit_killable+0x14/0x30
 [<c03abe62>] __wait_on_bit+0x42/0x70
 [<c0379d30>] rpc_wait_bit_killable+0x0/0x30
 [<c0379d30>] rpc_wait_bit_killable+0x0/0x30
 [<c03abeea>] out_of_line_wait_on_bit+0x5a/0x70
 [<c012e140>] wake_bit_function+0x0/0x60
 [<c037a162>] __rpc_execute+0xa2/0x240
 [<c014887a>] pagevec_lookup_tag+0x2a/0x40
 [<c0373fca>] rpc_run_task+0x2a/0x60
 [<c037409c>] rpc_call_sync+0x3c/0x60
 [<c01d1fa4>] nfs3_rpc_wrapper+0x34/0x60
 [<c01d2318>] nfs3_proc_getattr+0x48/0x80
 [<c01c7e98>] __nfs_revalidate_inode+0x138/0x270
 [<c01d0000>] nfs_writeback_done+0x190/0x1f0
 [<c01d0790>] __nfs_write_mapping+0x30/0x60
 [<c01d0814>] nfs_write_mapping+0x54/0x70
 [<c01c674a>] nfs_file_flush+0x7a/0xa0
 [<c0161fbe>] filp_close+0x2e/0x80
 [<c011e911>] put_files_struct+0x91/0xb0
 [<c011fa2e>] do_exit+0x11e/0x6b0
 [<c011d84b>] printk+0x1b/0x20
 [<c0104cd2>] die+0x152/0x160
 [<c0105070>] do_invalid_op+0x0/0x90
 [<c01050f1>] do_invalid_op+0x81/0x90
 [<c01177bb>] kmap_atomic_prot+0xbb/0xd0
 [<c012e100>] autoremove_wake_function+0x0/0x40
 [<c037abcc>] rpcauth_unwrap_resp+0x6c/0xa0
 [<c0373922>] call_decode+0x192/0x7b0
 [<c03acdf2>] error_code+0x6a/0x70
 [<c01177bb>] kmap_atomic_prot+0xbb/0xd0
 [<c01413f0>] __grab_cache_page+0x20/0xc0
 [<c0140add>] iov_iter_copy_from_user_atomic+0x2d/0x80
 [<c01420d4>] generic_file_buffered_write+0x134/0x620
 [<c0102789>] __switch_to+0x89/0x140
 [<c014283d>] __generic_file_aio_write_nolock+0x27d/0x4d0
 [<c0374152>] rpc_release_client+0x32/0x60
 [<c0142af2>] generic_file_aio_write+0x62/0xd0
 [<c01c739e>] nfs_update_inode+0xfe/0x740
 [<c01c64d5>] nfs_file_write+0xa5/0x170
 [<c01c7e21>] __nfs_revalidate_inode+0xc1/0x270
 [<c0163bc5>] do_sync_write+0xd5/0x120
 [<c012e100>] autoremove_wake_function+0x0/0x40
 [<c0173350>] fcntl_setlk+0x40/0x230
 [<c0214b8c>] security_file_permission+0xc/0x10
 [<c0163d8e>] rw_verify_area+0x5e/0xd0
 [<c0163af0>] do_sync_write+0x0/0x120
 [<c016445f>] vfs_write+0x9f/0x140
 [<c01637dc>] vfs_llseek+0x3c/0x50
 [<c0164a21>] sys_write+0x41/0x70
 [<c0103780>] sysenter_past_esp+0x6d/0xa5
 =======================
------------[ cut here ]------------
kernel BUG at arch/x86/mm/highmem_32.c:87!
invalid opcode: 0000 [#7]
Modules linked in: padlock_aes xts gf128mul cifs [last unloaded: padlock_aes]

Pid: 1, comm: init Tainted: G      D  (2.6.25-rc2-via #121)
EIP: 0060:[<c01177bb>] EFLAGS: 00010286 CPU: 0
EIP is at kmap_atomic_prot+0xbb/0xd0
EAX: da5f9163 EBX: c2b79960 ECX: 00000163 EDX: 00000003
ESI: fffff000 EDI: 0000000c EBP: 00000003 ESP: f7c69f00
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process init (pid: 1, ti=f7c68000 task=f7c5e000 task.ti=f7c68000)
Stack: c047169c b7f801c0 00000180 f7c69f58 00000180 c0140dfb 00000000 c2b79960
       00000000 00000180 00000000 c2b79960 00000d80 00000000 c015cd0c 00000d80
       00000000 f75e8800 00000000 00000000 f7406b14 0000a7c0 00000000 00000180
Call Trace:
 [<c0140dfb>] file_read_actor+0xcb/0x100
 [<c015cd0c>] shmem_file_read+0x10c/0x2a0
 [<c015cc00>] shmem_file_read+0x0/0x2a0
 [<c016459d>] vfs_read+0x9d/0x140
 [<c01649b1>] sys_read+0x41/0x70
 [<c0103780>] sysenter_past_esp+0x6d/0xa5
 =======================
Code: 2c b0 54 c0 8b 14 24 29 f8 e8 02 d4 ff ff 90 e8 3c d5 ff ff 83 e8 01 74 17 8d 45 45
83 c4 04 c1 e0 0c 29 c6 89 f0 5b 5e 5f 5d c3 <0f> 0b eb fe 90 8d b6 00 00 00 00 8d b6 00
00 00 00 eb db 66 90
EIP: [<c01177bb>] kmap_atomic_prot+0xbb/0xd0 SS:ESP 0068:f7c69f00
---[ end trace 526de21aa54fb137 ]---
note: init[1] exited with preempt_count 1
Kernel panic - not syncing: Attempted to kill init!


Sebastian Siewior schrieb:
> * Stefan Hellermann | 2008-02-24 12:54:20 [+0100]:
> 
>> Hello,
> Hello,
> 
>> I'm got my Via Epia SN Board a few days ago and could test everything related to the
>> padlock engine, I'm especially interested in the aes-{lrw,xts} combo, this doesn't work at
> Cool,
> 
>> the moment (last tested with 2.6.25-rc1).
> Could you be a little more specific on "it doesn't work"?
> Do you pass the tcrypt test at least?
> Does it* work without the HW acceleration?
> 
>> Cheers,
>> Stefan
> 
> *: it means a dm-crypt encrypted partition I guess.
> 
> Sebastian
> -
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--------------020307080402080708040504
Content-Type: text/plain;
 name="config-2.6.25-rc2-via"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="config-2.6.25-rc2-via"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.25-rc2
# Sun Feb 24 20:01:24 2008
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION="-via"
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=16
# CONFIG_CGROUPS is not set
CONFIG_GROUP_SCHED=y
# CONFIG_FAIR_GROUP_SCHED is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE="/usr/src/initramfs_neu/initramfs"
CONFIG_INITRAMFS_ROOT_UID=0
CONFIG_INITRAMFS_ROOT_GID=0
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_KPROBES=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set
# CONFIG_BLK_DEV_BSG is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_CLASSIC_RCU=y
# CONFIG_PREEMPT_RCU is not set

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP is not set
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_VSMP is not set
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
# CONFIG_XEN is not set
# CONFIG_VMI is not set
CONFIG_LGUEST_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
CONFIG_MVIAC7=y
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_IOMMU_HELPER is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
# CONFIG_RCU_TRACE is not set
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_NONFATAL is not set
# CONFIG_X86_MCE_P4THERMAL is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NR_QUICK=1
CONFIG_VIRT_TO_BUS=y
# CONFIG_HIGHPTE is not set
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
# CONFIG_COMPAT_VDSO is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_THERMAL is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_CUSTOM_DSDT_INITRD is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
CONFIG_X86_E_POWERSAVER=y

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_LEGACY is not set
# CONFIG_HT_IRQ is not set
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
# CONFIG_TCP_CONG_CUBIC is not set
CONFIG_TCP_CONG_WESTWOOD=y
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
CONFIG_DEFAULT_WESTWOOD=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="westwood"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETLABEL is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_BRIDGE=y
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y

#
# Wireless
#
CONFIG_CFG80211=y
CONFIG_NL80211=y
CONFIG_WIRELESS_EXT=y
CONFIG_MAC80211=y

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_DEFAULT_PID=y
# CONFIG_MAC80211_RC_DEFAULT_SIMPLE is not set
# CONFIG_MAC80211_RC_DEFAULT_NONE is not set

#
# Selecting 'y' for an algorithm will
#

#
# build the algorithm into mac80211.
#
CONFIG_MAC80211_RC_DEFAULT="pid"
CONFIG_MAC80211_RC_PID=y
# CONFIG_MAC80211_RC_SIMPLE is not set
# CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT is not set
# CONFIG_MAC80211_DEBUG is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG=y

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_XD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SVW is not set
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
CONFIG_SATA_VIA=y
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_LEGACY is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_QDI is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
CONFIG_PATA_VIA=y
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_WINBOND_VLB is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_LINEAR is not set
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_MIRROR=y
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NETDEVICES_MULTIQUEUE=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=y
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_LANCE is not set
# CONFIG_NET_VENDOR_SMC is not set
# CONFIG_NET_VENDOR_RACAL is not set
# CONFIG_NET_TULIP is not set
# CONFIG_AT1700 is not set
# CONFIG_DEPCA is not set
# CONFIG_HP100 is not set
# CONFIG_NET_ISA is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_AC3200 is not set
# CONFIG_APRICOT is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_CS89x0 is not set
# CONFIG_EEPRO100 is not set
# CONFIG_E100 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
CONFIG_VIA_RHINE=y
CONFIG_VIA_RHINE_MMIO=y
CONFIG_VIA_RHINE_NAPI=y
# CONFIG_SC92031 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_E1000E_ENABLED is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_SK98LIN is not set
CONFIG_VIA_VELOCITY=y
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_P54_COMMON is not set
CONFIG_ATH5K=m
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_HOSTAP is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set
# CONFIG_RT2X00 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=y
# CONFIG_PPP_MULTILINK is not set
# CONFIG_PPP_FILTER is not set
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_MPPE is not set
CONFIG_PPPOE=y
# CONFIG_PPPOL2TP is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=y
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_UINPUT is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=2
CONFIG_SERIAL_8250_RUNTIME_UARTS=2
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_INTEL is not set
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
CONFIG_HW_RANDOM_VIA=y
# CONFIG_NVRAM is not set
CONFIG_RTC=y
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_CHARDEV is not set

#
# I2C Algorithms
#
# CONFIG_I2C_ALGOBIT is not set
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_ELEKTOR is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_I810 is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y
# CONFIG_I2C_VOODOO3 is not set
# CONFIG_I2C_PCA_ISA is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
CONFIG_SENSORS_EEPROM=y
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_TPS65010 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=y
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_DAB is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_VIDEO_SELECT=y
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y

#
# Sound
#
# CONFIG_SOUND is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_PERSIST is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_DPCM is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MON is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
# CONFIG_LEDS_CLASS is not set

#
# LED drivers
#

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=y
# CONFIG_NFS_DIRECTIO is not set
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
CONFIG_NFSD_V4=y
CONFIG_NFSD_TCP=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_BIND34=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_EXPERIMENTAL=y
# CONFIG_CIFS_UPCALL is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_LATENCYTOP is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_SAMPLES is not set
CONFIG_EARLY_PRINTK=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_CAPABILITIES=y
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=y
# CONFIG_CRYPTO_SEQIV is not set
CONFIG_CRYPTO_MANAGER=y
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_XTS=m
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set
# CONFIG_CRYPTO_SERPENT is not set
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_TEST is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_LGUEST=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=y
# CONFIG_CRC16 is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--------------020307080402080708040504--
