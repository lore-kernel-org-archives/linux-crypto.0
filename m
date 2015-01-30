From: Markus Stockhausen <stockhausen@collogia.de>
Subject: [PATCH v2 3/3] SHA256 for PPC/SPE - kernel config
Date: Fri, 30 Jan 2015 15:39:34 +0100
Message-ID: <a1b6cce2-ea7f-4789-a719-7319d776afdb@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-8b43d047-ef44-4fa1-8fd8-b338a9d08b76"
Cc: <linuxppc-dev@lists.ozlabs.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:14035 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752319AbbA3Ojg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Jan 2015 09:39:36 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-8b43d047-ef44-4fa1-8fd8-b338a9d08b76
Content-Type: text/plain

[PATCH v2 3/3] SHA256 for PPC/SPE - kernel config

Integrate the module into the kernel config tree.

Signed-off-by: Markus Stockhausen <stockhausen@collogia.de>

diff --git a/arch/powerpc/crypto/Makefile b/arch/powerpc/crypto/Makefile
index 2926fb9..a07e763 100644
--- a/arch/powerpc/crypto/Makefile
+++ b/arch/powerpc/crypto/Makefile
@@ -5,5 +5,7 @@
 #
 
 obj-$(CONFIG_CRYPTO_SHA1_PPC) += sha1-powerpc.o
+obj-$(CONFIG_CRYPTO_SHA256_PPC_SPE) += sha256-ppc-spe.o
 
 sha1-powerpc-y := sha1-powerpc-asm.o sha1.o
+sha256-ppc-spe-y := sha256-spe-asm.o sha256_spe_glue.o
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 87bbc9c..86d35be 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -601,6 +601,15 @@ config CRYPTO_SHA256
 	  This code also includes SHA-224, a 224 bit hash with 112 bits
 	  of security against collision attacks.
 
+config CRYPTO_SHA256_PPC_SPE
+	tristate "SHA224 and SHA256 digest algorithm (PPC SPE)"
+	depends on PPC && SPE
+	select CRYPTO_SHA256
+	select CRYPTO_HASH
+	help
+	  SHA224 and SHA256 secure hash standard (DFIPS 180-2)
+	  implemented using powerpc SPE SIMD instruction set.
+
 config CRYPTO_SHA256_SPARC64
 	tristate "SHA224 and SHA256 digest algorithm (SPARC64)"
 	depends on SPARC64

------=_NextPartTM-000-8b43d047-ef44-4fa1-8fd8-b338a9d08b76
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

------=_NextPartTM-000-8b43d047-ef44-4fa1-8fd8-b338a9d08b76--
