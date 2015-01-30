From: Markus Stockhausen <stockhausen@collogia.de>
Subject: [PATCH v2 0/3] SHA256 for PPC/SPE
Date: Fri, 30 Jan 2015 15:39:18 +0100
Message-ID: <350eab62-9cf7-4bab-8855-a60bab26aefe@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-538bc6a8-7f02-417a-84d1-1707fcfd2f55"
Cc: <linuxppc-dev@lists.ozlabs.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:13893 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750780AbbA3OjU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Jan 2015 09:39:20 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-538bc6a8-7f02-417a-84d1-1707fcfd2f55
Content-Type: text/plain

[PATCH v2 0/3] SHA256 for PPC/SPE

The following patches add support for SIMD accelerated SHA256 
calculation on PPC processors with SPE instruction set. The 
implementation takes care of the following constraints:

- independant of processor endianess
- save SPE registers for interrupt context compatibility
- disable preemtion only for short intervals

Performance numbers from insmod tcrypt sec=3 mode=304 taken
on e500v2 800 MHz (TP Link WDR4900)

data    per     generic     this patch  speedup  cycles
length  update  bytes/sec   bytes/sec   factor   per byte
------  ------  ----------  ----------  -------  --------
    16      16   5,558,336   8,348,272    x1.50     95.82
    64      16  10,730,602  14,972,789    x1.39     53.43
    64      64  12,841,621  19,268,885    x1.50     41.52
   256      16  16,223,317  21,295,957    x1.31     37.57
   256      64  21,135,957  30,941,696    x1.46     25,86
   256     256  22,664,448  35,765,845    x1.57     22,37
  1024      16  18,608,128  23,893,674    x1.28     33.48
  1024     256  27,427,840  43,427,498    x1.58     18.42
  1024    1024  28,064,768  45,659,136    x1.62     17.52
  2048      16  19,054,592  24,425,130    x1.28     32.75
  2048     256  28,435,797  45,087,402    x1.58     17.74
  2048    1024  29,091,157  47,395,498    x1.62     16.88
  2048    2048  29,225,642  47,756,629    x1.63     16.75

------=_NextPartTM-000-538bc6a8-7f02-417a-84d1-1707fcfd2f55
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

------=_NextPartTM-000-538bc6a8-7f02-417a-84d1-1707fcfd2f55--
