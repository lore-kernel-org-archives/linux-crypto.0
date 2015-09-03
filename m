From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH] caam: desc: Remove unused JUMP_TYPE_MASK definition
Date: Thu,  3 Sep 2015 15:21:29 -0300
Message-ID: <1441304489-21738-1-git-send-email-festevam@gmail.com>
Cc: horia.geanta@freescale.com, vicki.milhoan@freescale.com,
	linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:34005 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473AbbICSVp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Sep 2015 14:21:45 -0400
Received: by ykdg206 with SMTP id g206so52140881ykd.1
        for <linux-crypto@vger.kernel.org>; Thu, 03 Sep 2015 11:21:45 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

JUMP_TYPE_MASK is defined in desc.h and it is never used, so we can
safely remove it to avoid the following build warning:

In file included from drivers/crypto/caam/desc_constr.h:7:0,
                 from drivers/crypto/caam/ctrl.c:15:
drivers/crypto/caam/desc.h:1495:0: warning: "JUMP_TYPE_MASK" redefined
 #define JUMP_TYPE_MASK  (0x03 << JUMP_TYPE_SHIFT)
 ^
In file included from include/linux/module.h:19:0,
                 from drivers/crypto/caam/compat.h:9,
                 from drivers/crypto/caam/ctrl.c:11:
include/linux/jump_label.h:131:0: note: this is the location of the previous definition
 #define JUMP_TYPE_MASK 1UL

Reported-by: Olof's autobuilder <build@lixom.net>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/crypto/caam/desc.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index 983d663..1e93c6a 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -1492,7 +1492,6 @@ struct sec4_sg_entry {
 #define JUMP_JSL		(1 << JUMP_JSL_SHIFT)
 
 #define JUMP_TYPE_SHIFT		22
-#define JUMP_TYPE_MASK		(0x03 << JUMP_TYPE_SHIFT)
 #define JUMP_TYPE_LOCAL		(0x00 << JUMP_TYPE_SHIFT)
 #define JUMP_TYPE_NONLOCAL	(0x01 << JUMP_TYPE_SHIFT)
 #define JUMP_TYPE_HALT		(0x02 << JUMP_TYPE_SHIFT)
-- 
1.9.1
