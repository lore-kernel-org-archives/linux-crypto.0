Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025F72837D
	for <linux-crypto@vger.kernel.org>; Thu, 18 Jul 2024 16:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721320976; cv=none; b=ROz1fIcxVgLog9rEKuZF6GCOq+7e+RKDrVCu72ehQDlWwLrm/cyxFdLnDnT02gzQ/9nr4BSISILAbu3sjVUpkZLgw1QGjM20yuMJ9OlD2lmPQZePaP2hG9vCkZsYQMZxPDEqd5VuRxm/g84b6+woJWBj716wg9rsJIJGDeMijzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721320976; c=relaxed/simple;
	bh=Z4DGzv2Nr6sgtMWqry15J/1mPi8Sy4eYGPSZXIgGgi0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EavYHMMJh9mTi39mYAI7393vmRf+KK2zd//7JVhtHTsgj5su2Syxsn4gTsjpQZDjlDxG4BTysY3MJTA6Ed5KWJDFKs0HQ9gDMFqLqofnGMq0dCqDOtnN4Vx5zMIVs2Rw65Hw0IdUwQFg988t0HRBpplAwmoXfYO+L9nZQ+CSrlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c+ShKx1T; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c+ShKx1T"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-663dd13c0bbso10840947b3.1
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jul 2024 09:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721320974; x=1721925774; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cI2QPhNVp09Qr9l9jfhIeKemivTmvklc7dGwXzlD48Y=;
        b=c+ShKx1TFTrd8lF+DmBBm8hoebHHXtnovUYWvAU4Ke5QF5F2gXLV7u6J4FX8+j1/f6
         NwHMACS9KwoUtltzaFEidJgvbiEXJWDvoHui4buKmxS8SQHxdhWVfkeaqKKO/G9QLQLP
         iwSxDW8hHB58oI+ctWtwGWSlZ/4wGPa1L74+DSMujRBmHnejvAA9hXkxMY1IjlARsp5U
         sn/yZHtFKsQQJgnVX+VP2YFJf1YurslJ+Lpq0UL8BtK4cUIE4LP5QwPVhd1bQ6dPp4P+
         XfQcu2upBAMUJPGhcrkmUcgJWFSkodv1tBDJzAKlZfmGQPcB/OZdZBktLkATeq2NYbWj
         T+IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721320974; x=1721925774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cI2QPhNVp09Qr9l9jfhIeKemivTmvklc7dGwXzlD48Y=;
        b=UghCsw5ZFPKbUELSsE0gN4/vblY7OkfrLGPEWtJR10AOhkn+Wixy1cOSAzXB35M+tA
         J92vFYKs0XZE10Dw6glE8zqQV7QDIajR922Z1mR37d4tjDDGaGTw9wUt2GRQojO+B+93
         7H/WouMhCD2Pd2WJ/cuEXXNxI4K3ynSkpNmHAZz8xKh826/k2OiKa+pK0S7ULCyqR2tZ
         Vh4hr288QrWpoPCxWAjAtmo+QtXX3cLqSJ+pNaC6SUINGCfg/oDvx8g5mcnLYRZzQ02a
         p672Zg4qZvIijinOjLOD1PH56KQe1QaG6tYfv4onoweu+FnnVKfAr/ZDg28r6weLw3K9
         bK4A==
X-Forwarded-Encrypted: i=1; AJvYcCV58WzBBSDHKzNvjWSMw6Xo3GNC475RCRZY/pGtGz4oZyiMuOpruvUMg54ynN3Tf2R1oSP10oYug1KwZukmEiNK8bWi9Tzowkm4tv3u
X-Gm-Message-State: AOJu0YyiIgcmDM/YdvYB5myuAAMCBVUNWQNB1nf0wAvmyc6zV2Lu80/3
	hTi+PFNn1CVVvTiTMpN5BWTqasO11N3C34FuAhxNbXQT25O8+gGv6YZE4SLIEwvcLy7tMuA58EV
	XC99iNZTvt8A/lYzmnTXhYwDkS648J0mguEua
