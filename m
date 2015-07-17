From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@freescale.com>
Subject: [PATCH 4/4] crypto: caam - fix warning in APPEND_MATH_IMM_u64
Date: Fri, 17 Jul 2015 16:54:54 +0300
Message-ID: <1437141294-15678-4-git-send-email-horia.geanta@freescale.com>
References: <1437141294-15678-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor.ambarus@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0140.outbound.protection.outlook.com ([65.55.169.140]:41758
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751305AbbGQN4h (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jul 2015 09:56:37 -0400
In-Reply-To: <1437141294-15678-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Tudor Ambarus <tudor.ambarus@freescale.com>

An implicit truncation is done when using a variable of 64 bits
in MATH command:

warning: large integer implicitly truncated to unsigned type [-Woverflo=
w]

Silence the compiler by feeding it with an explicit truncated value.

Signed-off-by: Tudor Ambarus <tudor.ambarus@freescale.com>
Signed-off-by: Horia Geant=C4=83 <horia.geanta@freescale.com>
---
 drivers/crypto/caam/desc_constr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/de=
sc_constr.h
index 9f79fd7bd4d7..98d07de24fc4 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -367,7 +367,7 @@ do { \
 	if (upper) \
 		append_u64(desc, data); \
 	else \
-		append_u32(desc, data); \
+		append_u32(desc, lower_32_bits(data)); \
 } while (0)
=20
 #define append_math_add_imm_u64(desc, dest, src0, src1, data) \
--=20
2.4.4
