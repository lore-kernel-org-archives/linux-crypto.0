Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F2A286A8;
	Thu, 18 Jul 2024 16:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721321072; cv=none; b=N/VcorLHLoAF+CZqTXBAakwuiUX5zma/tUIu5bIbQUQ/0sM/TinjBQBYKEKvFabX3+2iK1i1tTP5PtQHriQ1ENtxeSE3zJrFzHfq5/oKEY9JMP5RJMFewcmd3Pq6UjvHaLGv4vCSGu+/mQ28KCUYpTLzEOsRMAhxlnl5wpXiwIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721321072; c=relaxed/simple;
	bh=+EAxy4C8S+S7/QyxSWbaJapf6YaXBQeWGLo4h1CstQg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fhfn0zkR3qwImcmyo6soWtaj6L+KDeO1nSQ+zzIh4sFLWvd/HveUZ4OHJChupMfVkIoJJe3nsD0Hu50ySicv4st9TzKeWlhSbsI2KlMRHPpzCCQQ0FOx175sZzHZ2nUXotISOiwdIio1HWF7gP3jhaqIHDpT8eRiMhk+SyJxdnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=cDr1KHmX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="cDr1KHmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061B2C116B1;
	Thu, 18 Jul 2024 16:44:31 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="cDr1KHmX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1721321069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Cz/I5l8dDHXgtyrw2M5Qcxf5ieqvbkUTEBQmBY3X8Y=;
	b=cDr1KHmX57wPBWYPVNH/WI1aufn7GU+cXhBjuEMCNhKZYnsA4lJm80LIXHw8Ldov3mENuc
	tL/r0zTWTMbTp53Q/6nE5caIn7dqsS1X0FyVtwaCnDllxNq9CD10Rf7lv6qsKwkSD6IqCZ
	DZ0HpVydWpx1BPomwCh8Ld3fikLGzQM=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e353161a (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 18 Jul 2024 16:44:28 +0000 (UTC)
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-708e75d8d7cso602120a34.3;
        Thu, 18 Jul 2024 09:44:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUCHOmGYmUZRJXjC9hxDWNaM8d1i1gGN8wi61SKaBEwRCDLz/TDQr03Z9XjT8in811SDQuLGVoyY8kk7A37d3nTLyKU1FSA+osXJWtjGM/+Brng7SIJ0P6e82t95N0+IXgxnVNOraNVF17t
X-Gm-Message-State: AOJu0Yzf0T0j8PWNgs0Z1DA4eaB3sNUoAXgDb+44yd+1JPI5JAyP0idn
	yxa60I8tShUzJMQ4aIR2n1lqsQuJhGB5fZ3MlngddNuEyxWFXnU0LXwqkXBgQh7fu7/kSIWFtY/
	udPn7ybKe2rLGRAuisWITLRxP+44=
X-Google-Smtp-Source: AGHT+IFg2hihQA5p/zfT3BuCQmxcPQIolrcrVrPEEBfqg0oD2VoGvV8EmKoLjLiMH7BaYF+CYsb+tPAyqdXHQ37MeyA=
X-Received: by 2002:a05:6870:b9c3:b0:260:fcca:cf90 with SMTP id
 586e51a60fabf-260fccad748mr1336306fac.2.1721321067207; Thu, 18 Jul 2024
 09:44:27 -0700 (PDT)
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
In-Reply-To: <CAJuCfpG07s2jcsgT3EE85B_JGWY2B23n+iPhVWP6amgZgSHi3w@mail.gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 18 Jul 2024 18:44:15 +0200
X-Gmail-Original-Message-ID: <CAHmME9pjUJKTtYz10ULrWYBCB3LUCG77aNFz_n7uBvyddOge6Q@mail.gmail.com>
Message-ID: <CAHmME9pjUJKTtYz10ULrWYBCB3LUCG77aNFz_n7uBvyddOge6Q@mail.gmail.com>
Subject: Re: [syzbot] [crypto?] KASAN: slab-use-after-free Read in handle_mm_fault
To: Suren Baghdasaryan <surenb@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	syzbot <syzbot+4c882a4a0697c4a25364@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 18, 2024 at 6:42=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Thu, Jul 18, 2024 at 4:36=E2=80=AFPM Jason A. Donenfeld <Jason@zx2c4.c=
om> wrote:
> >
> > On Thu, Jul 18, 2024 at 04:23:47PM +0000, Suren Baghdasaryan wrote:
> > > On Thu, Jul 18, 2024 at 4:20=E2=80=AFPM Suren Baghdasaryan <surenb@go=
ogle.com> wrote:
> > > >
> > > > On Thu, Jul 18, 2024 at 3:43=E2=80=AFPM Liam R. Howlett <Liam.Howle=
tt@oracle.com> wrote:
> > > > >
> > > > > * Vlastimil Babka (SUSE) <vbabka@kernel.org> [240718 07:00]:
> > > > > > On 7/16/24 10:29 AM, syzbot wrote:
> > > > > > > Hello,
> > > > > >
> > > > > > dunno about the [crypto?] parts, sounds rather something for Su=
ren or Liam
> > > > > > or maybe it's due to some changes to gup?
> > > > >
> > > > > Yes, that crypto part is very odd.
> > > > >
> > > > > >
> > > > > > > syzbot found the following issue on:
> > > > > > >
> > > > > > > HEAD commit:    3fe121b62282 Add linux-next specific files fo=
r 20240712
> > > > > > > git tree:       linux-next
> > > > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D1=
097ebed980000
> > > > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D9=
8dd8c4bab5cdce
> > > > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=3D4c8=
82a4a0697c4a25364
> > > > > > > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binu=
tils for Debian) 2.40
> > > > > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=
=3D11d611a5980000
> > > > > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1=
3ce3259980000
> > > > > > >
> > > > > > > Downloadable assets:
> > > > > > > disk image: https://storage.googleapis.com/syzbot-assets/8c6f=
bf69718d/disk-3fe121b6.raw.xz
> > > > > > > vmlinux: https://storage.googleapis.com/syzbot-assets/39fc7e4=
3dfc1/vmlinux-3fe121b6.xz
> > > > > > > kernel image: https://storage.googleapis.com/syzbot-assets/0a=
78e70e4b4e/bzImage-3fe121b6.xz
> > > > > > > mounted in repro: https://storage.googleapis.com/syzbot-asset=
s/66cfe5a679f2/mount_0.gz
> > > > > > >
> > > > > > > IMPORTANT: if you fix the issue, please add the following tag=
 to the commit:
