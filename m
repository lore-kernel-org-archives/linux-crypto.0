Return-Path: <SRS0=RCNv=7Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB32C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 03:55:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5C3B2072F
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 03:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591156544;
	bh=FiUhhNdnCIUsVkjQis8NSHn7BUnltL4V+761roaOZCA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=iqXDcP5HXrciUq5jjbgqzujGZZwVbFEt1Pv+A5BfMnXyNP36+o6IQSTbWBH6fv0tP
	 rMIoL7r8Qkwn+uddu17FfwtsLdLgSi/RaDQfRLu2Oy/qCpVpUSoFfHrsi5vrt/NMWt
	 NH/CmVHKzGKzBY9unpjPU6XJ/oIqSdDbZ2teuqcA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgFCDzo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jun 2020 23:55:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725924AbgFCDzo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jun 2020 23:55:44 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 871A920674;
        Wed,  3 Jun 2020 03:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591156542;
        bh=FiUhhNdnCIUsVkjQis8NSHn7BUnltL4V+761roaOZCA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uB/6aBreDvLnfol9tpFO3hQGPvpNvZXnqaN/IFEeyU3qFpEsnxz1n4H6IcmWYxg1I
         1ED28OvxAO3sME/Pne5ky5YwoD9Ha+t9bFItspkUCFr9MzyYCsp45HH8pcfcIqFz5s
         AtdWKj6nRZsA3I8w+AzZR+KoUjXRwfrGgb2RD7JQ=
Date:   Tue, 2 Jun 2020 20:55:41 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+2e635807decef724a1fa@syzkaller.appspotmail.com>
Subject: Re: memory leak in crypto_create_tfm
Message-ID: <20200603035541.GB50072@sol.localdomain>
References: <0000000000002a280b05a725cd93@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000002a280b05a725cd93@google.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Probably a bug in crypto/drbg.c.  Stephan, can you take a look?

