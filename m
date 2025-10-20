Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86407333739
	for <linux-crypto@vger.kernel.org>; Mon, 20 Oct 2025 21:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760994450; cv=none; b=FcFIW0KZ6iBXoEhPUmujbcRRuUxhhpunLEPXxIXPNXHwCCk5Ov9mIwURYbcrEuTdO4+gB1JyFndsbA/g+ZBX7svvCFvUX8Tk/PAk2uUtJfwTnipKu8tVDeqNzdsnU2FaHQBhbr8WT+gYM1pfjrJsdoelCA3vLgzaV1I7xrdOMik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760994450; c=relaxed/simple;
	bh=5/CMwqL4rKkh5iFQB2whmHx7BiXLXchrkKqyebLv2Vs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=QglV3tAm/mxbqbSsFdzg7BaTvTHaL8U0HlrYX2Bp4l5MgADFUdw0sn+MHVVCeLlhQKRuqW40ncmab/tsZbk1q79sLjOSrQpTz6Oa0LbLllwZ6L9aPZfkJ2H9LpB2Sfr9aufdEBvS6YvPJLR6TJ9nSlTBR1rE+vbucvw1s/I/uyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-430b3c32f75so44024625ab.0
        for <linux-crypto@vger.kernel.org>; Mon, 20 Oct 2025 14:07:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760994447; x=1761599247;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7MP4MxmW3g2lLE0ZEpBNI9vD0O79wKy2YFQcAlj3WJw=;
        b=g7UXZRxianiCJn3obGlLpyjbvERdgfKThdKoh9czinzkd4BA4JmHEBVR2Cq5duQK/1
         aZ8dj8RJXq57fxjByDwlmNCCR/7VLho+F/1vx+5O8RuVklv18s2TDpzQRJXAmmc870yQ
         HOAu5MGT9uSL7rnLF2V0A8Vx2erxlqhWizBQ/q7WUkxIL150oRdBcSF77+qNF09QKUlF
         Elcbw0eHh/AYXIZ0kn9G4HQYUc8vKMCh5ngUwj8lc+i9vUBKrAUGMZbJhI090vjReqUK
         bK3sy4FBuycLmiL9zgdgGHv+oElBS2JC2bxk8/F4cz9gt30d+spvvXVoH5izYQuH5taj
         4XNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWuIpKzSIOMhySEbl/vPt/v5SQkZ3EEuTmZyVdSt/uA6KLtWKe7C2hH7nx9jQYe04cEBioiNz8/I+4nalI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzowvDTuUuN7Qqr4taNGLtRQTiG52a/aiFP/GhB46+ZZXUDVz2S
	9OcUIOQJpeTbzBGtVnfd5Wb+FXQq6tTgVAuNzW5+st/gw9eLcNoLGk5dRoxXwVFYVAOqz7517TI
	EKLaWQNLS/0IUXzZXALnJrvGNJF/eF/OJ9+iqjuNUe7fjhSjZu+8IXP0WaUU=
X-Google-Smtp-Source: AGHT+IEPbiClZteklFQlevW//+LDYWwrgylqyu6ZXyPbaWziR5zzn8BbnI8rx4um9wuj8TF10rojGmwvuE0tYEYpBPXJIav+TXCD
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a65:b0:430:aedb:3719 with SMTP id
 e9e14a558f8ab-430c5203730mr190399425ab.4.1760994447398; Mon, 20 Oct 2025
 14:07:27 -0700 (PDT)
Date: Mon, 20 Oct 2025 14:07:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f6a48f.050a0220.91a22.0452.GAE@google.com>
Subject: [syzbot] [crypto?] KMSAN: uninit-value in poly1305_blocks
From: syzbot <syzbot+01fcd39a0d90cdb0e3df@syzkaller.appspotmail.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    211ddde0823f Linux 6.18-rc2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11af9734580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bbd3e7f3c2e28265
dashboard link: https://syzkaller.appspot.com/bug?extid=01fcd39a0d90cdb0e3df
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11099492580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1096eb04580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/46c24dbd5a18/disk-211ddde0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4d12e20e76d7/vmlinux-211ddde0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9e4b9dd5db28/bzImage-211ddde0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+01fcd39a0d90cdb0e3df@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in poly1305_blocks+0x1a9/0x5f0 lib/crypto/x86/poly1305.h:110
 poly1305_blocks+0x1a9/0x5f0 lib/crypto/x86/poly1305.h:110
 poly1305_update+0x169/0x400 lib/crypto/poly1305.c:50
 poly_hash+0x9f3/0x1a00 crypto/chacha20poly1305.c:168
 poly_genkey+0x3b6/0x450 crypto/chacha20poly1305.c:233
 chacha_encrypt crypto/chacha20poly1305.c:269 [inline]
 chachapoly_encrypt+0x48a/0x5c0 crypto/chacha20poly1305.c:284
 crypto_aead_encrypt+0xe2/0x160 crypto/aead.c:91
 tls_do_encryption net/tls/tls_sw.c:582 [inline]
 tls_push_record+0x38c7/0x5810 net/tls/tls_sw.c:819
 bpf_exec_tx_verdict+0x1a0c/0x26a0 net/tls/tls_sw.c:859
 tls_sw_sendmsg_locked net/tls/tls_sw.c:1138 [inline]
 tls_sw_sendmsg+0x3401/0x4560 net/tls/tls_sw.c:1281
 inet6_sendmsg+0x26c/0x2a0 net/ipv6/af_inet6.c:659
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x145/0x3d0 net/socket.c:742
 sock_write_iter+0x3a6/0x420 net/socket.c:1195
 do_iter_readv_writev+0x9e1/0xc20 fs/read_write.c:-1
 vfs_writev+0x52a/0x1500 fs/read_write.c:1057
 do_writev+0x1b5/0x580 fs/read_write.c:1103
 __do_sys_writev fs/read_write.c:1171 [inline]
 __se_sys_writev fs/read_write.c:1168 [inline]
 __x64_sys_writev+0x99/0xf0 fs/read_write.c:1168
 x64_sys_call+0x24b1/0x3e30 arch/x86/include/generated/asm/syscalls_64.h:21
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd9/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Local variable desc created at:
 poly_hash+0x11d/0x1a00 crypto/chacha20poly1305.c:135
 poly_genkey+0x3b6/0x450 crypto/chacha20poly1305.c:233

CPU: 1 UID: 0 PID: 6030 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(none) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
=====================================================


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
