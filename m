From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 0/3] crypto: caam - add support for RSA algorithm
Date: Tue, 24 May 2016 18:58:03 +0200
Message-ID: <2874209.GQE6GP7zM1@positron.chronox.de>
References: <1463660118-19188-1-git-send-email-tudor-dan.ambarus@nxp.com> <3395695.ChDFsreWpU@tauon.atsec.com> <AMSPR04MB5360B73458157BC926CB57EB84F0@AMSPR04MB536.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Horia Ioan Geanta Neag <horia.geanta@nxp.com>,
	Ronald Harvey <ron.harvey@nxp.com>
To: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34746 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbcEXQ6H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 May 2016 12:58:07 -0400
In-Reply-To: <AMSPR04MB5360B73458157BC926CB57EB84F0@AMSPR04MB536.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 24. Mai 2016, 16:13:48 schrieb Tudor-Dan Ambarus:

Hi Tudor,

> Hi Stephan,
> 
> > > > as I am looking into the RSA countermeasures, I am wondering how much
> > 
> > of
> > 
> > > > countermeasures are actually applied inside hardware implementations.
> > > 
> > > Please point me to the reference RSA countermeasures so that we have
> > > a common point of start.
> > 
> > As the entire MPI logic is derived from libgcrypt, I am planning to use
> > the
> > libgcrypt implementation as a basis to implement the blinding defined by
> > the
> > Handbook of Applied Cryptograpy 11.118/11.119.
> 
> When using private key operation commands, our hardware provides
> 'timing equalization' to hide key information from timing attacks such that
> the modular exponentiation will take the same amount of time for a given
> byte length of N combined with a given byte length of the exponent.

Great, that is the other countermeasure option for RSA. So, your 
implementation would be covered.

I guess it would make sense to implement countermeasures on an as-needed basis 
then.
> 
> The other part of timing equalization causes each bit of exponent to take
> the same amount of time to process. In normal exponentiation, a one bit
> takes two multiplies, while a zero bit takes just one. In timing
> equalization, a zero bit causes an extra, but 'fake' multiply.

Good, so you have two types of countermeasures it seems. Again, you should be 
good then.


Ciao
Stephan
