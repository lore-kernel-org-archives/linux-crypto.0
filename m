From: Marek Vasut <marex@denx.de>
Subject: [PATCH 3/4] crypto: geode: Consistently use AES_KEYSIZE_128
Date: Wed, 14 May 2014 11:36:40 +0200
Message-ID: <1400060201-11519-3-git-send-email-marex@denx.de>
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
Received: from mail-out.m-online.net ([212.18.0.9]:58560 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbaENJg7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2014 05:36:59 -0400
In-Reply-To: <1400060201-11519-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Consistently use AES_KEYSIZE_128 instead of arbitrary defined value.

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
 drivers/crypto/geode-aes.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

NOTE: Geode guys, can you please test this change ?

diff --git a/drivers/crypto/geode-aes.h b/drivers/crypto/geode-aes.h
index 73e7b5f..f442ca9 100644
--- a/drivers/crypto/geode-aes.h
+++ b/drivers/crypto/geode-aes.h
@@ -10,8 +10,6 @@
 #define _GEODE_AES_H_
=20
 /* driver logic flags */
-#define AES_KEY_LENGTH 16
-
 #define AES_MODE_ECB 0
 #define AES_MODE_CBC 1
=20
@@ -62,7 +60,7 @@ struct geode_aes_op {
 	u32 flags;
 	int len;
=20
-	u8 key[AES_KEY_LENGTH];
+	u8 key[AES_KEYSIZE_128];
 	u8 *iv;
=20
 	union {
--=20
2.0.0.rc0
