From: Andrej Krutak <andrej.krutak@sysgo.com>
Subject: [PATCH] Add select of CONFIG_SRCU by CONFIG_CRYPTO
Date: Thu, 22 Oct 2015 08:56:33 +0200
Message-ID: <4666184.fJucKke4tk@kru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.sysgo.com ([176.9.12.79]:43249 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756693AbbJVHDS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Oct 2015 03:03:18 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Andrej Krutak <andrej.krutak@sysgo.com>

---
 crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 48ee3e1..c7596ee 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -14,6 +14,7 @@ source "crypto/async_tx/Kconfig"
 #
 menuconfig CRYPTO
        tristate "Cryptographic API"
+       select SRCU
        help
          This option provides the core Cryptographic API.
=20
--=20
1.9.1

--=20
Best regards | S pozdravom | Mit freundlichen Gr=FC=DFen | Cordialement

Andrej Krutak
