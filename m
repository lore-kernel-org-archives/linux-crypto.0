From: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] crypto: talitos - Fix panic in interrupt error path
Date: Wed, 30 May 2012 09:56:48 +0200
Message-ID: <1338364608-2123-1-git-send-email-helmut.schaa@googlemail.com>
Cc: kim.phillips@freescale.com, herbert@gondor.apana.org.au,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Sven Schnelle <svens@stackframe.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54937 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110Ab2E3H5A (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 May 2012 03:57:00 -0400
Received: by eeit10 with SMTP id t10so1389816eei.19
        for <linux-crypto@vger.kernel.org>; Wed, 30 May 2012 00:56:58 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The talitos interrupt error path can generate a kernel panic
when priv->chan[ch].fifo[tail].desc is NULL. Check the desc pointer
before use in current_desc_hdr.

Unable to handle kernel paging request for data at address 0x00000000
Faulting instruction address: 0xc01e0f40
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=2 P1020 RDB
last sysfs file: /sys/kernel/uevent_seqnum
Modules linked in: pl2303 option keyspan sg usb_wwan usbserial uhci_hcd
ohci_hcd macvlan ebt_snat ebt_dnat ebt_arpreply ebt_ip ebt_arp
ebt_redirect ebt_mark ebt_vlan ebt_stp ebt_pkttype ebt_mark_m ebt_limit
ebt_among ebt_802_3 ebtable_nc
NIP: c01e0f40 LR: c01e0ea8 CTR: c01e0ccc
REGS: efff1ea0 TRAP: 0300   Not tainted  (2.6.38.8)
MSR: 00021000 <ME,CE>  CR: 99355033  XER: c0000000
DEAR: 00000000, ESR: 00000000
TASK = c03422e0[0] 'swapper' THREAD: c035a000 CPU: 0
GPR00: 00000000 efff1f50 c03422e0 ef869608 ef869608 efff1ff0 00000000 00000000
GPR08: efb6ec80 00000000 efb75e00 efb75e10 00000000 1007e92c c02f1740 00000000
GPR16: c02f0000 c02f16bc c02a0000 00000000 ffffffea 00000003 00000001 00001280
GPR24: c02d78a4 010c0100 efb380c0 0000002d 000186a0 ef869608 00000000 00000008
NIP [c01e0f40] talitos_interrupt+0x274/0x8a0
LR [c01e0ea8] talitos_interrupt+0x1dc/0x8a0
Call Trace:
[efff1fa0] [c0066aa4] handle_IRQ_event+0x44/0x110
[efff1fd0] [c0069468] handle_fasteoi_irq+0x100/0x168
[efff1ff0] [c000d0ac] call_handle_irq+0x18/0x28
[efff3c30] [c000449c] do_IRQ+0xe8/0x168
[efff3c60] [c000f0a4] ret_from_except+0x0/0x18
--- Exception: 501 at udp_queue_rcv_skb+0xe0/0x378
    LR = udp_queue_rcv_skb+0xdc/0x378
[efff3d40] [c024a780] __udp4_lib_rcv+0x31c/0x5cc
[efff3d80] [c0223518] ip_local_deliver_finish+0x114/0x27c
[efff3da0] [c02233e0] ip_rcv_finish+0x4b0/0x4d4
[efff3dc0] [c01fa390] __netif_receive_skb+0x3f8/0x43c
[efff3e10] [c01fab38] netif_receive_skb+0x98/0xac
[efff3e40] [c01b84a0] gfar_clean_rx_ring+0x37c/0x470
[efff3ea0] [c01b89cc] gfar_poll+0x438/0x550
[efff3f60] [c01fae20] net_rx_action+0x88/0x170
[efff3fa0] [c0036218] __do_softirq+0xd8/0x170
[efff3ff0] [c000d084] call_do_softirq+0x14/0x24
[c035be60] [c000471c] do_softirq+0x7c/0x9c
[c035be80] [c0036364] irq_exit+0x50/0x60
[c035be90] [c00044f8] do_IRQ+0x144/0x168
[c035bec0] [c000f0a4] ret_from_except+0x0/0x18
--- Exception: 501 at cpu_idle+0xc8/0x154
    LR = cpu_idle+0xc8/0x154
[c035bf80] [c0008788] cpu_idle+0x150/0x154 (unreliable)
[c035bfb0] [c000236c] rest_init+0x68/0x7c
[c035bfc0] [c0318858] start_kernel+0x2f4/0x308
[c035bff0] [c00003d8] skpinv+0x2f0/0x32c
Instruction dump:
7fa3eb78 4bf98945 7c7b1b78 48000038 552b2036 39290001 7d6a5a14 800b0004
7f870000 409effb0 812b0000 7fa3eb78 <83090000> 4bf98915 7c7b1b78 2f980000
Kernel panic - not syncing: Fatal exception in interrupt
Call Trace:
[efff1dd0] [c0007bd0] show_stack+0x5c/0x164 (unreliable)
[efff1e10] [c028206c] panic+0xa8/0x1d8
[efff1e60] [c000a654] die+0x1f8/0x23c
[efff1e80] [c00135c8] bad_page_fault+0x100/0x114
[efff1e90] [c000eefc] handle_page_fault+0x7c/0x80
--- Exception: 300 at talitos_interrupt+0x274/0x8a0
    LR = talitos_interrupt+0x1dc/0x8a0
[efff1f50] [00000000]   (null) (unreliable)
[efff1fa0] [c0066aa4] handle_IRQ_event+0x44/0x110
[efff1fd0] [c0069468] handle_fasteoi_irq+0x100/0x168
[efff1ff0] [c000d0ac] call_handle_irq+0x18/0x28
[efff3c30] [c000449c] do_IRQ+0xe8/0x168
[efff3c60] [c000f0a4] ret_from_except+0x0/0x18
--- Exception: 501 at udp_queue_rcv_skb+0xe0/0x378
    LR = udp_queue_rcv_skb+0xdc/0x378
[efff3d40] [c024a780] __udp4_lib_rcv+0x31c/0x5cc
[efff3d80] [c0223518] ip_local_deliver_finish+0x114/0x27c
[efff3da0] [c02233e0] ip_rcv_finish+0x4b0/0x4d4
[efff3dc0] [c01fa390] __netif_receive_skb+0x3f8/0x43c
[efff3e10] [c01fab38] netif_receive_skb+0x98/0xac
[efff3e40] [c01b84a0] gfar_clean_rx_ring+0x37c/0x470
[efff3ea0] [c01b89cc] gfar_poll+0x438/0x550
[efff3f60] [c01fae20] net_rx_action+0x88/0x170
[efff3fa0] [c0036218] __do_softirq+0xd8/0x170
[efff3ff0] [c000d084] call_do_softirq+0x14/0x24
[c035be60] [c000471c] do_softirq+0x7c/0x9c
[c035be80] [c0036364] irq_exit+0x50/0x60
[c035be90] [c00044f8] do_IRQ+0x144/0x168
[c035bec0] [c000f0a4] ret_from_except+0x0/0x18
--- Exception: 501 at cpu_idle+0xc8/0x154
    LR = cpu_idle+0xc8/0x154
[c035bf80] [c0008788] cpu_idle+0x150/0x154 (unreliable)
[c035bfb0] [c000236c] rest_init+0x68/0x7c
[c035bfc0] [c0318858] start_kernel+0x2f4/0x308
[c035bff0] [c00003d8] skpinv+0x2f0/0x32c


Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Sven Schnelle <svens@stackframe.org>
Cc: Kim Phillips <kim.phillips@freescale.com>

---

Not sure if this is the same bug as "talitos: handle descriptor not found in
error path" was intended to fix. But I've been running this one for a while
now without experiencing the crash anymore.

Thanks,
Helmut

 drivers/crypto/talitos.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 921039e..56d7804 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -459,7 +459,9 @@ static u32 current_desc_hdr(struct device *dev, int ch)
 		}
 	}
 
-	return priv->chan[ch].fifo[tail].desc->hdr;
+	if (priv->chan[ch].fifo[tail].desc)
+		return priv->chan[ch].fifo[tail].desc->hdr;
+	return 0;
 }
 
 /*
-- 
1.7.7
