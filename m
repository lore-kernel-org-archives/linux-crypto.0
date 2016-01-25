From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/5] crypto: atmel-sha: fix registration issue and other
 bugs
Date: Mon, 25 Jan 2016 15:25:13 +0800
Message-ID: <20160125072513.GD5609@gondor.apana.org.au>
References: <cover.1452867917.git.cyrille.pitchen@atmel.com>
 <56A25E5D.6050504@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Cyrille Pitchen <cyrille.pitchen@atmel.com>, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57019 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbcAYHZU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jan 2016 02:25:20 -0500
Content-Disposition: inline
In-Reply-To: <56A25E5D.6050504@atmel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 22, 2016 at 05:52:45PM +0100, Nicolas Ferre wrote:
> Le 15/01/2016 15:49, Cyrille Pitchen a =E9crit :
> > Hi all,
> >=20
> > This series of patches fixes many issues such as the algo registrat=
ion failure
> > or the broken support of context switches.
>=20
> I think it's eligible as a "fixes" series for 4.5... Herbert, is the
> whole series can be queued as fixes, in your opinion?

Sorry, but I'd prefer to postpone this til the next cycle as it
came in too close to the cut-off mark.  This code is directly
accessible by unprivileged users so I'd like it to cook for a
bit longer.

Thanks,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
