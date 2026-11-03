Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793684549;
	b=wIpeiZvgAYIC54VZchCxui9CwcOQXsnVM9EYMwGpes56o6sOkInzxCCuCb1xCL51JkeT
	 QtUPc+V0j8VnjU2UPMeMmMsy3K9zT++pHfcl0aAep2WIVWgwOpOjwxlENGNigR0a78aho
	 rGO+wRYScdk3VucZzIuWRUtVwFvQMpVuRZLoGuUEEGp5pnKZNv49bsRVnEORrrlKEfU8B
	 Q0n0cgYhnpe1z/HfwjdrYoH19fAC07QLhZxAEiXLvhFhwlaHKIG9Ifj47BEKCqOVksyLM
	 yZtzBVyJEZwcgvXF6uKXQg7jGpLEvi/v7RGLbGIRdWXeFKkmxmJYtZL3PffjugMF9oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793684549;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2Cc3lUsEZk3MtA6YpJGPw70qiv6UnPpXc1c/VsAmgHc=;
	b=BwISQTt6BXuxwTAKLoaGLBB4hf2xtYAcNd58ubjO1DZBCz7EwIY9t7YkmIbWnBRCB27+
	 cIEMyqjxAGBOnLZBZMiDUbizPmTxmo7yGluPKxtiVuASEm6l5UBcHmGQevy8G4Et3s5F8
	 yvlHdLqbmvHDWfy/jn0m9cIL8cMuWXno7WVa+frLxrAYjRsYERsbeZrIszmA7cA555YTf
	 Kg1X9JXNYr103qUJUSHa0xoIoCVZKpQniC1+lJ2q8l2Yf0uxE86os3YRJWEOrSoRpk1pd
	 o5A/Eg4/86NbgBemAZpn+8Uxu24hoMg80+C/IdA+iWjilEaduRMVYEd20fBU3VhJQ6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RxVNadAq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1768606A324
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 05:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RxVNadAq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C7C1F000C1;
	Tue,  3 Nov 2026 05:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793684548;
	bh=2Cc3lUsEZk3MtA6YpJGPw70qiv6UnPpXc1c/VsAmgHc=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=RxVNadAqou4AbPg/M1k93b4cm41GnUUU5xjfbHkWjY3Qc1CKMoXqhdo0z3NYRjum+
	 V2Rsk9WGOgaH84uUJwcDrYeT394X8dGDvjp6a87b59h4wXs1Q+EXg6rgMK0ypyPmOw
	 g+zsJPZHF3vdDCcH5HO3m2l0aMKiCQF4ZToIJjf4MdZwhCK/XRHcSHxT5vSwm6QWMK
	 kanrBuvgYpIHv7X2IuIlEbtzeLHv4Ictn8rLFKJ6zS04izr4ayUa6E0yK81h8hfp6l
	 vrlLWlmuvGQlJuSseootw46gFM3JLxKNQssA8SxhEqwCgZunUZxE8iRNVA9SEhAWlt
	 nOg0/jYZ25PUw==
Message-ID: <sashiko-outbox-194595@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 1/1] mm: zswap: Move the crypto_acomp to be per pool,
 instead of per-CPU.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
In-Reply-To: <20261103000313.13677-1-kanchanapsridhar2026@gmail.com>
References: <20261103000313.13677-1-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 05:42:27 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm: zswap: per-pool crypto_alloc_acomp() breaks NUMA and HW queu=
e scaling
--

commit 0abfb2c1c527ffcd5ca8df2224cd1c4533f5face
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

mm: zswap: Move the crypto_acomp to be per pool, instead of per-CPU.

This commit moves the struct crypto_acomp instance from the per-CPU struct
crypto_acomp_ctx into the global struct zswap_pool, allocating a single
transform per pool in zswap_pool_create() instead of allocating one per CPU
in zswap_cpu_comp_prepare().

> diff --git a/mm/zswap.c b/mm/zswap.c
> index 37d217860a6b2..a958b74d4425d 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c

[ ... ]

