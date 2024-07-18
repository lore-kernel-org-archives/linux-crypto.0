Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7605B13C3E6
	for <linux-crypto@vger.kernel.org>; Thu, 18 Jul 2024 16:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721321375; cv=none; b=J4X5d0B7A2UKLPbr+BE4jOXyeVeY72+sgvKaNgVVFZdneVyGc3TQK+yZSTcCvmIpA1ADFwgF8FDq9Rokc2Z80NvSKjUyL22hXoNCJhgpfCRXE80K6N1LL3uNN+t2g/24Zo6tp8ucE+3ecrbYRei1huQy1AJt88jX9TWm1LxCOc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721321375; c=relaxed/simple;
	bh=nVNCbjdzFsWWbzorkn5xrK7/8mXxriF07L/cD5E8yxI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZdMBMEFR4jOdDZpiAANm8gOvokK6wIlVXyR+dafkoyAu5HviIv/X74x8Gctrw1V1VThdI6Kq/qzWihm6Jg1BLgCn8dOm8wvtZRy4N9TSq3zeWIy1VQ4RJZv0q9+Cr9me9CmPffY8B0l8+gilDWqhR+HGCm6DKap/iEzRuYqlK2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ub2YOAKA; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ub2YOAKA"
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e05ef3aefcfso965713276.2
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jul 2024 09:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721321372; x=1721926172; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZkZH2FYoDVOzEAvUwq5XuX+scAvrug+/FBbJphKQO3U=;
        b=Ub2YOAKArnbwZJOSZkliaiBM9NGEBVoT59jujK3rWpH1rOeud+lYy/R4oX/v8U/W95
         XcHrIlCBMc0VwLfnn+HX3Q/VGjiJrQm10OpAETz2OD4SsJJ3kSSD9Tv9Y2lft1i1mZ9y
         0ilPQ3thKY5eqfezaAQQf7OJUWf3pZMKEqALtNs0mod0GoseXnGHggvXj+LSEZWBYZbO
         aTrrp8DXaI2zYIsTiigCpEteu6wWW35BK36qa2FbErcvq0olRl/MQE5KZa3pxsbGUxhQ
         HnkITgT8i2PuuzyuxvXe7VX8UUA9RdP4qEljp5bApsF7qWKHuBsv0lGJFicXTJI6Rv+g
         FAYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721321372; x=1721926172;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZkZH2FYoDVOzEAvUwq5XuX+scAvrug+/FBbJphKQO3U=;
        b=dq0XIeKIB3fd1lJ3cfgvCDnbktkwS6GBAP/lJKM1Cv4WKnlkpi0ecO+g5YqkwsSqej
         4GQefMHbnJBwktTEGauz5YzcJGLVIYfiLXuRyt09XBBL3BOWT302AlH7/kdD2g28q9Bj
         kGDdCEEhog8dz9Tqwqs8s4XTlKlS1mTF3PYvV2gN++lJ9WNSnSLYJeNOO+FfylyTFfB6
         GdmofHgHKYitIiKcUgVcgjxUpGTb/aLM3w9v/16SMHCFfaaz/89xf0WJFpHfnerskGpr
         jayTUyEryBJAvfCzmvLQp3Z8MedPXdcCry/wfiVDoIaz5uelHOCt982cXv+8Qy1WuL8H
         4I9A==
X-Forwarded-Encrypted: i=1; AJvYcCX7xZMXY5B5BhaAOWBLwRkBQFgCKYKvjM3Kt9a603/GlvxXmQiUXfedAm5KxE3qFD0sWws0QO48h+ut/ugcQBXCL5WH9ipZ6pzH2aqK
X-Gm-Message-State: AOJu0YyLFKSUH8eml4/IRh89cW2v6+u7zsLkeknoSD1yFrvufXRDrt0F
	4ywowqK4bK9golqOq2oQ/Jx0f/P1qcQwSMK4l2QqynYCL0uhcSIm4dc+MwL2iDr543FXNHvS//2
	XSfWULguN3UV/AZVvudFDA7Ery4g8m8IoiC5/
