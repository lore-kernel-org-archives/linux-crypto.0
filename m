From: Markus Stockhausen <stockhausen@collogia.de>
Subject: [PATCH v1 0/3] crypto: powerpc/md5
Date: Sun, 1 Mar 2015 19:30:30 +0100
Message-ID: <4fc2d70a-8d5b-495b-babc-d1236781b2f0@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-e636df0e-66ba-4052-bcc6-3ec38228b06a"
Cc: <linuxppc-dev@lists.ozlabs.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:46674 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752173AbbCASae (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 Mar 2015 13:30:34 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-e636df0e-66ba-4052-bcc6-3ec38228b06a
Content-Type: text/plain

[PATCH v1 0/3] crypto: powerpc/md5

The following patches add support for optimized MD5
calculation on PPC processors. It completes the previous
patches to provide a comprehensive IPsec algorithm support
for low power routers without hardware crypto acceleration. 
The implementation is endian independant. Although only 
tested on 32 bit CPU it should run on 64 bit too.

Performance numbers from insmod tcrypt sec=3 mode=302 taken
on e500v2 800 MHz (TP Link WDR4900)

data    per     generic      this patch  speedup  cycles
length  update  bytes/sec    bytes/sec   factor   per byte
------  ------  -----------  ----------  -------  --------
    16      16   14,131,578   16,019,173   x1.13     49.94
    64      16   24,003,093   25,642,282   x1.07     31.20
    64      64   36,445,269   43,124,074   x1.18     18.55
   256      16   32,454,144   33,569,194   x1.03     23.83
   256      64   57,306,965   67,855,104   x1.18     11.79
   256     256   71,010,304   91,093,333   x1.28      8.78
  1024      16   35,902,122   36,451,328   x1.02     21.95
  1024     256   86,229,674  113,111,722   x1.31      7.07
  1024    1024   93,883,733  127,357,952   x1.36      6.28
  2048      16   36,175,189   36,937,728   x1.02     21.66
  2048     256   89,539,242  118,392,832   x1.32      6.76
  2048    1024   97,499,136  133,113,856   x1.37      6.01
  2048    2048   99,198,976  136,406,357   x1.38      5.86

------=_NextPartTM-000-e636df0e-66ba-4052-bcc6-3ec38228b06a
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

------=_NextPartTM-000-e636df0e-66ba-4052-bcc6-3ec38228b06a--
