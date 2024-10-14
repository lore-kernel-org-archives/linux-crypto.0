Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AD71CF2AF
	for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2024 22:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.58.85.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728945174; cv=none; b=BJirKk+5CrJSazV44PhId5xQ9X77LmzTyiZNklOhG7sxirsBRXgM533R4p3Wtf2Iearj2cLuV3FYM0p2qPuDOGIZeXlHedaRXdpD/GDCzYBOGg/EeCmmznLPG0knitAZVQPkkpHevsSzhhPu9+4+Rj8GEfbz7koi/2JgTPGX6fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728945174; c=relaxed/simple;
	bh=lOgJFq0LLEJA0XwyBLiDDV1tjkLg9QoAS9sBzOHo3SU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=llusKAwsSmRiPqYz+k1O5aXJTp/DYjfFGSYrP1oZJYzbhtsnP+8LuX7k9oJmH60KT/O1+P1sfx/GrgLbFtZjoGMX4kURYRke10ph+OxtWZfWWKu7YtxPYDxkAfcQ2x00d2OI9VMCpJ3AeGG6tUsUxlEPAaQWrrTDWwwjPOKtoko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM; spf=pass smtp.mailfrom=aculab.com; arc=none smtp.client-ip=185.58.85.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aculab.com
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-248-g4t_2AaNPGeNePHQ-LTnjg-1; Mon, 14 Oct 2024 23:32:49 +0100
X-MC-Unique: g4t_2AaNPGeNePHQ-LTnjg-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 14 Oct
 2024 23:32:48 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Mon, 14 Oct 2024 23:32:48 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'Eric Biggers' <ebiggers@kernel.org>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Ard Biesheuvel <ardb@kernel.org>, "Josh
 Poimboeuf" <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: RE: [PATCH 3/3] crypto: x86/crc32c - eliminate jump table and
 excessive unrolling
Thread-Topic: [PATCH 3/3] crypto: x86/crc32c - eliminate jump table and
 excessive unrolling
Thread-Index: AQHbHfE2Of1hyBaCckeJTHnfIiWE7LKGaWewgAAg9QCAADe7IA==
Date: Mon, 14 Oct 2024 22:32:48 +0000
Message-ID: <00c9c7c84e9043689942fc1f36e28591@AcuMS.aculab.com>
References: <20241014042447.50197-1-ebiggers@kernel.org>
 <20241014042447.50197-4-ebiggers@kernel.org>
 <a6c0c04a0486404ca4db3fd57a809d5b@AcuMS.aculab.com>
 <20241014190142.GA1137@sol.localdomain>
In-Reply-To: <20241014190142.GA1137@sol.localdomain>
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

...
> > Do you need to unroll it at all?

> It looks like on most CPUs, no.  On Haswell, Emerald Rapids, Zen 2 it doe=
s not
> make a significant difference.  However, it helps on Zen 5.

I wonder if one of the loop instructions is using the ALU
unit you really want to be processing a crc32?
If the cpu has fused arithmetic+jump u-ops then trying to get the
decoder to use one of those may help.

Is Zen 5 actually slower than the other systems?
I've managed to get clock cycle counts using the performance counters
that more of less match the predicted values.
You can't use 'rdtsc' because the cpu frequence isn't stable.

...
> > If you are really lucky you'll get two memory reads/clock.
> > So you won't ever to do than two crc32/clock.
> > Looking at Agner's instruction latency tables I don't think
> > any cpu can do more that one per clock, or pipeline them.
> > I think that means you don't even need two (never mind 3)
> > buffers.
>=20
> On most Intel and AMD CPUs (I tested Haswell for old Intel, Emerald Rapid=
s for
> new Intel, and Zen 2 for slightly-old AMD), crc32q has 3 cycle latency an=
d 1 per
> cycle throughput.  So you do need at least 3 streams.

Bah, I missed the latency column :-)

> AMD Zen 5 has much higher crc32q throughput and seems to want up to 7 str=
eams.
> This is not implemented yet.

The copy of the tables I have is old - doesn't contain Zen-5.
Does that mean that 2 (or more) of its alu 'units' can do crc32
so you can do more than 1/clock (along with the memory reads).

One thought is how much of it is actually worth while!
If the data isn't already in the L1 data cache then the cache
loads almost certainly dominate - especially if you have to
do out to 'real memory'.
You can benchmark the loops by repeatedly accessing the same
data - but that isn't what will actually happen.

> > Most modern x86 can do 4 or 5 (or even more) ALU operations
> > per clock - depending on the combination of instructions.
> >
> > Replace the loop termination with a comparison of 'bufp'
> > against a pre-calculated limit and you get two instructions
> > (that might get merged into one u-op) for the loop overhead.
> > They'll run in parallel with the crc32q instructions.
>=20
> That's actually still three instructions: add, cmp, and jne.

I was really thinking of the loop I quoted later.
The one that uses negative offsets from the end of the buffer.
That has an 'add' and a 'jnz' - which might even fuse into a
single u-op.
Maybe even constrained to p6 - so won't go near p1.
(I don't have a recent AMD cpu)

It may not actually matter.
The add/subtract/cmp are only dependant on themselves.
Similarly the jne is only dependant on the result of the sub/cmp.
In principle they can all run in the same clock (for different
loop cycles) since the rest of the loop only needs one of the
ALU blocks (on Intel only P1 can do crc).
But I failed to get a 1 clock loop (using ADC - which doesn't
have a latency issue).
It might be impossible because a predicted-taken conditional jmp
has a latency of 2.

> I tried it on both Intel and AMD, and it did not help.
>=20
> > I've never managed to get a 1-clock loop, but two is easy.
> > You might find that just:
> > 10:
> > =09crc32q=09(bufp), crc
> > =09crc32q=098(bufp), crc
> > =09add=09=09$16, bufp
> > =09cmp=09=09bufp, buf_lim
> > =09jne=09=0910b
> > will run at 8 bytes/clock on modern intel cpu.
>=20
> No, the latency of crc32q is still three cycles.  You need three streams.

If you need three streams to get one crc32/clock then, in theory,
you can get two more simple ALU ops, at least one memory read and
a jump in every clock - even on Sandy bridge.
So they are unlikely to dominate the loop whatever you do.

If the loop is too long you can get a stall (probably) because a register
has to be read back from the real register file and not just forwarded
from a previous use/alu result.
I've gained a clock back by adding an extra instruction in the middle
of a loop!
But the not-unrolled (multi-stream) loop isn't long enough for that
to be an issue.

Enough rambling.

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

