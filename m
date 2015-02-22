From: Markus Stockhausen <stockhausen@collogia.de>
Subject: [PATCH v2 7/7] AES for PPC/SPE - kernel config
Date: Sun, 22 Feb 2015 10:00:10 +0100
Message-ID: <714284f3-3db3-4a04-a5f5-f1630114d8f5@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-0625d425-0948-4383-a9de-154cfa1ba2d2"
Cc: <linuxppc-dev@lists.ozlabs.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:18014 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751744AbbBVJAM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 22 Feb 2015 04:00:12 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-0625d425-0948-4383-a9de-154cfa1ba2d2
Content-Type: text/plain

[PATCH v2 7/7] AES for PPC/SPE - kernel config

Integrate the module into the kernel configuration

v2 changes
- better explanation of use case in help text

Signed-off-by: Markus Stockhausen <stockhausen@collogia.de>

diff --git a/arch/powerpc/crypto/Makefile b/arch/powerpc/crypto/Makefile
index a07e763..1698fb9 100644
--- a/arch/powerpc/crypto/Makefile
+++ b/arch/powerpc/crypto/Makefile
@@ -4,8 +4,10 @@
 # Arch-specific CryptoAPI modules.
 #
 
+obj-$(CONFIG_CRYPTO_AES_PPC_SPE) += aes-ppc-spe.o
 obj-$(CONFIG_CRYPTO_SHA1_PPC) += sha1-powerpc.o
 obj-$(CONFIG_CRYPTO_SHA256_PPC_SPE) += sha256-ppc-spe.o
 
+aes-ppc-spe-y := aes-spe-core.o aes-spe-keys.o aes-tab-4k.o aes-spe-modes.o aes_spe_glue.o
 sha1-powerpc-y := sha1-powerpc-asm.o sha1.o
 sha256-ppc-spe-y := sha256-spe-asm.o sha256_spe_glue.o
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 86d35be..f34d136 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -857,6 +857,19 @@ config CRYPTO_AES_ARM_BS
 	  This implementation does not rely on any lookup tables so it is
 	  believed to be invulnerable to cache timing attacks.
 
+config CRYPTO_AES_PPC_SPE
+	tristate "AES cipher algorithms (PPC SPE)"
+	depends on PPC && SPE
+	help
+	  AES cipher algorithms (FIPS-197). Additionally the acceleration
+	  for popular block cipher modes ECB, CBC, CTR and XTS is supported.
+	  This module should only be used for low power (router) devices
+	  without hardware AES acceleration (e.g. caam crypto). It reduces the
+	  size of the AES tables from 16KB to 8KB + 256 bytes and mitigates
+	  timining attacks. Nevertheless it might be not as secure as other
+	  architecture specific assembler implementations that work on 1KB
+	  tables or 256 bytes S-boxes.
+
 config CRYPTO_ANUBIS
 	tristate "Anubis cipher algorithm"
 	select CRYPTO_ALGAPI

------=_NextPartTM-000-0625d425-0948-4383-a9de-154cfa1ba2d2
Content-Type: text/plain;
	name="InterScan_Disclaimer.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="InterScan_Disclaimer.txt"

****************************************************************************
Diese E-Mail enthält vertrauliche und/oder rechtlich geschützte
Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail
irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und
vernichten Sie diese Mail. Das unerlaubte Kopieren sowie die unbefugte
Weitergabe dieser Mail ist nicht gestattet.

Über das Internet versandte E-Mails können unter fremden Namen erstellt oder
manipuliert werden. Deshalb ist diese als E-Mail verschickte Nachricht keine
rechtsverbindliche Willenserklärung.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

Vorstand:
Kadir Akin
Dr. Michael Höhnerbach

Vorsitzender des Aufsichtsrates:
Hans Kristian Langva

Registergericht: Amtsgericht Köln
Registernummer: HRB 52 497

This e-mail may contain confidential and/or privileged information. If you
are not the intended recipient (or have received this e-mail in error)
please notify the sender immediately and destroy this e-mail. Any
unauthorized copying, disclosure or distribution of the material in this
e-mail is strictly forbidden.

e-mails sent over the internet may have been written under a wrong name or
been manipulated. That is why this message sent as an e-mail is not a
legally binding declaration of intention.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

executive board:
Kadir Akin
Dr. Michael Höhnerbach

President of the supervisory board:
Hans Kristian Langva

Registry office: district court Cologne
Register number: HRB 52 497

****************************************************************************

------=_NextPartTM-000-0625d425-0948-4383-a9de-154cfa1ba2d2--
