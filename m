Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7707407A;
	Thu, 18 Jul 2024 16:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721320588; cv=none; b=QedtJqlXYp64PQlaeJXe0+mMrfAoCU81mxUqFack+vnjnvDZqJrGB7ypa0m6JwZna00R0V+FlWVdkHRT2P6BNV1q8UWBrqOlFQI2e9y2Kwz/8cbKorkhBK9mF5ilrhJBfGJRZjbuYDBZ9yBQESbi8GUIqkAOV3EYD87IMDQvIm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721320588; c=relaxed/simple;
	bh=7sZQ1hBzF7alnTKa6InyMxKteYP6n+PfZ2TNT3VFOkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gclDDmVYoT9f3rZrOZ36u5rW+6IetbQ/wPL3JC7P68oIMft2aC/aOLha5gIn5w3EEdnE4FfpIZrPqYykhHP6MEz+/w/QxgMaTaG8o07rbpilENw0c6ZtfAFMYNvXXHJKTAnEbz3nyBolxoFkpY4BrGtSpViYD8ybb2GS5YWiCoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=b+lOCet0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="b+lOCet0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A802FC116B1;
	Thu, 18 Jul 2024 16:36:26 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="b+lOCet0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1721320584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bix84t35gXtRPYkty3QSaB5g/cT04qbn9fpRULI+1f0=;
	b=b+lOCet0lIq3w4Oyk5bxv+krjhI3wODYAsyh39cH4X//DeNImfSsa3mIixA88UMTL608qJ
	nSCPGRJPP2rIrMAIZNCzX7Pf8kF1MapKBrRwYXPI+eeYFTfUaF+sGtzCAY/RKUMqLzcseI
	mxc1guzbyWiBeSwT+Kfu/AbodPwoF1o=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ff761e3f (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 18 Jul 2024 16:36:22 +0000 (UTC)
Date: Thu, 18 Jul 2024 18:36:19 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	syzbot <syzbot+4c882a4a0697c4a25364@syzkaller.appspotmail.com>,
	akpm@linux-foundation.org, davem@davemloft.net,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	syzkaller-bugs@googlegroups.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [syzbot] [crypto?] KASAN: slab-use-after-free Read in
 handle_mm_fault
Message-ID: <ZplEgwFFb0LAXbH4@zx2c4.com>
References: <00000000000037cdb0061d5924b3@google.com>
 <46f44064-255b-4a1e-9317-f4b168706d65@kernel.org>
 <flthie3lmh4ovhlullgz2rsd5yfmwwfuqd76yef7xa2ncpqs4j@dxvhd64eoa7t>
 <CAJuCfpEX7JFbWbLT0w+nyKz-m87ccuzSoorB3PfnW82mA-nFfw@mail.gmail.com>
 <CAJuCfpEGATSeybdVNnUW5eS5EKHF00VzxHGwKoMfPiS_QRiKbQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpEGATSeybdVNnUW5eS5EKHF00VzxHGwKoMfPiS_QRiKbQ@mail.gmail.com>

On Thu, Jul 18, 2024 at 04:23:47PM +0000, Suren Baghdasaryan wrote:
> On Thu, Jul 18, 2024 at 4:20 PM Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > On Thu, Jul 18, 2024 at 3:43 PM Liam R. Howlett <Liam.Howlett@oracle.com> wrote:
> > >
> > > * Vlastimil Babka (SUSE) <vbabka@kernel.org> [240718 07:00]:
> > > > On 7/16/24 10:29 AM, syzbot wrote:
> > > > > Hello,
> > > >
> > > > dunno about the [crypto?] parts, sounds rather something for Suren or Liam
> > > > or maybe it's due to some changes to gup?
> > >
> > > Yes, that crypto part is very odd.
> > >
> > > >
> > > > > syzbot found the following issue on:
> > > > >
> > > > > HEAD commit:    3fe121b62282 Add linux-next specific files for 20240712
> > > > > git tree:       linux-next
> > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=1097ebed980000
> > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=98dd8c4bab5cdce
> > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=4c882a4a0697c4a25364
> > > > > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> > > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11d611a5980000
> > > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ce3259980000
> > > > >
> > > > > Downloadable assets:
> > > > > disk image: https://storage.googleapis.com/syzbot-assets/8c6fbf69718d/disk-3fe121b6.raw.xz
> > > > > vmlinux: https://storage.googleapis.com/syzbot-assets/39fc7e43dfc1/vmlinux-3fe121b6.xz
> > > > > kernel image: https://storage.googleapis.com/syzbot-assets/0a78e70e4b4e/bzImage-3fe121b6.xz
> > > > > mounted in repro: https://storage.googleapis.com/syzbot-assets/66cfe5a679f2/mount_0.gz
> > > > >
> > > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > > Reported-by: syzbot+4c882a4a0697c4a25364@syzkaller.appspotmail.com
> > > > >
> > > > > ==================================================================
> > > > > BUG: KASAN: slab-use-after-free in handle_mm_fault+0x14f0/0x19a0 mm/memory.c:5842
> > > > > Read of size 8 at addr ffff88802c4719d0 by task syz-executor125/5235
> > > > >
> > > > > CPU: 1 UID: 0 PID: 5235 Comm: syz-executor125 Not tainted 6.10.0-rc7-next-20240712-syzkaller #0
> > > > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
> > > > > Call Trace:
> > > > >  <TASK>
> > > > >  __dump_stack lib/dump_stack.c:94 [inline]
> > > > >  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
> > > > >  print_address_description mm/kasan/report.c:377 [inline]
> > > > >  print_report+0x169/0x550 mm/kasan/report.c:488
> > > > >  kasan_report+0x143/0x180 mm/kasan/report.c:601
> > > > >  handle_mm_fault+0x14f0/0x19a0 mm/memory.c:5842
> > >
> > > /*
> > >  * By the time we get here, we already hold the mm semaphore
> > >  *
> > >  * The mmap_lock may have been released depending on flags and our
> > >  * return value.  See filemap_fault() and __folio_lock_or_retry().
> > >  */
> > >
> > > Somehow we are here without an RCU or mmap_lock held?
> >
> > I'm guessing we did enter handle_mm_fault() with mmap_lock held but
> > __handle_mm_fault() dropped it before returning, see the comment for
> > __handle_mm_fault():
> >
> > /*
> >  * On entry, we hold either the VMA lock or the mmap_lock
> >  * (FAULT_FLAG_VMA_LOCK tells you which).  If VM_FAULT_RETRY is set in
> >  * the result, the mmap_lock is not held on exit.  See filemap_fault()
> >  * and __folio_lock_or_retry().
> >  */
> >
> > So after that there is nothing that guarantees VMA is not destroyed
> > from under us and if (vma->vm_flags & VM_DROPPABLE) check is unsafe.
> > Hillf's suggestion should fix this issue but we need to figure out how
> > to make this path more robust. Currently it's very easy to make a
> > similar mistake. Maybe a WARNING comment after __handle_mm_fault()
> > that VMA might be unstable after that function and should not be used?
> 
> CC'ing Jason.

Thanks for bringing this to my attention. I'll incorporate Hillf's patch
and also add a comment as you suggested. Something like the below?

diff --git a/mm/memory.c b/mm/memory.c
index 18fe893ce96d..f596a8d508ef 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5660,6 +5660,7 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
 	/* If the fault handler drops the mmap_lock, vma may be freed */
 	struct mm_struct *mm = vma->vm_mm;
 	vm_fault_t ret;
+	bool is_droppable;

 	__set_current_state(TASK_RUNNING);

@@ -5674,6 +5675,8 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
 		goto out;
 	}

+	is_droppable = !!(vma->vm_flags & VM_DROPPABLE);
+
 	/*
 	 * Enable the memcg OOM handling for faults triggered in user
 	 * space.  Kernel faults are handled more gracefully.
@@ -5688,10 +5691,15 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
 	else
 		ret = __handle_mm_fault(vma, address, flags);

+	/*
+	 * It is no longer safe to dereference vma-> after this point, as
+	 * __handle_mm_fault may have already destroyed it.
+	 */
+
 	lru_gen_exit_fault();

-	/* If the mapping is droppable, then errors due to OOM aren't fatal. */
-	if (vma->vm_flags & VM_DROPPABLE)
+	/* If the mapping is is_droppable, then errors due to OOM aren't fatal. */
+	if (is_droppable)
 		ret &= ~VM_FAULT_OOM;

 	if (flags & FAULT_FLAG_USER) {

