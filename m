From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 10/10] crypto: caam - fix uninitialized state->buf_dma field
Date: Fri, 11 Jul 2014 15:34:55 +0300
Message-ID: <1405082095-30146-11-git-send-email-horia.geanta@freescale.com>
References: <1405082095-30146-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	Vakul Garg <vakul@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:8491
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753508AbaGKMg1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jul 2014 08:36:27 -0400
In-Reply-To: <1405082095-30146-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

state->buf_dma not being initialized can cause try_buf_map_to_sec4_sg
to try to free unallocated DMA memory:

caam_jr ffe301000.jr: DMA-API: device driver tries to free DMA memory it has not allocated [device address=0x000000002eb15068] [size=0 bytes]
WARNING: at lib/dma-debug.c:1080
Modules linked in: caamhash(+) [last unloaded: caamhash]
CPU: 0 PID: 1387 Comm: cryptomgr_test Tainted: G        W     3.16.0-rc1 #23
task: eed24e90 ti: eebd0000 task.ti: eebd0000
NIP: c02889fc LR: c02889fc CTR: c02d7020
REGS: eebd1a50 TRAP: 0700   Tainted: G        W      (3.16.0-rc1)
MSR: 00029002 <CE,EE,ME>  CR: 44042082  XER: 00000000

GPR00: c02889fc eebd1b00 eed24e90 0000008d c1de3478 c1de382c 00000000 00029002
GPR08: 00000007 00000000 01660000 00000000 24042082 00000000 c07a1900 eeda2a40
GPR16: 005d62a0 c078ad4c 00000000 eeb15068 c07e1e10 c0da1180 00029002 c0d97408
GPR24: c62497a0 00000014 eebd1b58 00000000 c078ad4c ee130210 00000000 2eb15068
NIP [c02889fc] check_unmap+0x8ac/0xab0
LR [c02889fc] check_unmap+0x8ac/0xab0
Call Trace:
[eebd1b00] [c02889fc] check_unmap+0x8ac/0xab0 (unreliable)
--- Exception: 0 at   (null)
    LR =   (null)
[eebd1b50] [c0288c78] debug_dma_unmap_page+0x78/0x90 (unreliable)
[eebd1bd0] [f956f738] ahash_final_ctx+0x6d8/0x7b0 [caamhash]
[eebd1c30] [c022ff4c] __test_hash+0x2ac/0x6c0
[eebd1de0] [c0230388] test_hash+0x28/0xb0
[eebd1e00] [c02304a4] alg_test_hash+0x94/0xc0
[eebd1e20] [c022fa94] alg_test+0x114/0x2e0
[eebd1ea0] [c022cd1c] cryptomgr_test+0x4c/0x60
[eebd1eb0] [c00497a4] kthread+0xc4/0xe0
[eebd1f40] [c000f2fc] ret_from_kernel_thread+0x5c/0x64
Instruction dump:
41de01c8 80a9002c 2f850000 40fe0008 80a90008 80fa0018 3c60c06d 811a001c
3863f4a4 813a0020 815a0024 4830cd01 <0fe00000> 81340048 2f890000 40feff48

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/caamhash.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 44be5ad38ad7..b464d03ebf40 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1536,6 +1536,7 @@ static int ahash_init(struct ahash_request *req)
 	state->final = ahash_final_no_ctx;
 
 	state->current_buf = 0;
+	state->buf_dma = 0;
 
 	return 0;
 }
-- 
1.8.3.1
