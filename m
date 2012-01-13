From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: RE: sha512: make it work, undo percpu message schedule
Date: Fri, 13 Jan 2012 13:35:24 +0100
Message-ID: <1326458124.3826.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <AE90C24D6B3A694183C094C60CF0A2F6D8AF42@saturn3.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
	ken@codelabs.ch, Steffen Klassert <steffen.klassert@secunet.com>
To: David Laight <David.Laight@ACULAB.COM>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39997 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab2AMMf2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Jan 2012 07:35:28 -0500
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8AF42@saturn3.aculab.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Le vendredi 13 janvier 2012 =C3=A0 11:45 +0000, David Laight a =C3=A9cr=
it :
> > Trying a dynamic memory allocation, and fallback on a single
> > pre-allocated bloc of memory, shared by all cpus, protected by a
> > spinlock
> ...
> > -
> > +	static u64 msg_schedule[80];
> > +	static DEFINE_SPINLOCK(msg_schedule_lock);
> >  	int i;
> > -	u64 *W =3D get_cpu_var(msg_schedule);
> > +	u64 *W =3D kzalloc(sizeof(msg_schedule), GFP_ATOMIC |
> __GFP_NOWARN);
> > =20
> > +=09
> > +	if (!W) {
> > +		spin_lock_bh(&msg_schedule_lock);
> > +		W =3D msg_schedule;
> > +	}
>=20
> If this code can be called from an ISR is the kmalloc()
> call safe?
>=20

Yes, obviously, kmalloc() is IRQ safe.

> If the above is safe, wouldn't it be better to:
> 1) try to use the static buffer
> 2) try to kalloc() a buffer
> 3) spinwait for the static buffer to be free
>=20

No idea of what you mean, and why you think its better.

kmalloc() propably can give us a block already hot in cpu cache.
