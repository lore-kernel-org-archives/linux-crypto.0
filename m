From: Markus Stockhausen <stockhausen@collogia.de>
Subject: [PATCH v2 1/7] AES for PPC/SPE - register defines
Date: Sun, 22 Feb 2015 09:59:38 +0100
Message-ID: <466c99e5-b9d2-4312-b8a4-f0233d9d3f3c@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-c92436c2-ad30-4fc5-a0e6-56215051a972"
Cc: <linuxppc-dev@lists.ozlabs.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:17950 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751288AbbBVI7k (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 22 Feb 2015 03:59:40 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-c92436c2-ad30-4fc5-a0e6-56215051a972
Content-Type: text/plain

[PATCH v2 1/7] AES for PPC/SPE - register defines

Define some register aliases for better readability.

Signed-off-by: Markus Stockhausen <stockhausen@collogia.de>

diff --git a/arch/powerpc/crypto/aes-spe-regs.h b/arch/powerpc/crypto/aes-spe-regs.h
new file mode 100644
index 0000000..30d217b
--- /dev/null
+++ b/arch/powerpc/crypto/aes-spe-regs.h
@@ -0,0 +1,42 @@
+/*
+ * Common registers for PPC AES implementation
+ *
+ * Copyright (c) 2015 Markus Stockhausen <stockhausen@collogia.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#define rKS r0	/* copy of en-/decryption key pointer			*/
+#define rDP r3	/* destination pointer					*/
+#define rSP r4	/* source pointer					*/
+#define rKP r5	/* pointer to en-/decryption key pointer		*/
+#define rRR r6	/* en-/decryption rounds				*/
+#define rLN r7	/* length of data to be processed			*/
+#define rIP r8	/* potiner to IV (CBC/CTR/XTS modes)			*/
+#define rKT r9	/* pointer to tweak key (XTS mode)			*/
+#define rT0 r11	/* pointers to en-/decrpytion tables			*/
+#define rT1 r10
+#define rD0 r9	/* data 						*/
+#define rD1 r14
+#define rD2 r12
+#define rD3 r15
+#define rW0 r16	/* working registers					*/
+#define rW1 r17
+#define rW2 r18
+#define rW3 r19
+#define rW4 r20
+#define rW5 r21
+#define rW6 r22
+#define rW7 r23
+#define rI0 r24	/* IV							*/
+#define rI1 r25
+#define rI2 r26
+#define rI3 r27
+#define rG0 r28	/* endian reversed tweak (XTS mode)			*/
+#define rG1 r29
+#define rG2 r30
+#define rG3 r31

------=_NextPartTM-000-c92436c2-ad30-4fc5-a0e6-56215051a972
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

------=_NextPartTM-000-c92436c2-ad30-4fc5-a0e6-56215051a972--
