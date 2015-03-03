From: yjin <yanjiang.jin@windriver.com>
Subject: Re: [PATCH 4/4] crypto: caamhash: replace kmalloc with kzalloc
Date: Tue, 3 Mar 2015 14:54:50 +0800
Message-ID: <54F55ABA.8060502@windriver.com>
References: <1425103234-31129-1-git-send-email-yanjiang.jin@windriver.com> <1425103234-31129-4-git-send-email-yanjiang.jin@windriver.com> <54F4438A.30705@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <kim.phillips@freescale.com>, <ruchika.gupta@freescale.com>,
	<cristian.stoica@freescale.com>, <NiteshNarayanLal@freescale.com>,
	<jinyanjiang@gmail.com>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
To: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:46394 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbbCCGy7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Mar 2015 01:54:59 -0500
In-Reply-To: <54F4438A.30705@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On 2015=E5=B9=B403=E6=9C=8802=E6=97=A5 19:03, Horia Geant=C4=83 wrote:
> On 2/28/2015 8:00 AM, yanjiang.jin@windriver.com wrote:
>> From: Yanjiang Jin <yanjiang.jin@windriver.com>
>>
>> This can make sure we get a clean memory, else system would report
>> the below warning:
> I'd avoid using kzalloc, it's an overhead on the hot path. kmalloc ca=
n
> be used with a bit of attention to detail, i.e. what params to
> explicitly initialize.
Got it. Just zeroing edesc->sec4_sg_bytes in V2.

Thanks!
Yanjiang
>
> I see that the stack trace reports using WR Linux and a modified caam
> driver - it uses NAPI (net_rx_action) instead of tasklet.
>
> Have you actually reproduced the problem on upstream linux?
> There are some fixes that already address similar (if not exact) prob=
lem:
> 76b99080ccc9 "crypto: caam - fix uninitialized edesc->dst_dma fiel"
> 45e9af78b1ab "crypto: caam - fix uninitialized S/G table size in
> ahash_digest"
>
> Thanks,
> Horia
>
>> caam_jr ffe301000.jr: DMA-API: device driver tries to free DMA memor=
y it has not allocated [device address=3D0xdeadbeefdeadbeef] [size=3D18=
446744073150512879 bytes]
>> ------------[ cut here ]------------
>> WARNING: at lib/dma-debug.c:877
>> Modules linked in:
>> CPU: 1 PID: 98 Comm: cryptomgr_test Not tainted 3.10.62-ltsi-WR6.0.0=
=2E0_standard #175
>> task: c0000000f74bc400 ti: c0000000fffd0000 task.ti: c0000000f775c00=
0
>> NIP: c0000000004f5ed8 LR: c0000000004f5ed4 CTR: c00000000055a160
>> REGS: c0000000fffd3650 TRAP: 0700   Not tainted  (3.10.62-ltsi-WR6.0=
=2E0.0_standard)
>> MSR: 0000000080029000 <CE,EE,ME>  CR: 24a48e84  XER: 00000000
>> SOFTE: 1
>>
>> 004f5ed4 c0000000fffd38d0 c0000000012af348 00000000000000a0
>> 24a48e84 0000000000000000 c00000000125f1c8 00000000000001eb
>> 00000060 0000000000000001 0000000010187373 0000000000000020
>> 000001eb c000000001fff780 c0000000011ac928 c00000007f003028
>> 00000097 0000000000000098 0000000000000098 c0000000f7758800
>> f7098c00 0000000000000001 0000000000000001 000000000000003f
>> f7098c00 0000000000000014 c00000007f003000 c0000000011b0e98
>> 00000000 c000000001565b80 c0000000fffd39e0 c0000000f72f2410
>> NIP [c0000000004f5ed8] .check_unmap+0x848/0x9c0
>> LR [c0000000004f5ed4] .check_unmap+0x844/0x9c0
>> Call Trace:
>> [c0000000fffd38d0] [c0000000004f5ed4] .check_unmap+0x844/0x9c0 (unre=
liable)
>> [c0000000fffd3970] [c0000000004f60d4] .debug_dma_unmap_page+0x84/0xb=
0
>> [c0000000fffd3aa0] [c0000000008295cc] .ahash_done+0x1dc/0x360
>> [c0000000fffd3ca0] [c00000000081b7ec] .caam_jr_dequeue+0x26c/0x3a0
>> [c0000000fffd3da0] [c0000000008be50c] .net_rx_action+0x1cc/0x330
>> [c0000000fffd3e80] [c00000000007276c] .__do_softirq+0x19c/0x3d0
>> [c0000000fffd3f90] [c000000000017054] .call_do_softirq+0x14/0x24
>> [c0000000f775ef10] [c000000000005fe8] .do_softirq+0x118/0x150
>>   sda: sda1 sda2 sda3
>> [c0000000f775efa0] [c000000000072c54] .irq_exit+0x124/0x140
>> [c0000000f775f020] [c000000000005ac4] .do_IRQ+0x184/0x370
>> [c0000000f775f0d0] [c00000000001b93c] exc_0x500_common+0xfc/0x100
>> --- Exception: 501 at .rcu_note_context_switch+0x0/0x370
>> edule+0xbc/0x7f0
>> [c0000000f775f3c0] [c000000000a29944] .__schedule+0xa4/0x7f0 (unreli=
able)
>> [c0000000f775f620] [c000000000a277f4] .schedule_timeout+0x1b4/0x2e0
>> [c0000000f775f700] [c000000000a29428] .wait_for_common+0xf8/0x1d0
>> [c0000000f775f7c0] [c000000000a295ac] .wait_for_completion_interrupt=
ible+0x2c/0x50
>> [c0000000f775f840] [c000000000494b64] .do_one_async_hash_op.isra.1.p=
art.2+0x24/0x50
>> [c0000000f775f8c0] [c0000000004951a8] .test_hash+0x618/0x7d0
>> [c0000000f775fb30] [c000000000495424] .alg_test_hash+0xc4/0xf0
>> [c0000000f775fbc0] [c000000000494928] .alg_test+0xa8/0x2c0
>> [c0000000f775fcb0] [c000000000491164] .cryptomgr_test+0x64/0x80
>> [c0000000f775fd30] [c00000000009a8d0] .kthread+0xf0/0x100
>> [c0000000f775fe30] [c000000000000a08] .ret_from_kernel_thread+0x5c/0=
xd4
>> Instruction dump:
>> 7c641b78 419e0160 e8a90050 2fa50000 409e0008 e8a90010 e8de0028 e8fe0=
030
>> 3c62ff90 38638320 48546b69 60000000 <0fe00000> 4bffff34 e87e0010 2fa=
30000
>> ---[ end trace 52825d316d569f00 ]---
>>
>> Signed-off-by: Yanjiang Jin <yanjiang.jin@windriver.com>
>> ---
>
>
>
