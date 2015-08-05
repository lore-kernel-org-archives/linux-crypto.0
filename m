From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH v2 06/14] crypto: caam - Correct DMA unmap size in ahash_update_ctx()
Date: Wed, 5 Aug 2015 11:28:40 -0700
Message-ID: <1438799328-10757-7-git-send-email-vicki.milhoan@freescale.com>
References: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
 <1438799328-10757-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>, <shawnguo@kernel.org>,
	<kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
	<robh+dt@kernel.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bbn0103.outbound.protection.outlook.com ([157.56.111.103]:19391
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753725AbbHES3B (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Aug 2015 14:29:01 -0400
In-Reply-To: <1438799328-10757-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This change fixes:

------------[ cut here ]------------
WARNING: CPU: 0 PID: 456 at lib/dma-debug.c:1103 check_unmap+0x438/0x958()
caam_jr 2101000.jr0: DMA-API: device driver frees DMA memory with different size [device address=0x000000003a241080] [map ]
Modules linked in: tcrypt(+)
CPU: 0 PID: 456 Comm: insmod Not tainted 4.1.0-248766-gf823586-dirty #82
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[<80015e0c>] (unwind_backtrace) from [<80012764>] (show_stack+0x10/0x14)
[<80012764>] (show_stack) from [<806df8e8>] (dump_stack+0x84/0xc4)
[<806df8e8>] (dump_stack) from [<800266fc>] (warn_slowpath_common+0x84/0xb4)
[<800266fc>] (warn_slowpath_common) from [<8002675c>] (warn_slowpath_fmt+0x30/0x40)
[<8002675c>] (warn_slowpath_fmt) from [<802c7db8>] (check_unmap+0x438/0x958)
[<802c7db8>] (check_unmap) from [<802c835c>] (debug_dma_unmap_page+0x84/0x8c)
[<802c835c>] (debug_dma_unmap_page) from [<804d3b94>] (ahash_update_ctx+0xb08/0xec4)
[<804d3b94>] (ahash_update_ctx) from [<7f002984>] (test_ahash_pnum.isra.9.constprop.19+0x2b8/0x514 [tcrypt])
[<7f002984>] (test_ahash_pnum.isra.9.constprop.19 [tcrypt]) from [<7f005998>] (do_test+0x2db8/0x37cc [tcrypt])
[<7f005998>] (do_test [tcrypt]) from [<7f00b050>] (tcrypt_mod_init+0x50/0x9c [tcrypt])
[<7f00b050>] (tcrypt_mod_init [tcrypt]) from [<80009730>] (do_one_initcall+0x8c/0x1d4)
[<80009730>] (do_one_initcall) from [<806dda4c>] (do_init_module+0x5c/0x1a8)
[<806dda4c>] (do_init_module) from [<80085308>] (load_module+0x17e0/0x1da0)
[<80085308>] (load_module) from [<80085998>] (SyS_init_module+0xd0/0x120)
[<80085998>] (SyS_init_module) from [<8000f4c0>] (ret_fast_syscall+0x0/0x3c)
---[ end trace 60807cfb6521c79f ]---

Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
---
 drivers/crypto/caam/caamhash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 2361beb..16c03f8 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -829,7 +829,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 		state->buf_dma = try_buf_map_to_sec4_sg(jrdev,
 							edesc->sec4_sg + 1,
 							buf, state->buf_dma,
-							*buflen, last_buflen);
+							*next_buflen, *buflen);
 
 		if (src_nents) {
 			src_map_to_sec4_sg(jrdev, req->src, src_nents,
-- 
2.1.4
