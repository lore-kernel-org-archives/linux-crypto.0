Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794068433;
	b=gU9/kS8yXPscNEpJAEypsDnhXBlkcGW1t9A/yk6B4xOUIiWCnwLf8fAsQNgqQ3ra6alK
	 ysdLxVpqruGIWhATOYWFo0jOrbaU3yP+ELkVbhiBPS33gtpempzrnnlRDHlu3utavYiux
	 LbWfkzZbWHyyXiBV1SHUEffD9Ov6YfCblpqvmm2ONQ/QJfpv2/VHbr5U736RSq2BHckwq
	 fgZ77dqzkTN+XmBfmr65MoQ2PhQdMY8cuiWE/O+MyjFCidGEfSEnuezbUaGoWislTU7rO
	 xNVWl0ShPzGzfh0OO+GGLgbenXiz21m7KsqXpI+1Z2ZMjbkwoT+eeaIFG+gdR8DTnjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794068433;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cBCmQEUbvYRcLhRdOTOW9jlp5woIFU+mXT5uroJk6pA=;
	b=enBEAD3RvUdXZgdaxlAJtORZcomPW/aEkWD3vZgER8ZIQ/oY/QC/s1O6Q5IX8Wv75HJj
	 RkRGfAVObswMcSvXpsxNLI/qCGtTOs322nFmmNSzAyhq7SaggQNbaqXCp+tkLXevwUk5R
	 oCjhHu+s9scIfISkG+2/YPHGVMM+G7DDfpn+xlDnQXGq9A+EdVBNMrM9KToIeV8DLFlKF
	 74bmImzabsMse7DOgkTay1h3EN9ccQwPgPMQABDRLn4rdTZ3ps3qizfgyFgZmVsUsoj1j
	 Vja2eH8H6aS9T7HhV/B8HaAPTihYhTBf4ix34LPn4l4h1yV+e+vnrh+AJEao1q2gbbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jhMaaGze;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC77606A326
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 16:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jhMaaGze
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2EF1F0089F;
	Sat,  7 Nov 2026 16:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794068432;
	bh=cBCmQEUbvYRcLhRdOTOW9jlp5woIFU+mXT5uroJk6pA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jhMaaGze+QMx+xL8JY5sBEmp8TtlyzpgpoWimgLiABneUKvX9YduKnIbxxpPTNEb8
	 ZVQB0beH7VhYFQAjh2S1y7RfDJOdqva5WHw6NQfPvZ2TLzgk/UF5JcTSeulgPDv+wZ
	 RKYAr/qjl7AnMlpje5G80cuSKvYi9PvtV+q9FHYtZWteBRlMXoPyiDNWH1W7oM5ipu
	 EIUbB51YmjlvpinV2HKLG6O66AhR+I1nkb8FWx+isdacIsM1/siL6+AcNunxZSfgm1
	 d8aVaubeZHxH6eTAaifDC6v4epP/+FSsZJXRJ6W0Gt4h3he8gvChgiF58hbPcSVisU
	 iTIKvnvYPEJNA==
Message-ID: <sashiko-outbox-203049@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 04/15] crypto: ti - Fix use-after-free of dev_data
 on DTHEv2 driver removal
Reply-To: sashiko-reviews@lists.linux.dev
To: "T Pratham" <t-pratham@ti.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>
Cc: "Sebin Francis" <sebin.francis@ti.com>, "Manorit Chawdhry" <m-chawdhry@ti.com>, "Praneeth
 Bajjuri" <praneeth@ti.com>, "Vishal Mahaveer" <vishalm@ti.com>, linux-crypto@vger.kernel.org
In-Reply-To: <20261107160631.2592763-5-t-pratham@ti.com>
References: <20261107160631.2592763-1-t-pratham@ti.com>
 <20261107160631.2592763-5-t-pratham@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 16:20:31 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] crypto: ti - missing dev_data refcnt drain on dthe_probe()
  error path
--

commit 671be96b9ffa7abb434446440cf647e7e1f76348
Author: T Pratham <t-pratham@ti.com>

crypto: ti - Fix use-after-free of dev_data on DTHEv2 driver removal

This commit moves the dthe_data pointer from the transform context to the
request context, binds transforms to a reference-counted struct device,
and adds a kref and completion to struct dthe_data so dthe_remove() waits
for in-flight requests to drain before tearing down the device.

> diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2=
-common.c
> index 911e6bbe4d241..cd4626ed4c39a 100644
> --- a/drivers/crypto/ti/dthev2-common.c
> +++ b/drivers/crypto/ti/dthev2-common.c

[ ... ]

> @@ -184,6 +219,7 @@ static int dthe_probe(struct platform_device *pdev)
>  probe_register_algs_err:
>  	spin_lock_bh(&dthe_dev_list.lock);
>  	list_del(&dev_data->list);
> +	platform_set_drvdata(pdev, NULL);
>  	spin_unlock_bh(&dthe_dev_list.lock);
>  probe_engine_start_err:
>  	crypto_engine_exit(dev_data->engine);

[Severity: Medium]
Does the probe_register_algs_err rollback path also need to drop the
initial reference and wait for drain_compl like dthe_remove() does?

dthe_probe() publishes dev_data in drvdata and dthe_dev_list before calling
dthe_register_algs(), which registers skcipher algorithms first and AEAD
algorithms second:

drivers/crypto/ti/dthev2-aes.c:dthe_register_aes_algs() {
	ret =3D crypto_engine_register_skciphers(cipher_algs, ARRAY_SIZE(cipher_al=
gs));
	if (ret)
		return ret;
	ret =3D crypto_engine_register_aeads(aead_algs, ARRAY_SIZE(aead_algs));
	if (ret)
		crypto_engine_unregister_skciphers(cipher_algs, ARRAY_SIZE(cipher_algs));

	return ret;
}

If registering one of the later algorithms fails after an earlier algorithm
has already been picked up by cryptomgr_test or another user, a request can
remain in flight after crypto_engine_unregister_skciphers() returns:

CPU0                              CPU1
dthe_probe()
  platform_set_drvdata(pdev, dev_data)
  list_add(&dev_data->list, ...)
  dthe_register_algs()
    crypto_engine_register_skciphers()
                                  dthe_cipher_init_tfm()
                                    ctx->dev =3D dthe_get_dev()
                                  dthe_aes_crypt()
                                    dev_data =3D dthe_get_drvdata(ctx->dev)
    crypto_engine_register_aeads() -> fails
    crypto_engine_unregister_skciphers()
  list_del(&dev_data->list)
  platform_set_drvdata(pdev, NULL)
  crypto_engine_exit(dev_data->engine)
  return ret; (frees devm dev_data)
                                    crypto_transfer_skcipher_request_to_eng=
ine()
                                    dthe_put_drvdata(dev_data)
                                      <-- use-after-free

Calling dthe_put_drvdata(dev_data) and
wait_for_completion(&dev_data->drain_compl) before probe_engine_start_err
would wait for any in-flight requests to finish before tearing down the
engine and freeing dev_data.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107160631.2592=
763-1-t-pratham@ti.com?part=3D4
