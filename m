From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: hash - Fix handling of small unaligned buffers
Date: Fri, 6 Aug 2010 09:27:01 +0800
Message-ID: <20100806012701.GA22262@gondor.apana.org.au>
References: <AANLkTinw0a9NJNwLRg7d_HQWSFayRdRQH1cULKmmWEFP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Szilveszter =?iso-8859-1?B?1nJk9mc=?= <slipszi@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:60746 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934232Ab0HFB1D (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Aug 2010 21:27:03 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTinw0a9NJNwLRg7d_HQWSFayRdRQH1cULKmmWEFP@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 05, 2010 at 12:05:49PM +0200, Szilveszter =D6rd=F6g wrote:
> If a scatterwalk chain contains an entry with an unaligned offset the=
n
> hash_walk_next() will cut off the next step at the next alignment poi=
nt.
>=20
> However, if the entry ends before the next alignment point then we a =
loop,
> which leads to a kernel oops.
>=20
> Fix this by checking whether the next aligment point is before the en=
d of the
> current entry.
>=20
> Signed-off-by: Szilveszter =D6rd=F6g <slipszi@gmail.com>

Patch applied to crypto-2.6.  Thanks!
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
