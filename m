From: Stephan Mueller <smueller@chronox.de>
Subject: Re: IV generation in cryptographic driver in AEAD
Date: Wed, 18 May 2016 19:58:03 +0200
Message-ID: <17233369.gOFaIE3UCG@tauon.atsec.com>
References: <CADREXso6P503yNN93zcsU2LQFsKtFhWw3x3SuP_F=F2R6snRUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Denis B <begun.denis@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.atsec.com ([195.30.99.214]:57409 "EHLO mail.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834AbcERR6J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 May 2016 13:58:09 -0400
Received: from mail.atsec.com (localhost [127.0.0.1])
	by mail.atsec.com (Postfix) with ESMTP id B04D420A53
	for <linux-crypto@vger.kernel.org>; Wed, 18 May 2016 19:58:05 +0200 (CEST)
In-Reply-To: <CADREXso6P503yNN93zcsU2LQFsKtFhWw3x3SuP_F=F2R6snRUw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 18. Mai 2016, 15:06:19 schrieb Denis B:

Hi Denis,

> Hello,
>=20
> In AEAD mode (or in any case, in IPSec ESP IPv4 =E2=80=93 esp4.c), in=
 kernel
> versions prior to 4.2 the cryptographic driver is expected to generat=
e
> an IV.

The driver is not expected to generate the IV. Please see the ASCII art=
 at=20
[1]. The IV generation is done with the seqiv component. So, you driver=
 can=20
implement all of the logic of GCM, but pull the IV generation from the =
C=20
implementation provided by the kernel crypto API.

[1] http://www.chronox.de/crypto-API/ch02s07.html
>=20
> What if my driver is unable to generate an IV?
>=20
> Thanks,
> Dennis.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypt=
o" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Ciao
Stephan
