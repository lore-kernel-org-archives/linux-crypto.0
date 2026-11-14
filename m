Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794667954;
	b=dstT1FcMYM/kW/F4ynKYQjTBy2PSSrTbxgFpPt99oKdj5RxtfNiJj9/bjf/j4EHIFi61
	 yqVaFCjzDZ+H8LSc+a5+R688ft7aZ/qh+zTXTSf4T918J/8JCEvX0Lx3ChUe84bgNAY/a
	 tw4HbXRpBoYhfHOeMY2VcUw0xbTD/mobj2di1BIQ5EPV6G+BHsG+uOonolsLVGPxQ7sHo
	 y1qsRTbSVoBSZFzN0r/ejr+VNQKGnB/LRBgJ0mbr41LtFkrQVXlmMDpv2YM2k7jWm8lmu
	 Qxdek0iRNIN+DM6XOQGqhPVMh0VwCfADK+t4Cbohc0Jv2xHKuoB9wNI2DT3QjIxEQfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794667954;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CgPzDjZIzQlgP+XzfyfNhhUFT0mSeXMe9GRt8eeHiBA=;
	b=yZOfmJNf9Qp1TurmQtdhVH5esiMdLca/oKQw0ykDNqLSFePVkQlQBSrgdrVXSMgXE6Zk
	 WhbVq4S0+k59A9c0oHfnhaKcRP5+gKrjNL0j58TDerbD0+Xj9LXZTUhWhx1uzwj7QyjUU
	 U9CuTUpKDcFjPpZlvZzMapzFLGRr9NkHzIgN0ucGPdU9tX2Dda+6iinqzajU3Dsclyfrr
	 IV+YjLG/mc8TxqJCL3FAzKP2qslurtUMqJs688KVtQrlZo66oiBfE7bLLa/CTEfGa9UOC
	 zm0RY27ouHP/rVY+Wyhp8RwfHUnHmkZcdSKkkl/dnN47ycVPHaNmacC/9x70SDdTjUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bqraCl2+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C01606A334;
	Sat, 14 Nov 2026 14:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bqraCl2+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4694E1F000CC;
	Sat, 14 Nov 2026 14:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794667954;
	bh=CgPzDjZIzQlgP+XzfyfNhhUFT0mSeXMe9GRt8eeHiBA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bqraCl2+o4SaEbTGtrfxxhMB1hxwzcbYRd9ZM0IbgjDU48xtDgHlc9HqjfZSA8P7M
	 sGNdxS7dblE4PuD2HrCNCofccduXVs7SzYnzBdvP2VD0wdKcMZEJgGUsSMNuuTLW9m
	 cR2KlniMn886XMRfOCRAIqIyoj3Z+RWqHZvsLuPSGk5jfoBEtSPVB7hVc+7Pn6qYdq
	 w4+kL8Lu13OE+wfd+5F141+FccXrQYMouf5VYCtNQS3eGU5otacbQzXKwlCjYpesfj
	 N6yxhJENI82fB4nsJLDf2q7YRqVdTVjteJmyyIwmiz99ySFmrw78ut1gT17xV6kadZ
	 atVeuk8VBKfug==
Message-ID: <sashiko-outbox-214649@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v29 2/4] crypto: spacc - Add SPAcc ahash support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pavitrakumar Managutte" <pavitrakumarm@vayavyalabs.com>, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, herbert@gondor.apana.org.au, robh@kernel.org
Cc: krzk@kernel.org, conor+dt@kernel.org, ruud.derwig@gf.com, rbannerm@synopsys.com, manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com, navami.telsang@vayavyalabs.com, bhoomikak@vayavyalabs.com, nazim.khan@vayavyalabs.com
In-Reply-To: <20261114142212.716906-3-pavitrakumarm@vayavyalabs.com>
References: <20261114142212.716906-1-pavitrakumarm@vayavyalabs.com>
 <20261114142212.716906-3-pavitrakumarm@vayavyalabs.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 14:52:32 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] crypto: spacc: salg leak or priv ref underflow in
  spacc_probe_hashes()
- [Low] crypto: spacc: wrong field logged for AUX in spacc_init()
- [Low] crypto: spacc - missing stack key zeroization in context
  read/write helpers
--

commit 7f65f106112a1ad39dd6972a667e410520c333a1
Author: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>

crypto: spacc - Add SPAcc ahash support

This commit introduces the Synopsys DesignWare SPAcc crypto accelerator
driver along with ahash support for MD5, SHA-1, SHA-2, SHA-3, HMAC, and
SM4 CMAC/XCBC algorithms.

> diff --git a/drivers/crypto/dwc-spacc/spacc_ahash.c b/drivers/crypto/dwc-=
spacc/spacc_ahash.c
> new file mode 100644
> index 0000000000000..2e12ac7974fcd
> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/spacc_ahash.c

[ ... ]

> +static void spacc_hash_alg_destroy(struct crypto_alg *alg)
> +{
> +	struct spacc_alg *salg =3D container_of(alg, struct spacc_alg,
> +					      alg.hash.base.halg.base);
> +	struct spacc_priv *priv =3D salg->priv;
> +
> +	kfree(salg);
> +	kref_put(&priv->ref, spacc_priv_release);
> +}

[ ... ]

