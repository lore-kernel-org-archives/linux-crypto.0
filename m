Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15802F877
	for <linux-crypto@vger.kernel.org>; Thu, 18 Jul 2024 16:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721319841; cv=none; b=JOwWo+8Z1eWU62Q0cGnDAxLO0e2cT7t259ppGLe4fx95gvI4CpUflUgsZhrGKEXRFuNpEiOuYwWxyLk4qsnydNiBFVFFgCk8NVDaF9q40HcxISqRAHnvskEFzenLSE6JZcTDtH1GNpBz2gqVtisoL/qzyhSu4dkB86V0VMpKngg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721319841; c=relaxed/simple;
	bh=mf699jvjwKTxjJYDmTgIBcjzDeJyNf9SMeEqnGjmPUk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PyvtcdBy4cUoviydQ+KjP15/Db8vnMWN+CYr5y/P927lTQzO5HeqCNuxsF3wP33nUF+i1UTo/zc+n+KmzSH4mrsl6NrJ+CipPXdUYiLoWnEhxWilguBAFrcxwAoR7+TpCNWNTL0x8QzSJHIy0ADJad6wy7J/c70O0i7GO3cOZl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=23GJo0yl; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="23GJo0yl"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-66498fd4f91so9185047b3.3
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jul 2024 09:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721319838; x=1721924638; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sa5uf2OgU+1py4BdDs+igYpgbWk6LV/lNPR8dPB8BHM=;
        b=23GJo0yl0BkX5EKQ80OrXKTJ9+UA6NedRQPEa5+PlNXSoh17SO8vYibONxOAwI9iJ7
         7l3rymGVsAzNX7BgfLP50t8zeWnCIQMv1hPV4j46A5LkUoVVrw+hWkI4mXHAuFEcOe6C
         scMw6Q2N9jlvzVWuSHB3JYYoSl/aTLh0/rGIWNwOIOm1IZkI1PK2Lk+jr5Mweo72vJVC
         BFn5t49GKN7j83roG5WlEoSjqXPRrfIY2s6xTuNQiHgdndxw5zl4T/qqcaktDejVW5HY
         fnboGF04zswMK7JvqH2oFEIqcdeRrbnknb1+C2l2VIUEWzbuFSh6mp4GSXgtJxl8/ZHr
         bDjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721319838; x=1721924638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sa5uf2OgU+1py4BdDs+igYpgbWk6LV/lNPR8dPB8BHM=;
        b=o5F9GopXv6hxaPDwQH69EoU1HfqR67NYBAxighc5ePVKBB5oQcTcPBXdjWkBllT+zw
         U3AkFqVVKxK5yQOWLYU6D0xg4CLNb0B3g3d0cnvgYEo5aAkSsBLqfP/LNtSTzEecrh1h
         mYXhnxMIjx2OuXAMQ6FYKgIWbjlFWlhy4WtQAFVUmuTo+/E22XWSmh+jxW1pCRlOnW2c
         fgYNqCPoQNehdXfnpazsnrzX7NtyH3SCrYKEHx8wQgpJAREXwoD2F/9TOTCojtvU9TWz
         GObfyQUfX++A/p2EuDYWhDJD2rXK7o+meBn0PsYMyHnacYDY1XDbSUixsKvFAyFJg2vq
         A4BA==
X-Forwarded-Encrypted: i=1; AJvYcCUMByDSwmBRQN62ZRwM9879cKKVhb4btcIWXYo+nmUKjOaS69iSys2AOfXIxb3AvaTJeivvcRJy+sVOZ+0At9rT9czVfymvyBo9N/tg
X-Gm-Message-State: AOJu0YyUIPXSwrE/rg9r7kyLaUEzk6n7dWUG0KqqLPbRYFxuQHGcT1Xr
	uhUKTVOvbSiY9o/AGZLDjPcTeNk6BfovXiBKWoMeoWw1eSAWyXPlV0Tr+XwJY/zFTy+q4Ful46t
	OW6Fda1mrvENoqKxqBm9YtSYoazjU3/whubS+
X-Google-Smtp-Source: AGHT+IEM9QJw2U4dPnAkXo1B0Gufc3aeplGfPEpz16ljZsZc0hhXboL9lEjgyZGF2ziWEiXapvGKAD9w0hbXg1J8bW0=
X-Received: by 2002:a81:de4f:0:b0:65f:e123:b20a with SMTP id
 00721157ae682-664fd59ed09mr63762687b3.6.1721319838145; Thu, 18 Jul 2024
 09:23:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <00000000000037cdb0061d5924b3@google.com> <46f44064-255b-4a1e-9317-f4b168706d65@kernel.org>
 <flthie3lmh4ovhlullgz2rsd5yfmwwfuqd76yef7xa2ncpqs4j@dxvhd64eoa7t> <CAJuCfpEX7JFbWbLT0w+nyKz-m87ccuzSoorB3PfnW82mA-nFfw@mail.gmail.com>
