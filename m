Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6263C4501A
	for <linux-crypto@vger.kernel.org>; Thu, 18 Jul 2024 16:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721319636; cv=none; b=lJwGDx3StowYmUc73EzItSmRM9IP5yJI3zlIuc6n5CNSqD9DVbITxC3hD9l0lJsajb6vKArH8/YGGCzlszJEV6Hk5YFccdnZviLcbQXnLr3iVnICwg7sF35qG9WdDBnPeVLsA9R7RhWFw69Meh63K5hoHNhcjPrBNWMEoYxKOIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721319636; c=relaxed/simple;
	bh=ifhf2kYFXRMfLkteYAM2qV1ZFUhaKrVi+nRvfUetxNI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=Zm49zwUHJ3yolCi7L5jChjipYG3H+dixAUsbdK0Uqfkz1VBgcCEAF8do6Sy2U8j3NRM9wqGkaVBnwrrehdIkBvWYCU5AjYcqiqvuJw8ubtOKR95GQMVGTLNwXpEukj+8gEfqOhOC2p9QQ0RJ4XUnR2JVvitiv0Rq+0zDF0GTnUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uYcRWnw0; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uYcRWnw0"
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-e03caab48a2so761919276.1
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jul 2024 09:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721319633; x=1721924433; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lILN5rf74EY22tXQqLlsA80shtW/3IjUrkRneIFJQHQ=;
        b=uYcRWnw0uMBA/8itKL3V2+aJCNBicYQaZygyUZ+0iXNfaox1IkPLNxzo48Mi1Cjub1
         ivELbE5hJuIYeyqjZ6j94ud8SK6ySHnbKNlGdEFyQL0qXs2AVsPyBjQpgnfzN4U/52Id
         i5I97okoBnkjkh6TF3zxY9PrBaD1wbvxcsohdGjF1YUxEbKKDgqJwt+LTIHzl8umifmb
         kihbnKBYK4rFLZHnS5O+K2s44Cad7HXvBdIlpudK4ZxsjjZx0R4BGgOw6CGP+3MztOE9
         Eg5R3AD0lAAXIRJhq6xV/O2AbO4+yiI7NFvxB7VS6aKvRNrSHd4JDIxa23UQzpPlzJtw
         bwUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721319633; x=1721924433;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lILN5rf74EY22tXQqLlsA80shtW/3IjUrkRneIFJQHQ=;
        b=lr9aO+JvMfHvZ8YuoElreUG+0RT4DNaq20kvlrkGAtthDqGLABEfY527Dh3VUjZqOd
         P8ck6NsuEJONDRIa6xUvS1De4oWgwB549tF/1aCUwzqXeXDkWkoM2fuKkKmXjUvslTFK
         V2YLokjP7NKmL32yXFsqRk8pGYQ+CQQ/9mMN+EpZLzWoBvOttk3ZNtc1lnurA5svXE67
         8OAodM8D0Bg1Dm61WJnqF0iBK3Ft/T2CD7Sj9ebd91ucBRVa56PrWKNdTCnSe5c+Nlss
         m5HmO6gNR1mwH4RRT/GzLpXPQb0W+VoIMAvqOSoA/rowJSbYbpe8pfZF8xBvcmF244X0
         y9jA==
X-Forwarded-Encrypted: i=1; AJvYcCX4AV+K8f9BHGKArUZyARvlXL9R1KnHXtfIPNpar7mPAhLP37c2zzgIQUuR4VUK36PslL2bUF3xHrcc7h0Yx3yTy//5hcZNJ6OkvaF+
X-Gm-Message-State: AOJu0YwXhmuYyKkQh9TTzHLJaJrvOhzvNSDEMkA2141EBJhGjlSia1tj
	+CWd1Znb0KaR7eLnEZ/LxbtNtSa6pRCSqtKHMzw/JZQ8l/pjw9artdLPxytGa09B2mcjDhIoCN5
	ro0O2NQi/ygiKaWzz97XqYqFv9seleuNjJfTt
X-Google-Smtp-Source: AGHT+IG1XNLMtQBmGGne/pYbSYHfyNzb3xFbD8Ml/G5pMbaMDV3lm+sV9cS8QLiXNUyQc8Ei64Vg66xPh8v0AAqJWhc=
X-Received: by 2002:a25:26d0:0:b0:e03:a1fc:d086 with SMTP id
 3f1490d57ef6-e05ff1a7010mr2575666276.3.1721319632840; Thu, 18 Jul 2024
 09:20:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <00000000000037cdb0061d5924b3@google.com> <46f44064-255b-4a1e-9317-f4b168706d65@kernel.org>
 <flthie3lmh4ovhlullgz2rsd5yfmwwfuqd76yef7xa2ncpqs4j@dxvhd64eoa7t>
