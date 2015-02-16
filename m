From: Markus Stockhausen <stockhausen@collogia.de>
Subject: [PATCH v1 0/7] AES for PPC/SPE
Date: Mon, 16 Feb 2015 13:45:29 +0100
Message-ID: <67ff8bd2-f749-4773-a52a-3fd8a0bf74bf@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-7f55d32d-1c4b-44de-ad00-dd6bb494df2d"
Cc: <linuxppc-dev@lists.ozlabs.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:7389 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752565AbbBPMpc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Feb 2015 07:45:32 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-7f55d32d-1c4b-44de-ad00-dd6bb494df2d
Content-Type: text/plain

[PATCH v1 0/7] AES for PPC/SPE

The following patches add support for 64bit accelerated AES
calculation on PPC processors with SPE instruction set. Besides
the AES core module it implements ECB/CBC/CTR/XTS as block
ciphers. The implementation takes care of the following 
constraints:

- save SPE registers for interrupt context compatibility
- disable preemption only for short intervals
- endian independant

Module passes tcrypt mode=10 tests. Synthethic AES speedup 
factors from insmod tcrypt sec=3 mode=200 taken on e500v2 
800 MHz (TP Link WDR4900) compared with the generic kernel 
module.

key bytes  ecb   ecb   cbc   cbc   ctr   ctr   xts   xts
           enc   dec   enc   dec   enc   dec   enc   dec
--- -----  ----  ----  ----  ----  ----  ----  ----  ----
128    16  1.14  1.14  1.20  1.28  1.20  1.19  1.20  1.21
128    64  1.35  1.36  1.48  1.51  1.50  1.50  1.41  1.41
128   256  1.49  1.49  1.66  1.65  1.69  1.69  1.58  1.57
128  1024  1.51  1.51  1.69  1.68  1.72  1.72  1.61  1.60
128  8192  1.52  1.52  1.70  1.68  1.73  1.73  1.62  1.61
192    16  1.14  1.15  1.22  1.28  1.21  1.21  1.22  1.23
192    64  1.36  1.37  1.48  1.49  1.49  1.50  1.41  1.41
192   256  1.48  1.48  1.63  1.63  1.65  1.65  1.56  1.55
192  1024  1.50  1.50  1.65  1.64  1.68  1.68  1.59  1.58
192  8192  1.52  1.52  1.67  1.66  1.68  1.68  1.60  1.59
256    16  1.17  1.18  1.24  1.30  1.23  1.22  1.24  1.25
256    64  1.37  1.37  1.47  1.50  1.49  1.49  1.42  1.41
256   256  1.48  1.47  1.60  1.60  1.63  1.63  1.54  1.53
256  1024  1.50  1.49  1.62  1.61  1.65  1.65  1.57  1.56
256  8192  1.50  1.49  1.63  1.62  1.66  1.66  1.58  1.57

Additionally numbers from an iperf transfer benchmark. They
include the AES optimized and the SHA256 optimized module.

- Server : Xeon X3470 2.93GHz
- Client : Core I5 2.4GHz Windows (Shrew VPN client)
- Gateway: e500v2 800 MHz (TP Link WDR4900)

AES256 generic / SHA256 generic modules:
> iperf.exe -c a.b.c.d -t 60 -i 10
------------------------------------------------------------
Client connecting to a.b.c.d, TCP port 5001
TCP window size: 63.0 KByte (default)
------------------------------------------------------------
[  3] local u.v.w.x port 50730 connected with a.b.c.d port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  51.1 MBytes  42.9 Mbits/sec
[  3] 10.0-20.0 sec  51.9 MBytes  43.5 Mbits/sec
[  3] 20.0-30.0 sec  51.5 MBytes  43.2 Mbits/sec
[  3] 30.0-40.0 sec  51.5 MBytes  43.2 Mbits/sec
[  3] 40.0-50.0 sec  51.2 MBytes  43.0 Mbits/sec
[  3] 50.0-60.0 sec  50.6 MBytes  42.5 Mbits/sec
[  3]  0.0-60.0 sec   308 MBytes  43.0 Mbits/sec

AES256 (this patch) / SHA256 (my last patch)
> iperf.exe -c a.b.c.d -t 60 -i 10
------------------------------------------------------------
Client connecting to a.b.c.d, TCP port 5001
TCP window size: 63.0 KByte (default)
------------------------------------------------------------
[  3] local u.v.w.x port 50730 connected with a.b.c.d port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  69.6 MBytes  58.4 Mbits/sec
[  3] 10.0-20.0 sec  69.1 MBytes  58.0 Mbits/sec
[  3] 20.0-30.0 sec  69.2 MBytes  58.1 Mbits/sec
[  3] 30.0-40.0 sec  67.1 MBytes  56.3 Mbits/sec
[  3] 40.0-50.0 sec  67.6 MBytes  56.7 Mbits/sec
[  3] 50.0-60.0 sec  65.9 MBytes  55.3 Mbits/sec
[  3]  0.0-60.0 sec   409 MBytes  57.1 Mbits/sec

------=_NextPartTM-000-7f55d32d-1c4b-44de-ad00-dd6bb494df2d
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

------=_NextPartTM-000-7f55d32d-1c4b-44de-ad00-dd6bb494df2d--
