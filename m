Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA6E14B088
	for <linux-crypto@vger.kernel.org>; Mon, 30 Dec 2024 19:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735586551; cv=none; b=qiJmAdLtyzxhY8T5wwPSys3o+kDbxtdqWRxMtxevIY4csPqD6p06DCg//Qs8S1lW8m4VILAzOrmISkvqA1v9aNoGFcNC0UdV6qMYGI1rOh0XF4wwDDofqFwOb/sKsc0FnlwyhvArlmm09xKkPd9nSSPAE6EKAd+n8tRkeyApacw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735586551; c=relaxed/simple;
	bh=2sLMSxs07qoy5gkEOddmV8PJEfgSDW2cGiwUMFxnI9I=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=JeHIQJSJICOBsbbSXE+16vXAVihNOJQ2cApL6MYUBfRzRUGwYObuwTFmeMObqTXk4u/9bba6HPmbPpUNN7eUx/In/F+sZWIMjJidOo6XTwmn+gFXdLNsspsKGoGNyQjBH2RBWLyKM4W7oMuW3JzRqO54QtEo3idovWhok1pOskY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3a9d3e48637so93181795ab.1
        for <linux-crypto@vger.kernel.org>; Mon, 30 Dec 2024 11:22:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735586548; x=1736191348;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XZbk8DAAKvdGDfTKY/w3xdcQsaMwtxLDdwTUaKLkUEU=;
        b=ugRyIV6EBQ4+vH9rkm8jBRgMsMvIl+x+L/w2dOqJeCNuCJKkEdc/YXNt58Eek+W/8c
         2hTQIncNqkPUYQt1iMcZCIJ8SoScUNmLrONSVJeWZx5uJfAYHaiwLMxsnKhkSkYfxoCq
         qvDxf7YMEOiPzdgwtLqE8BFDI5NvHFVtKE28R6YZlKoR5h/n+PjVkOOP0zqQN75B3cu3
         YXJwRxPNTCFHzkZl4vfo5whA1Q8UFWXR9RjlvzALL0N4nBv6EqcUn3Bhwj7wqY0XO/S7
         MJa32TTBJJPe1X3UEc4UU7Xj6WP70p6PCQEaZK75uQVr3U0/B5kqp8D+Jk1QxT5c5eIf
         oGIA==
X-Forwarded-Encrypted: i=1; AJvYcCWo4emltNSkIJQ+wPFnjcT31QTMPkwYWgwLc1TE2UHs9FJoKQxvU4XZn+KVjJaqofE/wCRH67f/qzqjwUE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwPjf5bu71FGen+VqkMrfRRhBWyTXeKoPCI5QywYBlejQtPnEP
	mw+x6w2GS124zJ01a5TNsj9X3rptD8vvLRNjesvLkTTXJuld2H+wOrbd5y6HU/fiwWCTdLh99S/
	v48+Bs9ey82wrQRhY/XPzEuVd4ltUuhlD9J4BhMQc2L/Er3pf/6suArw=
X-Google-Smtp-Source: AGHT+IGIlbq6Ff2T6yYwCq+KHsjNUjnU0fHb+Oe6kaEC5noBFmwlNZepHSto0crBLqwJmWX+YEFYE1JF+8EfyVaBXnrmIo0RIN9k
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d0d:b0:3a7:dec1:de40 with SMTP id
 e9e14a558f8ab-3c2d1b9ba3emr272435595ab.5.1735586548511; Mon, 30 Dec 2024
 11:22:28 -0800 (PST)
Date: Mon, 30 Dec 2024 11:22:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6772f2f4.050a0220.2f3838.04cb.GAE@google.com>
Subject: [syzbot] [crypto?] BUG: sleeping function called from invalid context
 in crypto_put_default_null_skcipher
From: syzbot <syzbot+b3e02953598f447d4d2a@syzkaller.appspotmail.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a024e377efed net: llc: reset skb->transport_header
git tree:       net
console+strace: https://syzkaller.appspot.com/x/log.txt?x=15c7f0b0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6a2b862bf4a5409f
dashboard link: https://syzkaller.appspot.com/bug?extid=b3e02953598f447d4d2a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14bce818580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12bce818580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f2ea524d69fe/disk-a024e377.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b39d227b097d/vmlinux-a024e377.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8ee66636253f/bzImage-a024e377.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b3e02953598f447d4d2a@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at kernel/locking/mutex.c:562
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 0, name: swapper/0
preempt_count: 101, expected: 0
RCU nest depth: 0, expected: 0
1 lock held by swapper/0/0:
 #0: ffffffff8e937ba0 (rcu_callback){....}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8e937ba0 (rcu_callback){....}-{0:0}, at: rcu_do_batch kernel/rcu/tree.c:2561 [inline]
 #0: ffffffff8e937ba0 (rcu_callback){....}-{0:0}, at: rcu_core+0xa37/0x17a0 kernel/rcu/tree.c:2823
