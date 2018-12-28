Return-Path: <SRS0=sHEo=PF=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-oln040092254071.outbound.protection.outlook.com ([40.92.254.71]:6040
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727902AbeL1KJp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Dec 2018 05:09:45 -0500
From: Huang nut <minhaco@msn.com>
To: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Huang nut <minhaco@msn.com>
Subject: [PATCH] crypto: Fix typo in "pclmul"
Date: Fri, 28 Dec 2018 10:09:40 +0000
Message-ID: <SG2PR04MB3415A7CA56902CA965E6F62FAAB70@SG2PR04MB3415.apcprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: haco <minhaco@msn.com>

Fix typo "plcmul" to "pclmul"

Signed-off-by: Huaxuan Mao <minhaco@msn.com>
---
 crypto/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 045af6eeb..bc854c23d 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -642,7 +642,7 @@ config CRYPTO_CRC32_PCLMUL
 	  From Intel Westmere and AMD Bulldozer processor with SSE4.2
 	  and PCLMULQDQ supported, the processor will support
 	  CRC32 PCLMULQDQ implementation using hardware accelerated PCLMULQDQ
-	  instruction. This option will create 'crc32-plcmul' module,
+	  instruction. This option will create 'crc32-pclmul' module,
 	  which will enable any routine to use the CRC-32-IEEE 802.3 checksum
 	  and gain better performance as compared with the table implementation.
=20
@@ -671,7 +671,7 @@ config CRYPTO_CRCT10DIF_PCLMUL
 	  For x86_64 processors with SSE4.2 and PCLMULQDQ supported,
 	  CRC T10 DIF PCLMULQDQ computation can be hardware
 	  accelerated PCLMULQDQ instruction. This option will create
-	  'crct10dif-plcmul' module, which is faster when computing the
+	  'crct10dif-pclmul' module, which is faster when computing the
 	  crct10dif checksum as compared with the generic table implementation.
=20
 config CRYPTO_CRCT10DIF_VPMSUM
--=20
2.20.1
