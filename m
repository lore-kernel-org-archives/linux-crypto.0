Return-Path: <SRS0=/HXT=5R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC1FCC43331
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Apr 2020 10:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73FB42082F
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Apr 2020 10:24:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D1kwTHk4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731541AbgDAKYO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Apr 2020 06:24:14 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:38334 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgDAKYO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Apr 2020 06:24:14 -0400
Received: by mail-oi1-f196.google.com with SMTP id w2so21755702oic.5
        for <linux-crypto@vger.kernel.org>; Wed, 01 Apr 2020 03:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VSEkYXpnI5k7ve5WWVqCPGcBRbLwusRCarEKFYYH+lA=;
        b=D1kwTHk4+1DwwFaRP7uRqnwWHCzN7NQoeqtqEOdcecwTZHim3cXSSslHK+2rmC4Ymw
         qYEfH139RzCVPDbOiZUb+gMvlRmHBwAAU9TVJSUDL4KrFFEbgQ5ZZdl8Ka6jwREv8WPP
         Dy1Yr9sm9is/bEG5Tw2B/bVs+3Jdm84o6LE0kdPMBjK8Npptpotrsi6jtp1vpqvjzOZs
         HroQixeeieijRln/kPea33dQj3gkgz9Qn6DOM2VmfYZx/LG0zKez0hVfKT7LkRX0srF7
         j6GZ1SV5RD1Eyh4JKAC/PLY6u9A1emaClqKe6MU2LjVGYZ2L8BdLt+BTBcByHhNWkggP
         mQAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VSEkYXpnI5k7ve5WWVqCPGcBRbLwusRCarEKFYYH+lA=;
        b=SA2NK+FOeIlNWVaBp0xdqKfxW2mOrIMNYd7lp4UaPkzgucqwpAP8qkN+G0MlrXYNJs
         kroA+6f+7UJrw1oXwUDBtOMh3xVsv9rRFE/AhkXFG1QgvcBXBWK2k3SJ8hTD0UIzJ3BX
         Fn+ffzfpiOJHetKKY2NuBmdsEIxrvwGtGLd+0nc+1f5iIp4oK/svIVqNNKRvxUafKnh1
         lq6PwNNgV0L7/KvEk+jVkudF3syPqCbo57WwUK/IlM9981zRcqyD1CtHGeqADBm7i/Zh
         1VkvI2Ee9O9bMPhU80pvW3quqU6wJsvvlY649awDLPekmJ0q6LpM8YbSgXqbpIMXdO4X
         5kww==
X-Gm-Message-State: AGi0PuZQs5jwYdv2fSt5qaARznMmRdlrAupsULeuhWJgiUj/WFbJRcLr
        ns2JWxquKpkGI2V2sntUGAnaTe/ejZ6gTgrw9+SVpA==
X-Google-Smtp-Source: APiQypIX5jsWklRnsDiVjpG2+91oR9JrYV9BvpE/6Q3I2OIiYd65l+JJDINR2AOVQpznL/lBs0x9RCafUCW8TcOJc4g=
X-Received: by 2002:aca:f541:: with SMTP id t62mr2285070oih.172.1585736652691;
 Wed, 01 Apr 2020 03:24:12 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000009d5cef05a22baa95@google.com> <20200331202706.GA127606@gmail.com>
 <CACT4Y+ZSTjPmPmiL_1JEdroNZXYgaKewDBEH6RugnhsDVd+bUQ@mail.gmail.com>
