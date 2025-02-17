Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06385217641;
	Mon, 17 Feb 2025 10:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739787876; cv=none; b=BDaheSZqAxRYMe70A+hLIg9Zu9GEyuvR4p1PnGzMRVEpWuQikrzqoba9VLXsUH4LKU7WkIJSD9tIjFvUO689teyXtXaCCA/qzU2znb+byMiein20sD7HErXpPwGfJWL9/YWbthnowNPgvlhi8udWYtP5BoUqEHp1SNjc/OYKloI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739787876; c=relaxed/simple;
	bh=2XgjyaibevkLd3BgI0CWKCePkbYl0zCD5CgShziuagI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AyNHZzTgJiod0UE33lIkJu4h9FY2zfG5DI7WL8adR0uRTY060BaRsmZPKlQtGwwyiXjqJqxjJD/gAdqAVojNa0vbRC+9fvovCl93GsKFGmcyaPr1ClZ1HYbW0SQ3vS7ObCxoOw7ZKLHgjWIEda0klducfJxcm3+Z10Am0QkBsOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pNt34BP3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pNt34BP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764D0C4CEEB;
	Mon, 17 Feb 2025 10:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739787875;
	bh=2XgjyaibevkLd3BgI0CWKCePkbYl0zCD5CgShziuagI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=pNt34BP3DUIgqM083Xiuk3qMRdZwYHyt+ySXoVgw+xfA85ssNQv6cwzLq8RkY8znw
	 slAsgxUy8SF0fybbBxVHzzImJMHYCn4lTC+GjIHPiiAlMbnDeWwrWp0K24oVLt7nof
	 j+dm4mP6hn7FoJjjTWk9Qk0igtwQrS6Rgh77/SnawpLlcmu5eBZOz4WgEyxILc03WC
	 CK7B3INaV7Wpg3dPPOvgDoRc2c/WxvE3m2Wznz1ZJ0xQWiSNNo1VWtvg7xDfMjLnHI
	 iIcSQLrhPmVlPYkZWLxJ1tbEgZxiHvvTZyYM6oOptexeQStEjBm/HhRiAK14mCgPic
	 w4DhosXGg1OTA==
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5461a485a72so985208e87.0;
        Mon, 17 Feb 2025 02:24:35 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVyyAx9wgUO/y5g5zwIwbQ7RIFk5Xl6mc5a95K1uKczHL8VUvHOVEWKALTCJU7y+FZbgedywR2pgVyMDdE=@vger.kernel.org, AJvYcCW6aCvYGWAV2U1eyhy2A6Cf5w6LeJXIBdgJwYRhQ84ncet/iilA3M6FgrtuSlPF3CGv3GiLR+80B3P0lmOO@vger.kernel.org
X-Gm-Message-State: AOJu0YwndznjtTE01yjXb4Z0uW8GjQScSzkcfnkMBgQFVVS3sJjWQivA
	0jIw4fYhuer++gkSY4/WPSfR+w45J1d8vU4TcsXJqdCx2quhjv9H9cNuH5PplKGlRwfo44JLPll
	ApSIyeXE16I895wA0kcTOaujFaIw=
X-Google-Smtp-Source: AGHT+IGlu/99eOx0GKpTYlmGIocV4kOjh8X2T+M9LU7PB/WElcm+M+f2Wps38pfRl0wNH3YwFJQND46FyeFiIa/853I=
X-Received: by 2002:a05:6512:eaa:b0:545:c08:e17b with SMTP id
 2adb3069b0e04-5452fe5bec6mr2762443e87.23.1739787873807; Mon, 17 Feb 2025
 02:24:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <67b2eaf8.050a0220.173698.0020.GAE@google.com>
