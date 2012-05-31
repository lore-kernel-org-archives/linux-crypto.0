From: Geanta Neag Horia Ioan-B05471 <B05471@freescale.com>
Subject: RE: [PATCH] crypto: talitos - Fix panic in interrupt error path
Date: Thu, 31 May 2012 13:57:23 +0000
Message-ID: <FD18E5D573A8AB48A365D4D78185DE99208F3B@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1338364608-2123-1-git-send-email-helmut.schaa@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Phillips Kim-R1AAHA <R1AAHA@freescale.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	Sven Schnelle <svens@stackframe.org>
To: Helmut Schaa <helmut.schaa@googlemail.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:47280 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932378Ab2EaN6A convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 May 2012 09:58:00 -0400
In-Reply-To: <1338364608-2123-1-git-send-email-helmut.schaa@googlemail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
> owner@vger.kernel.org] On Behalf Of Helmut Schaa
> Sent: Wednesday, May 30, 2012 10:57 AM
> To: linux-crypto@vger.kernel.org
> Cc: Phillips Kim-R1AAHA; herbert@gondor.apana.org.au; Helmut Schaa; Sven
> Schnelle
> Subject: [PATCH] crypto: talitos - Fix panic in interrupt error path
> 
> The talitos interrupt error path can generate a kernel panic
> when priv->chan[ch].fifo[tail].desc is NULL. Check the desc pointer
> before use in current_desc_hdr.
> 
> Unable to handle kernel paging request for data at address 0x00000000
> Faulting instruction address: 0xc01e0f40
> Oops: Kernel access of bad area, sig: 11 [#1]
> SMP NR_CPUS=2 P1020 RDB
> last sysfs file: /sys/kernel/uevent_seqnum
> Modules linked in: pl2303 option keyspan sg usb_wwan usbserial uhci_hcd
> ohci_hcd macvlan ebt_snat ebt_dnat ebt_arpreply ebt_ip ebt_arp
> ebt_redirect ebt_mark ebt_vlan ebt_stp ebt_pkttype ebt_mark_m ebt_limit
> ebt_among ebt_802_3 ebtable_nc
> NIP: c01e0f40 LR: c01e0ea8 CTR: c01e0ccc
> REGS: efff1ea0 TRAP: 0300   Not tainted  (2.6.38.8)
> MSR: 00021000 <ME,CE>  CR: 99355033  XER: c0000000
> DEAR: 00000000, ESR: 00000000
> TASK = c03422e0[0] 'swapper' THREAD: c035a000 CPU: 0
> GPR00: 00000000 efff1f50 c03422e0 ef869608 ef869608 efff1ff0 00000000
> 00000000
> GPR08: efb6ec80 00000000 efb75e00 efb75e10 00000000 1007e92c c02f1740
> 00000000
> GPR16: c02f0000 c02f16bc c02a0000 00000000 ffffffea 00000003 00000001
> 00001280
> GPR24: c02d78a4 010c0100 efb380c0 0000002d 000186a0 ef869608 00000000
> 00000008
> NIP [c01e0f40] talitos_interrupt+0x274/0x8a0
> LR [c01e0ea8] talitos_interrupt+0x1dc/0x8a0
> Call Trace:
> [efff1fa0] [c0066aa4] handle_IRQ_event+0x44/0x110
> [efff1fd0] [c0069468] handle_fasteoi_irq+0x100/0x168
> [efff1ff0] [c000d0ac] call_handle_irq+0x18/0x28
> [efff3c30] [c000449c] do_IRQ+0xe8/0x168
> [efff3c60] [c000f0a4] ret_from_except+0x0/0x18
> --- Exception: 501 at udp_queue_rcv_skb+0xe0/0x378
>     LR = udp_queue_rcv_skb+0xdc/0x378
> [efff3d40] [c024a780] __udp4_lib_rcv+0x31c/0x5cc
> [efff3d80] [c0223518] ip_local_deliver_finish+0x114/0x27c
> [efff3da0] [c02233e0] ip_rcv_finish+0x4b0/0x4d4
> [efff3dc0] [c01fa390] __netif_receive_skb+0x3f8/0x43c
> [efff3e10] [c01fab38] netif_receive_skb+0x98/0xac
> [efff3e40] [c01b84a0] gfar_clean_rx_ring+0x37c/0x470
> [efff3ea0] [c01b89cc] gfar_poll+0x438/0x550
> [efff3f60] [c01fae20] net_rx_action+0x88/0x170
> [efff3fa0] [c0036218] __do_softirq+0xd8/0x170
> [efff3ff0] [c000d084] call_do_softirq+0x14/0x24
> [c035be60] [c000471c] do_softirq+0x7c/0x9c
> [c035be80] [c0036364] irq_exit+0x50/0x60
> [c035be90] [c00044f8] do_IRQ+0x144/0x168
> [c035bec0] [c000f0a4] ret_from_except+0x0/0x18
> --- Exception: 501 at cpu_idle+0xc8/0x154
>     LR = cpu_idle+0xc8/0x154
> [c035bf80] [c0008788] cpu_idle+0x150/0x154 (unreliable)
> [c035bfb0] [c000236c] rest_init+0x68/0x7c
> [c035bfc0] [c0318858] start_kernel+0x2f4/0x308
> [c035bff0] [c00003d8] skpinv+0x2f0/0x32c
> Instruction dump:
> 7fa3eb78 4bf98945 7c7b1b78 48000038 552b2036 39290001 7d6a5a14 800b0004
> 7f870000 409effb0 812b0000 7fa3eb78 <83090000> 4bf98915 7c7b1b78 2f980000
> Kernel panic - not syncing: Fatal exception in interrupt
> Call Trace:
> [efff1dd0] [c0007bd0] show_stack+0x5c/0x164 (unreliable)
> [efff1e10] [c028206c] panic+0xa8/0x1d8
> [efff1e60] [c000a654] die+0x1f8/0x23c
> [efff1e80] [c00135c8] bad_page_fault+0x100/0x114
> [efff1e90] [c000eefc] handle_page_fault+0x7c/0x80
> --- Exception: 300 at talitos_interrupt+0x274/0x8a0
>     LR = talitos_interrupt+0x1dc/0x8a0
> [efff1f50] [00000000]   (null) (unreliable)
> [efff1fa0] [c0066aa4] handle_IRQ_event+0x44/0x110
> [efff1fd0] [c0069468] handle_fasteoi_irq+0x100/0x168
> [efff1ff0] [c000d0ac] call_handle_irq+0x18/0x28
> [efff3c30] [c000449c] do_IRQ+0xe8/0x168
> [efff3c60] [c000f0a4] ret_from_except+0x0/0x18
> --- Exception: 501 at udp_queue_rcv_skb+0xe0/0x378
>     LR = udp_queue_rcv_skb+0xdc/0x378
> [efff3d40] [c024a780] __udp4_lib_rcv+0x31c/0x5cc
> [efff3d80] [c0223518] ip_local_deliver_finish+0x114/0x27c
> [efff3da0] [c02233e0] ip_rcv_finish+0x4b0/0x4d4
> [efff3dc0] [c01fa390] __netif_receive_skb+0x3f8/0x43c
> [efff3e10] [c01fab38] netif_receive_skb+0x98/0xac
> [efff3e40] [c01b84a0] gfar_clean_rx_ring+0x37c/0x470
> [efff3ea0] [c01b89cc] gfar_poll+0x438/0x550
> [efff3f60] [c01fae20] net_rx_action+0x88/0x170
> [efff3fa0] [c0036218] __do_softirq+0xd8/0x170
> [efff3ff0] [c000d084] call_do_softirq+0x14/0x24
> [c035be60] [c000471c] do_softirq+0x7c/0x9c
> [c035be80] [c0036364] irq_exit+0x50/0x60
> [c035be90] [c00044f8] do_IRQ+0x144/0x168
> [c035bec0] [c000f0a4] ret_from_except+0x0/0x18
> --- Exception: 501 at cpu_idle+0xc8/0x154
>     LR = cpu_idle+0xc8/0x154
> [c035bf80] [c0008788] cpu_idle+0x150/0x154 (unreliable)
> [c035bfb0] [c000236c] rest_init+0x68/0x7c
> [c035bfc0] [c0318858] start_kernel+0x2f4/0x308
> [c035bff0] [c00003d8] skpinv+0x2f0/0x32c
> 
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> Cc: Sven Schnelle <svens@stackframe.org>
> Cc: Kim Phillips <kim.phillips@freescale.com>
> 
> ---
> 
> Not sure if this is the same bug as "talitos: handle descriptor not found
> in
> error path" was intended to fix. But I've been running this one for a
> while
> now without experiencing the crash anymore.

I am trying to reproduce the issue here.
What tree are you running against?

Herbert, I think I am seeing an inconsistency b/w crypto and linux trees.
The following commit, found in Linus's tree
511d63c crypto: talitos - properly lock access to global talitos register
went through the crypto tree but doesn't seem to exist anymore.
This is relevant wrt current discussion...

My take is that the root cause is somewhere else, and I have two leads.
Helmut, could you please check no.1 while I am working to reproduce this
on my side?

1. Not sure which platform you are running on, but if you are using
a 64-bit kernel, the following fix applies. Let me know if this makes
a difference.

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index dc641c7..8aba2bb 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -444,6 +444,9 @@ static u32 current_desc_hdr(struct device *dev, int ch)
        dma_addr_t cur_desc;

        cur_desc = in_be32(priv->chan[ch].reg + TALITOS_CDPR_LO);
+       if (sizeof(dma_addr_t) == sizeof(u64))
+               cur_desc |= (u64)(in_be32(priv->chan[ch].reg + TALITOS_CDPR) &
+                            TALITOS_CDPR_EPTR) << 32;

        while (priv->chan[ch].fifo[tail].dma_desc != cur_desc) {
                tail = (tail + 1) & (priv->fifo_len - 1);


diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 3c17395..c6ba4d5 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -93,6 +93,7 @@

 /* current descriptor pointer register */
 #define TALITOS_CDPR                   0x40
+#define   TALITOS_CDPR_EPTR            0x0f
 #define TALITOS_CDPR_LO                        0x44

 /* descriptor buffer register */


2. Since commit 511d63c is probably missing from your tree, the following
scenario is possible
primary IRQ --> talitos_interrupt --> tasklet_schedule(talitos_done)
talitos_done --> flush_channel(ch0) --> request->desc = NULL;
secondary IRQ --> talitos_interrupt --> talitos_error --> current_desc_hdr(ch0)

But with 511d63c included, this is not feasible since talitos_error won't
handle anymore all channels, since it' called differently  - some bits in isr
are masked out:
talitos_error(dev, isr & ch_err_mask, isr_lo);

Horia

> 
> Thanks,
> Helmut
> 
>  drivers/crypto/talitos.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index 921039e..56d7804 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -459,7 +459,9 @@ static u32 current_desc_hdr(struct device *dev, int
> ch)
>  		}
>  	}
> 
> -	return priv->chan[ch].fifo[tail].desc->hdr;
> +	if (priv->chan[ch].fifo[tail].desc)
> +		return priv->chan[ch].fifo[tail].desc->hdr;
> +	return 0;
>  }
> 
>  /*
> --
> 1.7.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