> @@ -323,6 +313,17 @@ static struct zswap_pool *zswap_pool_create(char *co=
mpressor)
> =20
>  	strscpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
> =20
> +	/*
> +	 * In case of an error, crypto_alloc_acomp() returns an
> +	 * error pointer, never NULL.
> +	 */
> +	pool->acomp =3D crypto_alloc_acomp(pool->tfm_name, 0, 0);
> +	if (IS_ERR(pool->acomp)) {
> +		pr_err("could not alloc crypto acomp %s : %pe\n",
> +			pool->tfm_name, pool->acomp);
> +		goto error;
> +	}

[ ... ]

> @@ -841,34 +857,20 @@ static int zswap_cpu_comp_prepare(unsigned int cpu,=
 struct hlist_node *node)
>  	 * To handle cases where the CPU goes through online-offline-online
>  	 * transitions, we return if the acomp_ctx has already been initialized.
>  	 */
> -	if (acomp_ctx->acomp) {
> -		WARN_ON_ONCE(IS_ERR(acomp_ctx->acomp));
> +	if (acomp_ctx->comp.areq.req)
>  		return 0;
> -	}
> =20
>  	acomp_ctx->comp.buffer =3D kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_n=
ode(cpu));
>  	if (!acomp_ctx->comp.buffer)
>  		return ret;
> =20
> -	/*
> -	 * In case of an error, crypto_alloc_acomp_node() returns an
> -	 * error pointer, never NULL.
> -	 */
> -	acomp_ctx->acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_=
to_node(cpu));
> -	if (IS_ERR(acomp_ctx->acomp)) {
> -		pr_err("could not alloc crypto acomp %s : %pe\n",
> -				pool->tfm_name, acomp_ctx->acomp);
> -		ret =3D PTR_ERR(acomp_ctx->acomp);
> -		goto fail;
> -	}
> -
> -	ret =3D zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp);
> +	ret =3D zswap_acomp_req_init(&acomp_ctx->comp.areq, pool->acomp);

[Severity: Medium]
Does replacing the per-CPU crypto_alloc_acomp_node() call in
zswap_cpu_comp_prepare() with a single non-NUMA-aware crypto_alloc_acomp()
call in zswap_pool_create() cause a NUMA locality and hardware queue scaling
regression for hardware compression accelerators?

Previously, commits 7bc13b5b60e9 and 1ec3b5fe6eec allocated a dedicated
struct crypto_acomp per CPU on cpu_to_node(cpu) so that hardware compression
drivers would allocate per-CPU, NUMA-local hardware queues.

While software scomp backends and Intel IAA select per-CPU streams or
workqueues at request submission time, other hardware acomp drivers bind
hardware queues, rings, and NUMA-local accelerator devices to the struct
crypto_acomp transform during initialization based on the transform's node.

For example, in drivers/crypto/hisilicon/zip/zip_crypto.c,
hisi_zip_acomp_init() allocates one compression queue pair, one
decompression queue pair, and a per-transform request queue and spinlock on
tfm->base.node:

drivers/crypto/hisilicon/zip/zip_crypto.c:hisi_zip_acomp_init() {
	...
	ret =3D hisi_zip_ctx_init(ctx, COMP_NAME_TO_TYPE(alg_name), tfm->base.node=
);
	...
	ret =3D hisi_zip_create_req_q(ctx);
	...
}

Similarly, in drivers/crypto/intel/qat/qat_common/qat_comp_algs.c,
qat_comp_alg_init_tfm() binds the transform to a single hardware compression
ring pair on tfm->node:

drivers/crypto/intel/qat/qat_common/qat_comp_algs.c:qat_comp_alg_init_tfm()=
 {
	...
	inst =3D qat_compression_get_instance_node(node, alg);
	if (!inst)
		return -EINVAL;
	ctx->inst =3D inst;
	...
}

With a single pool->acomp allocated via crypto_alloc_acomp() (passing
NUMA_NO_NODE), won't all CPUs across all NUMA nodes share and contend on a
single hardware queue or ring pair on one accelerator device while leaving
all other hardware queues and NUMA-local devices unused?

Also, if pool->acomp is shared across all CPUs, should the comment in
zswap_compress() be updated as well? It currently still states:

mm/zswap.c:zswap_compress() {
	...
	 * but in different threads running on different cpu, we have different
	 * acomp instance, and compression and decompression use separate
	 * requests, so multiple threads can do (de)compression in parallel.
	 */
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103000313.1367=
7-1-kanchanapsridhar2026@gmail.com?part=3D1
