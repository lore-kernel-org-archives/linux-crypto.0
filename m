Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A098152DE0
	for <linux-crypto@vger.kernel.org>; Fri,  3 May 2024 12:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714739068; cv=none; b=m35NQn8/TEqL+ADKuPCgF12zrEJXTJ7s4LPVIU2y0kCCQSPh0+sXHOXEZexrP9iVRzy8AsNTc+fLUmPky4jh0U1JFcLvlZ3eFoK/ZILQnfz9TSKirarULKWXJNU9WIwvRguQi0WlBmF8cw3moZqy4wSg/h+nYJo5bqdJEgE4auE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714739068; c=relaxed/simple;
	bh=lQA+G/qrDvpvIPLSUty/yz+9ZmJrQZje8mPUo9tK1po=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=eG8j/ZPx2WyyZDskNWO+10+cDlCaPaY0bEPL2pFtrd7UuPkwTEVAdKwCzPLrljvNAt0UyXWwB/z+nWKNLdF9F89do5TSBXTnNMeW6yln9ksGDkdhn4fIW78MnAgow/aSzFEwDunwsHnli2OfY8wOwRtIAgQEQysAAPhZGo82lYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-36c4184ee5dso59729255ab.1
        for <linux-crypto@vger.kernel.org>; Fri, 03 May 2024 05:24:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714739065; x=1715343865;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jgtA0e/mNrBatZ4jADUGKOrqubVKM0PELvXzPtRsvXo=;
        b=uZkqMyrvfkJU+/26/HIZyVUMjvM6bGzCa7aKuhB0cNSfIILSzDBGzMFnvlWviiN/mn
         taSakH5dKDwsNpCsUK+MXHITVcZ1hG0XB9H7HtJLEOhRpKX/aWgKZ35GP6rJy/J84WaW
         IIlbvVPFqr45stPpBjQ8BU5i9PGV8tF8F3odGfYusNXsemsah1+Zt7wKJUZYbTvQVu+k
         XiKS0prRcIhnpaWov9TdyeeBWexAcT6VeeLmOubWpZesDCNC0eELweYI9mQ7bl8C1sC1
         zSLjv92gLmCBE9fT2F5Begyk/6+uTbG9Q43xJmSMBMcby405z+IycX58i4aRVe1O5NrU
         j2vg==
X-Forwarded-Encrypted: i=1; AJvYcCU0LPTQYhGone+zpt9H0AiccbCJPKKG1OGUhiLEZujX+LaYspW6HYBIlMjoq9Tmq/J9/17Lhwj0LD5J6qIyAsk8RaTiWokmqpgXlIEn
X-Gm-Message-State: AOJu0YyhRpYp65kAGuRfXJUO4lmnwm8ut7wOiZcYLbIfsSpZofZ93yHH
	4xCtBeECbFf+HDQhfMsIY02XlTi88WD3eX36Cdn+LO6nLPjIdnJjf4cGNPJnmSAe/MyQxtcl+Kk
	n/0n0mm/yG8xpb+0WScNlLuNbnMpZQEevoRw1pikiJhXQ96btp4wJnc8=
X-Google-Smtp-Source: AGHT+IFo3Hb+ssgX036xbPxKQT5E9v4lAm4X8apq1VjVHkoQbtmYpZ3rkfIW+d2b1iDAZ/zACfE8kEzCF7ZP72K8TITsN7QF7XKD
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a26:b0:36c:5029:1925 with SMTP id
 g6-20020a056e021a2600b0036c50291925mr156194ile.0.1714739065175; Fri, 03 May
 2024 05:24:25 -0700 (PDT)
Date: Fri, 03 May 2024 05:24:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dcd2ae06178bccb0@google.com>
Subject: [syzbot] [crypto?] KMSAN: uninit-value in skcipher_walk_virt
From: syzbot <syzbot+97b4444a5bd7bf30b3a8@syzkaller.appspotmail.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f03359bca01b Merge tag 'for-6.9-rc6-tag' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17c169df180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bbf567496022057b
dashboard link: https://syzkaller.appspot.com/bug?extid=97b4444a5bd7bf30b3a8
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b345b1c01095/disk-f03359bc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d59970ea319e/vmlinux-f03359bc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/47407f406f40/bzImage-f03359bc.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+97b4444a5bd7bf30b3a8@syzkaller.appspotmail.com

loop3: detected capacity change from 0 to 32768
bcachefs (loop3): mounting version 1.7: mi_btree_bitmap opts=metadata_checksum=none,data_checksum=none,nojournal_transaction_names
bcachefs (loop3): recovering from clean shutdown, journal seq 10
=====================================================
BUG: KMSAN: uninit-value in skcipher_walk_virt+0x91/0x1a0 crypto/skcipher.c:504
 skcipher_walk_virt+0x91/0x1a0 crypto/skcipher.c:504
 chacha_stream_xor+0x7c/0x710 crypto/chacha_generic.c:22
 crypto_chacha_crypt+0x79/0xb0 crypto/chacha_generic.c:45
 crypto_skcipher_encrypt+0x1a0/0x1e0 crypto/skcipher.c:671
 do_encrypt_sg fs/bcachefs/checksum.c:107 [inline]
 do_encrypt+0x99c/0xc30 fs/bcachefs/checksum.c:127
 gen_poly_key fs/bcachefs/checksum.c:190 [inline]
 bch2_checksum+0x21f/0x7c0 fs/bcachefs/checksum.c:226
 bch2_btree_node_read_done+0x1898/0x75e0 fs/bcachefs/btree_io.c:1055
 btree_node_read_work+0x8a5/0x1eb0 fs/bcachefs/btree_io.c:1324
 bch2_btree_node_read+0x3d42/0x4b50
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1748 [inline]
 bch2_btree_root_read+0xa6c/0x13d0 fs/bcachefs/btree_io.c:1772
 read_btree_roots+0x454/0xee0 fs/bcachefs/recovery.c:457
 bch2_fs_recovery+0x7adb/0x9310 fs/bcachefs/recovery.c:785
 bch2_fs_start+0x7b2/0xbd0 fs/bcachefs/super.c:1043
 bch2_fs_open+0x135f/0x1670 fs/bcachefs/super.c:2102
 bch2_mount+0x90d/0x1d90 fs/bcachefs/fs.c:1903
 legacy_get_tree+0x114/0x290 fs/fs_context.c:662
 vfs_get_tree+0xa7/0x570 fs/super.c:1779
 do_new_mount+0x71f/0x15e0 fs/namespace.c:3352
 path_mount+0x742/0x1f20 fs/namespace.c:3679
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x725/0x810 fs/namespace.c:3875
 __ia32_sys_mount+0xe3/0x150 fs/namespace.c:3875
 ia32_sys_call+0x3a9a/0x40a0 arch/x86/include/generated/asm/syscalls_32.h:22
 do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
 __do_fast_syscall_32+0xb4/0x120 arch/x86/entry/common.c:386
 do_fast_syscall_32+0x38/0x80 arch/x86/entry/common.c:411
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/common.c:449
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

Local variable __req_desc.i created at:
 do_encrypt_sg fs/bcachefs/checksum.c:101 [inline]
 do_encrypt+0x8f9/0xc30 fs/bcachefs/checksum.c:127
 gen_poly_key fs/bcachefs/checksum.c:190 [inline]
 bch2_checksum+0x21f/0x7c0 fs/bcachefs/checksum.c:226

CPU: 1 PID: 15218 Comm: syz-executor.3 Not tainted 6.9.0-rc6-syzkaller-00131-gf03359bca01b #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
=====================================================


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
