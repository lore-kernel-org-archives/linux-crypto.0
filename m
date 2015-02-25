From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: [PATCH v1 1/3] SHA1 for PPC/SPE - assembler
Date: Wed, 25 Feb 2015 12:21:30 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735F9E1F02@EXCHANGE.collogia.de>
References: <ce3e5ff2-5904-4e1c-bfa9-e37c9682f961@EXCHANGE.collogia.de>,<063D6719AE5E284EB5DD2968C1650D6D1CAEBB2D@AcuExch.aculab.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-e47ad864-244c-46c4-863b-689f4a55c786"
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
To: David Laight <David.Laight@ACULAB.COM>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:47992 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751866AbbBYMVr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2015 07:21:47 -0500
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1CAEBB2D@AcuExch.aculab.com>
Content-Language: de-DE
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-e47ad864-244c-46c4-863b-689f4a55c786
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: David Laight [David.Laight@ACULAB.COM]=0A=
> Gesendet: Mittwoch, 25. Februar 2015 13:01=0A=
> An: Markus Stockhausen; linux-crypto@vger.kernel.org=0A=
> Cc: linuxppc-dev@lists.ozlabs.org=0A=
> Betreff: RE: [PATCH v1 1/3] SHA1 for PPC/SPE - assembler=0A=
> =0A=
> From: Markus Stockhausen=0A=
> > [PATCH v1 1/3] SHA1 for PPC/SPE - assembler=0A=
> >=0A=
> > This is the assembler code for SHA1 implementation with=0A=
> > the SIMD SPE instruction set. With the enhanced instruction=0A=
> > set we can operate on 2 32 bit words in parallel. That helps=0A=
> > reducing the time to calculate W16-W79. For increasing=0A=
> > performance even more the assembler function can compute=0A=
> > hashes for more than one 64 byte input block.=0A=
> >=0A=
> > The state of the used SPE registers is preserved via the=0A=
> > stack so we can run from interrupt context=0A=
> =0A=
> Does the ppc use the same kind of delayed state save for the SPE=0A=
> resisters that x86 uses (at least on the BSDs) for its FP (etc) regs.=0A=
> =0A=
> That would mean that the registers might contain values for=0A=
> a different process, and that the cpu could receive an IPI=0A=
> requesting they be written to the processes normal save area=0A=
> so that they can be reloaded onto a different cpu.=0A=
=0A=
Indeed SPE registers are lazy switched. enable_kernel_spe()=0A=
will take care of that. Additionally I had some discussions about =0A=
interrupt context and its limitations. So=0A=
=0A=
1) I implemented register saving in all patches (see AES & SHA256). =0A=
This is because I know which registers I will overwrite. One should =0A=
remember that SPE registers are shared with normal registers. So =0A=
no big impact to save 32 bit or 64 bit of the non-volatile PPC =0A=
registers.=0A=
=0A=
2) And used disabling of preemption. But in contrast to other =0A=
crypto algorithm implementations only for reasonable time intervals =0A=
=0A=
Markus=0A=
------=_NextPartTM-000-e47ad864-244c-46c4-863b-689f4a55c786
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

------=_NextPartTM-000-e47ad864-244c-46c4-863b-689f4a55c786--
