From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@freescale.com>
Subject: [PATCH] crypto: caam - fix writing to JQCR_MS when using service interface
Date: Fri, 21 Aug 2015 18:53:20 +0300
Message-ID: <1440172400-3333-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0140.outbound.protection.outlook.com ([157.56.111.140]:48032
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751848AbbHUPxn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Aug 2015 11:53:43 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Most significant part of JQCR (Job Queue Control Register) contains
bits that control endianness: ILE - Immediate Little Endian,
DWS - Double Word Swap.
The bits are automatically set by the Job Queue Controller HW.

Unfortunately these bits are cleared in SW when submitting descriptors
via the register-based service interface.
=46rom LS1021A:
JQCR_MS =3D 08080100 - before writing: ILE | DWS | SRC (JR0)
JQCR_MS =3D 30000100 - after writing: WHL | FOUR | SRC (JR0)

This would cause problems on little endian caam for descriptors
containing immediata data or double-word pointers.
Currently there is no problem since the only descriptors ran through
this interface are the ones that (un)instantiate RNG.

Signed-off-by: Horia Geant=C4=83 <horia.geanta@freescale.com>
---

It does not affect current driver, thus not Cc-ing stable.

 drivers/crypto/caam/ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 81b552d1ad91..09c16f5ea97d 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -139,7 +139,7 @@ static inline int run_descriptor_deco0(struct devic=
e *ctrldev, u32 *desc,
 		flags |=3D DECO_JQCR_FOUR;
=20
 	/* Instruct the DECO to execute it */
-	wr_reg32(&deco->jr_ctl_hi, flags);
+	setbits32(&deco->jr_ctl_hi, flags);
=20
 	timeout =3D 10000000;
 	do {
--=20
2.4.4
