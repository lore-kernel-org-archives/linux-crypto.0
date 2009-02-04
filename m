From: Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH 2/3] crypto: Per-CPU cryptd thread implementation based
	on kcrypto_wq
Date: Wed, 04 Feb 2009 09:07:58 +0800
Message-ID: <1233709678.19806.107.camel@yhuang-dev.sh.intel.com>
References: <1233556940.19806.58.camel@yhuang-dev.sh.intel.com>
	 <20090203011038.c12acc5b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ji3+Qr3cN5SAwqAHIuLy"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19994 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbZBDBIB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Feb 2009 20:08:01 -0500
In-Reply-To: <20090203011038.c12acc5b.akpm@linux-foundation.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-Ji3+Qr3cN5SAwqAHIuLy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-02-03 at 17:10 +0800, Andrew Morton wrote:
> On Mon, 02 Feb 2009 14:42:20 +0800 Huang Ying <ying.huang@intel.com> wrot=
e:
>=20
> > Original cryptd thread implementation has scalability issue, this
> > patch solve the issue with a per-CPU thread implementation.
> >=20
> > struct cryptd_queue is defined to be a per-CPU queue, which holds one
> > struct cryptd_cpu_queue for each CPU. In struct cryptd_cpu_queue, a
> > struct crypto_queue holds all requests for the CPU, a struct
> > work_struct is used to run all requests for the CPU.
> >=20
> > ...
> >
> > +int cryptd_init_queue(struct cryptd_queue *queue, unsigned int max_cpu=
_qlen)
> > +{
> > +	int cpu;
> > +	struct cryptd_cpu_queue *cpu_queue;
> > +
> > +	queue->cpu_queue =3D alloc_percpu(struct cryptd_cpu_queue);
> > +	if (!queue->cpu_queue)
> > +		return -ENOMEM;
> > +	for_each_possible_cpu(cpu) {
> > +		cpu_queue =3D per_cpu_ptr(queue->cpu_queue, cpu);
> > +		crypto_init_queue(&cpu_queue->queue, max_cpu_qlen);
> > +		INIT_WORK(&cpu_queue->work, cryptd_queue_worker);
> > +	}
> > +	return 0;
> > +}
>=20
> Could be made static, I believe.

OK. I will make it static.

> > +void cryptd_fini_queue(struct cryptd_queue *queue)
> > +{
> > +	int cpu;
> > +	struct cryptd_cpu_queue *cpu_queue;
> > +
> > +	for_each_possible_cpu(cpu) {
> > +		cpu_queue =3D per_cpu_ptr(queue->cpu_queue, cpu);
> > +		BUG_ON(cpu_queue->queue.qlen);
> > +	}
> > +	free_percpu(queue->cpu_queue);
> > +}
>=20
> Ditto.

As above.

> > +int cryptd_enqueue_request(struct cryptd_queue *queue,
> > +			   struct crypto_async_request *request)
> > +{
> > +	int cpu, err;
> > +	struct cryptd_cpu_queue *cpu_queue;
> > +
> > +	cpu =3D get_cpu();
> > +	cpu_queue =3D per_cpu_ptr(queue->cpu_queue, cpu);
> > +	err =3D crypto_enqueue_request(&cpu_queue->queue, request);
> > +	queue_work_on(cpu, kcrypto_wq, &cpu_queue->work);
> > +	put_cpu();
> > +
> > +	return err;
> > +}
>=20
> Ditto?

As above.

> > +static void cryptd_queue_worker(struct work_struct *work)
>=20
> A few comments explaining the code wouldn't kill us...

OK. I will add some comments. This the function for work_struct in
cryptd_cpu_queue, it does real encryption/decryption.

> > +{
> > +	struct cryptd_cpu_queue *cpu_queue;
> > +	struct crypto_async_request *req, *backlog;
> > +
> > +	cpu_queue =3D container_of(work, struct cryptd_cpu_queue, work);
> > +	/* Only handle one request at a time to avoid hogging crypto
> > +	 * workqueue */
>=20
> Not sure what that means.

cryptd is not the only user of kcrypto_wq (now, chainiv uses it too),
and there may be a lot of requests in cryptd_cpu_queue, to reduce the
latency of other kcrypto_wq user, only one request is processed in
work_struct function, then the work_struct will be inserted again.

> > +	preempt_disable();
> > +	backlog =3D crypto_get_backlog(&cpu_queue->queue);
> > +	req =3D crypto_dequeue_request(&cpu_queue->queue);
> > +	preempt_enable();
>=20
> This function is run by a per-cpu thread, so it cannot be migrated to
> another CPU by the CPU scheduler.
>=20
> It is quite unclear what this preempt_disable() is needed for.  Please
> either remove it or provide adequate comments.

preempt_disable is used to protect cpu_queue->queue. It can be accessed
by cryptd_enqueue_request(). When cryptd_queue_worker() is running, it
can be preempted by cryptd_enqueue_request() on same CPU.

> > +	if (!req)
> > +		goto out;
> > +
> > +	if (backlog)
> > +		backlog->complete(backlog, -EINPROGRESS);
> > +	req->complete(req, 0);
> > +out:
> > +	if (cpu_queue->queue.qlen)
> > +		queue_work(kcrypto_wq, &cpu_queue->work);
>=20
> Again, unclear and needs commentary.
>=20
> If we come here via the `goto out;' path above, this CPU queue has no
> more work do do, I think?  If so, why does it requeue itself?

If there is no more work to do, the cpu_queue->queue.qlen will be zero,
so it will not request itself. If we come here via another path, we may
need do that.

Best Regards,
Huang Ying


--=-Ji3+Qr3cN5SAwqAHIuLy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmI6msACgkQKhFGF+eHlpg6NwCeJhhegxuWo9NpsJZY5Y8PK3ik
e+MAoJnd+vfOFsXgiKXOnqNTmEQHHsG8
=N+UC
-----END PGP SIGNATURE-----

--=-Ji3+Qr3cN5SAwqAHIuLy--

