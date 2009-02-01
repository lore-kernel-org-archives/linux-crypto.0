From: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC] per-CPU cryptd thread implementation based on workqueue
Date: Sun, 01 Feb 2009 17:37:06 +0800
Message-ID: <1233481026.19806.12.camel@yhuang-dev.sh.intel.com>
References: <1232075437.13948.12.camel@yhuang-dev.sh.intel.com>
	 <20090116033105.GB10390@gondor.apana.org.au>
	 <1232591537.6101.3.camel@yhuang-dev.sh.intel.com>
	 <20090123230706.4c8ae0ea.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-k1DWqKDwWs+H5IFg47i5"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32309 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbZBAJhT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 Feb 2009 04:37:19 -0500
In-Reply-To: <20090123230706.4c8ae0ea.akpm@linux-foundation.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-k1DWqKDwWs+H5IFg47i5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Sorry for my late. Last week is Chinese new year holiday.

On Sat, 2009-01-24 at 15:07 +0800, Andrew Morton wrote:
> On Thu, 22 Jan 2009 10:32:17 +0800 Huang Ying <ying.huang@intel.com> wrot=
e:
>=20
> > Use dedicate workqueue for crypto
> >=20
> > - A dedicated workqueue named kcrypto_wq is created.
> >=20
> > - chainiv uses kcrypto_wq instead of keventd_wq.
> >=20
> > - For cryptd, struct cryptd_queue is defined to be a per-CPU queue,
> >   which holds one struct cryptd_cpu_queue for each CPU. In struct
> >   cryptd_cpu_queue, a struct crypto_queue holds all requests for the
> >   CPU, a struct work_struct is used to run all requests for the CPU.
> >=20
>=20
> Please always prefer to include performance measurements when proposing
> a performance-enhancing patch.  Otherwise we have no basis upon which
> to evaluate the patch's worth.

I will setup a testing to measure the performance gain.

