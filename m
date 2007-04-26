From: "Martin Schiller" <mschiller@tdt.de>
Subject: RE: Testing the geode-aes driver with the tcrypt module completely freezes the machine
Date: Thu, 26 Apr 2007 13:27:56 +0200
Message-ID: <000d01c787f5$efce4b00$1a04010a@V505CP>
References: <000601c787e1$e169ff00$1a04010a@V505CP> <20070426110522.GB31648@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>
To: "'Sebastian Siewior'" <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.tdt.de ([195.243.126.82]:46228 "EHLO ns.tdt.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbXDZL15 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Apr 2007 07:27:57 -0400
Received: from ns (root@localhost)
	by ns.tdt.de (8.11.6/8.11.6/SuSE Linux 0.5) with SMTP id l3QBRuW06656
	for <linux-crypto@vger.kernel.org>; Thu, 26 Apr 2007 13:27:56 +0200
In-Reply-To: <20070426110522.GB31648@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thursday, April 26, 2007 1:05 PM, Sebastian Siewior wrote:

> * Martin Schiller | 2007-04-26 11:04:21 [+0200]:
>=20
>> - When the geode_aes module is loaded and I am loading the tcrypt
>>  module, the machine freezes completely.
>=20
> could you modify the tcrpto module to test only ecb(aes) enc/dec with
> keysize =3D 16 (1 instead of AES_ENC_TEST_VECTORS) and see if it is
> still freezing? =20
>=20

Tried it and it's still freezing.

Any other suggestions?

Regards,
Martin

--------------------------------
Martin Schiller
Dipl.-Inf. FH
Entwicklung / Development


T.D.T. Transfer Data Test GmbH
Siemensstrasse 18
Gewerbegebiet Altheim
84051 Essenbach
Germany

mschiller@tdt.de
www.tdt.de

tel: +49 8703 929 00
fax: +49 8703 929 201

Gesch=E4ftsf=FChrer: Elisabeth Pickhardt &  Michael Pickhardt
Registergericht Landshut, HRB: 1193
