Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794667724;
	b=Jr/ajzOOYzpSEN/BQj2CILo13w+po/vZamNs849i5bNDqi8vMuZhnSu2kU01Trmd63J7
	 1LY3QkeRIpSekEgtESLYkUfsXur310dRmw30cJQsg7A+dh+AFZnhAT4SsbWqC6fJde3av
	 7pqRiz3hBXAQJkZmWVrGClI3B5zUvBoWSz8plQ4X9tUu9zxX7Sff3qwJmvjNFJxnYh+ob
	 LwTGprMmXe7kdjy4Dx1I28fvYlCNhtQNp4XaYyPkc9+9+zf9wkIGcsW9RDm5HDFXbo9LK
	 xQmVJIgzKua4m+/gYD8R9YRfMeA1BuGhS2RRVurBvXws3HY/WeeDx6XFuifAgeydFoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794667724;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=do7TOQQuTMdEXx2r6skCqqZz/a75WGIr8hm3ELa77Bk=;
	b=QAjtWxa3bml6q4+0Phz/Kcfqyo8j+hC2XsqsTjTWuW1tZQpAKZr4z/cxYbuww8Umzu6G
	 VNC2F0Xt923dsvtI57F7eZk51ckp/dA7LE8+NjPL3AFOesDi/a002PBpigfzXFAlkVLdU
	 25omnLuw+ZORSxXIi8UdPT1wv7cYsp3P/WfyIh1zX8nESEZ/QtszYMUh11dF3Oq8b1Vti
	 0dCO7L1yEXlNkUcJvKBhjM63Y/LbTGebzj7vSLYm9b0kjHB8D8fw/cLYuqyTCJoTQdXh9
	 rwJL4ktM0qr1HQ5JZkznm2yhuwmGtc27T7DJ784uAaINfOljCBkr6HgM1dgK8Opb0xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y7L9fw2p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8218B606A323;
	Sat, 14 Nov 2026 14:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y7L9fw2p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF361F000C4;
	Sat, 14 Nov 2026 14:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794667724;
	bh=do7TOQQuTMdEXx2r6skCqqZz/a75WGIr8hm3ELa77Bk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y7L9fw2pkeW9t0HBX5AfrEQxBVNkHr6Jc7MSWnAA2MvF5k8Zpwp3ULL55rxAE6WoG
	 isNFLNod5Ly7XRt6ODVkuA+7v5GsfYFUK/dJblfvyAloOB3sXNHUoCjDIs0lN4Qruq
	 kP/9+/bXG2XHprnsfkmjzsLmPOaJgYTWBCakDzuLkeWVTdeevzUBCpfZ96mclnllYW
	 DUUHsIqeGgqVKAUCGkT4SO9eOPd7qeCyJvl30281CaYZzNQ8UpFD0sdYFOZj9QspUf
	 woq2/vqH5cNJsOQOkazH6smBjnNtm8AtD3YeNPgOg41vHW0xmb0ZwPx2et/GQP0gdJ
	 ihzaii+eRuxGg==
Message-ID: <sashiko-outbox-214646@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v29 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pavitrakumar Managutte" <pavitrakumarm@vayavyalabs.com>, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, herbert@gondor.apana.org.au, robh@kernel.org
Cc: krzk@kernel.org, conor+dt@kernel.org, ruud.derwig@gf.com, rbannerm@synopsys.com, manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com, navami.telsang@vayavyalabs.com, bhoomikak@vayavyalabs.com, nazim.khan@vayavyalabs.com
In-Reply-To: <20261114142212.716906-5-pavitrakumarm@vayavyalabs.com>
References: <20261114142212.716906-1-pavitrakumarm@vayavyalabs.com>
 <20261114142212.716906-5-pavitrakumarm@vayavyalabs.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 14:48:42 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] crypto: spacc: salg leak or priv->ref UAF in
  spacc_probe_hashes()