X-Google-Smtp-Source: AGHT+IEpvltijk6evqDJoq94UChM5YTgvvy6ILts2O1q38N109QkAR78Yxtbz/O3Co1rYWU4XgsHUftmxubfhsZWJfg=
X-Received: by 2002:a05:6902:11c1:b0:e03:9a95:bc78 with SMTP id
 3f1490d57ef6-e05ed722c7cmr5882551276.36.1721321372149; Thu, 18 Jul 2024
 09:49:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <00000000000037cdb0061d5924b3@google.com> <46f44064-255b-4a1e-9317-f4b168706d65@kernel.org>
 <flthie3lmh4ovhlullgz2rsd5yfmwwfuqd76yef7xa2ncpqs4j@dxvhd64eoa7t>
 <CAJuCfpEX7JFbWbLT0w+nyKz-m87ccuzSoorB3PfnW82mA-nFfw@mail.gmail.com>
 <CAJuCfpEGATSeybdVNnUW5eS5EKHF00VzxHGwKoMfPiS_QRiKbQ@mail.gmail.com>
 <ZplEgwFFb0LAXbH4@zx2c4.com> <CAJuCfpG07s2jcsgT3EE85B_JGWY2B23n+iPhVWP6amgZgSHi3w@mail.gmail.com>
 <CAHmME9pjUJKTtYz10ULrWYBCB3LUCG77aNFz_n7uBvyddOge6Q@mail.gmail.com>
In-Reply-To: <CAHmME9pjUJKTtYz10ULrWYBCB3LUCG77aNFz_n7uBvyddOge6Q@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 18 Jul 2024 09:49:21 -0700
Message-ID: <CAJuCfpEQQ4dKOwS8a9dRgwWtqR7LyKMx2Qr8vjaBu=CM4dNSCw@mail.gmail.com>
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

