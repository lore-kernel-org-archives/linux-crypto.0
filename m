From: "Martin Schiller" <mschiller@tdt.de>
Subject: RE: Testing the geode-aes driver with the tcrypt module completely freezes the machine
Date: Thu, 3 May 2007 15:12:43 +0200
Message-ID: <000601c78d84$bc24b430$1a04010a@V505CP>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>
To: <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.tdt.de ([195.243.126.82]:41917 "EHLO ns.tdt.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161910AbXECNMl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 May 2007 09:12:41 -0400
Received: from ns (root@localhost)
	by ns.tdt.de (8.11.6/8.11.6/SuSE Linux 0.5) with SMTP id l43DCZW29306
	for <linux-crypto@vger.kernel.org>; Thu, 3 May 2007 15:12:35 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thursday, May 03, 2007 00:58:45 -0700 , Evgeniy Polyakov wrote:

> Hi Martin.

Hi Evgeniy

>> Sorry for my late answer, but I didn't get your message because I ha=
ven't
>> subscribed to the mailing-list.
>> I've "found" it yesterday on the mailing-list archive. So please, co=
uld
you
>> reply directly to me and to the mailing-list on any further messages=
?
>
> I did, but your mail server bounced message.
> This message is also sent to you directly, hope it will pass through.
> Btw, AMD list bounces too.

It didn't, but I talked to our mail server admin and now your mails sho=
uld
reach me. :-)

After adding the debug outputs from your last patch, none of them was
displayed.
So I started adding some more outputs and doing a "line-by-line" debugg=
ing
and found out this (so far):

The freeze is the result of an invinite while-loop in the function
geode_ecb_encrypt()
(and maybe also in the geode_ecb_decrypt()).

The cause for this seems to be, that the op->src =3D=3D op->dst whereby=
 the
geode_aes_crypt() function does nothing at all,
and so the value of nbytes will never be changed.

Regards,
Martin

-------------------------------------------
=20
Martin Schiller
Dipl.-Inf. FH
Entwicklung / Development


T.D.T. Transfer Data Test GmbH
Siemensstrasse 18
Gewerbegebiet Altheim
84051 Essenbach
Germany=20

mschiller@tdt.de
www.tdt.de=20

tel: +49 8703 929 00
fax: +49 8703 929 201

Gesch=E4ftsf=FChrer: Elisabeth Pickhardt &  Michael Pickhardt
Registergericht Landshut, HRB: 1193=20
