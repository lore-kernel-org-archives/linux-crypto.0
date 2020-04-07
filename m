Return-Path: <SRS0=R0fc=5X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1694EC2BA80
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Apr 2020 15:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7B722075E
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Apr 2020 15:59:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgDGP7C (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Apr 2020 11:59:02 -0400
Received: from inva021.nxp.com ([92.121.34.21]:36532 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbgDGP7C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Apr 2020 11:59:02 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 8ED10201192;
        Tue,  7 Apr 2020 17:58:59 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 824E52003AC;
        Tue,  7 Apr 2020 17:58:59 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 1C592204B1;
        Tue,  7 Apr 2020 17:58:59 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH] crypto: caam - fix the address of the last entry of S/G
Date:   Tue,  7 Apr 2020 18:58:45 +0300
Message-Id: <1586275125-20571-1-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

For skcipher algorithms, the input, output HW S/G tables
look like this: [IV, src][dst, IV]
Now, we can have 2 conditions here:
- there is no IV;
- src and dst are equal (in-place encryption) and scattered
and the error is an "off-by-one" in the HW S/G table.

This issue was seen with KASAN:
BUG: KASAN: slab-out-of-bounds in skcipher_edesc_alloc+0x95c/0x1018

Read of size 4 at addr ffff000022a02958 by task cryptomgr_test/321

CPU: 2 PID: 321 Comm: cryptomgr_test Not tainted
5.6.0-rc1-00165-ge4ef8383-dirty #4
Hardware name: LS1046A RDB Board (DT)
Call trace:
 dump_backtrace+0x0/0x260
 show_stack+0x14/0x20
 dump_stack+0xe8/0x144
 print_address_description.isra.11+0x64/0x348
 __kasan_report+0x11c/0x230
 kasan_report+0xc/0x18
 __asan_load4+0x90/0xb0
 skcipher_edesc_alloc+0x95c/0x1018
 skcipher_encrypt+0x84/0x150
 crypto_skcipher_encrypt+0x50/0x68
 test_skcipher_vec_cfg+0x4d4/0xc10
 test_skcipher_vec+0x178/0x1d8
 alg_test_skcipher+0xec/0x230
 alg_test.part.44+0x114/0x4a0
 alg_test+0x1c/0x60
 cryptomgr_test+0x34/0x58
 kthread+0x1b8/0x1c0
 ret_from_fork+0x10/0x18

Allocated by task 321:
 save_stack+0x24/0xb0
 __kasan_kmalloc.isra.10+0xc4/0xe0
 kasan_kmalloc+0xc/0x18
 __kmalloc+0x178/0x2b8
 skcipher_edesc_alloc+0x21c/0x1018
 skcipher_encrypt+0x84/0x150
 crypto_skcipher_encrypt+0x50/0x68
 test_skcipher_vec_cfg+0x4d4/0xc10
 test_skcipher_vec+0x178/0x1d8
 alg_test_skcipher+0xec/0x230
 alg_test.part.44+0x114/0x4a0
 alg_test+0x1c/0x60
 cryptomgr_test+0x34/0x58
 kthread+0x1b8/0x1c0
 ret_from_fork+0x10/0x18

Freed by task 0:
(stack is not available)

The buggy address belongs to the object at ffff000022a02800
 which belongs to the cache dma-kmalloc-512 of size 512
The buggy address is located 344 bytes inside of
 512-byte region [ffff000022a02800, ffff000022a02a00)
The buggy address belongs to the page:
page:fffffe00006a8000 refcount:1 mapcount:0 mapping:ffff00093200c400
index:0x0 compound_mapcount: 0
flags: 0xffff00000010200(slab|head)
raw: 0ffff00000010200 dead000000000100 dead000000000122 ffff00093200c400
raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff000022a02800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff000022a02880: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff000022a02900: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
                                                    ^
 ffff000022a02980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff000022a02a00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc

Fixes: 334d37c9e263 ("crypto: caam - update IV using HW support")
Cc: <stable@vger.kernel.org> # v5.3+
Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index b7bb7c3..eed41da 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1711,7 +1711,7 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 
 	if (ivsize || mapped_dst_nents > 1)
 		sg_to_sec4_set_last(edesc->sec4_sg + dst_sg_idx +
-				    mapped_dst_nents);
+				    mapped_dst_nents - 1 + !!ivsize);
 
 	if (sec4_sg_bytes) {
 		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
-- 
2.1.0

