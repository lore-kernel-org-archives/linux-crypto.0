From: "Jonas Eymann" <J.Eymann@gmx.net>
Subject: Re: [PATCH 0/2] crypto: talitos - fix conversion to new AEAD
 interface
Date: Wed, 20 Apr 2016 14:09:27 +0200
Message-ID: <trinity-8dcdb1f6-150a-4801-b023-7884b3130854-1461154167206@3capp-gmx-bs61>
References: <AM2PR04MB067377F55DDE5D5EE126EBF3986B0@AM2PR04MB0673.eurprd04.prod.outlook.com>
 <1461087228-19359-1-git-send-email-horia.geanta@nxp.com>,
 <20160420095838.GB3003@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: horia.geanta@nxp.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:63099 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836AbcDTMJc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Apr 2016 08:09:32 -0400
In-Reply-To: <20160420095838.GB3003@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

sorry for the late reply, I was out of office. Thank you very much Hori=
a for fixing the typo, adding the sign-off and also for the second patc=
h. I'll also run some tests when I find the time to see how everything =
works together.

Jonas

> Gesendet: Mittwoch, 20. April 2016 um 11:58 Uhr
> Von: "Herbert Xu" <herbert@gondor.apana.org.au>
> An: "Horia Geant=C4=83" <horia.geanta@nxp.com>
> Cc: linux-crypto@vger.kernel.org, "Jonas Eymann" <J.Eymann@gmx.net>, =
"David S. Miller" <davem@davemloft.net>
> Betreff: Re: [PATCH 0/2] crypto: talitos - fix conversion to new AEAD=
 interface
>
> On Tue, Apr 19, 2016 at 08:33:46PM +0300, Horia Geant=C4=83 wrote:
> > Jonas Eymann reports a crash and some failures of AED algorithms
> > with kernel 4.4.6, all easily reproducible with tcrypt.
> >=20
> > These have to do with the onversion to the new AEAD interface:
> > aeb4c132f33d crypto: talitos - Convert to new AEAD interface
> >=20
> > Problems occur for 4.3+ kernels, sending patches to -stable.
> >=20
> > (*) Proper fix for hash algorithms registration failures
> > (implementation of import/export functionality) will be added separ=
ately.
>=20
> Both applied.  Thanks!
> --=20
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
