From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/tcrypt.c fix resource leak
Date: Tue, 8 Jul 2008 16:22:49 +0800
Message-ID: <20080708082248.GA25297@gondor.apana.org.au>
References: <1215458654.8316.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kernel Janitors <kernel-janitors@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, davem@davemloft.net,
	linux-crypto@vger.kernel.org, jmorris@intercode.com.au,
	jef@linuxbe.org
To: "Darren Jenkins\"" <darrenrjenkins@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:36294 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750717AbYGHIW5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Jul 2008 04:22:57 -0400
Content-Disposition: inline
In-Reply-To: <1215458654.8316.16.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 08, 2008 at 05:24:14AM +1000, Darren Jenkins" wrote:
> G'day people,
>=20
> Coverity CID: 2306 & 2307 RESOURCE_LEAK
>=20
> In the second for loop in test_cipher(), data is allocated space with
> kzalloc() and is only ever freed in an error case.
> Looking at this loop, data is written to this memory but nothing seem=
s
> to read from it.=20
> So here is a patch removing the allocation, I think this is the right
> fix.
>=20
> Only compile tested.
>=20
> =EF=BB=BFSigned-off-by: Darren Jenkins <darrenrjenkins@gmailcom>

Patch applied.  Thanks!
--=20
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
