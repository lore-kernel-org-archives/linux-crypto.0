From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: hash - Fix handling of small unaligned buffers
Date: Wed, 04 Aug 2010 13:59:55 -0700 (PDT)
Message-ID: <20100804.135955.232723581.davem@davemloft.net>
References: <AANLkTinj0tPGa1ZVEs2JZ1Hvg9YOq7qx56LZJrOs4WPc@mail.gmail.com>
	<20100804134851.GA3884@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: slipszi@gmail.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35201
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758588Ab0HDU7h convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 Aug 2010 16:59:37 -0400
In-Reply-To: <20100804134851.GA3884@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 4 Aug 2010 21:48:51 +0800

> On Mon, Aug 02, 2010 at 02:45:37PM +0200, Szilveszter =D6rd=F6g wrote=
:
>> If a scatterwalk chain contains an entry with an unaligned offset th=
en
>> hash_walk_next() will cut off the next step at the next alignment po=
int.
>>=20
>> However, if the entry ends before the next alignment point then we w=
ill want to
>> process more data than it is available.
>>=20
>> Fix this by checking whether the next aligment point is before the e=
nd of the
>> current entry.
>> ---
>>  crypto/ahash.c |    7 +++++--
>>  1 files changed, 5 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/crypto/ahash.c b/crypto/ahash.c
>> index b8c59b8..f669822 100644
>> --- a/crypto/ahash.c
>> +++ b/crypto/ahash.c
>> @@ -47,8 +47,11 @@ static int hash_walk_next(struct crypto_hash_walk=
 *walk)
>>  	walk->data =3D crypto_kmap(walk->pg, 0);
>>  	walk->data +=3D offset;
>>=20
>> -	if (offset & alignmask)
>> -		nbytes =3D alignmask + 1 - (offset & alignmask);
>> +	if (offset & alignmask) {
>> +		unsigned int unaligned =3D alignmask + 1 - (offset & alignmask);
>> +		if (nbytes > unaligned)
>> +			nbytes =3D unaligned;
>> +	}
>>=20
>>  	walk->entrylen -=3D nbytes;
>>  	return nbytes;
>=20
> The patch looks OK to me.  Dave, what do you think?

Looks good, thanks Szilveszter:

Acked-by: David S. Miller <davem@davemloft.net>