In-Reply-To: <flthie3lmh4ovhlullgz2rsd5yfmwwfuqd76yef7xa2ncpqs4j@dxvhd64eoa7t>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 18 Jul 2024 16:20:17 +0000
Message-ID: <CAJuCfpEX7JFbWbLT0w+nyKz-m87ccuzSoorB3PfnW82mA-nFfw@mail.gmail.com>
Subject: Re: [syzbot] [crypto?] KASAN: slab-use-after-free Read in handle_mm_fault
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	syzbot <syzbot+4c882a4a0697c4a25364@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, 
	Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 18, 2024 at 3:43=E2=80=AFPM Liam R. Howlett <Liam.Howlett@oracl=
e.com> wrote:
>
> * Vlastimil Babka (SUSE) <vbabka@kernel.org> [240718 07:00]:
> > On 7/16/24 10:29 AM, syzbot wrote:
> > > Hello,
> >
> > dunno about the [crypto?] parts, sounds rather something for Suren or L=
iam
> > or maybe it's due to some changes to gup?
>
> Yes, that crypto part is very odd.
>
> >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    3fe121b62282 Add linux-next specific files for 202407=
12
> > > git tree:       linux-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D1097ebed9=
80000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D98dd8c4ba=
b5cdce
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=3D4c882a4a069=
7c4a25364
> > > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for=
 Debian) 2.40
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D11d611a=
5980000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D13ce32599=
80000
> > >
> > > Downloadable assets:
> > > disk image: https://storage.googleapis.com/syzbot-assets/8c6fbf69718d=
/disk-3fe121b6.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/39fc7e43dfc1/vm=
linux-3fe121b6.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/0a78e70e4b=
4e/bzImage-3fe121b6.xz
> > > mounted in repro: https://storage.googleapis.com/syzbot-assets/66cfe5=
a679f2/mount_0.gz
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> > > Reported-by: syzbot+4c882a4a0697c4a25364@syzkaller.appspotmail.com
> > >
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > BUG: KASAN: slab-use-after-free in handle_mm_fault+0x14f0/0x19a0 mm/m=
emory.c:5842
> > > Read of size 8 at addr ffff88802c4719d0 by task syz-executor125/5235
> > >
> > > CPU: 1 UID: 0 PID: 5235 Comm: syz-executor125 Not tainted 6.10.0-rc7-=
next-20240712-syzkaller #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BI=
OS Google 06/07/2024
> > > Call Trace:
> > >  <TASK>
> > >  __dump_stack lib/dump_stack.c:94 [inline]
> > >  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
> > >  print_address_description mm/kasan/report.c:377 [inline]
> > >  print_report+0x169/0x550 mm/kasan/report.c:488
> > >  kasan_report+0x143/0x180 mm/kasan/report.c:601
> > >  handle_mm_fault+0x14f0/0x19a0 mm/memory.c:5842
>
> /*
>  * By the time we get here, we already hold the mm semaphore
>  *
>  * The mmap_lock may have been released depending on flags and our
>  * return value.  See filemap_fault() and __folio_lock_or_retry().
>  */
>
> Somehow we are here without an RCU or mmap_lock held?

I'm guessing we did enter handle_mm_fault() with mmap_lock held but
__handle_mm_fault() dropped it before returning, see the comment for
__handle_mm_fault():

/*
 * On entry, we hold either the VMA lock or the mmap_lock
 * (FAULT_FLAG_VMA_LOCK tells you which).  If VM_FAULT_RETRY is set in
 * the result, the mmap_lock is not held on exit.  See filemap_fault()
 * and __folio_lock_or_retry().
 */

So after that there is nothing that guarantees VMA is not destroyed
from under us and if (vma->vm_flags & VM_DROPPABLE) check is unsafe.
Hillf's suggestion should fix this issue but we need to figure out how
to make this path more robust. Currently it's very easy to make a
similar mistake. Maybe a WARNING comment after __handle_mm_fault()
that VMA might be unstable after that function and should not be used?