On Thu, Jul 18, 2024 at 9:44=E2=80=AFAM Jason A. Donenfeld <Jason@zx2c4.com=
> wrote:
>
> On Thu, Jul 18, 2024 at 6:42=E2=80=AFPM Suren Baghdasaryan <surenb@google=
.com> wrote:
> >
> > On Thu, Jul 18, 2024 at 4:36=E2=80=AFPM Jason A. Donenfeld <Jason@zx2c4=
.com> wrote:
> > >
> > > On Thu, Jul 18, 2024 at 04:23:47PM +0000, Suren Baghdasaryan wrote:
> > > > On Thu, Jul 18, 2024 at 4:20=E2=80=AFPM Suren Baghdasaryan <surenb@=
google.com> wrote:
> > > > >
> > > > > On Thu, Jul 18, 2024 at 3:43=E2=80=AFPM Liam R. Howlett <Liam.How=
lett@oracle.com> wrote:
> > > > > >
> > > > > > * Vlastimil Babka (SUSE) <vbabka@kernel.org> [240718 07:00]:
> > > > > > > On 7/16/24 10:29 AM, syzbot wrote:
> > > > > > > > Hello,
> > > > > > >
> > > > > > > dunno about the [crypto?] parts, sounds rather something for =
Suren or Liam
> > > > > > > or maybe it's due to some changes to gup?
> > > > > >
> > > > > > Yes, that crypto part is very odd.
> > > > > >
> > > > > > >
> > > > > > > > syzbot found the following issue on:
> > > > > > > >
> > > > > > > > HEAD commit:    3fe121b62282 Add linux-next specific files =
for 20240712
> > > > > > > > git tree:       linux-next
> > > > > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=
=3D1097ebed980000
> > > > > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=
=3D98dd8c4bab5cdce
> > > > > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=3D4=
c882a4a0697c4a25364
> > > > > > > > compiler:       Debian clang version 15.0.6, GNU ld (GNU Bi=
nutils for Debian) 2.40
> > > > > > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=
=3D11d611a5980000
> > > > > > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=
=3D13ce3259980000
> > > > > > > >
> > > > > > > > Downloadable assets:
> > > > > > > > disk image: https://storage.googleapis.com/syzbot-assets/8c=
6fbf69718d/disk-3fe121b6.raw.xz
> > > > > > > > vmlinux: https://storage.googleapis.com/syzbot-assets/39fc7=
e43dfc1/vmlinux-3fe121b6.xz
> > > > > > > > kernel image: https://storage.googleapis.com/syzbot-assets/=
0a78e70e4b4e/bzImage-3fe121b6.xz
> > > > > > > > mounted in repro: https://storage.googleapis.com/syzbot-ass=
ets/66cfe5a679f2/mount_0.gz
> > > > > > > >
> > > > > > > > IMPORTANT: if you fix the issue, please add the following t=
ag to the commit:
> > > > > > > > Reported-by: syzbot+4c882a4a0697c4a25364@syzkaller.appspotm=
ail.com
> > > > > > > >
> > > > > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > > > > BUG: KASAN: slab-use-after-free in handle_mm_fault+0x14f0/0=
x19a0 mm/memory.c:5842
> > > > > > > > Read of size 8 at addr ffff88802c4719d0 by task syz-executo=
r125/5235
> > > > > > > >
> > > > > > > > CPU: 1 UID: 0 PID: 5235 Comm: syz-executor125 Not tainted 6=
.10.0-rc7-next-20240712-syzkaller #0
> > > > > > > > Hardware name: Google Google Compute Engine/Google Compute =
Engine, BIOS Google 06/07/2024
> > > > > > > > Call Trace:
> > > > > > > >  <TASK>
> > > > > > > >  __dump_stack lib/dump_stack.c:94 [inline]
> > > > > > > >  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
> > > > > > > >  print_address_description mm/kasan/report.c:377 [inline]
> > > > > > > >  print_report+0x169/0x550 mm/kasan/report.c:488
> > > > > > > >  kasan_report+0x143/0x180 mm/kasan/report.c:601
> > > > > > > >  handle_mm_fault+0x14f0/0x19a0 mm/memory.c:5842
> > > > > >
> > > > > > /*
> > > > > >  * By the time we get here, we already hold the mm semaphore
> > > > > >  *
> > > > > >  * The mmap_lock may have been released depending on flags and =
our
> > > > > >  * return value.  See filemap_fault() and __folio_lock_or_retry=
().
> > > > > >  */
> > > > > >
> > > > > > Somehow we are here without an RCU or mmap_lock held?
> > > > >
> > > > > I'm guessing we did enter handle_mm_fault() with mmap_lock held b=
ut
> > > > > __handle_mm_fault() dropped it before returning, see the comment =
for
> > > > > __handle_mm_fault():
> > > > >
> > > > > /*
> > > > >  * On entry, we hold either the VMA lock or the mmap_lock
> > > > >  * (FAULT_FLAG_VMA_LOCK tells you which).  If VM_FAULT_RETRY is s=
et in
> > > > >  * the result, the mmap_lock is not held on exit.  See filemap_fa=
ult()
> > > > >  * and __folio_lock_or_retry().
> > > > >  */
> > > > >
> > > > > So after that there is nothing that guarantees VMA is not destroy=
ed
> > > > > from under us and if (vma->vm_flags & VM_DROPPABLE) check is unsa=
fe.
> > > > > Hillf's suggestion should fix this issue but we need to figure ou=
t how
> > > > > to make this path more robust. Currently it's very easy to make a
> > > > > similar mistake. Maybe a WARNING comment after __handle_mm_fault(=
)
> > > > > that VMA might be unstable after that function and should not be =
used?
> > > >
> > > > CC'ing Jason.
> > >
> > > Thanks for bringing this to my attention. I'll incorporate Hillf's pa=
tch
> > > and also add a comment as you suggested. Something like the below?
> > >
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index 18fe893ce96d..f596a8d508ef 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -5660,6 +5660,7 @@ vm_fault_t handle_mm_fault(struct vm_area_struc=
t *vma, unsigned long address,
> > >         /* If the fault handler drops the mmap_lock, vma may be freed=
 */
> > >         struct mm_struct *mm =3D vma->vm_mm;
> > >         vm_fault_t ret;
> > > +       bool is_droppable;
> > >
> > >         __set_current_state(TASK_RUNNING);
> > >
> > > @@ -5674,6 +5675,8 @@ vm_fault_t handle_mm_fault(struct vm_area_struc=
t *vma, unsigned long address,
> > >                 goto out;
> > >         }
> > >
> > > +       is_droppable =3D !!(vma->vm_flags & VM_DROPPABLE);
> > > +
> > >         /*
> > >          * Enable the memcg OOM handling for faults triggered in user
> > >          * space.  Kernel faults are handled more gracefully.
> > > @@ -5688,10 +5691,15 @@ vm_fault_t handle_mm_fault(struct vm_area_str=
uct *vma, unsigned long address,
> > >         else
> > >                 ret =3D __handle_mm_fault(vma, address, flags);
> > >
> > > +       /*
> > > +        * It is no longer safe to dereference vma-> after this point=
, as
> > > +        * __handle_mm_fault may have already destroyed it.
> >
> > __handle_mm_fault does not really destroy the vma. It might drop
> > mmap_lock and another task might destroy it from under us.
>
> Err, right. Okay, wording time:
>
> > Warning: It is no longer safe to dereference vma-> after this point, be=
cause mmap_lock is dropped, so vma might be destroyed from underneath us.

Better but I would change "mmap_lock is dropped" to "mmap_lock might
have been dropped by __handle_mm_fault()" because mmap_lock is not
always dropped by __handle_mm_fault(). Technicality but better be
clear about it.
With that changed feel free to add:

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> How about that?
