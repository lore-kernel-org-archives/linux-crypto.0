From: Markus Stockhausen <stockhausen@collogia.de>
Subject: [PATCH v1 0/3] SHA1 for PPC/SPE
Date: Tue, 24 Feb 2015 20:36:34 +0100
Message-ID: <894f2b07-c86f-4857-8855-0718e21e9e1b@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-ad571de8-39c6-422f-a465-6d3358857ac4"
Cc: <linuxppc-dev@lists.ozlabs.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:19754 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752960AbbBXTgk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Feb 2015 14:36:40 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-ad571de8-39c6-422f-a465-6d3358857ac4
Content-Type: text/plain

[PATCH v1 0/3] SHA1 for PPC/SPE

The following patches add support for SIMD accelerated SHA1
calculation on PPC processors with SPE instruction set. The 
implementation takes care of the following constraints:

- independant of processor endianess
- save SPE registers for interrupt context compatibility
- disable preemtion only for short intervals

Performance numbers from insmod tcrypt sec=3 mode=303 taken
on e500v2 800 MHz (TP Link WDR4900)

data    per     sha1-ppc     this patch   speedup  cycles
length  update  bytes/sec    bytes/sec    factor   per byte
------  ------  -----------  -----------  -------  --------
    16      16    9,686,688   13,195,285   x1.36      60.63
    64      16   18,769,344   21,886,122   x1.17      36.55
    64      64   26,187,712   33,181,184   x1.27      24.11
   256      16   27,461,120   29,614,080   x1.08      27.01
   256      64   45,257,898   52,748,373   x1.17      15.17
   256     256   56,050,773   68,863,061   x1.23      11.62
  1024      16   30,863,360   32,438,272   x1.05      24.66
  1024     256   72,531,626   85,434,709   x1.18       9.36
  1024    1024   78,640,469   94,731,605   x1.20       8.44
  2048      16   31,771,989   32,970,752   x1.04      24.26
  2048     256   76,478,464   89,234,090   x1.17       8.97
  2048    1024   83,010,218   98,902,698   x1.19       8.09
  2048    2048   84,336,640  101,038,762   x1.19       7.92

------=_NextPartTM-000-ad571de8-39c6-422f-a465-6d3358857ac4
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

------=_NextPartTM-000-ad571de8-39c6-422f-a465-6d3358857ac4--
