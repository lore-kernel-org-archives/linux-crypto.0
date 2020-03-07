Return-Path: <SRS0=eK4E=4Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 526D3C10F25
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Mar 2020 21:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2023720684
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Mar 2020 21:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583617672;
	bh=FSDdwWaubX3zIYIEEDYkU94X6thagmWw/nFWlKNsAMo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=rjIVLEszZYwHdCEEISIFLBwiNQFfxYmVBji49r68L5HbxuKvQ87ZoVjOLfqt0iY0A
	 Nj1fVxdyf40/o1Pz9wsSnyWo/fbIl1vl/at4GrEFF6aDkvvdTf6TtMBMVK3nuYW+6g
	 4ycdmZ+cEWDf/BOmOJ7Xz5nEZ0DbEq5fkEcNS0Ds=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgCGVrv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 7 Mar 2020 16:47:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgCGVrv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Mar 2020 16:47:51 -0500
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD9F020684;
        Sat,  7 Mar 2020 21:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583617669;
        bh=FSDdwWaubX3zIYIEEDYkU94X6thagmWw/nFWlKNsAMo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nf6h56vyi269p7tei4B+NFmV0FYsTWWmQkZQKkw/B3B7DAU2+q9yBjusulrYARVw+
         c6+rvdt0qqK6AfiMqMqKU3atcQKYZZSXam4ZZDP04rv8nTzXFvigd2t7SeMst73EZ4
         FA4Yvw0HlyvozuRA/xcQpmgdJgopQfYzo+tgOWpM=
Date:   Sat, 7 Mar 2020 13:47:48 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     syzbot <syzbot+b9cab61577c8d0a3c48e@syzkaller.appspotmail.com>
Cc:     linux-crypto@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: general protection fault in _initial_num_blocks_is_ADDR
Message-ID: <20200307214748.GQ15444@sol.localdomain>
References: <0000000000000147a30599cd7d93@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000000147a30599cd7d93@google.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Dec 15, 2019 at 11:52:08PM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    07c4b9e9 Merge tag 'scsi-fixes' of git://git.kernel.org/pu..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1049e3dee00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=79f79de2a27d3e3d
> dashboard link: https://syzkaller.appspot.com/bug?extid=b9cab61577c8d0a3c48e
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+b9cab61577c8d0a3c48e@syzkaller.appspotmail.com
> 
> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 26867 Comm: kworker/u4:3 Not tainted 5.5.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Workqueue: pencrypt_parallel padata_parallel_worker
> RIP: 0010:_initial_num_blocks_is_017529+0x2f7/0x3e1
> Code: 00 00 c4 e2 71 dd c8 c4 e2 69 dd d0 c4 e2 61 dd d8 c4 e2 59 dd e0 c4
> e2 51 dd e8 c4 e2 49 dd f0 c4 e2 41 dd f8 c4 62 39 dd c0 <c4> 21 7a 6f 24 19
> c4 c1 71 ef cc c4 a1 7a 7f 0c 1a c4 21 7a 6f 64
> RSP: 0018:ffffc90004ed7680 EFLAGS: 00010206
> RAX: 0000000000000010 RBX: 0000000000000f80 RCX: 0005088000000080
> RDX: ffff888066da800d RSI: ffffc90004ed78f0 RDI: ffff888062285850
> RBP: ffffc90004ed7b20 R08: 0000000000000f80 R09: 000000000000000d
> R10: 0000000000000080 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000f80 R14: ffffc90004ed7728 R15: 0000000000004000
> FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2d333000 CR3: 0000000094a09000 CR4: 00000000001426f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  gcmaes_encrypt arch/x86/crypto/aesni-intel_glue.c:840 [inline]
>  generic_gcmaes_encrypt+0x10d/0x160 arch/x86/crypto/aesni-intel_glue.c:1019
>  crypto_aead_encrypt+0xaf/0xf0 crypto/aead.c:94
>  simd_aead_encrypt+0x1a6/0x2b0 crypto/simd.c:335
>  crypto_aead_encrypt+0xaf/0xf0 crypto/aead.c:94
>  pcrypt_aead_enc+0x19/0x80 crypto/pcrypt.c:76
>  padata_parallel_worker+0x28f/0x470 kernel/padata.c:81
>  process_one_work+0x9af/0x1740 kernel/workqueue.c:2264
>  worker_thread+0x98/0xe40 kernel/workqueue.c:2410
>  kthread+0x361/0x430 kernel/kthread.c:255
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> Modules linked in:

This only happened once, there's still no reproducer, and there have been
potentially related fixes to crypto/pcrypt.c since then.  So I'm invalidating
this bug report.

#syz invalid
