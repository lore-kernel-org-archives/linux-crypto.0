From: Markus Stockhausen <stockhausen@collogia.de>
Subject: Re: [PATCH v1 0/3] SHA256 for PPC/SPE
Date: Mon, 26 Jan 2015 05:19:48 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735F9154C6@EXCHANGE.collogia.de>
References: <5ad377b3-e491-4c35-8b89-de1dfd0749a6@EXCHANGE.collogia.de>,<20150126001842.GA18477@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-f0e12eca-3762-4414-b314-b7d3d6709c3e"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:38191 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751747AbbAZFTw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Jan 2015 00:19:52 -0500
In-Reply-To: <20150126001842.GA18477@gondor.apana.org.au>
Content-Language: de-DE
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-f0e12eca-3762-4414-b314-b7d3d6709c3e
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: linux-crypto-owner@vger.kernel.org [linux-crypto-owner@vger.kernel.o=
rg]&quot; im Auftrag von &quot;Herbert Xu [herbert@gondor.apana.org.au]=0A=
> Gesendet: Montag, 26. Januar 2015 01:18=0A=
> An: Markus Stockhausen=0A=
> Cc: linux-crypto@vger.kernel.org; linuxppc-dev@lists.ozlabs.org=0A=
> Betreff: Re: [PATCH v1 0/3] SHA256 for PPC/SPE=0A=
> =0A=
> Markus Stockhausen <stockhausen@collogia.de> wrote:=0A=
> >=0A=
> >  [PATCH v1 0/3] SHA256 for PPC/SPE=0A=
> >=0A=
> > The following patches add support for SIMD accelerated SHA256=0A=
> > calculation on PPC processors with SPE instruction set. The=0A=
> > implementation takes care of the following constraints:=0A=
> >=0A=
> > - independant of processor endianess=0A=
> > - fallback to generic code if called from interrupt context=0A=
> > - disable preemtion only for short intervals=0A=
> =0A=
> Thanks for the patch! Unfortunately the interrupt context test=0A=
> is a bummer because that means your code won't be used by IPsec=0A=
> at all.=0A=
> =0A=
> Would it be possible to relax the conditions similar to sha1_ssse3=0A=
> on x86? If not how about going async with cryptd?=0A=
=0A=
@Herbert: thanks for that annotation. IPsec is the desired use case.=0A=
Do you have a programming template for the cryptd integration?=0A=
E.g. ghash-clmulni-intel_glue.c?=0A=
=0A=
@linuxppc: Intel world checks for usable FPU (SSE3, ...) in the crypto =0A=
modules with=0A=
=0A=
bool irq_fpu_usable(void)=0A=
{=0A=
  return !in_interrupt() ||=0A=
    interrupted_user_mode() ||=0A=
    interrupted_kernel_fpu_idle();=0A=
}=0A=
=0A=
I guess interrupted_kernel_fpu_idle() is the part that allows IPsec =0A=
inside an interrupt to make use of the accelerated module. =0A=
Explanation reads:=0A=
=0A=
* On others, we can do a kernel_fpu_begin/end() pair *ONLY* if =0A=
* that pair does nothing at all: the thread must not have fpu (so=0A=
* that we don't try to save the FPU state), and TS must=0A=
* be set (so that the clts/stts pair does nothing that is=0A=
* visible in the interrupted kernel thread).=0A=
=0A=
Do I have the chance to use something similiar in the PPC/SPE =0A=
case? Or is there a simple way like saving the SPE registers=0A=
myself?=0A=
=0A=
Thanks in advance.=0A=
=0A=
Markus=
------=_NextPartTM-000-f0e12eca-3762-4414-b314-b7d3d6709c3e
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

------=_NextPartTM-000-f0e12eca-3762-4414-b314-b7d3d6709c3e--
