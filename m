From: "Challa, Mahipal" <Mahipal.Challa@cavium.com>
Subject: Re: [RFC PATCH 0/3] Cavium ThunderX ZIP driver
Date: Tue, 27 Dec 2016 11:39:21 +0000
Message-ID: <DM5PR07MB3148D87C62159523B750CD20E5690@DM5PR07MB3148.namprd07.prod.outlook.com>
References: <20161212150439.18627-1-jglauber@cavium.com>,<20161227090227.GC10121@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Nair, Vishnu" <Vishnu.Nair@cavium.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Jan Glauber <Jan.Glauber@cavium.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0068.outbound.protection.outlook.com ([104.47.38.68]:48192
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754447AbcL0NOK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2016 08:14:10 -0500
In-Reply-To: <20161227090227.GC10121@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Hi Herbert,

Thanks for your response

>Hi Jan:

On Mon, Dec 12, 2016 at 04:04:36PM +0100, Jan Glauber wrote:
> >
> >this series adds support for hardware accelerated compression & decompre=
ssion
> >as found on ThunderX (arm64) SOCs. I've been reviewing this driver inter=
nally
> >for some time and would like to get feedback on the RFC to see if this g=
oes
> >into the right direction and to see if there are any concerns.
> >
> >We've discussed switching to the new acomp algorithm but for the time be=
ing
> >decided against acomp because our test cases are not yet supported with =
it.

> OK.=A0 Do you see any major problems in converting this over to acomp?
Mahipal: One major issue is, the kernel use cases to validate the Cavium Th=
underX ZIP driver are "ZSWAP" and "IPComp" which are not yet supported with=
 scomp-acomp framework.=20

Regards,
-Mahipal



From: Herbert Xu <herbert@gondor.apana.org.au>
Sent: Tuesday, December 27, 2016 2:32 PM
To: Jan Glauber
Cc: linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org; David S . M=
iller; Challa, Mahipal; Nair, Vishnu
Subject: Re: [RFC PATCH 0/3] Cavium ThunderX ZIP driver
=A0  =20
Hi Jan:

On Mon, Dec 12, 2016 at 04:04:36PM +0100, Jan Glauber wrote:
>=20
> this series adds support for hardware accelerated compression & decompres=
sion
> as found on ThunderX (arm64) SOCs. I've been reviewing this driver intern=
ally
> for some time and would like to get feedback on the RFC to see if this go=
es
> into the right direction and to see if there are any concerns.
>=20
> We've discussed switching to the new acomp algorithm but for the time bei=
ng
> decided against acomp because our test cases are not yet supported with i=
t.

OK.=A0 Do you see any major problems in converting this over to acomp?

Thanks,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
    =