>
> > >  faultin_page mm/gup.c:1194 [inline]
>
> /*
>  * mmap_lock must be held on entry.  If @flags has FOLL_UNLOCKABLE but no=
t
>  * FOLL_NOWAIT, the mmap_lock may be released.  If it is, *@locked will b=
e set
>  * to 0 and -EBUSY returned.
>  */
>
> We should probably have a lockdep check there then?
>
> > >  __get_user_pages+0x6ec/0x16a0 mm/gup.c:1493
> > >  populate_vma_page_range+0x264/0x330 mm/gup.c:1932
> > >  __mm_populate+0x27a/0x460 mm/gup.c:2035
>
> /*
>  * __mm_populate - populate and/or mlock pages within a range of address =
space.
>  *
>  * This is used to implement mlock() and the MAP_POPULATE / MAP_LOCKED mm=
ap
>  * flags. VMAs must be already marked with the desired vm_flags, and
>  * mmap_lock must not be held.
>  */
>
> What ensures the vma doesn't go away then? - I guess nothing, because it
> went away.
>
> I don't get it.. __mm_populate() must NOT have the mmap_lock, but
> faultin_page() must hold the mmap_lock...
>
> > >  mm_populate include/linux/mm.h:3429 [inline]
> > >  vm_mmap_pgoff+0x2c3/0x3d0 mm/util.c:593
> > >  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> > >  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > RIP: 0033:0x7f093ce17fe9
> > > Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 1d 00 00 90 48 89 f8 48 =
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f=
0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> > > RSP: 002b:00007f093cd9e158 EFLAGS: 00000246 ORIG_RAX: 000000000000000=
9
> > > RAX: ffffffffffffffda RBX: 00007f093ce9f4b8 RCX: 00007f093ce17fe9
> > > RDX: 0000000000000002 RSI: 0000000000b36000 RDI: 0000000020000000
> > > RBP: 00007f093ce9f4b0 R08: 00000000ffffffff R09: 0000000000000000
> > > R10: 0000000000008031 R11: 0000000000000246 R12: 00007f093ce9f4bc
> > > R13: 000000000000006e R14: 00007ffe8008cc30 R15: 00007ffe8008cd18
> > >  </TASK>
> > >
> > > Allocated by task 5235:
> ...
>
> > >
> > > Freed by task 5237:
> > >  kasan_save_stack mm/kasan/common.c:47 [inline]
> > >  kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
> > >  kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
> > >  poison_slab_object+0xe0/0x150 mm/kasan/common.c:240
> > >  __kasan_slab_free+0x37/0x60 mm/kasan/common.c:256
> > >  kasan_slab_free include/linux/kasan.h:184 [inline]
> > >  slab_free_hook mm/slub.c:2252 [inline]
> > >  slab_free mm/slub.c:4473 [inline]
> > >  kmem_cache_free+0x145/0x350 mm/slub.c:4548
> > >  rcu_do_batch kernel/rcu/tree.c:2569 [inline]
> > >  rcu_core+0xafd/0x1830 kernel/rcu/tree.c:2843
>
> This seems right.  RCU freeing of a vma here, so that's okay.
>
> > >  handle_softirqs+0x2c4/0x970 kernel/softirq.c:554
> > >  __do_softirq kernel/softirq.c:588 [inline]
> > >  invoke_softirq kernel/softirq.c:428 [inline]
> > >  __irq_exit_rcu+0xf4/0x1c0 kernel/softirq.c:637
> > >  irq_exit_rcu+0x9/0x30 kernel/softirq.c:649
> > >  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1043 [=
inline]
> > >  sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:10=
43
> > >  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idten=
try.h:702
> > >
> > > Last potentially related work creation:
>
> Also fine.
>
> > >  kasan_save_stack+0x3f/0x60 mm/kasan/common.c:47
> > >  __kasan_record_aux_stack+0xac/0xc0 mm/kasan/generic.c:541
> > >  __call_rcu_common kernel/rcu/tree.c:3106 [inline]
> > >  call_rcu+0x167/0xa70 kernel/rcu/tree.c:3210
> > >  remove_vma mm/mmap.c:189 [inline]
> > >  remove_mt mm/mmap.c:2415 [inline]
> > >  do_vmi_align_munmap+0x155c/0x18c0 mm/mmap.c:2758
> > >  do_vmi_munmap+0x261/0x2f0 mm/mmap.c:2830
> > >  mmap_region+0x72f/0x2090 mm/mmap.c:2881
> > >  do_mmap+0x8f9/0x1010 mm/mmap.c:1468
> > >  vm_mmap_pgoff+0x1dd/0x3d0 mm/util.c:588
> > >  ksys_mmap_pgoff+0x544/0x720 mm/mmap.c:1514
> > >  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> > >  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > >
> > > The buggy address belongs to the object at ffff88802c4719b0
> > >  which belongs to the cache vm_area_struct of size 184
>
> ...
>
