From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: AW: Best way to align key in AES context
Date: Fri, 13 Feb 2015 16:49:56 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735F9DE3DA@EXCHANGE.collogia.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD1735F9DD863@EXCHANGE.collogia.de>
 <12EF8D94C6F8734FB2FF37B9FBEDD1735F9DD877@EXCHANGE.collogia.de>,<54DE0E6F.7090509@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-6d28bb3e-ccae-4cd1-82d2-f9e29137226e"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:57756 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752924AbbBMQuA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Feb 2015 11:50:00 -0500
In-Reply-To: <54DE0E6F.7090509@intel.com>
Content-Language: de-DE
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-6d28bb3e-ccae-4cd1-82d2-f9e29137226e
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: linux-crypto-owner@vger.kernel.org [linux-crypto-owner@vger.kernel.o=
rg]&quot; im Auftrag von &quot;Tadeusz Struk [tadeusz.struk@intel.com]=0A=
> Gesendet: Freitag, 13. Februar 2015 15:47=0A=
> An: Markus Stockhausen=0A=
> Cc: linux-crypto@vger.kernel.org=0A=
> Betreff: Re: AW: Best way to align key in AES context=0A=
> =0A=
> On 02/11/2015 02:28 AM, Markus Stockhausen wrote:=0A=
> > I want to ensure that the key data in an AES ctx structure is 8 byte al=
igned=0A=
> > to avoid aligment exceptions afterwards. Other fields don't need that=
=0A=
> > restriction. At the moment I'm using the following (ugly) implementatio=
n.=0A=
> >=0A=
> > struct ppc_aes_ctx {=0A=
> >         u32 rounds;=0A=
> >         u32 *key_enc;=0A=
> >         u32 *key_dec;=0A=
> >         char data[AES_MAX_KEYLENGTH * 2 + 8];=0A=
> > };=0A=
> > ...=0A=
> > char *ptr;=0A=
> > ptr =3D ctx->data;=0A=
> > ptr =3D PTR_ALIGN(ptr, 8);=0A=
> > ctx->key_enc =3D (u32 *)(ptr);=0A=
> > ctx->key_dec =3D (u32 *)(ptr + AES_MAX_KEYLENGTH);=0A=
> >=0A=
> > Can anyone show me the recommended way for doing that.=0A=
> =0A=
> =0A=
> You can use gcc attributes.=0A=
> =0A=
> struct ppc_aes_ctx {=0A=
>         u8 key_enc[AES_MAX_KEYLENGTH];=0A=
>         u8 key_dec[AES_MAX_KEYLENGTH];=0A=
>         u32 rounds;=0A=
> } __aligned(8);=0A=
=0A=
Hi Tadeusz,=0A=
=0A=
thanks for the tip.  I will at least move the data definitions to the begin=
ning of =0A=
my structure.=0A=
=0A=
But while it sounds logical for data types that are directly created from t=
hat =0A=
structure I'm unsure about a context. If I understand it correctly a contex=
t is =0A=
dynamically allocated. Could it be possible that the start address is then =
only =0A=
4 bytes aligned?=0A=
=0A=
So I tried to dive into the magic of alignmask and contexts. This even conf=
uses=0A=
me a little bit more. Nearly all implementations in the crypto tree make us=
e of=0A=
alignmasks >=3D 3. I guess to be at least 4 bytes aligned. But when accessi=
ng the=0A=
context they "only" use crypto_blkcipher_ctx(). This will just return the c=
ontext=0A=
address while crypto_blkcipher_ctx_aligned() seems to be the right place to=
 =0A=
return a pointer that is aligned according to the predefined mask.=0A=
=0A=
Would you recommend to=0A=
=0A=
a) ignore alignmask and use only __aligned(8) for the structure=0A=
=0A=
b) to assume ctx will be automatically 8 bytes aligned regardless of __alig=
ned(8)=0A=
flag or cra_alignmask. So nothing to take care about.=0A=
=0A=
b) or to define structure without __aligned(8) but work with cra_alignmask=
=3D7. =0A=
I fear that this might impose alignment of input/output data to 8 too and l=
ead =0A=
to unneccessary memcpy() operations.=0A=
=0A=
Sorry for driving myself nuts but I want to understand if before I send pat=
ches.=0A=
=0A=
Best regards.=0A=
=0A=
Markus=0A=
------=_NextPartTM-000-6d28bb3e-ccae-4cd1-82d2-f9e29137226e
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

------=_NextPartTM-000-6d28bb3e-ccae-4cd1-82d2-f9e29137226e--