On Tue, Jun 02, 2020 at 08:41:21PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    19409891 Merge tag 'pnp-5.8-rc1' of git://git.kernel.org/p..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13165aa6100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6d41e63a2c7e0715
> dashboard link: https://syzkaller.appspot.com/bug?extid=2e635807decef724a1fa
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17f00ef2100000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=170f2ef2100000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+2e635807decef724a1fa@syzkaller.appspotmail.com
> 
> executing program
> executing program
> BUG: memory leak
> unreferenced object 0xffff8881175bc480 (size 64):
>   comm "syz-executor064", pid 6388, jiffies 4294941622 (age 13.280s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     e0 7e 56 84 ff ff ff ff 00 00 00 00 00 00 00 00  .~V.............
>   backtrace:
>     [<0000000029c7602f>] kmalloc include/linux/slab.h:560 [inline]
>     [<0000000029c7602f>] kzalloc include/linux/slab.h:669 [inline]
>     [<0000000029c7602f>] crypto_create_tfm+0x31/0x100 crypto/api.c:448
>     [<00000000bec8cbdb>] crypto_alloc_tfm+0x79/0x1a0 crypto/api.c:527
>     [<000000002f9791ba>] drbg_prepare_hrng crypto/drbg.c:1509 [inline]
>     [<000000002f9791ba>] drbg_instantiate crypto/drbg.c:1587 [inline]
>     [<000000002f9791ba>] drbg_kcapi_seed+0x432/0x6a9 crypto/drbg.c:1980
>     [<0000000041302bb8>] crypto_rng_reset+0x35/0x1a0 crypto/rng.c:53
>     [<000000004758c3c4>] alg_setkey crypto/af_alg.c:222 [inline]
>     [<000000004758c3c4>] alg_setsockopt+0x149/0x190 crypto/af_alg.c:255
>     [<000000008bc4b5cb>] __sys_setsockopt+0x112/0x230 net/socket.c:2132
>     [<00000000cfbf30da>] __do_sys_setsockopt net/socket.c:2148 [inline]
>     [<00000000cfbf30da>] __se_sys_setsockopt net/socket.c:2145 [inline]
>     [<00000000cfbf30da>] __x64_sys_setsockopt+0x22/0x30 net/socket.c:2145
>     [<00000000fc9c2183>] do_syscall_64+0x6e/0x220 arch/x86/entry/common.c:295
>     [<0000000040e080a1>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> BUG: memory leak
> unreferenced object 0xffff8881175bc040 (size 64):
>   comm "syz-executor064", pid 6389, jiffies 4294942172 (age 7.780s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     e0 7e 56 84 ff ff ff ff 00 00 00 00 00 00 00 00  .~V.............
>   backtrace:
>     [<0000000029c7602f>] kmalloc include/linux/slab.h:560 [inline]
>     [<0000000029c7602f>] kzalloc include/linux/slab.h:669 [inline]
>     [<0000000029c7602f>] crypto_create_tfm+0x31/0x100 crypto/api.c:448
>     [<00000000bec8cbdb>] crypto_alloc_tfm+0x79/0x1a0 crypto/api.c:527
>     [<000000002f9791ba>] drbg_prepare_hrng crypto/drbg.c:1509 [inline]
>     [<000000002f9791ba>] drbg_instantiate crypto/drbg.c:1587 [inline]
>     [<000000002f9791ba>] drbg_kcapi_seed+0x432/0x6a9 crypto/drbg.c:1980
>     [<0000000041302bb8>] crypto_rng_reset+0x35/0x1a0 crypto/rng.c:53
>     [<000000004758c3c4>] alg_setkey crypto/af_alg.c:222 [inline]
>     [<000000004758c3c4>] alg_setsockopt+0x149/0x190 crypto/af_alg.c:255
>     [<000000008bc4b5cb>] __sys_setsockopt+0x112/0x230 net/socket.c:2132
>     [<00000000cfbf30da>] __do_sys_setsockopt net/socket.c:2148 [inline]
>     [<00000000cfbf30da>] __se_sys_setsockopt net/socket.c:2145 [inline]
>     [<00000000cfbf30da>] __x64_sys_setsockopt+0x22/0x30 net/socket.c:2145
>     [<00000000fc9c2183>] do_syscall_64+0x6e/0x220 arch/x86/entry/common.c:295
>     [<0000000040e080a1>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> BUG: memory leak
> unreferenced object 0xffff88811b3ca080 (size 96):
>   comm "syz-executor064", pid 6389, jiffies 4294942172 (age 7.780s)
>   hex dump (first 32 bytes):
>     89 c7 08 cb 8a 12 10 6e 00 00 00 00 00 00 00 00  .......n........
>     71 51 5a c2 1b 00 00 00 35 7d 00 00 00 00 00 00  qQZ.....5}......
>   backtrace:
>     [<000000008ec3eca0>] jent_entropy_collector_alloc+0x1b/0xf8 crypto/jitterentropy.c:662
>     [<0000000026ed401a>] jent_kcapi_init+0x17/0x40 crypto/jitterentropy-kcapi.c:119
>     [<00000000be7d6b06>] crypto_create_tfm+0x89/0x100 crypto/api.c:459
>     [<00000000bec8cbdb>] crypto_alloc_tfm+0x79/0x1a0 crypto/api.c:527
>     [<000000002f9791ba>] drbg_prepare_hrng crypto/drbg.c:1509 [inline]
>     [<000000002f9791ba>] drbg_instantiate crypto/drbg.c:1587 [inline]
>     [<000000002f9791ba>] drbg_kcapi_seed+0x432/0x6a9 crypto/drbg.c:1980
>     [<0000000041302bb8>] crypto_rng_reset+0x35/0x1a0 crypto/rng.c:53
>     [<000000004758c3c4>] alg_setkey crypto/af_alg.c:222 [inline]
>     [<000000004758c3c4>] alg_setsockopt+0x149/0x190 crypto/af_alg.c:255
>     [<000000008bc4b5cb>] __sys_setsockopt+0x112/0x230 net/socket.c:2132
>     [<00000000cfbf30da>] __do_sys_setsockopt net/socket.c:2148 [inline]
>     [<00000000cfbf30da>] __se_sys_setsockopt net/socket.c:2145 [inline]
>     [<00000000cfbf30da>] __x64_sys_setsockopt+0x22/0x30 net/socket.c:2145
>     [<00000000fc9c2183>] do_syscall_64+0x6e/0x220 arch/x86/entry/common.c:295
>     [<0000000040e080a1>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/0000000000002a280b05a725cd93%40google.com.
