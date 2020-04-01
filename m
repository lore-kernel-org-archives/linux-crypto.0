Return-Path: <SRS0=/HXT=5R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB863C43331
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Apr 2020 16:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78ECD21556
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Apr 2020 16:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585758036;
	bh=8V5ySJp6dKmMDd4qsHqMtGhs0GOyBgG7cv8CBjvA5p0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=R6o376KAyNcbwlKAkCwGagoDHOnZFVdSFSA061f8rFJ3hJOs3d0HNqsgxsv9MloVX
	 yGYGCeip35ir/jzG1g00AAYzXWy/0z+tXGHI2PwJMTXu5frgPuRvowd/3BFlx4r9NX
	 mU0NQzcnmSw3Yvxv+jDANGqyhIWY3zHv+kBSv8G0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733034AbgDAQUc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Apr 2020 12:20:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733018AbgDAQUb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Apr 2020 12:20:31 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F72020658;
        Wed,  1 Apr 2020 16:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758030;
        bh=8V5ySJp6dKmMDd4qsHqMtGhs0GOyBgG7cv8CBjvA5p0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hueEbZyr2b62S+jA7pZBn0YNOhGWyklG0QV4lQtMadslrE1yEzaiOrUCltN7ujRMN
         M1t1aaaA4Wc2OVgk5/G4NKChua6T3CUJAI3iDU36sqkuIdcXBhGQPfkSU68knLQ2JT
         ncj4zL9kYdqvdad6y2pYggEauqH6KuuXRgFlzKXU=
Date:   Wed, 1 Apr 2020 09:20:28 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Marco Elver <elver@google.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+6a6bca8169ffda8ce77b@syzkaller.appspotmail.com>,
        Borislav Petkov <bp@alien8.de>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: KCSAN: data-race in glue_cbc_decrypt_req_128bit /
 glue_cbc_decrypt_req_128bit
Message-ID: <20200401162028.GA201933@gmail.com>
References: <0000000000009d5cef05a22baa95@google.com>
 <20200331202706.GA127606@gmail.com>
 <CACT4Y+ZSTjPmPmiL_1JEdroNZXYgaKewDBEH6RugnhsDVd+bUQ@mail.gmail.com>
 <CANpmjNPkzTSwtJhRXWE0DYi8mToDufuOztjE4h9KopZ11T+q+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNPkzTSwtJhRXWE0DYi8mToDufuOztjE4h9KopZ11T+q+w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 01, 2020 at 12:24:01PM +0200, Marco Elver wrote:
