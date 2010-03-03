From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ahash - Fix handling of unaligned buffers
Date: Wed, 3 Mar 2010 08:04:31 +0800
Message-ID: <20100303000431.GA8593@gondor.apana.org.au>
References: <ac67d9131003021510n47414dewf36d359a315115aa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Szilveszter Ordog <slipszi@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:43130 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751497Ab0CCAEf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Mar 2010 19:04:35 -0500
Content-Disposition: inline
In-Reply-To: <ac67d9131003021510n47414dewf36d359a315115aa@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Szilveszter Ordog <slipszi@gmail.com> wrote:
>> When we get an unaligned buffer, we first process the bit from the
>> start to the first aligned address. =A0Once we get to the aligned
>> address everything happens as usual.
>>
>> So where this code is, we're trying to move to the next aligned
>> address, and as ALIGN rounds down, we need to add alignmask.
>> So the bug is the fact that we're adding alignmask - 1.
>=20
> No, ALIGN rounds *up* (as it should). See:

Ah, of course it does.  I've applied your patch.  Thanks a lot!
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