In-Reply-To: <67b2eaf8.050a0220.173698.0020.GAE@google.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 17 Feb 2025 11:24:22 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGGtE1j4tX5EOn_nH3CCsne4tTP2MH88-zMzz_1YjEbkA@mail.gmail.com>
X-Gm-Features: AWEUYZln9QGEVCTtUPZqLWNHe-h9z0bV8yJUH349i-dCKfRfB0LQSYkc3yYwCJU
Message-ID: <CAMj1kXGGtE1j4tX5EOn_nH3CCsne4tTP2MH88-zMzz_1YjEbkA@mail.gmail.com>
Subject: Re: [syzbot] [crypto?] KASAN: use-after-free Read in crypto_poly1305_update
To: syzbot <syzbot+d587b24799bd8c2d32f4@syzkaller.appspotmail.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, davem@davemloft.net, 
	herbert@gondor.apana.org.au, hpa@zytor.com, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

#syz set subsystems: bcachefs

On Mon, 17 Feb 2025 at 08:53, syzbot
<syzbot+d587b24799bd8c2d32f4@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    ba643b6d8440 Merge tag 'irq_urgent_for_v6.14_rc3' of git:/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=176ea898580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c776e555cfbdb82d
> dashboard link: https://syzkaller.appspot.com/bug?extid=d587b24799bd8c2d32f4
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150557df980000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10eea898580000
>
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-ba643b6d.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/b6a86fb77c0b/vmlinux-ba643b6d.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/c4725da84fe0/bzImage-ba643b6d.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/769f8967e4f1/mount_0.gz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+d587b24799bd8c2d32f4@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KASAN: use-after-free in crypto_poly1305_update+0x28/0x40 arch/x86/crypto/poly1305_glue.c:230
> Read of size 8 at addr ffff888049757390 by task syz-executor358/5305
>
> CPU: 0 UID: 0 PID: 5305 Comm: syz-executor358 Not tainted 6.14.0-rc2-syzkaller-00346-gba643b6d8440 #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0x169/0x550 mm/kasan/report.c:489
>  kasan_report+0x143/0x180 mm/kasan/report.c:602
>  kasan_check_range+0x282/0x290 mm/kasan/generic.c:189
>  __asan_memcpy+0x29/0x70 mm/kasan/shadow.c:105
>  crypto_poly1305_update+0x28/0x40 arch/x86/crypto/poly1305_glue.c:230
>  bch2_checksum+0x5fa/0x780 fs/bcachefs/checksum.c:239
>  bch2_btree_node_read_done+0x1402/0x6180 fs/bcachefs/btree_io.c:1130
>  btree_node_read_work+0x6dc/0x1380 fs/bcachefs/btree_io.c:1358
>  bch2_btree_node_read+0x2433/0x29f0
>  __bch2_btree_root_read fs/bcachefs/btree_io.c:1789 [inline]
>  bch2_btree_root_read+0x626/0x7b0 fs/bcachefs/btree_io.c:1811
>  read_btree_roots+0x3d3/0xa70 fs/bcachefs/recovery.c:581
>  bch2_fs_recovery+0x260f/0x3de0 fs/bcachefs/recovery.c:928
>  bch2_fs_start+0x37c/0x610 fs/bcachefs/super.c:1041
>  bch2_fs_get_tree+0xdb7/0x17a0 fs/bcachefs/fs.c:2203
>  vfs_get_tree+0x90/0x2b0 fs/super.c:1814
>  do_new_mount+0x2be/0xb40 fs/namespace.c:3560
>  do_mount fs/namespace.c:3900 [inline]
>  __do_sys_mount fs/namespace.c:4111 [inline]
>  __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd8b49b71ba
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff5a4d7e78 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007fff5a4d7e90 RCX: 00007fd8b49b71ba
> RDX: 0000400000000000 RSI: 0000400000000200 RDI: 00007fff5a4d7e90
> RBP: 0000400000000000 R08: 00007fff5a4d7ed0 R09: 000000000000f634
> R10: 0000000002a08414 R11: 0000000000000282 R12: 0000400000000200
> R13: 00007fff5a4d7ed0 R14: 0000000000000003 R15: 0000000002a08414
>  </TASK>
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x49757
> flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
> raw: 04fff00000000000 ffffea000125d5c8 ffffea000125d5c8 0000000000000000
> raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner info is not present (never set?)
>
> Memory state around the buggy address:
>  ffff888049757280: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ffff888049757300: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >ffff888049757380: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>                          ^
>  ffff888049757400: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ffff888049757480: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ==================================================================
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup
>
