From: Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2] caam: desc: Remove unused JUMP_TYPE_MASK definition
Date: Tue, 15 Sep 2015 13:54:53 -0300
Message-ID: <1442336093-22688-1-git-send-email-fabio.estevam@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <horia.geanta@freescale.com>, <linux-crypto@vger.kernel.org>,
	"Fabio Estevam" <fabio.estevam@freescale.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0117.outbound.protection.outlook.com ([157.56.111.117]:46464
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750698AbbIORKp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Sep 2015 13:10:45 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit a1efb01feca597b ("jump_label, locking/static_keys: Rename=20
JUMP_LABEL_TYPE_* and related helpers to the static_key* pattern")
introduced the definition of JUMP_TYPE_MASK in=20
include/linux/jump_label.h causing the following name collision:

In file included from drivers/crypto/caam/desc_constr.h:7:0,
                 from drivers/crypto/caam/ctrl.c:15:
drivers/crypto/caam/desc.h:1495:0: warning: "JUMP_TYPE_MASK" redefined
 #define JUMP_TYPE_MASK  (0x03 << JUMP_TYPE_SHIFT)
 ^
In file included from include/linux/module.h:19:0,
                 from drivers/crypto/caam/compat.h:9,
                 from drivers/crypto/caam/ctrl.c:11:
include/linux/jump_label.h:131:0: note: this is the location of the pre=
vious definition
 #define JUMP_TYPE_MASK 1UL

As JUMP_TYPE_MASK definition in desc.h is never used, we can safely rem=
ove
it to avoid the name collision.

Reported-by: Olof's autobuilder <build@lixom.net>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Reviewed-by: Horia Geant=C4=83 <horia.geanta@freescale.com>
---
Changes since v1:
- Explain the commit that caused the name collision (Horia)

 drivers/crypto/caam/desc.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index 983d663..1e93c6a 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -1492,7 +1492,6 @@ struct sec4_sg_entry {
 #define JUMP_JSL		(1 << JUMP_JSL_SHIFT)
=20
 #define JUMP_TYPE_SHIFT		22
-#define JUMP_TYPE_MASK		(0x03 << JUMP_TYPE_SHIFT)
 #define JUMP_TYPE_LOCAL		(0x00 << JUMP_TYPE_SHIFT)
 #define JUMP_TYPE_NONLOCAL	(0x01 << JUMP_TYPE_SHIFT)
 #define JUMP_TYPE_HALT		(0x02 << JUMP_TYPE_SHIFT)
--=20
1.9.1
