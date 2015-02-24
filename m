From: Markus Stockhausen <stockhausen@collogia.de>
Subject: [PATCH v1 3/3] SHA1 for PPC/SPE - kernel config
Date: Tue, 24 Feb 2015 20:36:50 +0100
Message-ID: <b458e261-7a38-49b0-8386-73164ab0e2f6@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-7f2fb35a-e6fe-4ab1-8b46-0d080418d68c"
Cc: <linuxppc-dev@lists.ozlabs.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:19784 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753089AbbBXTgw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Feb 2015 14:36:52 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-7f2fb35a-e6fe-4ab1-8b46-0d080418d68c
Content-Type: text/plain

[PATCH v1 3/3] SHA1 for PPC/SPE - kernel config

Integrate the module into the kernel config tree.

Signed-off-by: Markus Stockhausen <stockhausen@collogia.de>

diff --git a/arch/powerpc/crypto/Makefile b/arch/powerpc/crypto/Makefile
index 1698fb9..d400bf9 100644
--- a/arch/powerpc/crypto/Makefile
+++ b/arch/powerpc/crypto/Makefile
@@ -6,8 +6,10 @@
 
 obj-$(CONFIG_CRYPTO_AES_PPC_SPE) += aes-ppc-spe.o
 obj-$(CONFIG_CRYPTO_SHA1_PPC) += sha1-powerpc.o
+obj-$(CONFIG_CRYPTO_SHA1_PPC_SPE) += sha1-ppc-spe.o
 obj-$(CONFIG_CRYPTO_SHA256_PPC_SPE) += sha256-ppc-spe.o
 
 aes-ppc-spe-y := aes-spe-core.o aes-spe-keys.o aes-tab-4k.o aes-spe-modes.o aes_spe_glue.o
 sha1-powerpc-y := sha1-powerpc-asm.o sha1.o
+sha1-ppc-spe-y := sha1-spe-asm.o sha1_spe_glue.o
 sha256-ppc-spe-y := sha256-spe-asm.o sha256_spe_glue.o
diff --git a/crypto/Kconfig b/crypto/Kconfig
index f34d136..7fc084f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -573,6 +573,13 @@ config CRYPTO_SHA1_PPC
 	  This is the powerpc hardware accelerated implementation of the
 	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2).
 
+config CRYPTO_SHA1_PPC_SPE
+	tristate "SHA1 digest algorithm (PPC SPE)"
+	depends on PPC && SPE
+	help
+	  SHA-1 secure hash standard (DFIPS 180-4) implemented
+	  using powerpc SPE SIMD instruction set.
+
 config CRYPTO_SHA1_MB
 	tristate "SHA1 digest algorithm (x86_64 Multi-Buffer, Experimental)"
 	depends on X86 && 64BIT

------=_NextPartTM-000-7f2fb35a-e6fe-4ab1-8b46-0d080418d68c
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

------=_NextPartTM-000-7f2fb35a-e6fe-4ab1-8b46-0d080418d68c--
