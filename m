From: <yanjiang.jin@windriver.com>
Subject: [PATCH 3/3] crypto: caamhash: - fix uninitialized edesc->sec4_sg_bytes field
Date: Tue, 3 Mar 2015 14:50:53 +0800
Message-ID: <1425365453-19358-4-git-send-email-yanjiang.jin@windriver.com>
References: <1425365453-19358-1-git-send-email-yanjiang.jin@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <kim.phillips@freescale.com>, <ruchika.gupta@freescale.com>,
	<cristian.stoica@freescale.com>, <NiteshNarayanLal@freescale.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<jinyanjiang@gmail.com>
To: <horia.geanta@freescale.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425365453-19358-1-git-send-email-yanjiang.jin@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Yanjiang Jin <yanjiang.jin@windriver.com>

sec4_sg_bytes not being properly initialized causes ahash_done
to try to free unallocated DMA memory:

caam_jr ffe301000.jr: DMA-API: device driver tries to free DMA memory it has not allocated [device address=0xdeadbeefdeadbeef] [size=3735928559 bytes]
------------[ cut here ]------------
WARNING: at lib/dma-debug.c:1093
Modules linked in:
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.0.0-rc1-WR6.0.0.0_standard+ #6
task: e9598c00 ti: effca000 task.ti: e95a2000
NIP: c04ef24c LR: c04ef24c CTR: c0549730
REGS: effcbd40 TRAP: 0700   Not tainted  (4.0.0-rc1-WR6.0.0.0_standard+)
MSR: 00029002 <CE,EE,ME>  CR: 22008084  XER: 20000000

GPR00: c04ef24c effcbdf0 e9598c00 00000096 c08f7424 c00ab2b0 00000000 00000001
GPR08: c0fe7510 effca000 00000000 000001c3 22008082 00000000 c1048e77 c1050000
GPR16: c0c36700 493c0040 0000002c e690e4a0 c1054fb4 c18bac40 00029002 c18b0788
GPR24: 00000014 e690e480 effcbe48 00000000 c0fde128 e6ffac10 deadbeef deadbeef
NIP [c04ef24c] check_unmap+0x93c/0xb40
LR [c04ef24c] check_unmap+0x93c/0xb40
Call Trace:
[effcbdf0] [c04ef24c] check_unmap+0x93c/0xb40 (unreliable)
[effcbe40] [c04ef4f4] debug_dma_unmap_page+0xa4/0xc0
[effcbec0] [c070cda8] ahash_done+0x128/0x1a0
[effcbef0] [c0700070] caam_jr_dequeue+0x1d0/0x290
[effcbf40] [c0045f40] tasklet_action+0x110/0x1f0
[effcbf80] [c0044bc8] __do_softirq+0x188/0x700
[effcbfe0] [c00455d8] irq_exit+0x108/0x120
[effcbff0] [c000f520] call_do_irq+0x24/0x3c
[e95a3e20] [c00059b8] do_IRQ+0xc8/0x170
[e95a3e50] [c0011bc8] ret_from_except+0x0/0x18
--- interrupt: 501 at arch_cpu_idle+0x30/0xa0
    LR = arch_cpu_idle+0x30/0xa0
[e95a3f10] [c009a5c8] trace_hardirqs_off_caller+0xf8/0x1d0 (unreliable)
[e95a3f20] [c0094810] cpu_startup_entry+0x220/0x4b0
[e95a3f90] [c00140f8] start_secondary+0x3a8/0x4e0
[e95a3ff0] [c0001c88] __secondary_start+0x7c/0xc8
Instruction dump:
41de01c8 80a9002c 2f850000 40fe0008 80a90008 80fa0018 3c60c0ae 811a001c
38637b8c 813a0020 815a0024 4840ef15 <0fe00000> 8134004c 2f890000 40feff48
---[ end trace 52fb050c6682b55a ]---

Signed-off-by: Yanjiang Jin <yanjiang.jin@windriver.com>
---

Change log:
v2:

Abandon the v1 patch 0004-crypto-caamhash-replace-kmalloc-with-kzalloc.patch.
Just zeroing edesc->sec4_sg_bytes.

 drivers/crypto/caam/caamhash.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index f347ab7..ba0532e 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1172,6 +1172,7 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
+	edesc->sec4_sg_bytes = 0;
 	sh_len = desc_len(sh_desc);
 	desc = edesc->hw_desc;
 	init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER | HDR_REVERSE);
-- 
1.9.1
