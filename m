From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 5/5] crypto: talitos: Add software backlog queue
 handling
Date: Fri, 6 Mar 2015 15:48:21 +1100
Message-ID: <20150306044821.GA1411@gondor.apana.org.au>
References: <1425388897-5434-1-git-send-email-mort@bork.org>
 <1425388897-5434-6-git-send-email-mort@bork.org>
 <20150303182332.546523088b5891a776880c0f@freescale.com>
 <54F8235B.5080301@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Kim Phillips <kim.phillips@freescale.com>,
	Martin Hicks <mort@bork.org>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>,
	linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:57689 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364AbbCFEsm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Mar 2015 23:48:42 -0500
Content-Disposition: inline
In-Reply-To: <54F8235B.5080301@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 05, 2015 at 11:35:23AM +0200, Horia Geant=C4=83 wrote:
>=20
> > Only potential problem is getting the crypto API to set the GFP_DMA
> > flag in the allocation request, but presumably a
> > CRYPTO_TFM_REQ_DMA crt_flag can be made to handle that.
>=20
> Right. And this flag would apply only to request __ctx[].
>=20
> Herbert, would this be an acceptable addition to crypto API?

How would such a flag work?

Cheers,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
