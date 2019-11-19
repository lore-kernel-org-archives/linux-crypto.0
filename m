Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9CBAC432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 17:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EBC922303
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 17:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574185056;
	bh=nzENVcNFHfi1Al+SPMVvussvjnjP5WONeLBEPZlONO0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=zz49u7+en/p8Vjd8rLjkDBN8iPMHT3lUgKxIFy+wzf732Id+GiMUuvw5de5LHDkdd
	 g55CZT2Pqcp/WiH6RFnjugVJT+Brj8l+Z2kUkx1v3oGvHxiZxF4gpRRUQjD34pDG/f
	 Fd/Efy9Gq2xMQF7Vn5fs+PZojmf6uDiWj88BELUg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbfKSRhf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 12:37:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:43046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727929AbfKSRhf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 12:37:35 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C00822302;
        Tue, 19 Nov 2019 17:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574185054;
        bh=nzENVcNFHfi1Al+SPMVvussvjnjP5WONeLBEPZlONO0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aEo0+1wSmGbdot2bHXW/WDvZuORk8Uea1+KKKMdVGADk21gxbyVGWNtEOhPvkZ72d
         YS/dIRUPB9q9tMs2Jqfy7NKq0vO0NFWrI/xnMSwYs1HZK82cnW+ZqLRGuaJ4t948yH
         tlRRY1LXUoYzJ2+vE8Ya46IwBQw4hqOCk3NIaj2A=
Date:   Tue, 19 Nov 2019 09:37:32 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [PATCH] crypto: pcrypt - Avoid deadlock by using per-instance
 padata queues
Message-ID: <20191119173732.GB819@sol.localdomain>
References: <20191119130556.dso2ni6qlks3lr23@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119130556.dso2ni6qlks3lr23@gondor.apana.org.au>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On Tue, Nov 19, 2019 at 09:05:57PM +0800, Herbert Xu wrote:
> If the pcrypt template is used multiple times in an algorithm, then a
> deadlock occurs because all pcrypt instances share the same
> padata_instance, which completes requests in the order submitted.  That
> is, the inner pcrypt request waits for the outer pcrypt request while
> the outer request is already waiting for the inner.
> 
> This patch fixes this by allocating a set of queues for each pcrypt
> instance instead of using two global queues.  In order to maintain
> the existing user-space interface, the pinst structure remains global
> so any sysfs modifications will apply to every instance.
> 
> The new per-instance data structure is called padata_shell and is
> essentially a wrapper around parallel_data.
> 
> Reproducer:
> 
> 	#include <linux/if_alg.h>
> 	#include <sys/socket.h>
> 	#include <unistd.h>
> 
> 	int main()
> 	{
> 		struct sockaddr_alg addr = {
> 			.salg_type = "aead",
> 			.salg_name = "pcrypt(pcrypt(rfc4106-gcm-aesni))"
> 		};
> 		int algfd, reqfd;
> 		char buf[32] = { 0 };
> 
> 		algfd = socket(AF_ALG, SOCK_SEQPACKET, 0);
> 		bind(algfd, (void *)&addr, sizeof(addr));
> 		setsockopt(algfd, SOL_ALG, ALG_SET_KEY, buf, 20);
> 		reqfd = accept(algfd, 0, 0);
> 		write(reqfd, buf, 32);
> 		read(reqfd, buf, 16);
> 	}
> 
> Reported-by: syzbot+56c7151cad94eec37c521f0e47d2eee53f9361c4@syzkaller.appspotmail.com
> Fixes: 5068c7a883d1 ("crypto: pcrypt - Add pcrypt crypto parallelization wrapper")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 

FYI, with your 3 pcrypt patches applied, I tried enabling CONFIG_CRYPTO_PCRYPT=y
again and running syzkaller targetting AF_ALG, and I quickly got the following
warning:

------------[ cut here ]------------
WARNING: CPU: 7 PID: 64550 at kernel/cpu.c:329 lockdep_assert_cpus_held+0xc3/0xf0 kernel/cpu.c:329
Kernel panic - not syncing: panic_on_warn set ...
CPU: 7 PID: 64550 Comm: cryptomgr_probe Not tainted 5.4.0-rc1-00267-g94b2b3991aca #10
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20191013_105130-anatol 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xd4/0x156 lib/dump_stack.c:113
 panic+0x2a3/0x6b3 kernel/panic.c:220
 __warn.cold+0x2f/0x3e kernel/panic.c:581
 report_bug+0x291/0x300 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:179 [inline]
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 do_error_trap+0x11b/0x1c0 arch/x86/kernel/traps.c:272
 do_invalid_op+0x50/0x70 arch/x86/kernel/traps.c:291
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1028
RIP: 0010:lockdep_assert_cpus_held+0xc3/0xf0 kernel/cpu.c:329
Code: e8 02 39 24 00 be ff ff ff ff 48 c7 c7 30 55 2b 83 e8 c1 5b 11 00 31 ff 89 c3 89 c6 e8 66 3a 24 00 85 db 75 d3 e8 dd 38 24 00 <0f> 0b e8 d6 38 24 00 5b 5d c3 48 c7 c7 44 71 5a 83 e8 17 7c 46 00
RSP: 0018:ffff888068007d98 EFLAGS: 00010293
RAX: ffff88804b10c040 RBX: 0000000000000000 RCX: ffffffff811f417a
RDX: 0000000000000000 RSI: ffffffff811f4183 RDI: 0000000000000005
RBP: ffff888068007da0 R08: ffff88804b10c040 R09: ffffed100dafe405
R10: ffffed100dafe404 R11: ffff88806d7f2023 R12: ffff88806baa0cc0
R13: ffff88806ae432c0 R14: 000000000000ffff R15: ffff88806b4e9008
 apply_workqueue_attrs+0x18/0x50 kernel/workqueue.c:4042
 padata_setup_cpumasks kernel/padata.c:374 [inline]
 padata_alloc_pd+0x2f5/0xbb0 kernel/padata.c:449
 padata_alloc_shell+0x97/0x290 kernel/padata.c:1052
 pcrypt_create_aead crypto/pcrypt.c:255 [inline]
 pcrypt_create+0x19e/0x890 crypto/pcrypt.c:319
 cryptomgr_probe+0x6f/0x290 crypto/algboss.c:70
 kthread+0x361/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Dumping ftrace buffer:
   (ftrace buffer empty)
Kernel Offset: disabled
Rebooting in 1 seconds..
