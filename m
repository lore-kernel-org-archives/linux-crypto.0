From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: [PATCH v1 2/7] AES for PPC/SPE - aes tables
Date: Mon, 16 Feb 2015 17:18:48 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735F9DF098@EXCHANGE.collogia.de>
References: <cfb098e9-69ae-47ff-afa7-08c922accd31@EXCHANGE.collogia.de>
 <063D6719AE5E284EB5DD2968C1650D6D1CAE46B2@AcuExch.aculab.com>,<20150216143706.GA3609@gate.crashing.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-d0fb26b8-9b33-4b13-a2b2-3b353007fa76"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
To: Segher Boessenkool <segher@kernel.crashing.org>,
	David Laight <David.Laight@ACULAB.COM>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:10570 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753197AbbBPRSv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Feb 2015 12:18:51 -0500
In-Reply-To: <20150216143706.GA3609@gate.crashing.org>
Content-Language: de-DE
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-d0fb26b8-9b33-4b13-a2b2-3b353007fa76
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: linux-crypto-owner@vger.kernel.org [linux-crypto-owner@vger.kernel.o=
rg]&quot; im Auftrag von &quot;Segher Boessenkool [segher@kernel.crashing.o=
rg]=0A=
> Gesendet: Montag, 16. Februar 2015 15:37=0A=
> An: David Laight=0A=
> Cc: Markus Stockhausen; linux-crypto@vger.kernel.org; linuxppc-dev@lists.=
ozlabs.org=0A=
> Betreff: Re: [PATCH v1 2/7] AES for PPC/SPE - aes tables=0A=
> =0A=
> On Mon, Feb 16, 2015 at 02:19:50PM +0000, David Laight wrote:=0A=
> > From:  Markus Stockhausen=0A=
> > > 4K AES tables for big endian=0A=
> >=0A=
> > I can't help feeling that you could give more information about how the=
=0A=
> > values are generated.=0A=
> =0A=
> ... and an explanation of why this does not open you up to a timing attac=
k?=0A=
=0A=
Good points,=0A=
=0A=
the tables are only big endian reversed ones of those found in crypto/aes_g=
eneric.c.=0A=
=0A=
Regarding timing attacks: I understand, that reducing AES table sizes for a=
 constant =0A=
AES processing time is important to avoid cache timing attacks. Hopefully t=
he =0A=
following points will mitigate the concern.=0A=
=0A=
Target architecture are low performance e500 cores without available caam =
=0A=
features. These can currently use only aes-generic module. That one depends=
 =0A=
on 16K T-tables. 2*4K for encryption and 2*4K for decryption. The new modul=
e=0A=
reduces the T-table sizes to 8K+256 bytes. Far away from a minimal 256 byte=
=0A=
S-BOX but at least an improvement.=0A=
=0A=
To narrow it down further. Intended use is for cheap routers. So no multius=
er =0A=
environments where a malicous process could drive complex flush+reload =0A=
attacks. In case someone gains unallowed access there will be a lot of othe=
r =0A=
and simpler ways to compromise the system.=0A=
=0A=
In case that is sufficient for you I will add respective notes into a patch=
 v2.=0A=
=0A=
Markus=
------=_NextPartTM-000-d0fb26b8-9b33-4b13-a2b2-3b353007fa76
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

------=_NextPartTM-000-d0fb26b8-9b33-4b13-a2b2-3b353007fa76--
