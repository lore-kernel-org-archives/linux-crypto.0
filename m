From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 2/2] crypto: crypto4xx - Staticize local symbols
Date: Fri, 09 Aug 2013 16:59:57 +0900
Message-ID: <000901ce94d6$70a09f50$51e1ddf0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "'David S. Miller'" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, 'James Hsiao' <jhsiao@amcc.com>,
	Jingoo Han <jg1.han@samsung.com>
To: 'Herbert Xu' <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:38471 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967662Ab3HIH77 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Aug 2013 03:59:59 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MR900G497JJ2KF0@mailout4.samsung.com> for
 linux-crypto@vger.kernel.org; Fri, 09 Aug 2013 16:59:57 +0900 (KST)
Content-language: ko
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

These local symbols are used only in this file.
Fix the following sparse warnings:

drivers/crypto/amcc/crypto4xx_alg.c:35:6: warning: symbol 'set_dynamic_sa_command_0' was not declared. Should it be static?
drivers/crypto/amcc/crypto4xx_alg.c:55:6: warning: symbol 'set_dynamic_sa_command_1' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/crypto/amcc/crypto4xx_alg.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index a33243c..4afca39 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -32,10 +32,10 @@
 #include "crypto4xx_sa.h"
 #include "crypto4xx_core.h"
 
-void set_dynamic_sa_command_0(struct dynamic_sa_ctl *sa, u32 save_h,
-			      u32 save_iv, u32 ld_h, u32 ld_iv, u32 hdr_proc,
-			      u32 h, u32 c, u32 pad_type, u32 op_grp, u32 op,
-			      u32 dir)
+static void set_dynamic_sa_command_0(struct dynamic_sa_ctl *sa, u32 save_h,
+				     u32 save_iv, u32 ld_h, u32 ld_iv,
+				     u32 hdr_proc, u32 h, u32 c, u32 pad_type,
+				     u32 op_grp, u32 op, u32 dir)
 {
 	sa->sa_command_0.w = 0;
 	sa->sa_command_0.bf.save_hash_state = save_h;
@@ -52,9 +52,10 @@ void set_dynamic_sa_command_0(struct dynamic_sa_ctl *sa, u32 save_h,
 	sa->sa_command_0.bf.dir = dir;
 }
 
-void set_dynamic_sa_command_1(struct dynamic_sa_ctl *sa, u32 cm, u32 hmac_mc,
-			      u32 cfb, u32 esn, u32 sn_mask, u32 mute,
-			      u32 cp_pad, u32 cp_pay, u32 cp_hdr)
+static void set_dynamic_sa_command_1(struct dynamic_sa_ctl *sa, u32 cm,
+				     u32 hmac_mc, u32 cfb, u32 esn,
+				     u32 sn_mask, u32 mute, u32 cp_pad,
+				     u32 cp_pay, u32 cp_hdr)
 {
 	sa->sa_command_1.w = 0;
 	sa->sa_command_1.bf.crypto_mode31 = (cm & 4) >> 2;
-- 
1.7.10.4
