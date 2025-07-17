Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AA11E1DE9
	for <linux-crypto@vger.kernel.org>; Thu, 17 Jul 2025 10:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752747341; cv=none; b=ULnQ4t6pHzROAaUyguLHOvZRnsXPxD09wbCGvS6OTMACobCIC86/R2me85TdiG86jrnA/sFNCUka9Hf1oJxeURSf9SLmPzPOeoNWHGgeu81l99/FDrA7pK9p/nSTZRoJmTAAW8NRJYovdwKFikWIP75SrfoaAxhm9skYSA4GZ2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752747341; c=relaxed/simple;
	bh=Kc2TiflgLD8XqwFilb4h7Wvy43ym10UjTuvpKR/YsOY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=dSwxHyAK4sYMYI+pVezOMdxdojtKDTMfiCOtG63Vih2lQcvES5AiTRHw9qjQusc6F2vC8IgJAoj1QhvaOcgn5q8ZfK28gthtwdGg3mUhM60fTiqSn+zaIaRZejDc8AUuR4sOn7kS2pg011OWqXV3sD/mWwKp1MVNjO3CkPkZs40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3ddbfe1fc8fso16556645ab.2
        for <linux-crypto@vger.kernel.org>; Thu, 17 Jul 2025 03:15:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752747338; x=1753352138;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jwf4VoVCorBa5FpP7xdG1geXYjAyuoZokukQ+KjAL6Y=;
        b=tzyGg5z6zsj1Ajx8jNWl92HFMgIPttFCt6PlN7QCWk5drhnef4qNrOFB7/Q1NbUZy4
         nEgrd+qWrmWaPXDymmEEPaB+TUPCndHMUXG9x65X1UqOTBdOXSUhZH2rJLWXQvPT1A1d
         LcKyIkE/ACMMsb1OvQT9Jb8DGLLDuiKoCwFxNRTfRHT7sFSgV2+aEkcKCFRGNhhIXSOa
         2BoN2eXIjv5DuX6un/CpgvCSSKA+06Lwb2N673Hy15fdr9lUuRtdTX3AtZvpxR9LsoyV
         l0qZgfEuyfnrwkE9mL9hT2L5eXPMisNqCCi6HyJTuCc6tMLeDK6LGQhd5jmH9rZhKXqK
         UXzA==
X-Forwarded-Encrypted: i=1; AJvYcCV88d7mmTEClyUG3qDt226rMulkjmTeUN620PkEezu5zTv9DuIjcD4nAFm5vJNu4yUNLZW+59AbgFpuw6Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoVfqFgd6jZkysSa5849PpcnKqgKWAQFqfC5tNdHXeT4fJ/sWe
	qPMOCGw+HUxtuHvbar2NHkqMOr0lBbNjp1Ho4uhmX3E8Ic9l86WacuLBsFq8lueJ2Ry9fWW6+Lx
	orPv2W7w27lMl/HSXIWS4j2I0B5U8yT5d88DR8EqB4XpkN4EQZBFpFTyOnNQ=
X-Google-Smtp-Source: AGHT+IFNF3LWrTamx8JPdOfhsYOFMQ83W3eg3F+nRozTOHBTiXIwVSVwi+Sy+8nc2ALbQwmhKr9sh9NXhcNglon3qck5mOSVh2IA
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:471a:b0:3df:154d:aa5b with SMTP id
 e9e14a558f8ab-3e2823a6c2amr71719005ab.5.1752747337872; Thu, 17 Jul 2025
 03:15:37 -0700 (PDT)
Date: Thu, 17 Jul 2025 03:15:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6878cd49.a70a0220.693ce.0044.GAE@google.com>
Subject: [syzbot] [crypto?] BUG: unable to handle kernel paging request in ieee80211_wep_encrypt
From: syzbot <syzbot+d1008c24929007591b6b@syzkaller.appspotmail.com>
To: ardb@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	ebiggers@kernel.org, hpa@zytor.com, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5e28d5a3f774 net/sched: sch_qfq: Fix race condition on qfq..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=146550f0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b309c907eaab29da
dashboard link: https://syzkaller.appspot.com/bug?extid=d1008c24929007591b6b
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/897daa1d604c/disk-5e28d5a3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0d5527eee75d/vmlinux-5e28d5a3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/31ee968efcd7/bzImage-5e28d5a3.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d1008c24929007591b6b@syzkaller.appspotmail.com