Preemption disabled at:
[<ffffffff8bc9a85d>] schedule_preempt_disabled+0x1d/0x30 kernel/sched/core.c:6906
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.13.0-rc3-syzkaller-00174-ga024e377efed #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 __might_resched+0x5d4/0x780 kernel/sched/core.c:8758
 __mutex_lock_common kernel/locking/mutex.c:562 [inline]
 __mutex_lock+0x131/0xee0 kernel/locking/mutex.c:735
 crypto_put_default_null_skcipher+0x18/0x70 crypto/crypto_null.c:179
 aead_release+0x3d/0x50 crypto/algif_aead.c:489
 alg_do_release crypto/af_alg.c:118 [inline]
 alg_sock_destruct+0x86/0xc0 crypto/af_alg.c:502
 __sk_destruct+0x58/0x5f0 net/core/sock.c:2260
 rcu_do_batch kernel/rcu/tree.c:2567 [inline]
 rcu_core+0xaaa/0x17a0 kernel/rcu/tree.c:2823
 handle_softirqs+0x2d4/0x9b0 kernel/softirq.c:561
 __do_softirq kernel/softirq.c:595 [inline]
 invoke_softirq kernel/softirq.c:435 [inline]
 __irq_exit_rcu+0xf7/0x220 kernel/softirq.c:662
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:678
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1049 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1049
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:native_irq_disable arch/x86/include/asm/irqflags.h:37 [inline]
RIP: 0010:arch_local_irq_disable arch/x86/include/asm/irqflags.h:92 [inline]
RIP: 0010:acpi_safe_halt+0x21/0x30 drivers/acpi/processor_idle.c:112
Code: 90 90 90 90 90 90 90 90 90 65 48 8b 04 25 00 d6 03 00 48 f7 00 08 00 00 00 75 10 66 90 0f 00 2d 15 c1 a0 00 f3 0f 1e fa fb f4 <fa> c3 cc cc cc cc 66 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90
RSP: 0018:ffffffff8e607ca8 EFLAGS: 00000246
RAX: ffffffff8e6965c0 RBX: ffff888140ee4064 RCX: 000000000001ace9
RDX: 0000000000000001 RSI: ffff888140ee4000 RDI: ffff888140ee4064
RBP: 000000000003a9f8 R08: ffff8880b8637cdb R09: 1ffff110170c6f9b
R10: dffffc0000000000 R11: ffffffff8bc8bc80 R12: ffff88814628d000
R13: 0000000000000001 R14: 0000000000000001 R15: ffffffff8f1217a0
 acpi_idle_enter+0xe4/0x140 drivers/acpi/processor_idle.c:699
 cpuidle_enter_state+0x109/0x470 drivers/cpuidle/cpuidle.c:268
 cpuidle_enter+0x5d/0xa0 drivers/cpuidle/cpuidle.c:389
 call_cpuidle kernel/sched/idle.c:155 [inline]
 cpuidle_idle_call kernel/sched/idle.c:230 [inline]
 do_idle+0x372/0x5c0 kernel/sched/idle.c:325
 cpu_startup_entry+0x42/0x60 kernel/sched/idle.c:423
 rest_init+0x2dc/0x300 init/main.c:747
 start_kernel+0x47f/0x500 init/main.c:1102
 x86_64_start_reservations+0x2a/0x30 arch/x86/kernel/head64.c:507
 x86_64_start_kernel+0x9f/0xa0 arch/x86/kernel/head64.c:488
 common_startup_64+0x13e/0x147
 </TASK>

=============================
[ BUG: Invalid wait context ]
6.13.0-rc3-syzkaller-00174-ga024e377efed #0 Tainted: G        W         
-----------------------------
swapper/0/0 is trying to lock:
ffffffff8f035d88 (crypto_default_null_skcipher_lock){+.+.}-{4:4}, at: crypto_put_default_null_skcipher+0x18/0x70 crypto/crypto_null.c:179
other info that might help us debug this:
context-{3:3}
1 lock held by swapper/0/0:
 #0: ffffffff8e937ba0 (rcu_callback){....}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8e937ba0 (rcu_callback){....}-{0:0}, at: rcu_do_batch kernel/rcu/tree.c:2561 [inline]
 #0: ffffffff8e937ba0 (rcu_callback){....}-{0:0}, at: rcu_core+0xa37/0x17a0 kernel/rcu/tree.c:2823
