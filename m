Return-Path: <SRS0=uha7=5Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E97C43331
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Mar 2020 20:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19B55208E0
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Mar 2020 20:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585686430;
	bh=KBJwO6H6Y0CusLpsPnIlkDyiEbM5ompx0TxNHV6EnzM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=t/cL7wW73KbSWJurl2/4RhoHffWNVIm8DvHN3IuOt4XZGhtanVZRbrSsOpsvyGRdF
	 vrV/EjfuVrs5LfVMmATMtcXxkY1wy1MO8IcJFTcZZhiXg1ZaGZAqIFDG0gTxT8otHb
	 kC8KFkf5mXPhFonLzQntRd/ur00SiRDJXZqn70tk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbgCaU1J (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Mar 2020 16:27:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbgCaU1J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Mar 2020 16:27:09 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A44020757;
        Tue, 31 Mar 2020 20:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585686428;
        bh=KBJwO6H6Y0CusLpsPnIlkDyiEbM5ompx0TxNHV6EnzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O/twBmAHYyNn1uDHoUVUd38Q6xNXNUbnyriuOKsOYdno07+7Wr65zcI/9Lstpd8KL
         EcYuKqK+nnNt6EbAE0kaWadIXzTqN1HlHCKawd/ldOPlouz0ne5ZREr4Unn3dqsExI
         iL2sQFXTDdDWOn6Ao21a0DgybA48ITA4UcofHjZI=
Date:   Tue, 31 Mar 2020 13:27:06 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     syzbot <syzbot+6a6bca8169ffda8ce77b@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, davem@davemloft.net, elver@google.com,
        herbert@gondor.apana.org.au, hpa@zytor.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, x86@kernel.org
Subject: Re: KCSAN: data-race in glue_cbc_decrypt_req_128bit /
 glue_cbc_decrypt_req_128bit
Message-ID: <20200331202706.GA127606@gmail.com>
References: <0000000000009d5cef05a22baa95@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000009d5cef05a22baa95@google.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 31, 2020 at 12:35:13PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    b12d66a6 mm, kcsan: Instrument SLAB free with ASSERT_EXCLU..
> git tree:       https://github.com/google/ktsan.git kcsan
> console output: https://syzkaller.appspot.com/x/log.txt?x=111f0865e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=10bc0131c4924ba9
> dashboard link: https://syzkaller.appspot.com/bug?extid=6a6bca8169ffda8ce77b
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+6a6bca8169ffda8ce77b@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KCSAN: data-race in glue_cbc_decrypt_req_128bit / glue_cbc_decrypt_req_128bit
> 
> write to 0xffff88809966e128 of 8 bytes by task 24119 on cpu 0:
>  u128_xor include/crypto/b128ops.h:67 [inline]
>  glue_cbc_decrypt_req_128bit+0x396/0x460 arch/x86/crypto/glue_helper.c:144
>  cbc_decrypt+0x26/0x40 arch/x86/crypto/serpent_avx2_glue.c:152
>  crypto_skcipher_decrypt+0x65/0x90 crypto/skcipher.c:652
>  _skcipher_recvmsg crypto/algif_skcipher.c:142 [inline]
>  skcipher_recvmsg+0x7fa/0x8c0 crypto/algif_skcipher.c:161
>  skcipher_recvmsg_nokey+0x5e/0x80 crypto/algif_skcipher.c:279
>  sock_recvmsg_nosec net/socket.c:886 [inline]
>  sock_recvmsg net/socket.c:904 [inline]
>  sock_recvmsg+0x92/0xb0 net/socket.c:900
>  ____sys_recvmsg+0x167/0x3a0 net/socket.c:2566
>  ___sys_recvmsg+0xb2/0x100 net/socket.c:2608
>  __sys_recvmsg+0x9d/0x160 net/socket.c:2642
>  __do_sys_recvmsg net/socket.c:2652 [inline]
>  __se_sys_recvmsg net/socket.c:2649 [inline]
>  __x64_sys_recvmsg+0x51/0x70 net/socket.c:2649
>  do_syscall_64+0xcc/0x3a0 arch/x86/entry/common.c:294
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> read to 0xffff88809966e128 of 8 bytes by task 24118 on cpu 1:
>  u128_xor include/crypto/b128ops.h:67 [inline]
>  glue_cbc_decrypt_req_128bit+0x37c/0x460 arch/x86/crypto/glue_helper.c:144
>  cbc_decrypt+0x26/0x40 arch/x86/crypto/serpent_avx2_glue.c:152
>  crypto_skcipher_decrypt+0x65/0x90 crypto/skcipher.c:652
>  _skcipher_recvmsg crypto/algif_skcipher.c:142 [inline]
>  skcipher_recvmsg+0x7fa/0x8c0 crypto/algif_skcipher.c:161
>  skcipher_recvmsg_nokey+0x5e/0x80 crypto/algif_skcipher.c:279
>  sock_recvmsg_nosec net/socket.c:886 [inline]
>  sock_recvmsg net/socket.c:904 [inline]
>  sock_recvmsg+0x92/0xb0 net/socket.c:900
>  ____sys_recvmsg+0x167/0x3a0 net/socket.c:2566
>  ___sys_recvmsg+0xb2/0x100 net/socket.c:2608
>  __sys_recvmsg+0x9d/0x160 net/socket.c:2642
>  __do_sys_recvmsg net/socket.c:2652 [inline]
>  __se_sys_recvmsg net/socket.c:2649 [inline]
>  __x64_sys_recvmsg+0x51/0x70 net/socket.c:2649
>  do_syscall_64+0xcc/0x3a0 arch/x86/entry/common.c:294
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 1 PID: 24118 Comm: syz-executor.1 Not tainted 5.6.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> ==================================================================
> 

I think this is a problem for almost all the crypto code.  Due to AF_ALG, both
the source and destination buffers can be userspace pages that were gotten with
get_user_pages().  Such pages can be concurrently modified, not just by the
kernel but also by userspace.

I'm not sure what can be done about this.

- Eric
