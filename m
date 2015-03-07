From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: [PATCH] crypto: powerpc - move files to fix build error
Date: Sat, 7 Mar 2015 07:32:44 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735F9E571F@EXCHANGE.collogia.de>
References: <20150306184621.c2d277457bb1b3112b1d3a64@freescale.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="----=_NextPartTM-000-23dc74a4-eafd-4069-80b3-de2ba29c5542"
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Kim Phillips <kim.phillips@freescale.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Benjamin Herrenschmidt
 <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, "Michael
 Ellerman" <mpe@ellerman.id.au>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20150306184621.c2d277457bb1b3112b1d3a64@freescale.com>
Content-Language: de-DE
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org


This is a multi-part message in MIME format.

------=_NextPartTM-000-23dc74a4-eafd-4069-80b3-de2ba29c5542
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

> Von: Kim Phillips [kim.phillips@freescale.com]=0A=
> Gesendet: Samstag, 7. M=E4rz 2015 01:46=0A=
> An: Herbert Xu; Benjamin Herrenschmidt; Paul Mackerras; Michael Ellerman=
=0A=
> Cc: Markus Stockhausen; linux-crypto@vger.kernel.org; linuxppc-dev@lists.=
ozlabs.org; linux-kernel@vger.kernel.org=0A=
> Betreff: [PATCH] crypto: powerpc - move files to fix build error=0A=
> =0A=
> The current cryptodev-2.6 tree commits:=0A=
> =0A=
> d9850fc529ef ("crypto: powerpc/sha1 - kernel config")=0A=
> 50ba29aaa7b0 ("crypto: powerpc/sha1 - glue")=0A=
> =0A=
> failed to properly place files under arch/powerpc/crypto, which=0A=
> leads to build errors:=0A=
> =0A=
> make[1]: *** No rule to make target 'arch/powerpc/crypto/sha1-spe-asm.o',=
 needed by 'arch/powerpc/crypto/sha1-ppc-spe.o'.  Stop.=0A=
> make[1]: *** No rule to make target 'arch/powerpc/crypto/sha1_spe_glue.o'=
, needed by 'arch/powerpc/crypto/sha1-ppc-spe.o'.  Stop.=0A=
> Makefile:947: recipe for target 'arch/powerpc/crypto' failed=0A=
> =0A=
> Move the two sha1 spe files under crypto/, and whilst there, rename=0A=
> other powerpc crypto files with underscores to use dashes for=0A=
> consistency.=0A=
=0A=
Sorry for the glitches. Did not notice that I had the files in adjacent fol=
ders=0A=
and finally added the wrong ones to my git. Thanks a lot for fixing that. =
=0A=
=0A=
Markus=
------=_NextPartTM-000-23dc74a4-eafd-4069-80b3-de2ba29c5542
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

------=_NextPartTM-000-23dc74a4-eafd-4069-80b3-de2ba29c5542
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXhwcGMt
ZGV2IG1haWxpbmcgbGlzdApMaW51eHBwYy1kZXZAbGlzdHMub3psYWJzLm9yZwpodHRwczovL2xp
c3RzLm96bGFicy5vcmcvbGlzdGluZm8vbGludXhwcGMtZGV2

------=_NextPartTM-000-23dc74a4-eafd-4069-80b3-de2ba29c5542--
