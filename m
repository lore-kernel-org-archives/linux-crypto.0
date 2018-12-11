Return-Path: <SRS0=eKEb=OU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27492C5CFFE
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Dec 2018 05:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91BCF20672
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Dec 2018 05:08:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91BCF20672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbeLKFIA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Dec 2018 00:08:00 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:43246 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726324AbeLKFH7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Dec 2018 00:07:59 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gWaGv-0004Hi-Sx; Tue, 11 Dec 2018 13:07:53 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gWaGg-0002Rg-28; Tue, 11 Dec 2018 13:07:38 +0800
Date:   Tue, 11 Dec 2018 13:07:38 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     christophe.leroy@c-s.fr, "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] crypto/testmgr: fix skcipher test with CONFIG_VMAP_STACK
Message-ID: <20181211050737.ubxpofoxj7gjmcs3@gondor.apana.org.au>
References: <20181207173309.82A0E6D165@po14163vm.idsi0.si.c-s.fr>
 <CAKv+Gu9gz0h2CFNPe9bgrSBzRe7iTVOMxiEEb6OXb75Acv7HUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9gz0h2CFNPe9bgrSBzRe7iTVOMxiEEb6OXb75Acv7HUQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181211050738.TjFk7wlhF3F1idDlXF8Uc2FGkKHW4W8UBOPWbRu9vrs@z>

On Fri, Dec 07, 2018 at 09:26:15PM +0100, Ard Biesheuvel wrote:
> On Fri, 7 Dec 2018 at 18:33, Christophe Leroy <christophe.leroy@c-s.fr> wrote:
> >
> > [    2.364486] WARNING: CPU: 0 PID: 60 at ./arch/powerpc/include/asm/io.h:837 dma_nommu_map_page+0x44/0xd4
> > [    2.373579] CPU: 0 PID: 60 Comm: cryptomgr_test Tainted: G        W         4.20.0-rc5-00560-g6bfb52e23a00-dirty #531
> > [    2.384740] NIP:  c000c540 LR: c000c584 CTR: 00000000
> > [    2.389743] REGS: c95abab0 TRAP: 0700   Tainted: G        W          (4.20.0-rc5-00560-g6bfb52e23a00-dirty)
> > [    2.400042] MSR:  00029032 <EE,ME,IR,DR,RI>  CR: 24042204  XER: 00000000
> > [    2.406669]
> > [    2.406669] GPR00: c02f2244 c95abb60 c6262990 c95abd80 0000256a 00000001 00000001 00000001
> > [    2.406669] GPR08: 00000000 00002000 00000010 00000010 24042202 00000000 00000100 c95abd88
> > [    2.406669] GPR16: 00000000 c05569d4 00000001 00000010 c95abc88 c0615664 00000004 00000000
> > [    2.406669] GPR24: 00000010 c95abc88 c95abc88 00000000 c61ae210 c7ff6d40 c61ae210 00003d68
> > [    2.441559] NIP [c000c540] dma_nommu_map_page+0x44/0xd4
> > [    2.446720] LR [c000c584] dma_nommu_map_page+0x88/0xd4
> > [    2.451762] Call Trace:
> > [    2.454195] [c95abb60] [82000808] 0x82000808 (unreliable)
> > [    2.459572] [c95abb80] [c02f2244] talitos_edesc_alloc+0xbc/0x3c8
> > [    2.465493] [c95abbb0] [c02f2600] ablkcipher_edesc_alloc+0x4c/0x5c
> > [    2.471606] [c95abbd0] [c02f4ed0] ablkcipher_encrypt+0x20/0x64
> > [    2.477389] [c95abbe0] [c02023b0] __test_skcipher+0x4bc/0xa08
> > [    2.483049] [c95abe00] [c0204b60] test_skcipher+0x2c/0xcc
> > [    2.488385] [c95abe20] [c0204c48] alg_test_skcipher+0x48/0xbc
> > [    2.494064] [c95abe40] [c0205cec] alg_test+0x164/0x2e8
> > [    2.499142] [c95abf00] [c0200dec] cryptomgr_test+0x48/0x50
> > [    2.504558] [c95abf10] [c0039ff4] kthread+0xe4/0x110
> > [    2.509471] [c95abf40] [c000e1d0] ret_from_kernel_thread+0x14/0x1c
> > [    2.515532] Instruction dump:
> > [    2.518468] 7c7e1b78 7c9d2378 7cbf2b78 41820054 3d20c076 8089c200 3d20c076 7c84e850
> > [    2.526127] 8129c204 7c842e70 7f844840 419c0008 <0fe00000> 2f9e0000 54847022 7c84fa14
> > [    2.533960] ---[ end trace bf78d94af73fe3b8 ]---
> > [    2.539123] talitos ff020000.crypto: master data transfer error
> > [    2.544775] talitos ff020000.crypto: TEA error: ISR 0x20000000_00000040
> > [    2.551625] alg: skcipher: encryption failed on test 1 for ecb-aes-talitos: ret=22
> >
> > IV cannot be on stack when CONFIG_VMAP_STACK is selected because the stack
> > cannot be DMA mapped anymore.
> >
> > This patch allocates it with kmalloc()
> >
> 
> This looks like a driver bug to me. Other accelerators in
> drivers/crypto all take a copy of the IV before mapping it for DMA, so
> it would be better if talitos did the same.

Yes please fix the driver.  In general, if a paramter is coming in
as a pointer, you must assume that it may lie on the stack.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
