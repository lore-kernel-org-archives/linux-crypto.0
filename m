Return-Path: <SRS0=aDvo=PQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr40058.outbound.protection.outlook.com ([40.107.4.58]:30929
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727001AbfAHJso (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Jan 2019 04:48:44 -0500
From: Horia Geanta <horia.geanta@nxp.com>
To: Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v4 2/2] crypto: talitos - fix ablkcipher for
 CONFIG_VMAP_STACK
Date: Tue, 8 Jan 2019 09:48:01 +0000
Message-ID: <VI1PR0402MB348598283A66F0F2C39A437E988A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <5ed91db5e2976a4c260465c3d027acc9affd2d2b.1545445924.git.christophe.leroy@c-s.fr>
 <e082265fba04b4a4c17003a73820844c8feb5017.1545445924.git.christophe.leroy@c-s.fr>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 1/8/2019 8:56 AM, Christophe Leroy wrote:=0A=
> [    2.364486] WARNING: CPU: 0 PID: 60 at ./arch/powerpc/include/asm/io.h=
:837 dma_nommu_map_page+0x44/0xd4=0A=
> [    2.373579] CPU: 0 PID: 60 Comm: cryptomgr_test Tainted: G        W   =
      4.20.0-rc5-00560-g6bfb52e23a00-dirty #531=0A=
> [    2.384740] NIP:  c000c540 LR: c000c584 CTR: 00000000=0A=
> [    2.389743] REGS: c95abab0 TRAP: 0700   Tainted: G        W          (=
4.20.0-rc5-00560-g6bfb52e23a00-dirty)=0A=
> [    2.400042] MSR:  00029032 <EE,ME,IR,DR,RI>  CR: 24042204  XER: 000000=
00=0A=
> [    2.406669]=0A=
> [    2.406669] GPR00: c02f2244 c95abb60 c6262990 c95abd80 0000256a 000000=
01 00000001 00000001=0A=
> [    2.406669] GPR08: 00000000 00002000 00000010 00000010 24042202 000000=
00 00000100 c95abd88=0A=
> [    2.406669] GPR16: 00000000 c05569d4 00000001 00000010 c95abc88 c06156=
64 00000004 00000000=0A=
> [    2.406669] GPR24: 00000010 c95abc88 c95abc88 00000000 c61ae210 c7ff6d=
40 c61ae210 00003d68=0A=
> [    2.441559] NIP [c000c540] dma_nommu_map_page+0x44/0xd4=0A=
> [    2.446720] LR [c000c584] dma_nommu_map_page+0x88/0xd4=0A=
> [    2.451762] Call Trace:=0A=
> [    2.454195] [c95abb60] [82000808] 0x82000808 (unreliable)=0A=
> [    2.459572] [c95abb80] [c02f2244] talitos_edesc_alloc+0xbc/0x3c8=0A=
> [    2.465493] [c95abbb0] [c02f2600] ablkcipher_edesc_alloc+0x4c/0x5c=0A=
> [    2.471606] [c95abbd0] [c02f4ed0] ablkcipher_encrypt+0x20/0x64=0A=
> [    2.477389] [c95abbe0] [c02023b0] __test_skcipher+0x4bc/0xa08=0A=
> [    2.483049] [c95abe00] [c0204b60] test_skcipher+0x2c/0xcc=0A=
> [    2.488385] [c95abe20] [c0204c48] alg_test_skcipher+0x48/0xbc=0A=
> [    2.494064] [c95abe40] [c0205cec] alg_test+0x164/0x2e8=0A=
> [    2.499142] [c95abf00] [c0200dec] cryptomgr_test+0x48/0x50=0A=
> [    2.504558] [c95abf10] [c0039ff4] kthread+0xe4/0x110=0A=
> [    2.509471] [c95abf40] [c000e1d0] ret_from_kernel_thread+0x14/0x1c=0A=
> [    2.515532] Instruction dump:=0A=
> [    2.518468] 7c7e1b78 7c9d2378 7cbf2b78 41820054 3d20c076 8089c200 3d20=
c076 7c84e850=0A=
> [    2.526127] 8129c204 7c842e70 7f844840 419c0008 <0fe00000> 2f9e0000 54=
847022 7c84fa14=0A=
> [    2.533960] ---[ end trace bf78d94af73fe3b8 ]---=0A=
> [    2.539123] talitos ff020000.crypto: master data transfer error=0A=
> [    2.544775] talitos ff020000.crypto: TEA error: ISR 0x20000000_0000004=
0=0A=
> [    2.551625] alg: skcipher: encryption failed on test 1 for ecb-aes-tal=
itos: ret=3D22=0A=
> =0A=
> IV cannot be on stack when CONFIG_VMAP_STACK is selected because the stac=
k=0A=
> cannot be DMA mapped anymore.=0A=
> =0A=
> This patch copies the IV into the extended descriptor.=0A=
> =0A=
> Fixes: 4de9d0b547b9 ("crypto: talitos - Add ablkcipher algorithms")=0A=
> Cc: stable@vger.kernel.org=0A=
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