BUG: unable to handle page fault for address: ffff8880bfffd000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 1a201067 P4D 1a201067 PUD 23ffff067 PMD 23fffe067 PTE 0
Oops: Oops: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 8097 Comm: syz.1.594 Not tainted 6.16.0-rc5-syzkaller-00183-g5e28d5a3f774 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:crc32_lsb_pclmul_sse+0x8f/0x220 arch/x86/lib/crc32-pclmul.S:6
Code: 0f 3a 44 c7 11 66 0f ef ec 66 0f ef c5 f3 0f 6f 66 10 66 0f 6f e9 66 0f 3a 44 ef 00 66 0f 3a 44 cf 11 66 0f ef ec 66 0f ef cd <f3> 0f 6f 66 20 66 0f 6f ea 66 0f 3a 44 ef 00 66 0f 3a 44 d7 11 66
RSP: 0018:ffffc9001bcae6f8 EFLAGS: 00010296
RAX: e4cc01b02de40500 RBX: fffffffffffffffe RCX: ffffffff8be53dc0
RDX: ffffffff7301ca7e RSI: ffff8880bfffcfde RDI: 00000000ffffffff
RBP: 00000000ffffffff R08: ffff88801cb09e07 R09: 1ffff110039613c0
R10: dffffc0000000000 R11: ffffed10039613c1 R12: fffffffffffffffe
R13: ffff888033019a5e R14: ffff888033019a5e R15: ffff888067eeec80
FS:  00007f4779be36c0(0000) GS:ffff888125d1b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff8880bfffd000 CR3: 00000000671a8000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 crc32_le_arch+0x56/0xa0 arch/x86/lib/crc32.c:21
 crc32_le include/linux/crc32.h:18 [inline]
 ieee80211_wep_encrypt_data net/mac80211/wep.c:114 [inline]
 ieee80211_wep_encrypt+0x228/0x410 net/mac80211/wep.c:158
 wep_encrypt_skb net/mac80211/wep.c:277 [inline]
 ieee80211_crypto_wep_encrypt+0x1f6/0x320 net/mac80211/wep.c:300
 invoke_tx_handlers_late+0x1145/0x1820 net/mac80211/tx.c:1846
 ieee80211_tx_dequeue+0x3068/0x4340 net/mac80211/tx.c:3916
 wake_tx_push_queue net/mac80211/util.c:294 [inline]
 ieee80211_handle_wake_tx_queue+0x125/0x2a0 net/mac80211/util.c:315
 drv_wake_tx_queue net/mac80211/driver-ops.h:1367 [inline]
 schedule_and_wake_txq net/mac80211/driver-ops.h:1374 [inline]
 ieee80211_queue_skb+0x19e8/0x2180 net/mac80211/tx.c:1648
 ieee80211_tx+0x297/0x420 net/mac80211/tx.c:1951
 __ieee80211_tx_skb_tid_band+0x50f/0x680 net/mac80211/tx.c:6103
 ieee80211_tx_skb_tid+0x266/0x420 net/mac80211/tx.c:6131
 ieee80211_mgmt_tx+0x1c25/0x21d0 net/mac80211/offchannel.c:1023
 rdev_mgmt_tx net/wireless/rdev-ops.h:762 [inline]
 cfg80211_mlme_mgmt_tx+0x7f2/0x1620 net/wireless/mlme.c:938
 nl80211_tx_mgmt+0x9fd/0xd50 net/wireless/nl80211.c:12921
 genl_family_rcv_msg_doit+0x215/0x300 net/netlink/genetlink.c:1115
 genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
 genl_rcv_msg+0x60e/0x790 net/netlink/genetlink.c:1210
 netlink_rcv_skb+0x205/0x470 net/netlink/af_netlink.c:2552
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
 netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
 netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1346
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
 sock_sendmsg_nosec net/socket.c:712 [inline]
 __sock_sendmsg+0x219/0x270 net/socket.c:727
 ____sys_sendmsg+0x505/0x830 net/socket.c:2566
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2620
 __sys_sendmsg net/socket.c:2652 [inline]
 __do_sys_sendmsg net/socket.c:2657 [inline]
 __se_sys_sendmsg net/socket.c:2655 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2655
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4778d8e929
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4779be3038 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f4778fb6080 RCX: 00007f4778d8e929
RDX: 0000000024008080 RSI: 0000200000000c00 RDI: 0000000000000005
RBP: 00007f4778e10b39 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f4778fb6080 R15: 00007ffff7e551c8
 </TASK>
Modules linked in:
CR2: ffff8880bfffd000
---[ end trace 0000000000000000 ]---
RIP: 0010:crc32_lsb_pclmul_sse+0x8f/0x220 arch/x86/lib/crc32-pclmul.S:6
Code: 0f 3a 44 c7 11 66 0f ef ec 66 0f ef c5 f3 0f 6f 66 10 66 0f 6f e9 66 0f 3a 44 ef 00 66 0f 3a 44 cf 11 66 0f ef ec 66 0f ef cd <f3> 0f 6f 66 20 66 0f 6f ea 66 0f 3a 44 ef 00 66 0f 3a 44 d7 11 66
RSP: 0018:ffffc9001bcae6f8 EFLAGS: 00010296
RAX: e4cc01b02de40500 RBX: fffffffffffffffe RCX: ffffffff8be53dc0
RDX: ffffffff7301ca7e RSI: ffff8880bfffcfde RDI: 00000000ffffffff
RBP: 00000000ffffffff R08: ffff88801cb09e07 R09: 1ffff110039613c0
R10: dffffc0000000000 R11: ffffed10039613c1 R12: fffffffffffffffe
R13: ffff888033019a5e R14: ffff888033019a5e R15: ffff888067eeec80
FS:  00007f4779be36c0(0000) GS:ffff888125d1b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff8880bfffd000 CR3: 00000000671a8000 CR4: 00000000003526f0
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	3a 44 c7 11          	cmp    0x11(%rdi,%rax,8),%al
   4:	66 0f ef ec          	pxor   %xmm4,%xmm5
   8:	66 0f ef c5          	pxor   %xmm5,%xmm0
   c:	f3 0f 6f 66 10       	movdqu 0x10(%rsi),%xmm4
  11:	66 0f 6f e9          	movdqa %xmm1,%xmm5
  15:	66 0f 3a 44 ef 00    	pclmullqlqdq %xmm7,%xmm5
  1b:	66 0f 3a 44 cf 11    	pclmulhqhqdq %xmm7,%xmm1
  21:	66 0f ef ec          	pxor   %xmm4,%xmm5
  25:	66 0f ef cd          	pxor   %xmm5,%xmm1
* 29:	f3 0f 6f 66 20       	movdqu 0x20(%rsi),%xmm4 <-- trapping instruction
  2e:	66 0f 6f ea          	movdqa %xmm2,%xmm5
  32:	66 0f 3a 44 ef 00    	pclmullqlqdq %xmm7,%xmm5
  38:	66 0f 3a 44 d7 11    	pclmulhqhqdq %xmm7,%xmm2
  3e:	66                   	data16


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
