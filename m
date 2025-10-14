Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E042FFDDA
	for <linux-crypto@vger.kernel.org>; Tue, 14 Oct 2025 14:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760453879; cv=none; b=ZM4MMhoaA41FOyQsMo0wXOBfd6RgYXrmqlHQHd8RNRz9gJ7J2qwZuNrT8LEER5QH7/bGopCwivZQWwU03pb3de2Vj/LMix/fg/+8nn3fkSM9wqnEvy9SWcF3xylQBc6LwMj9Yj3tMytgVVva9r1SSWc6iyjZ2NuNcZSg4etc3vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760453879; c=relaxed/simple;
	bh=ib/Lb6gIXVXOKcTFxY+uc/tG6coal3pQoixbpHZMF3w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HW3EW6AQoaE7XziA+lZKVlQHGraIvYixkdzKfFC+90ebFv2khBr+cxdQ7/X5zZ6y8jxcDugSvYfYL2RxRbaSXqaFusYuNmSLvSMw0n9/0I226ZCtihY68Hb0QPS4d+JWg0/72vUz/nHB+LPfGV3BZxcao26tSkSn+UMudagvjlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KsgD5vQw; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KsgD5vQw"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-64d696840b6so2668775eaf.2
        for <linux-crypto@vger.kernel.org>; Tue, 14 Oct 2025 07:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760453876; x=1761058676; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wMM4owIJy3YIyx8RhfziWATfHpJmVWZnkONwKUFQZUE=;
        b=KsgD5vQwB+cY7cgjZLMqY5fqvyHppJBRozhFFheXLa+UfWDdna1blPYX6Gp1Miz1l8
         znQvDE7P7du3LVopuDZqeKkClA1zG/+UDyd+GGnvuMDZBYIParEOJTTy2EDDWXRimBaW
         FYaFtXqAH0AotDVuc4RWyXPjeF0xuJ62dNU81OT0k24x8I0Z2SNRjLXhNjKWg3mgbJIV
         ie3h9Xw6kkhEX6vvTNz06oKUI88i6PkyqHToClU5oZnluRqCSWpHhgyXatFuzrpcO9rq
         yu/VXx780i8i1zVpl/BV0G1Sab+keZZ40FWaloNfkm7kggocxf0b9gEHdn183SMAsT/j
         K27A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760453876; x=1761058676;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wMM4owIJy3YIyx8RhfziWATfHpJmVWZnkONwKUFQZUE=;
        b=qVT8gXELGTx2NnkUClJQZQwUXofIM6leLyEB2W2xe7tqJtFWBWv8iBeWC+Y09/5YLs
         vKRdjYEmvqsMlAefQypMWfD7Cm5XwjPjzHJ0glsMYGtE+gLeoU7uvI+QA+slixenx3wV
         eYt/eZkEOqTiJQSutflNIs0cH+pOC+5utyhvZ5kBqjZa0tN3O+j2fDV0Isa2otu1ZUtV
         YqOKEkK+DtlRJ0X7dmg1DUzSj5ib/PcJJVjYd6TBtGnurtlgLTUFzk2yg73yuoiocjOB
         C4IxaoLUrdLihnV4M/cBMzPVBoUz9/x4G4D4rcGzx6zqNgjJToqkiVbu0iVzIpysqgCH
         ZKsQ==
X-Forwarded-Encrypted: i=1; AJvYcCViVRuUyJ3Vp25mL9II0wb7Ze+bcv9Dlbihv1Nz0BAMHq04WSNZdPhXysrUNxRefZQ2CTOlTCxRVkI3WsM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWXxNAsMziUXneJGGkOFZr9CoZcATeVvnJh6KFh0eONMssIUS/
	eSisRE0qj9EOpRJ7lwOHmpj/mDVbMCpIiRovEoy2+RJl0drRRTGlKvwWlbPA/XM7OWYLtc3iea1
	icOVqdJAh4qPWRvSA0asqtFLtM9JDG0T1u8IleQXR
X-Gm-Gg: ASbGncvHOOtinWJfjLThugC5LncIgeCK05Przfd++JoWgZYfD06QeG/fHhBjzni1T35
	Teolzd1i02maiFHkU7eccKztjYlEkLGAjSILuOZ5QEcGNRuMPS3obDM0J03hWf9rab0uq+ub3rL
	0czAjV/Mx6iNidYQ/IPiDkMkZsFQKQYtARE5LSqVzDJWwx+k9KcrE/rsQfsuoNJj/KisAN/pTHn
	ODrwyfTw1z0ByY5IGYKLqfvwm6aE/fuQMsyFEOmKen4fq8yCXwXdYsmU5IkwoY=
