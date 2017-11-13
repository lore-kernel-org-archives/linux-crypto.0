From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH 1/2] crypto: tcrypt - fix S/G table for test_aead_speed()
Date: Mon, 13 Nov 2017 20:24:21 +0200
Message-ID: <c0079a24-d338-76f0-2957-1d3727e966fc@microchip.com>
References: <1507630920-9014-1-git-send-email-robert.baronescu@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
To: Robert Baronescu <robert.baronescu@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:24116 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754445AbdKMSY3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Nov 2017 13:24:29 -0500
In-Reply-To: <1507630920-9014-1-git-send-email-robert.baronescu@nxp.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On 10/10/2017 01:21 PM, Robert Baronescu wrote:
> In case buffer length is a multiple of PAGE_SIZE,
> the S/G table is incorrectly generated.
> Fix this by handling buflen = k * PAGE_SIZE separately.
> 
> Signed-off-by: Robert Baronescu <robert.baronescu@nxp.com>
> ---
>   crypto/tcrypt.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)

This patch fixes the segmentation fault listed below. The NULL
dereference can be seen starting with:
7aacbfc crypto: tcrypt - fix buffer lengths in test_aead_speed()

Cheers,
ta

# insmod tcrypt.ko mode=212

testing speed of rfc4309(ccm(aes)) 
(rfc4309(ccm_base(ctr(aes-generic),cbcmac(aes-generic)))) encryption
test 0 (152 bit key, 16 byte blocks):
1 operation in 0 cycles (16 bytes)
test 1 (152 bit key, 64 byte blocks):
1 operation in 0 cycles (64 bytes)
test 2 (152 bit key, 256 byte blocks):
1 operation in 0 cycles (256 bytes)
test 3 (152 bit key, 512 byte blocks):
1 operation in 0 cycles (512 bytes)
test 4 (152 bit key, 1024 byte blocks):
1 operation in 0 cycles (1024 bytes)
test 5 (152 bit key, 2048 byte blocks):
1 operation in 0 cycles (2048 bytes)
test 6 (152 bit key, 4096 byte blocks):
Unable to handle kernel NULL pointer dereference at virtual address 00000004
pgd = deee0000
[00000004] *pgd=3f6b8831, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1] ARM
Modules linked in: tcrypt(+)
CPU: 0 PID: 795 Comm: insmod Not tainted 4.14.0-rc3+ #15
Hardware name: Atmel SAMA5
task: def4d000 task.stack: def4a000
PC is at scatterwalk_copychunks+0x14c/0x18c
LR is at scatterwalk_copychunks+0x144/0x18c
pc : [<c02c2d84>]    lr : [<c02c2d7c>]    psr: 20000013
sp : def4bbf8  ip : 00000000  fp : def4bcb4
r10: c02d1e5c  r9 : 00000000  r8 : def4a000
r7 : defd0090  r6 : def4bc58  r5 : 00000010  r4 : 00000000
r3 : dffe71e2  r2 : def4d000  r1 : 00000000  r0 : 00000000
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 10c53c7d  Table: 3eee0059  DAC: 00000051
Process insmod (pid: 795, stack limit = 0xdef4a208)
Stack: (0xdef4bbf8 to 0xdef4c000)
bbe0:                                                       def4bc48 
00000010
bc00: def4bcbc ffffffff 00000010 00000000 c02d1e5c c02c47f0 00000010 
def4bc28
bc20: deefe110 00000000 deefe200 def11800 c02d1e5c c02cc178 000000e7 
def4bc38
bc40: 00000010 def4bcbc dffd8fc0 defd0090 dffd8fc0 defd0080 00000000 
00000000
bc60: 00001000 def7e2a0 00000000 00001000 00000000 defd0080 deefe200 
00000010
bc80: 00000000 00000010 00000001 00000000 00000000 c02cc0bc 00000000 
ded1a4c0
bca0: 00001000 deefe200 deefe0c0 deefe134 deefe164 c02c509c 00001000 
deda5280
bcc0: deefe200 00000400 deefe100 c02cec9c def4bd70 deefe000 00000000 
deefe000
bce0: 00000000 00000004 00000000 def7e200 bf007144 ded19300 00000000 
bf001950
bd00: 014000c0 bf007234 00000000 00000010 bf0075c0 def7e290 deda7a80 
00000006
bd20: c0a4bd38 00001000 00000000 ded19300 bf007140 ded19340 00000000 
defd0f00
bd40: 00000000 def4bd44 def4bd44 c0176ea4 df60f000 def5c000 def5e000 
deff1000
bd60: df4a5000 df651000 df648000 df646000 deebe000 dee59000 deeae000 
defd1000
bd80: deda0000 defd3000 de806000 def82000 def63000 def78000 deec7000 
deeff000
bda0: deeb9000 deef2000 deeba000 deebd000 00000000 00000000 00000004 
bf0075c0
bdc0: bf007440 defd0f00 bf007488 00000001 2102f11c bf005238 df4ac000 
000075c0
bde0: 00000003 bf0075c0 bf007440 bf0075c0 00000004 bf0075c0 bf007440 
defd0f00
be00: bf007488 bf00a054 bf007440 bf00a000 00000000 c01018e8 00000000 
ded17780
be20: df4ac000 c0a3a72c df420000 c0844a4c c07df704 c01a5054 bf007488 
c0684d38
be40: 00000012 deda7440 defd0f08 a0000013 deda7640 e0a7e000 00000001 
defd0f00
be60: bf007440 defd0f08 deda7640 defd0f00 bf007488 c016203c bf007488 
00000001
be80: def4bf50 defd0f08 00000001 c0161390 bf00744c 00007fff bf007440 
c015ea8c
bea0: 00000000 bf007590 00000578 bf007528 c0844c7c c07018f0 c01b1060 
bf000000
bec0: 0000dcfb 0000dcfb 00000000 00000000 00000000 00000000 00000000 
00000000
bee0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
00000000
bf00: 00000000 00000000 7fffffff 00000000 00000003 00099008 0000017b 
c0107964
bf20: def4a000 00000000 00000000 c0161a68 7fffffff 00000000 00000003 
a0000013
bf40: dedd1c00 e0a7e000 0000dcfb 00000000 e0a83d03 e0a7e000 0000dcfb 
e0a85238
bf60: e0a850dd e0a8b258 00008000 000081d0 00000000 00000000 00000000 
00002e84
bf80: 00000021 00000022 00000019 00000000 00000013 00000000 00099008 
bebd1f45
bfa0: 00000003 c01077a0 00099008 bebd1f45 00000003 00099008 00000000 
bebd1f45
bfc0: 00099008 bebd1f45 00000003 0000017b bebd1f45 00000000 00000000 
00000000
bfe0: bebd1ca8 bebd1c98 0001f99d b6f3f2c4 80000030 00000003 00000000 
00000000
[<c02c2d84>] (scatterwalk_copychunks) from [<c02c47f0>] 
(blkcipher_walk_next+0x3a0/0x44c)
[<c02c47f0>] (blkcipher_walk_next) from [<c02cc178>] 
(crypto_ctr_crypt+0xbc/0x1cc)
[<c02cc178>] (crypto_ctr_crypt) from [<c02c509c>] 
(skcipher_encrypt_blkcipher+0x44/0x4c)
[<c02c509c>] (skcipher_encrypt_blkcipher) from [<c02cec9c>] 
(crypto_ccm_encrypt+0xc8/0xf8)
[<c02cec9c>] (crypto_ccm_encrypt) from [<bf001950>] 
(test_aead_speed.constprop.2+0x3e8/0x5a8 [tcrypt])
[<bf001950>] (test_aead_speed.constprop.2 [tcrypt]) from [<bf005238>] 
(do_test+0x3728/0x3e88 [tcrypt])
[<bf005238>] (do_test [tcrypt]) from [<bf00a054>] 
(tcrypt_mod_init+0x54/0x1000 [tcrypt])
[<bf00a054>] (tcrypt_mod_init [tcrypt]) from [<c01018e8>] 
(do_one_initcall+0x40/0x16c)
[<c01018e8>] (do_one_initcall) from [<c016203c>] (do_init_module+0x60/0x1d8)
[<c016203c>] (do_init_module) from [<c0161390>] (load_module+0x1c4c/0x214c)
[<c0161390>] (load_module) from [<c0161a68>] (SyS_finit_module+0x8c/0x9c)
[<c0161a68>] (SyS_finit_module) from [<c01077a0>] 
(ret_fast_syscall+0x0/0x48)
Code: e1a00001 eb00da5e e5860000 e1a01000 (e590c004)
---[ end trace d97c437cd566fdf4 ]---
Segmentation fault
