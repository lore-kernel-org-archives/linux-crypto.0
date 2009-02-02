From: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC] per-CPU cryptd thread implementation based on workqueue
Date: Mon, 02 Feb 2009 10:59:32 +0800
Message-ID: <1233543572.19806.32.camel@yhuang-dev.sh.intel.com>
References: <1232075437.13948.12.camel@yhuang-dev.sh.intel.com>
	 <20090116033105.GB10390@gondor.apana.org.au>
	 <1232591537.6101.3.camel@yhuang-dev.sh.intel.com>
	 <20090123230706.4c8ae0ea.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-F45DS98ULoQEz3RbYQet"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:57617 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbZBBC7g (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 Feb 2009 21:59:36 -0500
In-Reply-To: <20090123230706.4c8ae0ea.akpm@linux-foundation.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-F45DS98ULoQEz3RbYQet
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I design a performance testing for cryptd with a little modified
dm-crypt. The testing script is as follow:

-------------------- script begin ---------------------------
#!/bin/sh

dmc_create()
{
        # Create a crypt device using dmsetup
        dmsetup create $2 --table "0 `blockdev --getsize $1` crypt cbc(aes-=
asm)?cryptd?plain:plain babebabebabebabebabebabebabebabe 0 $1 0"
}

dmsetup remove crypt0
dmsetup remove crypt1

dd if=3D/dev/zero of=3D/dev/ram0 bs=3D1M count=3D4 >& /dev/null
dd if=3D/dev/zero of=3D/dev/ram1 bs=3D1M count=3D4 >& /dev/null

dmc_create /dev/ram0 crypt0
dmc_create /dev/ram1 crypt1

cat >tr.sh <<EOF
#!/bin/sh

for n in \$(seq 10); do
        dd if=3D/dev/dm-0 of=3D/dev/null >& /dev/null &
        dd if=3D/dev/dm-1 of=3D/dev/null >& /dev/null &
done
wait
EOF

for n in $(seq 10); do
        /usr/bin/time sh tr.sh
done
rm tr.sh
-------------------- script end   ---------------------------

The separator of dm-crypt parameter is changed from "-" to "?", because
"-" is used in some cipher driver name too, and cryptds need to specify
cipher driver name instead of cipher name.

The test result on an Intel Core2 E6400 (two cores) is as follow:

without crypto workqueue patch:
-----------------wo cryptowq begin --------------------------
0.04user 0.38system 0:00.39elapsed 107%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6566minor)pagefaults 0swaps
0.07user 0.35system 0:00.35elapsed 121%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6567minor)pagefaults 0swaps
0.06user 0.34system 0:00.30elapsed 135%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6562minor)pagefaults 0swaps
0.05user 0.37system 0:00.36elapsed 119%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6607minor)pagefaults 0swaps
0.06user 0.36system 0:00.35elapsed 120%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6562minor)pagefaults 0swaps
0.05user 0.37system 0:00.31elapsed 136%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6594minor)pagefaults 0swaps
0.04user 0.34system 0:00.30elapsed 126%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6597minor)pagefaults 0swaps
0.06user 0.32system 0:00.31elapsed 125%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6571minor)pagefaults 0swaps
0.06user 0.34system 0:00.31elapsed 134%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6581minor)pagefaults 0swaps
0.05user 0.38system 0:00.31elapsed 138%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6600minor)pagefaults 0swaps
-----------------wo cryptowq end   --------------------------


with crypto workqueue patch:
------------------w cryptowq begin --------------------------
0.02user 0.31system 0:00.24elapsed 141%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6554minor)pagefaults 0swaps
0.05user 0.34system 0:00.31elapsed 127%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6606minor)pagefaults 0swaps
0.07user 0.33system 0:00.26elapsed 155%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6559minor)pagefaults 0swaps
0.07user 0.32system 0:00.26elapsed 151%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6562minor)pagefaults 0swaps
0.05user 0.34system 0:00.26elapsed 150%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6603minor)pagefaults 0swaps
0.03user 0.36system 0:00.31elapsed 124%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6562minor)pagefaults 0swaps
0.04user 0.35system 0:00.26elapsed 147%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6586minor)pagefaults 0swaps
0.03user 0.37system 0:00.27elapsed 146%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6562minor)pagefaults 0swaps
0.04user 0.36system 0:00.26elapsed 154%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6594minor)pagefaults 0swaps
0.04user 0.35system 0:00.26elapsed 154%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6557minor)pagefaults 0swaps
------------------w cryptowq end   --------------------------

The middle value of elapsed time is:
wo cryptwq: 0.31
w  cryptwq: 0.26

The performance gain is about (0.31-0.26)/0.26 =3D 0.192.

Best Regards,
Huang Ying

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
>=20
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
>=20
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
>=20
> > +	put_cpu();
> > +
> > +	return err;
> > +}
> > +
> > +int cryptd_tfm_in_queue(struct cryptd_queue *queue, struct crypto_tfm =
*tfm)
>=20
> Did this need to have global scope?
>=20
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
>=20
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
>=20
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
>=20
> > +	struct crypto_async_request *req, *backlog;
> > +
> > +	/* Only handle one request at a time to avoid hogging crypto
> > +	 * workqueue */
> > +	spin_lock_bh(&cpu_queue->lock);
> > +	backlog =3D crypto_get_backlog(&cpu_queue->queue);
> > +	req =3D crypto_dequeue_request(&cpu_queue->queue);
> > +	spin_unlock_bh(&cpu_queue->lock);
> > +
> > +	if (!req)
> > +		goto out;
> > +
> > +	if (backlog)
> > +		backlog->complete(backlog, -EINPROGRESS);
> > +	req->complete(req, 0);
> > +out:
> > +	cryptd_queue_work_done(cpu_queue);
> > +}
> > +
> > +static inline struct cryptd_queue *cryptd_get_queue(struct crypto_tfm =
*tfm)
> >  {
> >  	struct crypto_instance *inst =3D crypto_tfm_alg_instance(tfm);
> >  	struct cryptd_instance_ctx *ictx =3D crypto_instance_ctx(inst);
> > -	return ictx->state;
> > +	return ictx->queue;
> >  }
> > =20
> >  static int cryptd_blkcipher_setkey(struct crypto_ablkcipher *parent,
> > @@ -131,19 +248,13 @@ static int cryptd_blkcipher_enqueue(stru
> >  {
> >  	struct cryptd_blkcipher_request_ctx *rctx =3D ablkcipher_request_ctx(=
req);
> >  	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
> > -	struct cryptd_state *state =3D
> > -		cryptd_get_state(crypto_ablkcipher_tfm(tfm));
> > -	int err;
> > +	struct cryptd_queue *queue =3D
> > +		cryptd_get_queue(crypto_ablkcipher_tfm(tfm));
>=20
> ditto
>=20
> >
> > ...
> >
>=20

--=-F45DS98ULoQEz3RbYQet
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmGYZEACgkQKhFGF+eHlphQxQCeJUfsf2Xgbqp2R7ggKA4XmAte
PiQAoIB7mTjH/UR1g0OFSmJe9xAmpEEt
=xVDw
-----END PGP SIGNATURE-----

--=-F45DS98ULoQEz3RbYQet--