> > > > > > > Reported-by: syzbot+4c882a4a0697c4a25364@syzkaller.appspotmai=
l.com
> > > > > > >
> > > > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > > > BUG: KASAN: slab-use-after-free in handle_mm_fault+0x14f0/0x1=
9a0 mm/memory.c:5842
> > > > > > > Read of size 8 at addr ffff88802c4719d0 by task syz-executor1=
25/5235
> > > > > > >
> > > > > > > CPU: 1 UID: 0 PID: 5235 Comm: syz-executor125 Not tainted 6.1=
0.0-rc7-next-20240712-syzkaller #0
> > > > > > > Hardware name: Google Google Compute Engine/Google Compute En=
gine, BIOS Google 06/07/2024
> > > > > > > Call Trace:
> > > > > > >  <TASK>
> > > > > > >  __dump_stack lib/dump_stack.c:94 [inline]
> > > > > > >  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
> > > > > > >  print_address_description mm/kasan/report.c:377 [inline]
> > > > > > >  print_report+0x169/0x550 mm/kasan/report.c:488
> > > > > > >  kasan_report+0x143/0x180 mm/kasan/report.c:601
> > > > > > >  handle_mm_fault+0x14f0/0x19a0 mm/memory.c:5842
> > > > >
> > > > > /*
> > > > >  * By the time we get here, we already hold the mm semaphore
> > > > >  *
> > > > >  * The mmap_lock may have been released depending on flags and ou=
r
> > > > >  * return value.  See filemap_fault() and __folio_lock_or_retry()=
.
> > > > >  */
> > > > >
> > > > > Somehow we are here without an RCU or mmap_lock held?
> > > >
> > > > I'm guessing we did enter handle_mm_fault() with mmap_lock held but
> > > > __handle_mm_fault() dropped it before returning, see the comment fo=
r
> > > > __handle_mm_fault():
> > > >
> > > > /*
> > > >  * On entry, we hold either the VMA lock or the mmap_lock
> > > >  * (FAULT_FLAG_VMA_LOCK tells you which).  If VM_FAULT_RETRY is set=
 in
> > > >  * the result, the mmap_lock is not held on exit.  See filemap_faul=
t()
> > > >  * and __folio_lock_or_retry().
> > > >  */
> > > >
> > > > So after that there is nothing that guarantees VMA is not destroyed
> > > > from under us and if (vma->vm_flags & VM_DROPPABLE) check is unsafe=
.
> > > > Hillf's suggestion should fix this issue but we need to figure out =
how
> > > > to make this path more robust. Currently it's very easy to make a
> > > > similar mistake. Maybe a WARNING comment after __handle_mm_fault()
> > > > that VMA might be unstable after that function and should not be us=
ed?
> > >
> > > CC'ing Jason.
> >
> > Thanks for bringing this to my attention. I'll incorporate Hillf's patc=
h
> > and also add a comment as you suggested. Something like the below?
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 18fe893ce96d..f596a8d508ef 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -5660,6 +5660,7 @@ vm_fault_t handle_mm_fault(struct vm_area_struct =
*vma, unsigned long address,
> >         /* If the fault handler drops the mmap_lock, vma may be freed *=
/
> >         struct mm_struct *mm =3D vma->vm_mm;
> >         vm_fault_t ret;
> > +       bool is_droppable;
> >
> >         __set_current_state(TASK_RUNNING);
> >
> > @@ -5674,6 +5675,8 @@ vm_fault_t handle_mm_fault(struct vm_area_struct =
*vma, unsigned long address,
> >                 goto out;
> >         }
> >
> > +       is_droppable =3D !!(vma->vm_flags & VM_DROPPABLE);
> > +
> >         /*
> >          * Enable the memcg OOM handling for faults triggered in user
> >          * space.  Kernel faults are handled more gracefully.
> > @@ -5688,10 +5691,15 @@ vm_fault_t handle_mm_fault(struct vm_area_struc=
t *vma, unsigned long address,
> >         else
> >                 ret =3D __handle_mm_fault(vma, address, flags);
> >
> > +       /*
> > +        * It is no longer safe to dereference vma-> after this point, =
as
> > +        * __handle_mm_fault may have already destroyed it.
>
> __handle_mm_fault does not really destroy the vma. It might drop
> mmap_lock and another task might destroy it from under us.

Err, right. Okay, wording time:

> Warning: It is no longer safe to dereference vma-> after this point, beca=
use mmap_lock is dropped, so vma might be destroyed from underneath us.

How about that?