> On Wed, 1 Apr 2020 at 09:04, Dmitry Vyukov <dvyukov@google.com> wrote:
> >
> > On Tue, Mar 31, 2020 at 10:27 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > On Tue, Mar 31, 2020 at 12:35:13PM -0700, syzbot wrote:
> > > > Hello,
> > > >
> > > > syzbot found the following crash on:
> > > >
> > > > HEAD commit:    b12d66a6 mm, kcsan: Instrument SLAB free with ASSERT_EXCLU..
> > > > git tree:       https://github.com/google/ktsan.git kcsan
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=111f0865e00000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=10bc0131c4924ba9
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=6a6bca8169ffda8ce77b
> > > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > >
> > > > Unfortunately, I don't have any reproducer for this crash yet.
> > > >
> > > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > > Reported-by: syzbot+6a6bca8169ffda8ce77b@syzkaller.appspotmail.com
> > > >
> > > > ==================================================================
> > > > BUG: KCSAN: data-race in glue_cbc_decrypt_req_128bit / glue_cbc_decrypt_req_128bit
> > > >
> > > > write to 0xffff88809966e128 of 8 bytes by task 24119 on cpu 0:
> > > >  u128_xor include/crypto/b128ops.h:67 [inline]
> > > >  glue_cbc_decrypt_req_128bit+0x396/0x460 arch/x86/crypto/glue_helper.c:144
> > > >  cbc_decrypt+0x26/0x40 arch/x86/crypto/serpent_avx2_glue.c:152
> > > >  crypto_skcipher_decrypt+0x65/0x90 crypto/skcipher.c:652
> > > >  _skcipher_recvmsg crypto/algif_skcipher.c:142 [inline]
> > > >  skcipher_recvmsg+0x7fa/0x8c0 crypto/algif_skcipher.c:161
> > > >  skcipher_recvmsg_nokey+0x5e/0x80 crypto/algif_skcipher.c:279
> > > >  sock_recvmsg_nosec net/socket.c:886 [inline]
> > > >  sock_recvmsg net/socket.c:904 [inline]
> > > >  sock_recvmsg+0x92/0xb0 net/socket.c:900
> > > >  ____sys_recvmsg+0x167/0x3a0 net/socket.c:2566
> > > >  ___sys_recvmsg+0xb2/0x100 net/socket.c:2608
> > > >  __sys_recvmsg+0x9d/0x160 net/socket.c:2642
> > > >  __do_sys_recvmsg net/socket.c:2652 [inline]
> > > >  __se_sys_recvmsg net/socket.c:2649 [inline]
> > > >  __x64_sys_recvmsg+0x51/0x70 net/socket.c:2649
> > > >  do_syscall_64+0xcc/0x3a0 arch/x86/entry/common.c:294
> > > >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > >
> > > > read to 0xffff88809966e128 of 8 bytes by task 24118 on cpu 1:
> > > >  u128_xor include/crypto/b128ops.h:67 [inline]
> > > >  glue_cbc_decrypt_req_128bit+0x37c/0x460 arch/x86/crypto/glue_helper.c:144
> > > >  cbc_decrypt+0x26/0x40 arch/x86/crypto/serpent_avx2_glue.c:152
> > > >  crypto_skcipher_decrypt+0x65/0x90 crypto/skcipher.c:652
> > > >  _skcipher_recvmsg crypto/algif_skcipher.c:142 [inline]
> > > >  skcipher_recvmsg+0x7fa/0x8c0 crypto/algif_skcipher.c:161
> > > >  skcipher_recvmsg_nokey+0x5e/0x80 crypto/algif_skcipher.c:279
> > > >  sock_recvmsg_nosec net/socket.c:886 [inline]
> > > >  sock_recvmsg net/socket.c:904 [inline]
> > > >  sock_recvmsg+0x92/0xb0 net/socket.c:900
> > > >  ____sys_recvmsg+0x167/0x3a0 net/socket.c:2566
> > > >  ___sys_recvmsg+0xb2/0x100 net/socket.c:2608
> > > >  __sys_recvmsg+0x9d/0x160 net/socket.c:2642
> > > >  __do_sys_recvmsg net/socket.c:2652 [inline]
> > > >  __se_sys_recvmsg net/socket.c:2649 [inline]
> > > >  __x64_sys_recvmsg+0x51/0x70 net/socket.c:2649
> > > >  do_syscall_64+0xcc/0x3a0 arch/x86/entry/common.c:294
> > > >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > >
> > > > Reported by Kernel Concurrency Sanitizer on:
> > > > CPU: 1 PID: 24118 Comm: syz-executor.1 Not tainted 5.6.0-rc1-syzkaller #0
> > > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > > ==================================================================
> > > >
> > >
> > > I think this is a problem for almost all the crypto code.  Due to AF_ALG, both
> > > the source and destination buffers can be userspace pages that were gotten with
> > > get_user_pages().  Such pages can be concurrently modified, not just by the
> > > kernel but also by userspace.
> > >
> > > I'm not sure what can be done about this.
> >
> > Oh, I thought it's something more serious like a shared crypto object.
> > Thanks for debugging.
> > I think I've seen this before in another context (b/149818448):
> >
> > BUG: KCSAN: data-race in copyin / copyin
> >
> > write to 0xffff888103c8b000 of 4096 bytes by task 20917 on cpu 0:
> >  instrument_copy_from_user include/linux/instrumented.h:106 [inline]
> >  copyin+0xab/0xc0 lib/iov_iter.c:151
> >  copy_page_from_iter_iovec lib/iov_iter.c:296 [inline]
> >  copy_page_from_iter+0x23f/0x5f0 lib/iov_iter.c:942
> >  process_vm_rw_pages mm/process_vm_access.c:46 [inline]
> >  process_vm_rw_single_vec mm/process_vm_access.c:120 [inline]
> >  process_vm_rw_core.isra.0+0x448/0x820 mm/process_vm_access.c:218
> >  process_vm_rw+0x1c4/0x1e0 mm/process_vm_access.c:286
> >  __do_sys_process_vm_writev mm/process_vm_access.c:308 [inline]
> >  __se_sys_process_vm_writev mm/process_vm_access.c:303 [inline]
> >  __x64_sys_process_vm_writev+0x8b/0xb0 mm/process_vm_access.c:303
> >  do_syscall_64+0xcc/0x3a0 arch/x86/entry/common.c:294
> >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> > write to 0xffff888103c8b000 of 4096 bytes by task 20918 on cpu 1:
> >  instrument_copy_from_user include/linux/instrumented.h:106 [inline]
> >  copyin+0xab/0xc0 lib/iov_iter.c:151
> >  copy_page_from_iter_iovec lib/iov_iter.c:296 [inline]
> >  copy_page_from_iter+0x23f/0x5f0 lib/iov_iter.c:942
> >  process_vm_rw_pages mm/process_vm_access.c:46 [inline]
> >  process_vm_rw_single_vec mm/process_vm_access.c:120 [inline]
> >  process_vm_rw_core.isra.0+0x448/0x820 mm/process_vm_access.c:218
> >  process_vm_rw+0x1c4/0x1e0 mm/process_vm_access.c:286
> >  __do_sys_process_vm_writev mm/process_vm_access.c:308 [inline]
> >  __se_sys_process_vm_writev mm/process_vm_access.c:303 [inline]
> >  __x64_sys_process_vm_writev+0x8b/0xb0 mm/process_vm_access.c:303
> >  do_syscall_64+0xcc/0x3a0 arch/x86/entry/common.c:294
> >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> >
> > Marco, I think we need to ignore all memory that comes from
> > get_user_pages() somehow. Either not set watchpoints at all, or
> > perhaps filter them out later if the check is not totally free.
> 
> Makes sense. We already have similar checks, and they're in the
> slow-path, so it shouldn't be a problem. Let me investigate.
> 

I'm wondering whether you really should move so soon to ignoring these races?
They are still races; the crypto code is doing standard unannotated reads/writes
of memory that can be concurrently modified.

The issue is that fixing it would require adding READ_ONCE() / WRITE_ONCE() in
hundreds of different places, affecting most crypto-related .c files.

Generally, since encryption and hash algorithms are designed to handle arbitrary
data anyway, getting different values on each read won't crash the code.  So
hopefully this isn't a "real" problem.  But it's still undefined behavior.

- Eric
