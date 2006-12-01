From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [RFC][PATCH] Pseudo-random number generator
Date: Fri, 01 Dec 2006 18:33:01 +0100
Message-ID: <E1GqCFx-0006X8-IO@be1.lrz>
References: <7ngD0-8fX-11@gated-at.bofh.it> <7ngMA-8D-39@gated-at.bofh.it> <7niv3-4sQ-21@gated-at.bofh.it> <7niEE-4Mk-5@gated-at.bofh.it>
Reply-To: 7eggert@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:42981 "EHLO
	moutng.kundenserver.de") by vger.kernel.org with ESMTP
	id S1031660AbWLARdL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 Dec 2006 12:33:11 -0500
To: Alan <alan@lxorguk.ukuu.org.uk>,
	Jan Glauber <jan.glauber@de.ibm.com>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Alan <alan@lxorguk.ukuu.org.uk> wrote:
> On Fri, 01 Dec 2006 16:20:46 +0100
> Jan Glauber <jan.glauber@de.ibm.com> wrote:

>> Yes, a user can just symlink urandom to prandom and will have a fast=
er
>> generator.
>=20
>=20
> More usefully they can use it as an entropy source with an entropy
> daemon to feed it into the standard urandom/random.

Only if other users will randomly drain /dev/prandom, otherwise you mig=
ht
as well use /dev/zero.
--=20
Ich danke GMX daf=FCr, die Verwendung meiner Adressen mittels per SPF
verbreiteten L=FCgen zu sabotieren.

http://david.woodhou.se/why-not-spf.html