- [Medium] crypto: spacc: free of active DMA buffer in
  spacc_xof_stringsize_autodetect()
--

commit 4c9159addec558f9b92d14bf8fcd8f5e1fee645b
Author: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>

crypto: spacc - Add SPAcc Kconfig and Makefile

This commit adds the Kconfig and Makefile entries to build the Synopsys
DesignWare SPAcc driver.

> diff --git a/drivers/crypto/dwc-spacc/Makefile b/drivers/crypto/dwc-spacc=
/Makefile
> new file mode 100644
> index 0000000000000..b7125a7797ba0
> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/Makefile
> @@ -0,0 +1,7 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_CRYPTO_DEV_SPACC) +=3D snps-spacc.o
> +
> +snps-spacc-y :=3D spacc_hal.o spacc_core.o \
> +spacc_manager.o spacc_interrupt.o spacc_device.o

[Severity: Medium]
Can spacc_xof_stringsize_autodetect() free DMA buffers while a timed-out
hardware job is still in flight?

drivers/crypto/dwc-spacc/spacc_core.c:spacc_wait_for_job_completion() {
	if (readl_poll_timeout(spacc->regmap + SPACC_REG_FIFO_STAT, rbuf,
			       !(rbuf & SPACC_FIFO_STAT_STAT_EMPTY),
			       10, 10000))
		return false;
...
}

drivers/crypto/dwc-spacc/spacc_core.c:spacc_xof_stringsize_autodetect() {
...
			writel(spacc_ctrl[alg], spacc->regmap + SPACC_REG_CTRL);

			if (spacc_wait_for_job_completion(spacc, virt, md[alg]))
				spacc->config.string_size =3D (16 << ss);
		}
	}
...
	pdu_ddt_free(&ddt);
	dma_free_coherent(spacc->dptr, SPACC_TEST_DMA_BUFF_SIZE,
			  virt, dma);
}

If the 10ms poll times out, spacc_wait_for_job_completion() returns
false just as it does on a digest mismatch.
spacc_xof_stringsize_autodetect() then submits further jobs and frees
ddt and virt while the uncancelable DMA operation may still be accessing
them, and spacc_init() treats the failure as non-fatal and continues
probing.

> +
> +snps-spacc-$(CONFIG_CRYPTO_DEV_SPACC_HASH) +=3D spacc_ahash.o

[Severity: High]
Does spacc_probe_hashes() leak salg or drop priv->ref twice when
spacc_register_hash() fails?

drivers/crypto/dwc-spacc/spacc_ahash.c:spacc_probe_hashes() {
...
			salg =3D kmalloc_obj(*salg, GFP_KERNEL);
			if (!salg) {
				rc =3D -ENOMEM;
				goto err_unregister;
			}

			salg->mode =3D &possible_hashes[index];
			salg->dev =3D &spacc_pdev->dev;
			salg->priv =3D priv;
			kref_get(&priv->ref);

			rc =3D spacc_register_hash(salg);
			if (rc < 0) {
				kref_put(&priv->ref, spacc_priv_release);
				continue;
			}
}

spacc_register_hash() sets cra_destroy to spacc_hash_alg_destroy(),
which calls kfree(salg) and kref_put(&priv->ref, spacc_priv_release).

If spacc_register_hash() fails before __crypto_register_alg() (for
example, when crypto_alloc_ahash() fails), cra_destroy never runs and
salg is leaked.  Conversely, if __crypto_register_alg() fails inside
crypto_engine_register_ahash() (for example, with -EEXIST when a second
SPAcc instance probes with the same cra_driver_name),
crypto_register_alg() calls crypto_alg_put() and runs
spacc_hash_alg_destroy(), so the error branch in spacc_probe_hashes()
drops priv->ref a second time and frees priv while probe continues
using it.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114142212.7169=
06-1-pavitrakumarm@vayavyalabs.com?part=3D4
