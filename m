From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Clarification of allowed context for crypto routines
Date: Sat, 24 Jan 2009 20:32:45 +1100
Message-ID: <20090124093245.GA4889@gondor.apana.org.au>
References: <200901240815.08903.arvidjaar@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrey Borzenkov <arvidjaar@mail.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47990 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751015AbZAXJct (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 24 Jan 2009 04:32:49 -0500
Content-Disposition: inline
In-Reply-To: <200901240815.08903.arvidjaar@mail.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Andrey Borzenkov <arvidjaar@mail.ru> wrote:
>=20
> On 24 =D1=8F=D0=BD=D0=B2=D0=B0=D1=80=D1=8F 2009 01:31:50 Herbert Xu w=
rote:
>>
>> 2) The highmem primitives we use are currently softirq only.  We
>> could make them work for hardirq as well, but because of 1) we
>> didn't.
>=20
> Could you point to example of such primitive in code under crypto?

Grep for kmap under crypto.

Cheers,
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
