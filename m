Return-Path: <SRS0=aDvo=PQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:54804 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfAHFBD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Jan 2019 00:01:03 -0500
Date: Tue, 8 Jan 2019 13:00:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] crypto: talitos - fix ablkcipher for CONFIG_VMAP_STACK
Message-ID: <20190108050028.mrdz727dhzmlbi7i@gondor.apana.org.au>
References: <ae7b64e9415874060977e32ed48b62f1f6148084.1545346337.git.christophe.leroy@c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae7b64e9415874060977e32ed48b62f1f6148084.1545346337.git.christophe.leroy@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 21, 2018 at 08:07:52AM +0000, Christophe Leroy wrote:
> [    2.364486] WARNING: CPU: 0 PID: 60 at ./arch/powerpc/include/asm/io.h:837 dma_nommu_map_page+0x44/0xd4
> [    2.373579] CPU: 0 PID: 60 Comm: cryptomgr_test Tainted: G        W         4.20.0-rc5-00560-g6bfb52e23a00-dirty #531
> [    2.384740] NIP:  c000c540 LR: c000c584 CTR: 00000000
> [    2.389743] REGS: c95abab0 TRAP: 0700   Tainted: G        W          (4.20.0-rc5-00560-g6bfb52e23a00-dirty)
> [    2.400042] MSR:  00029032 <EE,ME,IR,DR,RI>  CR: 24042204  XER: 00000000
> [    2.406669]
> [    2.406669] GPR00: c02f2244 c95abb60 c6262990 c95abd80 0000256a 00000001 00000001 00000001
> [    2.406669] GPR08: 00000000 00002000 00000010 00000010 24042202 00000000 00000100 c95abd88
> [    2.406669] GPR16: 00000000 c05569d4 00000001 00000010 c95abc88 c0615664 00000004 00000000
> [    2.406669] GPR24: 00000010 c95abc88 c95abc88 00000000 c61ae210 c7ff6d40 c61ae210 00003d68
> [    2.441559] NIP [c000c540] dma_nommu_map_page+0x44/0xd4
> [    2.446720] LR [c000c584] dma_nommu_map_page+0x88/0xd4
> [    2.451762] Call Trace:
> [    2.454195] [c95abb60] [82000808] 0x82000808 (unreliable)
> [    2.459572] [c95abb80] [c02f2244] talitos_edesc_alloc+0xbc/0x3c8
> [    2.465493] [c95abbb0] [c02f2600] ablkcipher_edesc_alloc+0x4c/0x5c
> [    2.471606] [c95abbd0] [c02f4ed0] ablkcipher_encrypt+0x20/0x64
> [    2.477389] [c95abbe0] [c02023b0] __test_skcipher+0x4bc/0xa08
> [    2.483049] [c95abe00] [c0204b60] test_skcipher+0x2c/0xcc
> [    2.488385] [c95abe20] [c0204c48] alg_test_skcipher+0x48/0xbc
> [    2.494064] [c95abe40] [c0205cec] alg_test+0x164/0x2e8
> [    2.499142] [c95abf00] [c0200dec] cryptomgr_test+0x48/0x50
> [    2.504558] [c95abf10] [c0039ff4] kthread+0xe4/0x110
> [    2.509471] [c95abf40] [c000e1d0] ret_from_kernel_thread+0x14/0x1c
> [    2.515532] Instruction dump:
> [    2.518468] 7c7e1b78 7c9d2378 7cbf2b78 41820054 3d20c076 8089c200 3d20c076 7c84e850
> [    2.526127] 8129c204 7c842e70 7f844840 419c0008 <0fe00000> 2f9e0000 54847022 7c84fa14
> [    2.533960] ---[ end trace bf78d94af73fe3b8 ]---
> [    2.539123] talitos ff020000.crypto: master data transfer error
> [    2.544775] talitos ff020000.crypto: TEA error: ISR 0x20000000_00000040
> [    2.551625] alg: skcipher: encryption failed on test 1 for ecb-aes-talitos: ret=22
> 
> IV cannot be on stack when CONFIG_VMAP_STACK is selected because the stack
> cannot be DMA mapped anymore.
> 
> This patch copies the IV into the extended descriptor when iv is not
> a valid linear address.

Please make the copy unconditional.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