In-Reply-To: <CAJuCfpEX7JFbWbLT0w+nyKz-m87ccuzSoorB3PfnW82mA-nFfw@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 18 Jul 2024 16:23:47 +0000
Message-ID: <CAJuCfpEGATSeybdVNnUW5eS5EKHF00VzxHGwKoMfPiS_QRiKbQ@mail.gmail.com>
Subject: Re: [syzbot] [crypto?] KASAN: slab-use-after-free Read in handle_mm_fault
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	syzbot <syzbot+4c882a4a0697c4a25364@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, 
	Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jason@zx2c4.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 18, 2024 at 4:20=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Thu, Jul 18, 2024 at 3:43=E2=80=AFPM Liam R. Howlett <Liam.Howlett@ora=
cle.com> wrote:
> >
> > * Vlastimil Babka (SUSE) <vbabka@kernel.org> [240718 07:00]:
> > > On 7/16/24 10:29 AM, syzbot wrote:
> > > > Hello,
> > >
> > > dunno about the [crypto?] parts, sounds rather something for Suren or=
 Liam
> > > or maybe it's due to some changes to gup?
> >
> > Yes, that crypto part is very odd.
> >
> > >
> > > > syzbot found the following issue on:
> > > >
> > > > HEAD commit:    3fe121b62282 Add linux-next specific files for 2024=
0712
> > > > git tree:       linux-next
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D1097ebe=
d980000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D98dd8c4=
bab5cdce
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=3D4c882a4a0=
697c4a25364
> > > > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils f=
or Debian) 2.40
> > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D11d61=
1a5980000
> > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D13ce325=
9980000
> > > >
> > > > Downloadable assets:
> > > > disk image: https://storage.googleapis.com/syzbot-assets/8c6fbf6971=
8d/disk-3fe121b6.raw.xz
> > > > vmlinux: https://storage.googleapis.com/syzbot-assets/39fc7e43dfc1/=
vmlinux-3fe121b6.xz
> > > > kernel image: https://storage.googleapis.com/syzbot-assets/0a78e70e=
4b4e/bzImage-3fe121b6.xz
> > > > mounted in repro: https://storage.googleapis.com/syzbot-assets/66cf=
e5a679f2/mount_0.gz
> > > >
> > > > IMPORTANT: if you fix the issue, please add the following tag to th=
e commit:
> > > > Reported-by: syzbot+4c882a4a0697c4a25364@syzkaller.appspotmail.com
> > > >
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > BUG: KASAN: slab-use-after-free in handle_mm_fault+0x14f0/0x19a0 mm=
/memory.c:5842
> > > > Read of size 8 at addr ffff88802c4719d0 by task syz-executor125/523=
5
> > > >
> > > > CPU: 1 UID: 0 PID: 5235 Comm: syz-executor125 Not tainted 6.10.0-rc=
7-next-20240712-syzkaller #0
> > > > Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS Google 06/07/2024
> > > > Call Trace:
> > > >  <TASK>
> > > >  __dump_stack lib/dump_stack.c:94 [inline]
> > > >  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
> > > >  print_address_description mm/kasan/report.c:377 [inline]
> > > >  print_report+0x169/0x550 mm/kasan/report.c:488
> > > >  kasan_report+0x143/0x180 mm/kasan/report.c:601
> > > >  handle_mm_fault+0x14f0/0x19a0 mm/memory.c:5842
> >
> > /*
> >  * By the time we get here, we already hold the mm semaphore
> >  *
> >  * The mmap_lock may have been released depending on flags and our
> >  * return value.  See filemap_fault() and __folio_lock_or_retry().
> >  */
> >
> > Somehow we are here without an RCU or mmap_lock held?
>
> I'm guessing we did enter handle_mm_fault() with mmap_lock held but
> __handle_mm_fault() dropped it before returning, see the comment for
> __handle_mm_fault():
>
> /*
>  * On entry, we hold either the VMA lock or the mmap_lock
>  * (FAULT_FLAG_VMA_LOCK tells you which).  If VM_FAULT_RETRY is set in
>  * the result, the mmap_lock is not held on exit.  See filemap_fault()
>  * and __folio_lock_or_retry().
>  */
>
> So after that there is nothing that guarantees VMA is not destroyed
> from under us and if (vma->vm_flags & VM_DROPPABLE) check is unsafe.
> Hillf's suggestion should fix this issue but we need to figure out how
> to make this path more robust. Currently it's very easy to make a
> similar mistake. Maybe a WARNING comment after __handle_mm_fault()
> that VMA might be unstable after that function and should not be used?

CC'ing Jason.

