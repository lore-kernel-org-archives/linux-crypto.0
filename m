From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 6/6] crypto: talitos - fix memory corruption on SEC2
Date: Thu, 21 Sep 2017 09:19:57 +0200 (CEST)
Message-ID: <67156bd23e71a80dcd32c1ec084e26ed4d114b47.1575825623.git.christophe.leroy@c-s.fr>
References: <cover.1575825623.git.christophe.leroy@c-s.fr>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:36877 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751716AbdIUHT7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2017 03:19:59 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 3xySfn45HXz9ttBX
        for <linux-crypto@vger.kernel.org>; Thu, 21 Sep 2017 09:19:45 +0200 (CEST)
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id X9URSTGLYTUM for <linux-crypto@vger.kernel.org>;
        Thu, 21 Sep 2017 09:19:45 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 3xySfn3Dbwz9ttBK
        for <linux-crypto@vger.kernel.org>; Thu, 21 Sep 2017 09:19:45 +0200 (CEST)
In-Reply-To: <cover.1575825623.git.christophe.leroy@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On SEC2, when using the old descriptors type (hmac snoop no afeu)
for doing IPsec, the CICV out pointeur points out of the allocated
memory.

[    2.502554] =============================================================================
[    2.510740] BUG dma-kmalloc-256 (Not tainted): Redzone overwritten
[    2.516907] -----------------------------------------------------------------------------
[    2.516907]
[    2.526535] Disabling lock debugging due to kernel taint
[    2.531845] INFO: 0xde858108-0xde85810b. First byte 0xf8 instead of 0xcc
[    2.538549] INFO: Allocated in 0x806181a9 age=0 cpu=0 pid=58
[    2.544229] 	__kmalloc+0x374/0x564
[    2.547649] 	talitos_edesc_alloc+0x17c/0x48c
[    2.551929] 	aead_edesc_alloc+0x80/0x154
[    2.555863] 	aead_encrypt+0x30/0xe0
[    2.559368] 	__test_aead+0x5a0/0x1f3c
[    2.563042] 	test_aead+0x2c/0x110
[    2.566371] 	alg_test_aead+0x5c/0xf4
[    2.569958] 	alg_test+0x1dc/0x5a0
[    2.573305] 	cryptomgr_test+0x50/0x70
[    2.576984] 	kthread+0xd8/0x134
[    2.580155] 	ret_from_kernel_thread+0x5c/0x64
[    2.584534] INFO: Freed in ipsec_esp_encrypt_done+0x130/0x240 age=6 cpu=0 pid=0
[    2.591839] 	ipsec_esp_encrypt_done+0x130/0x240
[    2.596395] 	flush_channel+0x1dc/0x488
[    2.600161] 	talitos2_done_4ch+0x30/0x200
[    2.604185] 	tasklet_action+0xa0/0x13c
[    2.607948] 	__do_softirq+0x148/0x6cc
[    2.611623] 	irq_exit+0xc0/0x124
[    2.614869] 	call_do_irq+0x24/0x3c
[    2.618292] 	do_IRQ+0x78/0x108
[    2.621369] 	ret_from_except+0x0/0x14
[    2.625055] 	finish_task_switch+0x58/0x350
[    2.629165] 	schedule+0x80/0x134
[    2.632409] 	schedule_preempt_disabled+0x38/0xc8
[    2.637042] 	cpu_startup_entry+0xe4/0x190
[    2.641074] 	start_kernel+0x3f4/0x408
[    2.644741] 	0x3438
[    2.646857] INFO: Slab 0xdffbdb00 objects=9 used=1 fp=0xde8581c0 flags=0x0080
[    2.653978] INFO: Object 0xde858008 @offset=8 fp=0xca4395df
[    2.653978]
[    2.661032] Redzone de858000: cc cc cc cc cc cc cc cc                          ........
[    2.669029] Object de858008: 00 00 00 02 00 00 00 02 00 6b 6b 6b 1e 83 ea 28  .........kkk...(
[    2.677628] Object de858018: 00 00 00 70 1e 85 80 64 ff 73 1d 21 6b 6b 6b 6b  ...p...d.s.!kkkk
[    2.686228] Object de858028: 00 20 00 00 1e 84 17 24 00 10 00 00 1e 85 70 00  . .....$......p.
[    2.694829] Object de858038: 00 18 00 00 1e 84 17 44 00 08 00 00 1e 83 ea 28  .......D.......(
[    2.703430] Object de858048: 00 80 00 00 1e 84 f0 00 00 80 00 00 1e 85 70 10  ..............p.
[    2.712030] Object de858058: 00 20 6b 00 1e 85 80 f4 6b 6b 6b 6b 00 80 02 00  . k.....kkkk....
[    2.720629] Object de858068: 1e 84 f0 00 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  ....kkkkkkkkkkkk
[    2.729230] Object de858078: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[    2.737830] Object de858088: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[    2.746429] Object de858098: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[    2.755029] Object de8580a8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[    2.763628] Object de8580b8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[    2.772229] Object de8580c8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[    2.780829] Object de8580d8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[    2.789430] Object de8580e8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 73 b0 ea 9f  kkkkkkkkkkkks...
[    2.798030] Object de8580f8: e8 18 80 d6 56 38 44 c0 db e3 4f 71 f7 ce d1 d3  ....V8D...Oq....
[    2.806629] Redzone de858108: f8 bd 3e 4f                                      ..>O
[    2.814279] Padding de8581b0: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
[    2.822283] CPU: 0 PID: 0 Comm: swapper Tainted: G    B           4.9.50-g995be12679 #179
[    2.831819] Call Trace:
[    2.834301] [dffefd20] [c01aa9a8] check_bytes_and_report+0x100/0x194 (unreliable)
[    2.841801] [dffefd50] [c01aac3c] check_object+0x200/0x530
[    2.847306] [dffefd80] [c01ae584] free_debug_processing+0x290/0x690
[    2.853585] [dffefde0] [c01aec8c] __slab_free+0x308/0x628
[    2.859000] [dffefe80] [c05057f4] ipsec_esp_encrypt_done+0x130/0x240
[    2.865378] [dffefeb0] [c05002c4] flush_channel+0x1dc/0x488
[    2.870968] [dffeff10] [c05007a8] talitos2_done_4ch+0x30/0x200
[    2.876814] [dffeff30] [c002fe38] tasklet_action+0xa0/0x13c
[    2.882399] [dffeff60] [c002f118] __do_softirq+0x148/0x6cc
[    2.887896] [dffeffd0] [c002f954] irq_exit+0xc0/0x124
[    2.892968] [dffefff0] [c0013adc] call_do_irq+0x24/0x3c
[    2.898213] [c0d4be00] [c000757c] do_IRQ+0x78/0x108
[    2.903113] [c0d4be30] [c0015c08] ret_from_except+0x0/0x14
[    2.908634] --- interrupt: 501 at finish_task_switch+0x70/0x350
[    2.908634]     LR = finish_task_switch+0x58/0x350
[    2.919327] [c0d4bf20] [c085e1d4] schedule+0x80/0x134
[    2.924398] [c0d4bf50] [c085e2c0] schedule_preempt_disabled+0x38/0xc8
[    2.930853] [c0d4bf60] [c007f064] cpu_startup_entry+0xe4/0x190
[    2.936707] [c0d4bfb0] [c096c434] start_kernel+0x3f4/0x408
[    2.942198] [c0d4bff0] [00003438] 0x3438
[    2.946137] FIX dma-kmalloc-256: Restoring 0xde858108-0xde85810b=0xcc
[    2.946137]
[    2.954158] FIX dma-kmalloc-256: Object at 0xde858008 not freed

This patch reworks the handling of the CICV out in order
to properly handle all cases.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index a5b608b54c74..e7e31f8fd3d1 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1239,14 +1239,15 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 			dma_map_sg(dev, areq->dst, sg_count, DMA_FROM_DEVICE);
 	}
 
-	sg_count = talitos_sg_map(dev, areq->dst, cryptlen, edesc,
-				  &desc->ptr[5], sg_count, areq->assoclen,
-				  tbl_off);
+	ret = talitos_sg_map(dev, areq->dst, cryptlen, edesc, &desc->ptr[5],
+			     sg_count, areq->assoclen, tbl_off);
 
 	if (desc->hdr & DESC_HDR_TYPE_IPSEC_ESP)
 		to_talitos_ptr_ext_or(&desc->ptr[5], authsize, is_sec1);
 
-	if (sg_count > 1) {
+	/* ICV data */
+	if (ret > 1) {
+		tbl_off += ret;
 		edesc->icv_ool = true;
 		sync_needed = true;
 
@@ -1256,9 +1257,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 				     sizeof(struct talitos_ptr) + authsize;
 
 			/* Add an entry to the link table for ICV data */
-			tbl_ptr += sg_count - 1;
-			to_talitos_ptr_ext_set(tbl_ptr, 0, is_sec1);
-			tbl_ptr++;
+			to_talitos_ptr_ext_set(tbl_ptr - 1, 0, is_sec1);
 			to_talitos_ptr_ext_set(tbl_ptr, DESC_PTR_LNKTBL_RETURN,
 					       is_sec1);
 			to_talitos_ptr_len(tbl_ptr, authsize, is_sec1);
@@ -1266,14 +1265,27 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 			/* icv data follows link tables */
 			to_talitos_ptr(tbl_ptr, edesc->dma_link_tbl + offset,
 				       is_sec1);
-		}
-	}
+		} else {
+			dma_addr_t addr = edesc->dma_link_tbl;
 
-	/* ICV data */
-	if (!(desc->hdr & DESC_HDR_TYPE_IPSEC_ESP)) {
-		to_talitos_ptr_len(&desc->ptr[6], authsize, is_sec1);
-		to_talitos_ptr(&desc->ptr[6], edesc->dma_link_tbl +
-			       areq->assoclen + cryptlen, is_sec1);
+			if (is_sec1)
+				addr += areq->assoclen + cryptlen;
+			else
+				addr += sizeof(struct talitos_ptr) * tbl_off;
+
+			to_talitos_ptr(&desc->ptr[6], addr, is_sec1);
+			to_talitos_ptr_len(&desc->ptr[6], authsize, is_sec1);
+		}
+	} else if (!(desc->hdr & DESC_HDR_TYPE_IPSEC_ESP)) {
+		ret = talitos_sg_map(dev, areq->dst, authsize, edesc,
+				     &desc->ptr[6], sg_count, areq->assoclen +
+							      cryptlen,
+				     tbl_off);
+		if (ret > 1) {
+			tbl_off += ret;
+			edesc->icv_ool = true;
+			sync_needed = true;
+		}
 	}
 
 	/* iv out */
-- 
2.13.3
