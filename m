From: Marek Vasut <marex@denx.de>
Subject: [PATCH 2/4] crypto: geode: Kill AES_IV_LENGTH
Date: Wed, 14 May 2014 11:36:39 +0200
Message-ID: <1400060201-11519-2-git-send-email-marex@denx.de>
References: <1400060201-11519-1-git-send-email-marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: herbert@gondor.apana.org.au, Marek Vasut <marex@denx.de>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
	=?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	Kent Yoder <key@linux.vnet.ibm.com>,
	Michal Ludvig <michal@logix.cz>,
	Varun Wadekar <vwadekar@nvidia.com>,
	Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
	linux-geode@lists.infradead.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:54789 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbaENJhG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2014 05:37:06 -0400
In-Reply-To: <1400060201-11519-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The AES IV length is always 128bits, just use the define from aes.h

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Cc: Eric B=C3=A9nard <eric@eukrea.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Kent Yoder <key@linux.vnet.ibm.com>
Cc: Michal Ludvig <michal@logix.cz>
Cc: Varun Wadekar <vwadekar@nvidia.com>
Cc: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: linux-geode@lists.infradead.org
---
 drivers/crypto/geode-aes.c | 2 +-
 drivers/crypto/geode-aes.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

NOTE: Geode guys, can you please test this change ?

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 32001d6b..69e1b02 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -408,7 +408,7 @@ static struct crypto_alg geode_cbc_alg =3D {
 			.setkey			=3D	geode_setkey_blk,
 			.encrypt		=3D	geode_cbc_encrypt,
 			.decrypt		=3D	geode_cbc_decrypt,
-			.ivsize			=3D	AES_IV_LENGTH,
+			.ivsize			=3D	AES_BLOCK_SIZE,
 		}
 	}
 };
diff --git a/drivers/crypto/geode-aes.h b/drivers/crypto/geode-aes.h
index cedf2c5..73e7b5f 100644
--- a/drivers/crypto/geode-aes.h
+++ b/drivers/crypto/geode-aes.h
@@ -10,7 +10,6 @@
 #define _GEODE_AES_H_
=20
 /* driver logic flags */
-#define AES_IV_LENGTH  16
 #define AES_KEY_LENGTH 16
=20
 #define AES_MODE_ECB 0
--=20
2.0.0.rc0
