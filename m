From: austin zhang <austin_zhang@linux.intel.com>
Subject: Re: FW: [Fwd: [PATCH]Using Intel CRC32 instruction to implement
	hardware accelerated CRC32c algorithm.]
Date: Tue, 08 Jul 2008 06:25:54 -0400
Message-ID: <1215512754.2906.23.camel@localhost.localdomain>
References: <000901c8e0d4$6f5cf230$7fb410ac@ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: davem@davemloft.net, chaapala@cisco.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	arjan@linux.intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:54537 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750717AbYGHK0W (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Jul 2008 06:26:22 -0400
In-Reply-To: <000901c8e0d4$6f5cf230$7fb410ac@ccr.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thanks, =EF=BB=BFHerbert, see my reply as below.
> 1) Utilise the brand new crypto ahash interface (note that it's
=EF=BB=BFWhen you mentioned ahash, can you give a explanation on it?=20
The brand new crypto interface is different with crypto/api?
> designed to support sync just as well as async despite the name)
=EF=BB=BFDo you mean use async_xxx interface?
> to rewrite the crypto/crc32c implementation such that one tfm can
> be used by multiple users.  All that has to be done is to move
> the state from the tfm into the request object.
=20
> 2) Convert all crc32c users to use the crypto interface and phase
> out lib/crc32c completely.
>=20
> 3) Add the Intel-specific crc32c implementation through the crypto
> API.
Agreed. And which module in crypto is the template for following the cr=
ypto API?

> That way none of this iffy testing will be necessary.  Even better,
> most users can share one common tfm and therefore there will only
> be one test for the CPU flag at boot time rather than every time
> it's used.
>=20
> In fact, we could even skip 2) and reimplement lib/crc32c as a
> wrapper on the crypto crc32c interface with a shared tfm so you
> don't need to modify its existing users.
Good idea.
> Cheers,

--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
