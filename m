From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: Asymmetric cryptography HW offloading
Date: Sun, 29 Sep 2013 19:50:56 +0200
Message-ID: <52486880.4060009@gnutls.org>
References: <524034A1.70204@freescale.com> <524041EE.5070209@gnutls.org> <524564CF.6030508@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Yashpal Dutta <yashpal.dutta@freescale.com>
To: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:46740 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab3I2Ru7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 29 Sep 2013 13:50:59 -0400
Received: by mail-ee0-f51.google.com with SMTP id c1so2225137eek.10
        for <linux-crypto@vger.kernel.org>; Sun, 29 Sep 2013 10:50:58 -0700 (PDT)
In-Reply-To: <524564CF.6030508@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/27/2013 12:58 PM, Horia Geant=C4=83 wrote:

> Thanks for the tip.
> I took a look at BSD - AFAICT there is no SW implementation and crypt=
o
> engine drivers handle only the first two operations (MOD_EXP).
>=20
> My main concern now is the asymmetric ciphers API, that would eventua=
lly
> allow implementing the operations in SW/HW.
> I was wondering whether the same logic as for symmetric ciphers
> could/should be used (the API layering mentioned in
> Documentation/crypto/api-intro.txt).
> For example, crypto/asymmetric_keys/rsa.c could be registered and the=
n
> used via Crypto API:
> rsa.c: crypto_alg->cra_name =3D "rsa";

As RSA fits into the encryption API it may be just ok. I'd say do it an=
d
then we see whether that API causes some bottleneck for asymmetric
encryption. But how would you fit modexp in that case?

Having the expensive big number operations could be useful to non-crypt=
o
number crunching projects as well (e.g. gmp and its users).

regards,
Nikos
