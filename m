From: "Martin Schiller" <mschiller@tdt.de>
Subject: Testing the geode-aes driver with the tcrypt module completely freezes the machine
Date: Thu, 26 Apr 2007 11:04:21 +0200
Message-ID: <000601c787e1$e169ff00$1a04010a@V505CP>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.tdt.de ([195.243.126.82]:45611 "EHLO ns.tdt.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030459AbXDZKKW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Apr 2007 06:10:22 -0400
Received: from ns (root@localhost)
	by ns.tdt.de (8.11.6/8.11.6/SuSE Linux 0.5) with SMTP id l3Q95vX02496
	for <linux-crypto@vger.kernel.org>; Thu, 26 Apr 2007 11:05:57 +0200
Received: from V505CP (mschiller3 [10.1.4.26])
	by ns.tdt.de (8.11.6/8.11.6/SuSE Linux 0.5) with ESMTP id l3Q95vQ02489
	for <linux-crypto@vger.kernel.org>; Thu, 26 Apr 2007 11:05:57 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

here is what I do:

- I have an AEWIN CB-6971 with an AMD Geode LX800.

- Testing with kernel 2.6.21-rc7-git5.

- When the geode_aes module is loaded and I am loading the tcrypt modul=
e,
  the machine freezes completely.

- When the geode_aes module is NOT loaded and I am loading the tcrypt
module,
  the test works well.

Has anyone else tried to test the geode-aes driver with the tcrypt modu=
le?

I am also not able to use the geode-aes driver with openswan-2.4.7 on k=
ernel
2.6.19 (with patched-in geode driver).

Regards,
Martin


--------------------------
=20
Martin Schiller
Dipl.-Inf. FH
Development


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
