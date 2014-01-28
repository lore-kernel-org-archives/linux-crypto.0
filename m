From: Kevin Hao <haokexin@gmail.com>
Subject: [PATCH] crypto: talitos: init the priv->alg_list more earlier in talitos_probe()
Date: Tue, 28 Jan 2014 20:17:23 +0800
Message-ID: <1390911443-17936-1-git-send-email-haokexin@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:38259 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbaA1MSP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Jan 2014 07:18:15 -0500
Received: by mail-pa0-f51.google.com with SMTP id ld10so294972pab.24
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jan 2014 04:18:15 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In function talitos_probe(), it will jump to err_out when getting an
error in talitos_probe_irq(). Then the uninitialized list head
priv->alg_list will be used in function talitos_remove(). In this case
we would get a call trace like the following. So move up the
initialization of priv->alg_list.

  Unable to handle kernel paging request for data at address 0x00000000
  Faulting instruction address: 0xc0459ff4
  Oops: Kernel access of bad area, sig: 11 [#1]
  SMP NR_CPUS=8 P1020 RDB
  Modules linked in:
  CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.13.0-08789-g54c0a4b46150 #33
  task: cf050000 ti: cf04c000 task.ti: cf04c000
  NIP: c0459ff4 LR: c0459fd4 CTR: c02f2438
  REGS: cf04dcb0 TRAP: 0300   Tainted: G        W     (3.13.0-08789-g54c0a4b46150)
  MSR: 00029000 <CE,EE,ME>  CR: 82000028  XER: 20000000
  DEAR: 00000000 ESR: 00000000
  GPR00: c045ac28 cf04dd60 cf050000 cf2579c0 00021000 00000000 c02f35b0 0000014e
  GPR08: c07e702c cf104300 c07e702c 0000014e 22000024 00000000 c0002a3c 00000000
  GPR16: 00000000 00000000 00000000 00000000 00000000 00000000 c082e4e0 000000df
  GPR24: 00000000 00100100 00200200 cf257a2c cf0efe10 cf2579c0 cf0efe10 00000000
  NIP [c0459ff4] talitos_remove+0x3c/0x1c8
  LR [c0459fd4] talitos_remove+0x1c/0x1c8
  Call Trace:
  [cf04dd60] [c07485d8] __func__.13331+0x1241c8/0x1391c0 (unreliable)
  [cf04dd90] [c045ac28] talitos_probe+0x244/0x998
  [cf04dde0] [c0306a74] platform_drv_probe+0x28/0x68
  [cf04ddf0] [c0304d38] really_probe+0x78/0x250
  [cf04de10] [c030505c] __driver_attach+0xc8/0xcc
  [cf04de30] [c0302e98] bus_for_each_dev+0x6c/0xb8
  [cf04de60] [c03043cc] bus_add_driver+0x168/0x220
  [cf04de80] [c0305798] driver_register+0x88/0x130
  [cf04de90] [c0002458] do_one_initcall+0x14c/0x198
  [cf04df00] [c079f904] kernel_init_freeable+0x138/0x1d4
  [cf04df30] [c0002a50] kernel_init+0x14/0x124
  [cf04df40] [c000ec40] ret_from_kernel_thread+0x5c/0x64

Signed-off-by: Kevin Hao <haokexin@gmail.com>
---
 drivers/crypto/talitos.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 5967667e1a8f..624b8be0c365 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2637,6 +2637,8 @@ static int talitos_probe(struct platform_device *ofdev)
 	if (!priv)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&priv->alg_list);
+
 	dev_set_drvdata(dev, priv);
 
 	priv->ofdev = ofdev;
@@ -2657,8 +2659,6 @@ static int talitos_probe(struct platform_device *ofdev)
 			     (unsigned long)dev);
 	}
 
-	INIT_LIST_HEAD(&priv->alg_list);
-
 	priv->reg = of_iomap(np, 0);
 	if (!priv->reg) {
 		dev_err(dev, "failed to of_iomap\n");
-- 
1.8.5.3
