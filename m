From: Thomas Egerer <hakke_007@gmx.de>
Subject: [PATCH] crypto: Make CRYPTO_CBC select CRYPTO_ECHAINIV
Date: Mon, 4 Jan 2016 19:56:59 +0100
Message-ID: <568AC07B.8020605@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060102090305090204080608"
Cc: herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52270 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbcADS4h (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Jan 2016 13:56:37 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060102090305090204080608
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit


Similar to CTR mode selecting CRYPTO_SEQIV, CBC mode requires echainiv
and has to select CRYPTO_ECHAINIV in order to work properly. This solves
the issues caused by a misconfiguration as described in [1].

[1] https://lists.strongswan.org/pipermail/users/2015-December/009074.html

Signed-off-by: Thomas Egerer <hakke_007@gmx.de>
---
 crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)



--------------060102090305090204080608
Content-Type: text/x-patch;
 name="0001-crypto-Make-CRYPTO_CBC-select-CRYPTO_ECHAINIV.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0001-crypto-Make-CRYPTO_CBC-select-CRYPTO_ECHAINIV.patch"


--------------060102090305090204080608--
