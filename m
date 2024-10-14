Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259591ABEC9
	for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2024 16:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.58.86.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728923411; cv=none; b=dX7OkXOtav35PUgGcfi/EppBMvZ5hjDfrOVnZZVPjK4enflewnVu6HtTq/ikR5mt/5VLiXGB31WD7Y84IsTNkl0Jo/jE+vR+B6v1NRh+ayRfEKO6t52ft7zGTVsWzVhBhFxh60Ye/SyQLXqVUfZzrgXsfx6QVkJIRQGQ7PBOiCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728923411; c=relaxed/simple;
	bh=MqDoa+aWbGkHWUz7ay7S+ulaBshn9RyOgsYiphaQi5U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=fLXYsZcRci51PgGEJ9kEbvxkoNvb1Z/MurBL8VBbW+DfiwzFmmOqoPpd10CwCh1Tp/s6IO7oQ+zMxL6gXrfVBSAZlVSczdAMjUuqXioHT4VX+Tcu25i6XAsk0uEAblj/yer8t2YPbbap4qLYgvnrFVZ5jwJp4sLAF8nXxhsX7/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM; spf=pass smtp.mailfrom=aculab.com; arc=none smtp.client-ip=185.58.86.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aculab.com
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-215-SbgoJqXHMQafOzomsgtOvQ-1; Mon, 14 Oct 2024 17:30:06 +0100
X-MC-Unique: SbgoJqXHMQafOzomsgtOvQ-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 14 Oct
 2024 17:30:05 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Mon, 14 Oct 2024 17:30:05 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'Eric Biggers' <ebiggers@kernel.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Ard Biesheuvel <ardb@kernel.org>, "Josh
 Poimboeuf" <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: RE: [PATCH 3/3] crypto: x86/crc32c - eliminate jump table and
 excessive unrolling
Thread-Topic: [PATCH 3/3] crypto: x86/crc32c - eliminate jump table and
 excessive unrolling
Thread-Index: AQHbHfE2Of1hyBaCckeJTHnfIiWE7LKGaWew
Date: Mon, 14 Oct 2024 16:30:05 +0000
Message-ID: <a6c0c04a0486404ca4db3fd57a809d5b@AcuMS.aculab.com>
References: <20241014042447.50197-1-ebiggers@kernel.org>
 <20241014042447.50197-4-ebiggers@kernel.org>
In-Reply-To: <20241014042447.50197-4-ebiggers@kernel.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Eric Biggers
> Sent: 14 October 2024 05:25
>=20
> crc32c-pcl-intel-asm_64.S has a loop with 1 to 127 iterations fully
> unrolled and uses a jump table to jump into the correct location.  This
> optimization is misguided, as it bloats the binary code size and
> introduces an indirect call.  x86_64 CPUs can predict loops well, so it
> is fine to just use a loop instead.  Loop bookkeeping instructions can
> compete with the crc instructions for the ALUs, but this is easily
> mitigated by unrolling the loop by a smaller amount, such as 4 times.

Do you need to unroll it at all?

...
> +=09# Unroll the loop by a factor of 4 to reduce the overhead of the loop
> +=09# bookkeeping instructions, which can compete with crc32q for the ALU=
s.
> +.Lcrc_3lanes_4x_loop:
> +=09crc32q=09(bufp), crc_init_q
> +=09crc32q=09(bufp,chunk_bytes_q), crc1
> +=09crc32q=09(bufp,chunk_bytes_q,2), crc2
> +=09crc32q=098(bufp), crc_init_q
> +=09crc32q=098(bufp,chunk_bytes_q), crc1
> +=09crc32q=098(bufp,chunk_bytes_q,2), crc2
> +=09crc32q=0916(bufp), crc_init_q
> +=09crc32q=0916(bufp,chunk_bytes_q), crc1
> +=09crc32q=0916(bufp,chunk_bytes_q,2), crc2
> +=09crc32q=0924(bufp), crc_init_q
> +=09crc32q=0924(bufp,chunk_bytes_q), crc1
> +=09crc32q=0924(bufp,chunk_bytes_q,2), crc2
> +=09add=09$32, bufp
> +=09sub=09$4, %eax
> +=09jge=09.Lcrc_3lanes_4x_loop

If you are really lucky you'll get two memory reads/clock.
So you won't ever to do than two crc32/clock.
Looking at Agner's instruction latency tables I don't think
any cpu can do more that one per clock, or pipeline them.
I think that means you don't even need two (never mind 3)
buffers.

Most modern x86 can do 4 or 5 (or even more) ALU operations
per clock - depending on the combination of instructions.

Replace the loop termination with a comparison of 'bufp'
against a pre-calculated limit and you get two instructions
(that might get merged into one u-op) for the loop overhead.
They'll run in parallel with the crc32q instructions.

I've never managed to get a 1-clock loop, but two is easy.
You might find that just:
10:
=09crc32q=09(bufp), crc
=09crc32q=098(bufp), crc
=09add=09=09$16, bufp
=09cmp=09=09bufp, buf_lim
=09jne=09=0910b
will run at 8 bytes/clock on modern intel cpu.
You can write that in C with a simple asm function for the crc32
instruction itself.

You might need the more complex to setup loop:
=09offset =3D -length;
=09bufend =3D buf + length;
10:
=09crc32q=09(offset, bufend), crc
=09crc32q=098(offset, bufend), crc
=09add=09=09&16, offset
=09jne=09=0910b
which uses negative offsets from the end of the buffer.

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