In-Reply-To: <CACT4Y+ZSTjPmPmiL_1JEdroNZXYgaKewDBEH6RugnhsDVd+bUQ@mail.gmail.com>
From:   Marco Elver <elver@google.com>
Date:   Wed, 1 Apr 2020 12:24:01 +0200
Message-ID: <CANpmjNPkzTSwtJhRXWE0DYi8mToDufuOztjE4h9KopZ11T+q+w@mail.gmail.com>
Subject: Re: KCSAN: data-race in glue_cbc_decrypt_req_128bit / glue_cbc_decrypt_req_128bit
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
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
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 1 Apr 2020 at 09:04, Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Tue, Mar 31, 2020 at 10:27 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Tue, Mar 31, 2020 at 12:35:13PM -0700, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following crash on:
> > >
> > > HEAD commit:    b12d66a6 mm, kcsan: Instrument SLAB free with ASSERT_EXCLU..
> > > git tree:       https://github.com/google/ktsan.git kcsan
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=111f0865e00000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=10bc0131c4924ba9
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=6a6bca8169ffda8ce77b
> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > >
> > > Unfortunately, I don't have any reproducer for this crash yet.
> > >
> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > Reported-by: syzbot+6a6bca8169ffda8ce77b@syzkaller.appspotmail.com
> > >
> > > ==================================================================
> > > BUG: KCSAN: data-race in glue_cbc_decrypt_req_128bit / glue_cbc_decrypt_req_128bit
> > >
> > > write to 0xffff88809966e128 of 8 bytes by task 24119 on cpu 0:
> > >  u128_xor include/crypto/b128ops.h:67 [inline]
> > >  glue_cbc_decrypt_req_128bit+0x396/0x460 arch/x86/crypto/glue_helper.c:144
> > >  cbc_decrypt+0x26/0x40 arch/x86/crypto/serpent_avx2_glue.c:152
> > >  crypto_skcipher_decrypt+0x65/0x90 crypto/skcipher.c:652
> > >  _skcipher_recvmsg crypto/algif_skcipher.c:142 [inline]
> > >  skcipher_recvmsg+0x7fa/0x8c0 crypto/algif_skcipher.c:161
> > >  skcipher_recvmsg_nokey+0x5e/0x80 crypto/algif_skcipher.c:279
> > >  sock_recvmsg_nosec net/socket.c:886 [inline]
> > >  sock_recvmsg net/socket.c:904 [inline]
> > >  sock_recvmsg+0x92/0xb0 net/socket.c:900
> > >  ____sys_recvmsg+0x167/0x3a0 net/socket.c:2566
> > >  ___sys_recvmsg+0xb2/0x100 net/socket.c:2608
> > >  __sys_recvmsg+0x9d/0x160 net/socket.c:2642
> > >  __do_sys_recvmsg net/socket.c:2652 [inline]
> > >  __se_sys_recvmsg net/socket.c:2649 [inline]
> > >  __x64_sys_recvmsg+0x51/0x70 net/socket.c:2649
> > >  do_syscall_64+0xcc/0x3a0 arch/x86/entry/common.c:294
> > >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > >
> > > read to 0xffff88809966e128 of 8 bytes by task 24118 on cpu 1:
> > >  u128_xor include/crypto/b128ops.h:67 [inline]
> > >  glue_cbc_decrypt_req_128bit+0x37c/0x460 arch/x86/crypto/glue_helper.c:144
> > >  cbc_decrypt+0x26/0x40 arch/x86/crypto/serpent_avx2_glue.c:152
> > >  crypto_skcipher_decrypt+0x65/0x90 crypto/skcipher.c:652
> > >  _skcipher_recvmsg crypto/algif_skcipher.c:142 [inline]
> > >  skcipher_recvmsg+0x7fa/0x8c0 crypto/algif_skcipher.c:161
> > >  skcipher_recvmsg_nokey+0x5e/0x80 crypto/algif_skcipher.c:279
> > >  sock_recvmsg_nosec net/socket.c:886 [inline]
> > >  sock_recvmsg net/socket.c:904 [inline]
> > >  sock_recvmsg+0x92/0xb0 net/socket.c:900
> > >  ____sys_recvmsg+0x167/0x3a0 net/socket.c:2566
> > >  ___sys_recvmsg+0xb2/0x100 net/socket.c:2608
> > >  __sys_recvmsg+0x9d/0x160 net/socket.c:2642
> > >  __do_sys_recvmsg net/socket.c:2652 [inline]
> > >  __se_sys_recvmsg net/socket.c:2649 [inline]
> > >  __x64_sys_recvmsg+0x51/0x70 net/socket.c:2649
> > >  do_syscall_64+0xcc/0x3a0 arch/x86/entry/common.c:294
> > >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > >
> > > Reported by Kernel Concurrency Sanitizer on:
> > > CPU: 1 PID: 24118 Comm: syz-executor.1 Not tainted 5.6.0-rc1-syzkaller #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > ==================================================================
> > >
> >
> > I think this is a problem for almost all the crypto code.  Due to AF_ALG, both
> > the source and destination buffers can be userspace pages that were gotten with
> > get_user_pages().  Such pages can be concurrently modified, not just by the
> > kernel but also by userspace.
> >
> > I'm not sure what can be done about this.
>
> Oh, I thought it's something more serious like a shared crypto object.
> Thanks for debugging.
> I think I've seen this before in another context (b/149818448):
>
> BUG: KCSAN: data-race in copyin / copyin
>
> write to 0xffff888103c8b000 of 4096 bytes by task 20917 on cpu 0:
>  instrument_copy_from_user include/linux/instrumented.h:106 [inline]
>  copyin+0xab/0xc0 lib/iov_iter.c:151
>  copy_page_from_iter_iovec lib/iov_iter.c:296 [inline]
>  copy_page_from_iter+0x23f/0x5f0 lib/iov_iter.c:942
>  process_vm_rw_pages mm/process_vm_access.c:46 [inline]
>  process_vm_rw_single_vec mm/process_vm_access.c:120 [inline]
>  process_vm_rw_core.isra.0+0x448/0x820 mm/process_vm_access.c:218
>  process_vm_rw+0x1c4/0x1e0 mm/process_vm_access.c:286
>  __do_sys_process_vm_writev mm/process_vm_access.c:308 [inline]
>  __se_sys_process_vm_writev mm/process_vm_access.c:303 [inline]
>  __x64_sys_process_vm_writev+0x8b/0xb0 mm/process_vm_access.c:303
>  do_syscall_64+0xcc/0x3a0 arch/x86/entry/common.c:294
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> write to 0xffff888103c8b000 of 4096 bytes by task 20918 on cpu 1:
>  instrument_copy_from_user include/linux/instrumented.h:106 [inline]
>  copyin+0xab/0xc0 lib/iov_iter.c:151
>  copy_page_from_iter_iovec lib/iov_iter.c:296 [inline]
>  copy_page_from_iter+0x23f/0x5f0 lib/iov_iter.c:942
>  process_vm_rw_pages mm/process_vm_access.c:46 [inline]
>  process_vm_rw_single_vec mm/process_vm_access.c:120 [inline]
>  process_vm_rw_core.isra.0+0x448/0x820 mm/process_vm_access.c:218
>  process_vm_rw+0x1c4/0x1e0 mm/process_vm_access.c:286
>  __do_sys_process_vm_writev mm/process_vm_access.c:308 [inline]
>  __se_sys_process_vm_writev mm/process_vm_access.c:303 [inline]
>  __x64_sys_process_vm_writev+0x8b/0xb0 mm/process_vm_access.c:303
>  do_syscall_64+0xcc/0x3a0 arch/x86/entry/common.c:294
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
>
> Marco, I think we need to ignore all memory that comes from
> get_user_pages() somehow. Either not set watchpoints at all, or
> perhaps filter them out later if the check is not totally free.

Makes sense. We already have similar checks, and they're in the
slow-path, so it shouldn't be a problem. Let me investigate.

Thanks,
-- Marco
