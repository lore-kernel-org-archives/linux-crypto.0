From: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Subject: RE: [PATCH v6 0/3] crypto: caam - add support for RSA algorithm
Date: Tue, 24 May 2016 16:13:48 +0000
Message-ID: <AMSPR04MB5360B73458157BC926CB57EB84F0@AMSPR04MB536.eurprd04.prod.outlook.com>
References: <1463660118-19188-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <2370625.CgO9A4qjJ6@positron.chronox.de>
 <AMSPR04MB536BAC8C0E2406B390B1C4CB84E0@AMSPR04MB536.eurprd04.prod.outlook.com>
 <3395695.ChDFsreWpU@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Horia Ioan Geanta Neag" <horia.geanta@nxp.com>,
	Ronald Harvey <ron.harvey@nxp.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-am1on0085.outbound.protection.outlook.com ([157.56.112.85]:34624
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753629AbcEXRqV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 May 2016 13:46:21 -0400
In-Reply-To: <3395695.ChDFsreWpU@tauon.atsec.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

> > > as I am looking into the RSA countermeasures, I am wondering how much
> of
> > > countermeasures are actually applied inside hardware implementations.
> >
> > Please point me to the reference RSA countermeasures so that we have
> > a common point of start.
> 
> As the entire MPI logic is derived from libgcrypt, I am planning to use the
> libgcrypt implementation as a basis to implement the blinding defined by
> the
> Handbook of Applied Cryptograpy 11.118/11.119.

When using private key operation commands, our hardware provides
'timing equalization' to hide key information from timing attacks such that
the modular exponentiation will take the same amount of time for a given
byte length of N combined with a given byte length of the exponent.

The other part of timing equalization causes each bit of exponent to take
the same amount of time to process. In normal exponentiation, a one bit takes
two multiplies, while a zero bit takes just one. In timing equalization,
a zero bit causes an extra, but 'fake' multiply.

Thanks,
ta
