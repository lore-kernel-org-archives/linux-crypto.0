From: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH 0/5] crypto: atmel-sha: fix registration issue and other
 bugs
Date: Fri, 22 Jan 2016 17:52:45 +0100
Message-ID: <56A25E5D.6050504@atmel.com>
References: <cover.1452867917.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
To: Cyrille Pitchen <cyrille.pitchen@atmel.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:24487 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbcAVQwv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jan 2016 11:52:51 -0500
In-Reply-To: <cover.1452867917.git.cyrille.pitchen@atmel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Le 15/01/2016 15:49, Cyrille Pitchen a =E9crit :
> Hi all,
>=20
> This series of patches fixes many issues such as the algo registratio=
n failure
> or the broken support of context switches.

I think it's eligible as a "fixes" series for 4.5... Herbert, is the
whole series can be queued as fixes, in your opinion?

And, on the whole series:
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>


> This series was applied to linux-next and tested on a sama5d2 xplaine=
d
> ultra board. We now pass the tcrypt tests in the following modes:
> -  2: sha1
> -  6: sha256
> - 11: sha384
> - 12: sha512
> - 33: sha224
>=20
> The context switch fix was tested with a userspace program using the =
cryptodev
> module. This single thread program computes the SHA256 hashes of many=
 files
> by splitting then into fixed size chunks. The chunks of each file are
> processed by calling 'update' operations using a round robin algorith=
m.
>=20
> However, the .import() / .export() implementation was NOT tested!
> Nonetheless the last patch is needed to fix the registration issue, o=
therwise
> atmel_sha_probe() would still fail.
>=20
> Best regards,
>=20
> Cyrille
>=20
>=20
> Cyrille Pitchen (5):
>   crypto: atmel-sha: fix crash when computing digest on empty message
>   crypto: atmel-sha: fix a race between the 'done' tasklet and the
>     crypto client
>   crypto: atmel-sha: add support of sama5d2x SoCs
>   crypto: atmel-sha: fix context switches
>   crypto: atmel-sha: fix algorihtm registration
>=20
>  drivers/crypto/atmel-sha-regs.h |   4 +
>  drivers/crypto/atmel-sha.c      | 186 ++++++++++++++++++++++++++++++=
+++-------
>  2 files changed, 158 insertions(+), 32 deletions(-)
>=20


--=20
Nicolas Ferre