X-Google-Smtp-Source: AGHT+IHvWzRa6w22oZkIH/WB6DfN04ggYBQcxSfriPB4prkFVdOWVQ0FPS0od0zgyBJU5HLIi5I7+YHseSSjuCy/LlU=
X-Received: by 2002:a05:6808:1b8d:b0:43f:5fc5:e04b with SMTP id
 5614622812f47-4417b36e8c4mr10773972b6e.15.1760453875890; Tue, 14 Oct 2025
 07:57:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <68ea2595.a70a0220.b3ac9.0006.GAE@google.com> <CAMj1kXErR15QWWZXFXjmXgRrxG0Fj_Qjk7OQzbUU+oR7g27RLw@mail.gmail.com>
In-Reply-To: <CAMj1kXErR15QWWZXFXjmXgRrxG0Fj_Qjk7OQzbUU+oR7g27RLw@mail.gmail.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 14 Oct 2025 16:57:44 +0200
X-Gm-Features: AS18NWDlqytEd33y6B1eaNMbXyOjLMIHLEHe2M6UiOrT4fL26AO4XhifHt2rjsc
Message-ID: <CANp29Y674o4PNC47eppvjPvYo8XiXYmgG6eSAsXO54w_Bh3Ytw@mail.gmail.com>
Subject: Re: [syzbot] [crypto?] KMSAN: uninit-value in aes_encrypt (6)
To: Ard Biesheuvel <ardb@kernel.org>
Cc: syzbot <syzbot+22bff16a8f91d65e2e58@syzkaller.appspotmail.com>, 
	davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz dup: KMSAN: uninit-value in fscrypt_crypt_data_unit

