From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: [PATCH] HIFN: make Kconfig option depend on PCI
Date: Mon, 12 Nov 2007 13:31:49 +0000
Message-ID: <1194874310.5656.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:46540 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758303AbXKLMcI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Nov 2007 07:32:08 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate5.de.ibm.com (8.13.8/8.13.8) with ESMTP id lACCW6uC220454
	for <linux-crypto@vger.kernel.org>; Mon, 12 Nov 2007 12:32:06 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.6) with ESMTP id lACCW60J2076848
	for <linux-crypto@vger.kernel.org>; Mon, 12 Nov 2007 13:32:06 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lACCW5BV014198
	for <linux-crypto@vger.kernel.org>; Mon, 12 Nov 2007 13:32:06 +0100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The HIFN driver is currently selectable on s390 but wont compile.
Since it looks like HIFN needs PCI make the Kconfig dependent on PCI,
which is not available on s390.

-jang

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>

Index: cryptodev-2.6/drivers/crypto/Kconfig
===================================================================
--- cryptodev-2.6.orig/drivers/crypto/Kconfig
+++ cryptodev-2.6/drivers/crypto/Kconfig
@@ -88,6 +88,7 @@ config CRYPTO_DEV_HIFN_795X
 	select CRYPTO_DES
 	select CRYPTO_ALGAPI
 	select CRYPTO_ABLKCIPHER
+	depends on PCI
 	help
 	  This option allows you to have support for HIFN 795x crypto adapters.
 