>
> >
> > > >  faultin_page mm/gup.c:1194 [inline]
> >
> > /*
> >  * mmap_lock must be held on entry.  If @flags has FOLL_UNLOCKABLE but =
not
> >  * FOLL_NOWAIT, the mmap_lock may be released.  If it is, *@locked will=
 be set
> >  * to 0 and -EBUSY returned.
> >  */
> >
> > We should probably have a lockdep check there then?
> >
> > > >  __get_user_pages+0x6ec/0x16a0 mm/gup.c:1493
> > > >  populate_vma_page_range+0x264/0x330 mm/gup.c:1932
> > > >  __mm_populate+0x27a/0x460 mm/gup.c:2035
> >
> > /*
> >  * __mm_populate - populate and/or mlock pages within a range of addres=
s space.
> >  *
> >  * This is used to implement mlock() and the MAP_POPULATE / MAP_LOCKED =
mmap
> >  * flags. VMAs must be already marked with the desired vm_flags, and
> >  * mmap_lock must not be held.
> >  */
> >
> > What ensures the vma doesn't go away then? - I guess nothing, because i=
t
> > went away.
> >
> > I don't get it.. __mm_populate() must NOT have the mmap_lock, but
> > faultin_page() must hold the mmap_lock...
> >
> > > >  mm_populate include/linux/mm.h:3429 [inline]
> > > >  vm_mmap_pgoff+0x2c3/0x3d0 mm/util.c:593
> > > >  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> > > >  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> > > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > > RIP: 0033:0x7f093ce17fe9
> > > > Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 1d 00 00 90 48 89 f8 4=
8 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01=
 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> > > > RSP: 002b:00007f093cd9e158 EFLAGS: 00000246 ORIG_RAX: 0000000000000=
009
> > > > RAX: ffffffffffffffda RBX: 00007f093ce9f4b8 RCX: 00007f093ce17fe9
> > > > RDX: 0000000000000002 RSI: 0000000000b36000 RDI: 0000000020000000
> > > > RBP: 00007f093ce9f4b0 R08: 00000000ffffffff R09: 0000000000000000
> > > > R10: 0000000000008031 R11: 0000000000000246 R12: 00007f093ce9f4bc
> > > > R13: 000000000000006e R14: 00007ffe8008cc30 R15: 00007ffe8008cd18
> > > >  </TASK>
> > > >
> > > > Allocated by task 5235:
> > ...
> >
> > > >
> > > > Freed by task 5237:
> > > >  kasan_save_stack mm/kasan/common.c:47 [inline]
> > > >  kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
> > > >  kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
> > > >  poison_slab_object+0xe0/0x150 mm/kasan/common.c:240
> > > >  __kasan_slab_free+0x37/0x60 mm/kasan/common.c:256
> > > >  kasan_slab_free include/linux/kasan.h:184 [inline]
> > > >  slab_free_hook mm/slub.c:2252 [inline]
> > > >  slab_free mm/slub.c:4473 [inline]
> > > >  kmem_cache_free+0x145/0x350 mm/slub.c:4548
> > > >  rcu_do_batch kernel/rcu/tree.c:2569 [inline]
> > > >  rcu_core+0xafd/0x1830 kernel/rcu/tree.c:2843
> >
> > This seems right.  RCU freeing of a vma here, so that's okay.
> >
> > > >  handle_softirqs+0x2c4/0x970 kernel/softirq.c:554
> > > >  __do_softirq kernel/softirq.c:588 [inline]
> > > >  invoke_softirq kernel/softirq.c:428 [inline]
> > > >  __irq_exit_rcu+0xf4/0x1c0 kernel/softirq.c:637
> > > >  irq_exit_rcu+0x9/0x30 kernel/softirq.c:649
> > > >  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1043=
 [inline]
> > > >  sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:=
1043
> > > >  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idt=
entry.h:702
> > > >
> > > > Last potentially related work creation:
> >
> > Also fine.
> >
> > > >  kasan_save_stack+0x3f/0x60 mm/kasan/common.c:47
> > > >  __kasan_record_aux_stack+0xac/0xc0 mm/kasan/generic.c:541
> > > >  __call_rcu_common kernel/rcu/tree.c:3106 [inline]
> > > >  call_rcu+0x167/0xa70 kernel/rcu/tree.c:3210
> > > >  remove_vma mm/mmap.c:189 [inline]
> > > >  remove_mt mm/mmap.c:2415 [inline]
> > > >  do_vmi_align_munmap+0x155c/0x18c0 mm/mmap.c:2758
> > > >  do_vmi_munmap+0x261/0x2f0 mm/mmap.c:2830
> > > >  mmap_region+0x72f/0x2090 mm/mmap.c:2881
> > > >  do_mmap+0x8f9/0x1010 mm/mmap.c:1468
> > > >  vm_mmap_pgoff+0x1dd/0x3d0 mm/util.c:588
> > > >  ksys_mmap_pgoff+0x544/0x720 mm/mmap.c:1514
> > > >  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> > > >  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> > > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > >
> > > > The buggy address belongs to the object at ffff88802c4719b0
> > > >  which belongs to the cache vm_area_struct of size 184
> >
> > ...
> >