On Sat, Oct 11, 2025 at 4:53=E2=80=AFPM 'Ard Biesheuvel' via syzkaller-bugs
<syzkaller-bugs@googlegroups.com> wrote:
>
> #syz set subsystems: ext4, fscrypt
>
> On Sat, 11 Oct 2025 at 02:38, syzbot
> <syzbot+22bff16a8f91d65e2e58@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    917167ed1211 Merge tag 'xtensa-20251010' of https://git=
hub..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D10f55304580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D3b820eb4c6d=
d8482
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D22bff16a8f91d=
65e2e58
> > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7=
976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > userspace arch: i386
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/f8b165efe52b/d=
isk-917167ed.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/01b56300cdc7/vmli=
nux-917167ed.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/6c32d21e8075=
/bzImage-917167ed.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+22bff16a8f91d65e2e58@syzkaller.appspotmail.com
> >
> > EXT4-fs error (device loop5): ext4_orphan_get:1418: comm syz.5.10451: b=
ad orphan inode 131083
> > EXT4-fs (loop5): mounted filesystem 00000000-0000-0000-0000-00000000000=
0 r/w without journal. Quota mode: none.
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > BUG: KMSAN: uninit-value in subshift lib/crypto/aes.c:150 [inline]
> > BUG: KMSAN: uninit-value in aes_encrypt+0x1239/0x1960 lib/crypto/aes.c:=
283
> >  subshift lib/crypto/aes.c:150 [inline]
> >  aes_encrypt+0x1239/0x1960 lib/crypto/aes.c:283
> >  aesti_encrypt+0x7d/0xf0 crypto/aes_ti.c:31
> >  crypto_ecb_crypt crypto/ecb.c:23 [inline]
> >  crypto_ecb_encrypt2+0x13f/0x300 crypto/ecb.c:40
> >  crypto_lskcipher_crypt_sg+0x3a9/0x930 crypto/lskcipher.c:188
> >  crypto_lskcipher_encrypt_sg+0x8b/0xc0 crypto/lskcipher.c:207
> >  crypto_skcipher_encrypt+0x111/0x1e0 crypto/skcipher.c:194
> >  xts_encrypt+0x2e1/0x570 crypto/xts.c:269
> >  crypto_skcipher_encrypt+0x187/0x1e0 crypto/skcipher.c:195
> >  fscrypt_crypt_data_unit+0x38e/0x590 fs/crypto/crypto.c:139
> >  fscrypt_encrypt_pagecache_blocks+0x430/0x900 fs/crypto/crypto.c:197
> >  ext4_bio_write_folio+0x1383/0x30d0 fs/ext4/page-io.c:552
> >  mpage_submit_folio fs/ext4/inode.c:2080 [inline]
> >  mpage_process_page_bufs+0xf1b/0x13e0 fs/ext4/inode.c:2191
> >  mpage_prepare_extent_to_map+0x1792/0x2a10 fs/ext4/inode.c:2736
> >  ext4_do_writepages+0x11b6/0x8020 fs/ext4/inode.c:2877
> >  ext4_writepages+0x338/0x870 fs/ext4/inode.c:3025
> >  do_writepages+0x3ef/0x860 mm/page-writeback.c:2604
> >  filemap_fdatawrite_wbc mm/filemap.c:389 [inline]
> >  __filemap_fdatawrite_range mm/filemap.c:422 [inline]
> >  file_write_and_wait_range+0x6f0/0x7d0 mm/filemap.c:797
> >  generic_buffers_fsync_noflush+0x79/0x3c0 fs/buffer.c:609
> >  ext4_fsync_nojournal fs/ext4/fsync.c:88 [inline]
> >  ext4_sync_file+0x587/0x12f0 fs/ext4/fsync.c:147
> >  vfs_fsync_range+0x1a1/0x240 fs/sync.c:187
> >  generic_write_sync include/linux/fs.h:3046 [inline]
> >  ext4_buffered_write_iter+0xae9/0xce0 fs/ext4/file.c:305
> >  ext4_file_write_iter+0x2a2/0x3d90 fs/ext4/file.c:-1
> >  do_iter_readv_writev+0x9de/0xc20 fs/read_write.c:-1
> >  vfs_writev+0x52a/0x1500 fs/read_write.c:1057
> >  do_pwritev fs/read_write.c:1153 [inline]
> >  __do_compat_sys_pwritev2 fs/read_write.c:1298 [inline]
> >  __se_compat_sys_pwritev2 fs/read_write.c:1290 [inline]
> >  __ia32_compat_sys_pwritev2+0x43d/0x6b0 fs/read_write.c:1290
> >  ia32_sys_call+0x1810/0x4310 arch/x86/include/generated/asm/syscalls_32=
.h:380
> >  do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
> >  __do_fast_syscall_32+0xb0/0x150 arch/x86/entry/syscall_32.c:306
> >  do_fast_syscall_32+0x38/0x80 arch/x86/entry/syscall_32.c:331
> >  do_SYSENTER_32+0x1f/0x30 arch/x86/entry/syscall_32.c:369
> >  entry_SYSENTER_compat_after_hwframe+0x84/0x8e
> >
> > Uninit was stored to memory at:
> >  le128_xor include/crypto/b128ops.h:69 [inline]
> >  xts_xor_tweak+0x566/0xbd0 crypto/xts.c:123
> >  xts_xor_tweak_pre crypto/xts.c:135 [inline]
> >  xts_encrypt+0x278/0x570 crypto/xts.c:268
> >  crypto_skcipher_encrypt+0x187/0x1e0 crypto/skcipher.c:195
> >  fscrypt_crypt_data_unit+0x38e/0x590 fs/crypto/crypto.c:139
> >  fscrypt_encrypt_pagecache_blocks+0x430/0x900 fs/crypto/crypto.c:197
> >  ext4_bio_write_folio+0x1383/0x30d0 fs/ext4/page-io.c:552
> >  mpage_submit_folio fs/ext4/inode.c:2080 [inline]
> >  mpage_process_page_bufs+0xf1b/0x13e0 fs/ext4/inode.c:2191
> >  mpage_prepare_extent_to_map+0x1792/0x2a10 fs/ext4/inode.c:2736
> >  ext4_do_writepages+0x11b6/0x8020 fs/ext4/inode.c:2877
> >  ext4_writepages+0x338/0x870 fs/ext4/inode.c:3025
> >  do_writepages+0x3ef/0x860 mm/page-writeback.c:2604
> >  filemap_fdatawrite_wbc mm/filemap.c:389 [inline]
> >  __filemap_fdatawrite_range mm/filemap.c:422 [inline]
> >  file_write_and_wait_range+0x6f0/0x7d0 mm/filemap.c:797
> >  generic_buffers_fsync_noflush+0x79/0x3c0 fs/buffer.c:609
> >  ext4_fsync_nojournal fs/ext4/fsync.c:88 [inline]
> >  ext4_sync_file+0x587/0x12f0 fs/ext4/fsync.c:147
> >  vfs_fsync_range+0x1a1/0x240 fs/sync.c:187
> >  generic_write_sync include/linux/fs.h:3046 [inline]
> >  ext4_buffered_write_iter+0xae9/0xce0 fs/ext4/file.c:305
> >  ext4_file_write_iter+0x2a2/0x3d90 fs/ext4/file.c:-1
> >  do_iter_readv_writev+0x9de/0xc20 fs/read_write.c:-1
> >  vfs_writev+0x52a/0x1500 fs/read_write.c:1057
> >  do_pwritev fs/read_write.c:1153 [inline]
> >  __do_compat_sys_pwritev2 fs/read_write.c:1298 [inline]
> >  __se_compat_sys_pwritev2 fs/read_write.c:1290 [inline]
> >  __ia32_compat_sys_pwritev2+0x43d/0x6b0 fs/read_write.c:1290
> >  ia32_sys_call+0x1810/0x4310 arch/x86/include/generated/asm/syscalls_32=
.h:380
> >  do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
> >  __do_fast_syscall_32+0xb0/0x150 arch/x86/entry/syscall_32.c:306
> >  do_fast_syscall_32+0x38/0x80 arch/x86/entry/syscall_32.c:331
> >  do_SYSENTER_32+0x1f/0x30 arch/x86/entry/syscall_32.c:369
> >  entry_SYSENTER_compat_after_hwframe+0x84/0x8e
> >
> > Uninit was created at:
> >  __alloc_frozen_pages_noprof+0x689/0xf00 mm/page_alloc.c:5206
> >  alloc_pages_mpol+0x328/0x860 mm/mempolicy.c:2416
> >  alloc_frozen_pages_noprof mm/mempolicy.c:2487 [inline]
> >  alloc_pages_noprof mm/mempolicy.c:2507 [inline]
> >  folio_alloc_noprof+0x109/0x360 mm/mempolicy.c:2517
> >  filemap_alloc_folio_noprof+0x9d/0x420 mm/filemap.c:1020
> >  __filemap_get_folio+0xb45/0x1930 mm/filemap.c:2012
> >  write_begin_get_folio include/linux/pagemap.h:784 [inline]
> >  ext4_write_begin+0x6d9/0x2d70 fs/ext4/inode.c:1318
> >  generic_perform_write+0x362/0x1050 mm/filemap.c:4242
> >  ext4_buffered_write_iter+0x61a/0xce0 fs/ext4/file.c:299
> >  ext4_file_write_iter+0x2a2/0x3d90 fs/ext4/file.c:-1
> >  do_iter_readv_writev+0x9de/0xc20 fs/read_write.c:-1
> >  vfs_writev+0x52a/0x1500 fs/read_write.c:1057
> >  do_pwritev fs/read_write.c:1153 [inline]
> >  __do_compat_sys_pwritev2 fs/read_write.c:1298 [inline]
> >  __se_compat_sys_pwritev2 fs/read_write.c:1290 [inline]
> >  __ia32_compat_sys_pwritev2+0x43d/0x6b0 fs/read_write.c:1290
> >  ia32_sys_call+0x1810/0x4310 arch/x86/include/generated/asm/syscalls_32=
.h:380
> >  do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
> >  __do_fast_syscall_32+0xb0/0x150 arch/x86/entry/syscall_32.c:306
> >  do_fast_syscall_32+0x38/0x80 arch/x86/entry/syscall_32.c:331
> >  do_SYSENTER_32+0x1f/0x30 arch/x86/entry/syscall_32.c:369
> >  entry_SYSENTER_compat_after_hwframe+0x84/0x8e
> >
> > CPU: 1 UID: 0 PID: 8113 Comm: syz.5.10451 Tainted: G        W          =
 syzkaller #0 PREEMPT(none)
> > Tainted: [W]=3DWARN
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 10/02/2025
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >
> > If the report is already addressed, let syzbot know by replying with:
> > #syz fix: exact-commit-title
> >
> > If you want to overwrite report's subsystems, reply with:
> > #syz set subsystems: new-subsystem
> > (See the list of subsystem names on the web dashboard)
> >
> > If the report is a duplicate of another one, reply with:
> > #syz dup: exact-subject-of-another-report
> >
> > If you want to undo deduplication, reply with:
> > #syz undup
> >
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-bugs/CAMj1kXErR15QWWZXFXjmXgRrxG0Fj_Qjk7OQzbUU%2BoR7g27RLw%40mail.gmail.co=
m.