X-Google-Smtp-Source: AGHT+IHEJYW9btAxJlFZwTEwgi6lSq+MyoaQR3zPqdN7fqmKx+jYCgqfJVax8uuyuwp2beK5Tnha6wBy5+UlK8FV394=
X-Received: by 2002:a81:8b50:0:b0:62f:67b4:790c with SMTP id
 00721157ae682-666a1c1ca30mr28650117b3.14.1721320973534; Thu, 18 Jul 2024
 09:42:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <00000000000037cdb0061d5924b3@google.com> <46f44064-255b-4a1e-9317-f4b168706d65@kernel.org>
 <flthie3lmh4ovhlullgz2rsd5yfmwwfuqd76yef7xa2ncpqs4j@dxvhd64eoa7t>
 <CAJuCfpEX7JFbWbLT0w+nyKz-m87ccuzSoorB3PfnW82mA-nFfw@mail.gmail.com>
 <CAJuCfpEGATSeybdVNnUW5eS5EKHF00VzxHGwKoMfPiS_QRiKbQ@mail.gmail.com> <ZplEgwFFb0LAXbH4@zx2c4.com>
In-Reply-To: <ZplEgwFFb0LAXbH4@zx2c4.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 18 Jul 2024 16:42:39 +0000
Message-ID: <CAJuCfpG07s2jcsgT3EE85B_JGWY2B23n+iPhVWP6amgZgSHi3w@mail.gmail.com>
Subject: Re: [syzbot] [crypto?] KASAN: slab-use-after-free Read in handle_mm_fault
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	syzbot <syzbot+4c882a4a0697c4a25364@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 18, 2024 at 4:36=E2=80=AFPM Jason A. Donenfeld <Jason@zx2c4.com=
> wrote:
>
> On Thu, Jul 18, 2024 at 04:23:47PM +0000, Suren Baghdasaryan wrote:
> > On Thu, Jul 18, 2024 at 4:20=E2=80=AFPM Suren Baghdasaryan <surenb@goog=
le.com> wrote:
> > >
> > > On Thu, Jul 18, 2024 at 3:43=E2=80=AFPM Liam R. Howlett <Liam.Howlett=
@oracle.com> wrote:
> > > >
> > > > * Vlastimil Babka (SUSE) <vbabka@kernel.org> [240718 07:00]:
> > > > > On 7/16/24 10:29 AM, syzbot wrote:
> > > > > > Hello,
> > > > >
> > > > > dunno about the [crypto?] parts, sounds rather something for Sure=
n or Liam
> > > > > or maybe it's due to some changes to gup?
> > > >
> > > > Yes, that crypto part is very odd.
> > > >
> > > > >
> > > > > > syzbot found the following issue on:
> > > > > >
> > > > > > HEAD commit:    3fe121b62282 Add linux-next specific files for =
20240712
> > > > > > git tree:       linux-next
> > > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D109=
7ebed980000
> > > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D98d=
d8c4bab5cdce
> > > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=3D4c882=
a4a0697c4a25364
> > > > > > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binuti=
ls for Debian) 2.40
> > > > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1=
1d611a5980000
> > > > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D13c=
e3259980000
> > > > > >
> > > > > > Downloadable assets:
> > > > > > disk image: https://storage.googleapis.com/syzbot-assets/8c6fbf=
69718d/disk-3fe121b6.raw.xz
> > > > > > vmlinux: https://storage.googleapis.com/syzbot-assets/39fc7e43d=
fc1/vmlinux-3fe121b6.xz
> > > > > > kernel image: https://storage.googleapis.com/syzbot-assets/0a78=
e70e4b4e/bzImage-3fe121b6.xz
> > > > > > mounted in repro: https://storage.googleapis.com/syzbot-assets/=
66cfe5a679f2/mount_0.gz
> > > > > >
> > > > > > IMPORTANT: if you fix the issue, please add the following tag t=
o the commit:
> > > > > > Reported-by: syzbot+4c882a4a0697c4a25364@syzkaller.appspotmail.=
com
> > > > > >
> > > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > > BUG: KASAN: slab-use-after-free in handle_mm_fault+0x14f0/0x19a=
0 mm/memory.c:5842
> > > > > > Read of size 8 at addr ffff88802c4719d0 by task syz-executor125=
/5235
> > > > > >
> > > > > > CPU: 1 UID: 0 PID: 5235 Comm: syz-executor125 Not tainted 6.10.=
0-rc7-next-20240712-syzkaller #0
> > > > > > Hardware name: Google Google Compute Engine/Google Compute Engi=
ne, BIOS Google 06/07/2024
> > > > > > Call Trace:
> > > > > >  <TASK>
> > > > > >  __dump_stack lib/dump_stack.c:94 [inline]
> > > > > >  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
> > > > > >  print_address_description mm/kasan/report.c:377 [inline]
> > > > > >  print_report+0x169/0x550 mm/kasan/report.c:488
> > > > > >  kasan_report+0x143/0x180 mm/kasan/report.c:601
> > > > > >  handle_mm_fault+0x14f0/0x19a0 mm/memory.c:5842
> > > >
> > > > /*
> > > >  * By the time we get here, we already hold the mm semaphore
> > > >  *
> > > >  * The mmap_lock may have been released depending on flags and our
> > > >  * return value.  See filemap_fault() and __folio_lock_or_retry().
> > > >  */
> > > >
> > > > Somehow we are here without an RCU or mmap_lock held?
> > >
> > > I'm guessing we did enter handle_mm_fault() with mmap_lock held but
> > > __handle_mm_fault() dropped it before returning, see the comment for
> > > __handle_mm_fault():
> > >
> > > /*
> > >  * On entry, we hold either the VMA lock or the mmap_lock
> > >  * (FAULT_FLAG_VMA_LOCK tells you which).  If VM_FAULT_RETRY is set i=
n
> > >  * the result, the mmap_lock is not held on exit.  See filemap_fault(=
)
> > >  * and __folio_lock_or_retry().
> > >  */
> > >
> > > So after that there is nothing that guarantees VMA is not destroyed
> > > from under us and if (vma->vm_flags & VM_DROPPABLE) check is unsafe.
> > > Hillf's suggestion should fix this issue but we need to figure out ho=
w
> > > to make this path more robust. Currently it's very easy to make a
> > > similar mistake. Maybe a WARNING comment after __handle_mm_fault()
> > > that VMA might be unstable after that function and should not be used=
?
> >
> > CC'ing Jason.
>
> Thanks for bringing this to my attention. I'll incorporate Hillf's patch
> and also add a comment as you suggested. Something like the below?
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 18fe893ce96d..f596a8d508ef 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5660,6 +5660,7 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *v=
ma, unsigned long address,
>         /* If the fault handler drops the mmap_lock, vma may be freed */
>         struct mm_struct *mm =3D vma->vm_mm;
>         vm_fault_t ret;
> +       bool is_droppable;
>
>         __set_current_state(TASK_RUNNING);
>
> @@ -5674,6 +5675,8 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *v=
ma, unsigned long address,
>                 goto out;
>         }
>
> +       is_droppable =3D !!(vma->vm_flags & VM_DROPPABLE);
> +
>         /*
>          * Enable the memcg OOM handling for faults triggered in user
>          * space.  Kernel faults are handled more gracefully.
> @@ -5688,10 +5691,15 @@ vm_fault_t handle_mm_fault(struct vm_area_struct =
*vma, unsigned long address,
>         else
>                 ret =3D __handle_mm_fault(vma, address, flags);
>
> +       /*
> +        * It is no longer safe to dereference vma-> after this point, as
> +        * __handle_mm_fault may have already destroyed it.

__handle_mm_fault does not really destroy the vma. It might drop
mmap_lock and another task might destroy it from under us.

> +        */
> +
>         lru_gen_exit_fault();
>
> -       /* If the mapping is droppable, then errors due to OOM aren't fat=
al. */
> -       if (vma->vm_flags & VM_DROPPABLE)
> +       /* If the mapping is is_droppable, then errors due to OOM aren't =
fatal. */
> +       if (is_droppable)
>                 ret &=3D ~VM_FAULT_OOM;
>
>         if (flags & FAULT_FLAG_USER) {
>