stack backtrace:
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Tainted: G        W          6.13.0-rc3-syzkaller-00174-ga024e377efed #0
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_lock_invalid_wait_context kernel/locking/lockdep.c:4826 [inline]
 check_wait_context kernel/locking/lockdep.c:4898 [inline]
 __lock_acquire+0x15a8/0x2100 kernel/locking/lockdep.c:5176
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
 __mutex_lock_common kernel/locking/mutex.c:585 [inline]
 __mutex_lock+0x1ac/0xee0 kernel/locking/mutex.c:735
 crypto_put_default_null_skcipher+0x18/0x70 crypto/crypto_null.c:179
 aead_release+0x3d/0x50 crypto/algif_aead.c:489
 alg_do_release crypto/af_alg.c:118 [inline]
 alg_sock_destruct+0x86/0xc0 crypto/af_alg.c:502
 __sk_destruct+0x58/0x5f0 net/core/sock.c:2260
 rcu_do_batch kernel/rcu/tree.c:2567 [inline]
 rcu_core+0xaaa/0x17a0 kernel/rcu/tree.c:2823
 handle_softirqs+0x2d4/0x9b0 kernel/softirq.c:561
 __do_softirq kernel/softirq.c:595 [inline]
 invoke_softirq kernel/softirq.c:435 [inline]
 __irq_exit_rcu+0xf7/0x220 kernel/softirq.c:662
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:678
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1049 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1049
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:native_irq_disable arch/x86/include/asm/irqflags.h:37 [inline]
RIP: 0010:arch_local_irq_disable arch/x86/include/asm/irqflags.h:92 [inline]
RIP: 0010:acpi_safe_halt+0x21/0x30 drivers/acpi/processor_idle.c:112
Code: 90 90 90 90 90 90 90 90 90 65 48 8b 04 25 00 d6 03 00 48 f7 00 08 00 00 00 75 10 66 90 0f 00 2d 15 c1 a0 00 f3 0f 1e fa fb f4 <fa> c3 cc cc cc cc 66 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90
RSP: 0018:ffffffff8e607ca8 EFLAGS: 00000246
RAX: ffffffff8e6965c0 RBX: ffff888140ee4064 RCX: 000000000001ace9
RDX: 0000000000000001 RSI: ffff888140ee4000 RDI: ffff888140ee4064
RBP: 000000000003a9f8 R08: ffff8880b8637cdb R09: 1ffff110170c6f9b
R10: dffffc0000000000 R11: ffffffff8bc8bc80 R12: ffff88814628d000
R13: 0000000000000001 R14: 0000000000000001 R15: ffffffff8f1217a0
 acpi_idle_enter+0xe4/0x140 drivers/acpi/processor_idle.c:699
 cpuidle_enter_state+0x109/0x470 drivers/cpuidle/cpuidle.c:268
 cpuidle_enter+0x5d/0xa0 drivers/cpuidle/cpuidle.c:389
 call_cpuidle kernel/sched/idle.c:155 [inline]
 cpuidle_idle_call kernel/sched/idle.c:230 [inline]
 do_idle+0x372/0x5c0 kernel/sched/idle.c:325
 cpu_startup_entry+0x42/0x60 kernel/sched/idle.c:423
 rest_init+0x2dc/0x300 init/main.c:747
 start_kernel+0x47f/0x500 init/main.c:1102
 x86_64_start_reservations+0x2a/0x30 arch/x86/kernel/head64.c:507
 x86_64_start_kernel+0x9f/0xa0 arch/x86/kernel/head64.c:488
 common_startup_64+0x13e/0x147
 </TASK>
----------------
Code disassembly (best guess):
   0:	90                   	nop
   1:	90                   	nop
   2:	90                   	nop
   3:	90                   	nop
   4:	90                   	nop
   5:	90                   	nop
   6:	90                   	nop
   7:	90                   	nop
   8:	90                   	nop
   9:	65 48 8b 04 25 00 d6 	mov    %gs:0x3d600,%rax
  10:	03 00
  12:	48 f7 00 08 00 00 00 	testq  $0x8,(%rax)
  19:	75 10                	jne    0x2b
  1b:	66 90                	xchg   %ax,%ax
  1d:	0f 00 2d 15 c1 a0 00 	verw   0xa0c115(%rip)        # 0xa0c139
  24:	f3 0f 1e fa          	endbr64
  28:	fb                   	sti
  29:	f4                   	hlt
* 2a:	fa                   	cli <-- trapping instruction
  2b:	c3                   	ret
  2c:	cc                   	int3
  2d:	cc                   	int3
  2e:	cc                   	int3
  2f:	cc                   	int3
  30:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  37:	00 00
  39:	90                   	nop
  3a:	90                   	nop
  3b:	90                   	nop
  3c:	90                   	nop
  3d:	90                   	nop
  3e:	90                   	nop
  3f:	90                   	nop


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