> > +++ b/crypto/crypto_wq.c
> > @@ -0,0 +1,39 @@
> > +/*
> > + * Workqueue for crypto subsystem
> > + *
> > + * Copyright (c) 2009 Intel Corp.
> > + *   Author: Huang Ying <ying.huang@intel.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modif=
y it
> > + * under the terms of the GNU General Public License as published by t=
he Free
> > + * Software Foundation; either version 2 of the License, or (at your o=
ption)
> > + * any later version.
> > + *
> > + */
> > +
> > +#include <linux/workqueue.h>
> > +#include <crypto/algapi.h>
> > +#include <crypto/crypto_wq.h>
> > +
> > +struct workqueue_struct *kcrypto_wq;
> > +EXPORT_SYMBOL_GPL(kcrypto_wq);
> > +
> > +static int __init crypto_wq_init(void)
> > +{
> > +	kcrypto_wq =3D create_workqueue("crypto");
> > +	if (unlikely(!kcrypto_wq))
> > +		return -ENOMEM;
> > +	return 0;
> > +}
> > +
> > +static void __exit crypto_wq_exit(void)
> > +{
> > +	if (likely(kcrypto_wq))
> > +		destroy_workqueue(kcrypto_wq);
>=20
> I don't believe that it is possible to get here with kcrypto_wq=3D=3DNULL=
.

Yes. I will fix this.

> >
> > ...
> >
> > +int cryptd_enqueue_request(struct cryptd_queue *queue,
> > +			   struct crypto_async_request *request)
> > +{
> > +	int cpu, err, queued;
> > +	struct cryptd_cpu_queue *cpu_queue;
> > +
> > +	cpu =3D get_cpu();
> > +	cpu_queue =3D per_cpu_ptr(queue->cpu_queue, cpu);
> > +	spin_lock_bh(&cpu_queue->lock);
> > +	err =3D crypto_enqueue_request(&cpu_queue->queue, request);
> > +	spin_unlock_bh(&cpu_queue->lock);
> > +	/* INUSE should be set after queue->qlen assigned, but
> > +	 * spin_unlock_bh imply a memory barrior already */
> > +	if (!test_and_set_bit_lock(CRYPTD_STATE_INUSE, &cpu_queue->state)) {
> > +		queued =3D queue_work(kcrypto_wq, &cpu_queue->work);
> > +		BUG_ON(!queued);
> > +	}
>=20
> Do we actually need to use CRYPTD_STATE_INUSE here?  The
> WORK_STRUCT_PENDING handling in the workqueue does basically the same
> thing?

Yes. It is not necessary, I will fix this.

> > +	put_cpu();
> > +
> > +	return err;
> > +}
> > +
> > +int cryptd_tfm_in_queue(struct cryptd_queue *queue, struct crypto_tfm =
*tfm)
>=20
> Did this need to have global scope?

It should be static. I will fix this.

> > +{
> > +	int cpu, in_queue;
> > +	struct cryptd_cpu_queue *cpu_queue;
> > +
> > +	for_each_possible_cpu(cpu) {
> > +		cpu_queue =3D per_cpu_ptr(queue->cpu_queue, cpu);
> > +		spin_lock_bh(&cpu_queue->lock);
> > +		in_queue =3D crypto_tfm_in_queue(&cpu_queue->queue, tfm);
> > +		spin_unlock_bh(&cpu_queue->lock);
> > +		if (in_queue)
> > +			return 1;
> > +	}
> > +	return 0;
> > +}
>=20
> Did you consider using for_each_online_cpu() and implementing CPU
> hotplug?  There might be situations where the number of possible CPUs
> is much greater than the number of online CPUs.

For cryptd_queue_init() and cryptd_queue_fini(), I think
for_each_possible_cpu() is sufficient and simpler. Because they are only
need to be executed once and in slow path. For cryptd_in_queue,
for_each_online_cpu() can be used.

> > +static void cryptd_queue_work_done(struct cryptd_cpu_queue *cpu_queue)
> > +{
> > +	int queued;
> > +
> > +	if (!cpu_queue->queue.qlen) {
> > +		clear_bit_unlock(CRYPTD_STATE_INUSE, &cpu_queue->state);
> > +		/* queue.qlen must be checked after INUSE bit cleared */
> > +		smp_mb();
> > +		if (!cpu_queue->queue.qlen ||
> > +		    test_and_set_bit_lock(CRYPTD_STATE_INUSE,
> > +					  &cpu_queue->state))
> > +			return;
> > +	}
> > +
> > +	queued =3D queue_work(kcrypto_wq, &cpu_queue->work);
> > +	BUG_ON(!queued);
> > +}
>=20
> It is unclear (to me) why this code is using the special "locked"
> bitops.  This should be explained in a code comment.
>=20
> It isn't immediately clear (to me) what this function does, what its
> role is in the overall scheme.  It wouldn't hurt at all to put a nice
> comment over non-trivial functions explaining such things.

This function is used for CRYPTD_STATE_INUSE logic, because
CRYPTD_STATE_INUSE is not needed, this function is not needed too. Just
calling queue_work() at end of cryptd_queue_work() is sufficient.

> > +static void cryptd_queue_work(struct work_struct *work)
> > +{
> > +	struct cryptd_cpu_queue *cpu_queue =3D
> > +		container_of(work, struct cryptd_cpu_queue, work);
>=20
> You could just do
>=20
> 	struct cryptd_cpu_queue *cpu_queue;
>=20
> 	cpu_queue =3D container_of(work, struct cryptd_cpu_queue, work);
>=20
> rather than uglifying the code to fit in 80-cols.

OK. I will fix this.

Best Regards,
Huang Ying


--=-k1DWqKDwWs+H5IFg47i5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmFbUAACgkQKhFGF+eHlpj/zACeMyxUi6wCHd9ckIxg+7HvFugY
OlsAoKx2z26wKgXQgEEryrM2/mQHoc1u
=atP6
-----END PGP SIGNATURE-----

--=-k1DWqKDwWs+H5IFg47i5--