> +static int spacc_register_hash(struct spacc_alg *salg)
> +{
> +	int rc =3D 0;
> +	struct spacc_priv *priv =3D salg->priv;
> +
> +	salg->calg =3D &salg->alg.hash.base.halg.base;
> +	salg->alg.hash =3D spacc_hash_template;
> +
> +	/* Unkeyed digests must not advertise a setkey. */
> +	if (!spacc_mode_is_keyed(salg->mode->id))
> +		salg->alg.hash.base.setkey =3D NULL;
> +
> +	rc =3D spacc_init_calg(salg->calg, salg->mode);
> +	if (rc)
> +		return rc;
> +
> +	salg->alg.hash.base.halg.digestsize =3D salg->mode->hashlen;
> +	{
> +		struct crypto_ahash *fb;
> +
> +		/* statesize must equal the software fallback's exported state. */
> +		fb =3D crypto_alloc_ahash(salg->calg->cra_name, 0,
> +					CRYPTO_ALG_ASYNC);
> +		if (IS_ERR(fb))
> +			return PTR_ERR(fb);
> +		salg->alg.hash.base.halg.statesize =3D crypto_ahash_statesize(fb);
> +		crypto_free_ahash(fb);
> +	}
> +
> +	rc =3D crypto_engine_register_ahash(&salg->alg.hash);
> +	if (rc < 0)
> +		return rc;
> +
> +	guard(mutex)(&priv->hash_alg_mutex);
> +	list_add(&salg->list, &priv->hash_alg_list);
> +
> +	return 0;
> +}
> +
> +int spacc_probe_hashes(struct platform_device *spacc_pdev)
> +{

[ ... ]

> +		if (spacc_is_mode_keysize_supported(&priv->spacc,
> +					possible_hashes[index].id & 0xFF,
> +					possible_hashes[index].hashlen, 1)) {
> +			salg =3D kmalloc_obj(*salg, GFP_KERNEL);
> +			if (!salg) {
> +				rc =3D -ENOMEM;
> +				goto err_unregister;
> +			}
> +
> +			salg->mode =3D &possible_hashes[index];
> +			salg->dev =3D &spacc_pdev->dev;
> +			salg->priv =3D priv;
> +			kref_get(&priv->ref);
> +
> +			rc =3D spacc_register_hash(salg);
> +			if (rc < 0) {
> +				kref_put(&priv->ref, spacc_priv_release);
> +				continue;
> +			}
> +			registered++;
> +		}
> +	}

[Severity: High]
Can a failure in spacc_register_hash() leak salg or underflow priv->ref?

If spacc_register_hash() fails before crypto_check_alg() initializes
cra_refcnt (for example in spacc_init_calg() or crypto_alloc_ahash()),
spacc_hash_alg_destroy() never runs and spacc_probe_hashes() never frees
salg.

Conversely, if crypto_engine_register_ahash() fails inside
__crypto_register_alg() (for example with -EEXIST when a second SPAcc
device probes with the same "spacc-<alg>" cra_driver_name),
crypto_register_alg() calls crypto_alg_put() -> spacc_hash_alg_destroy(),
which frees salg and drops priv->ref.  The error path in
spacc_probe_hashes() then calls kref_put(&priv->ref, spacc_priv_release) a
second time, freeing priv while spacc_probe_hashes() is still using it.

Taking priv->ref inside spacc_register_hash() right before
crypto_engine_register_ahash() and freeing salg directly on earlier errors
would avoid both issues.

> diff --git a/drivers/crypto/dwc-spacc/spacc_core.c b/drivers/crypto/dwc-s=
pacc/spacc_core.c
> new file mode 100644
> index 0000000000000..490451cfc5bdb
> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/spacc_core.c

[ ... ]

> +	if (spacc->config.version >=3D 0x48)
> +		dev_dbg(spacc->dptr,
> +			"   TYPE       : %lx (%s)\n", SPACC_ID_TYPE(id),
> +			version_string[SPACC_ID_TYPE(id) & 1]);
> +
> +	dev_dbg(spacc->dptr, "   AUX        : %x\n", info->spacc_version.qos);

[Severity: Low]
Should this print info->spacc_version.aux instead of
info->spacc_version.qos?

> diff --git a/drivers/crypto/dwc-spacc/spacc_manager.c b/drivers/crypto/dw=
c-spacc/spacc_manager.c
> new file mode 100644
> index 0000000000000..d883cc0e9b05c
> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/spacc_manager.c

[ ... ]

> +/* Write appropriate context data which depends on operation and mode */
> +int spacc_write_context(struct spacc_device *spacc, int job_idx, int op,
> +			const unsigned char *key, int ksz,
> +			const unsigned char *iv, int ivsz)
> +{
> +	int buflen;
> +	int ret =3D 0;
> +	unsigned char buf[300] __aligned(sizeof(u32));
> +	struct spacc_ctx *ctx =3D NULL;
> +	struct spacc_job *job =3D NULL;

[ ... ]

> +	return ret;
> +}
> +
> +int spacc_read_context(struct spacc_device *spacc, int job_idx,
> +		       int op, unsigned char *key, int ksz,
> +		       unsigned char *iv, int ivsz)
> +{
> +	int buflen;
> +	int ret =3D 0;
> +	unsigned char buf[300] __aligned(sizeof(u32));
> +	struct spacc_ctx *ctx =3D NULL;
> +	struct spacc_job *job =3D NULL;

[ ... ]

> +	return ret;
> +}

[Severity: Low]
Should spacc_write_context() and spacc_read_context() clear buf with
memzero_explicit() before returning so cipher and hash keys are not left on
the stack?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114142212.7169=
06-1-pavitrakumarm@vayavyalabs.com?part=3D2
