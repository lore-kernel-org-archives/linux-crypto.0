Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794985143;
	b=YJhkhxxycuRMAeFPIo24oDPX0Z7rXEvd047ftCm9iY8oQ7aePQU/lrcRhe+lESO4IgcZ
	 5m0NaqRP1nmMeRME0PQUEMZZbw9dlpVFBphhj6x8ZjCF39WPsfb5RD9LOWz8sWiwl4z3E
	 qXF02bXuaAsdHqalPMVir1Nw7eKWikcoaXTuECvBbWdQWnpNQ3Z102ynhZ6VgtfDnbeIK
	 CYvJnD9LkC7FJrA/Vt/2apUnt2Rzh6//brA/MoaxvpyvvRYFwe8drTVgM2kn44/nhP3QW
	 jDDEJ6OBE6i1mLFEuP95VHr9i4vuvSTyPmOvsNZetRC+MJoBQNro9e65HhKVBdEcDjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794985143;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Dfn2oqPIMzAyLbD0RYo29pDJC2iv7SauWYNVrYYRhvM=;
	b=ADhvzqFo3dtr78zPF7V1j0IGhk01rrjq/JYARmiFLxLfdzUbm4q3GxnDn8IZ5YT/VJRL
	 voo3QHIhEIUcXFKcH0yWWQ47BfOr1L7LecmEoOgWhDf3iPS/BLBPxGUYh43cguvRrYMLF
	 ycYnq4+04VnEA4XO4l8CiM4OYG2bFdY3A/C1AN6cJs/ytIRUjftREnZAGRNV8KhjVcYxV
	 TKtRwBVIcc3o59+CVKj8Eap6yj9PqGojTb2EsP98Dh5UzfkeCin9Wjuv1EOoO2svGoTRG
	 gghnlcWIqIMif1Jiyf7GpiGQ53MvynEdGFuUkKX0YYBpoMYzQ6eQIbCdMvClS7NEd0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CA6D2YSH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC2A606A325;
	Wed, 18 Nov 2026 06:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CA6D2YSH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5F91F000C4;
	Wed, 18 Nov 2026 06:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794985143;
	bh=Dfn2oqPIMzAyLbD0RYo29pDJC2iv7SauWYNVrYYRhvM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CA6D2YSH93IfYJwDmwmdraBj8ecUx2mZ6cnOPLCXzPbeNBaKbxd1V7PSePR/ncpnK
	 +hinE1J8Ql5x+QmnBnKkdaB1bTHdBESVgyTV3PeDL/r+MqiWNzDYTZuPAOeHMn5RL5
	 u5eJqfwtgd5cjZHWcrWpq62UTHm9Fc9KwkmHJbVz4D2wubCr7os/wb5VcJbOSejPXS
	 w9vZVnAaEWjbgvnfXT8Z1of9k+9WzousUydz9tEKpm8F6MZTxayiQ0ZmO7f0OUcPSr
	 2hr4ty3TvtGc6htoqnHpxnm6uWPvBWGwTqpThdJ1A1Q9qfFb+728qFp2PJuwxKLsrO
	 Pis+Igda4pxFA==
Message-ID: <sashiko-outbox-220280@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v30 2/4] crypto: spacc - Add SPAcc ahash support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pavitrakumar Managutte" <pavitrakumarm@vayavyalabs.com>, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, herbert@gondor.apana.org.au, robh@kernel.org
Cc: krzk@kernel.org, conor+dt@kernel.org, ruud.derwig@gf.com, rbannerm@synopsys.com, manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com, navami.telsang@vayavyalabs.com, bhoomikak@vayavyalabs.com, nazim.khan@vayavyalabs.com
In-Reply-To: <20261118063504.835259-3-pavitrakumarm@vayavyalabs.com>
References: <20261118063504.835259-1-pavitrakumarm@vayavyalabs.com>
 <20261118063504.835259-3-pavitrakumarm@vayavyalabs.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 06:59:02 +0000
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
- [Medium] crypto: spacc: DMA leak on timeout in
  spacc_xof_stringsize_autodetect()
--

commit 375f3a6084b254b6c5dc8f9b677b8c0b4f921b54
Author: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>

crypto: spacc - Add SPAcc ahash support

This commit adds core device management, HAL, interrupt handling, and ahash
algorithm support for the Synopsys DesignWare SPAcc crypto accelerator.

> diff --git a/drivers/crypto/dwc-spacc/spacc_core.c b/drivers/crypto/dwc-s=
pacc/spacc_core.c
> new file mode 100644
> index 0000000000000..b447716908af4
> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/spacc_core.c

[ ... ]

> +static int spacc_xof_stringsize_autodetect(struct spacc_device *spacc)
> +{
> +	void *virt;
> +	int ss, alg;
> +	int ret;
> +	bool match;
> +	dma_addr_t dma;
> +	struct pdu_ddt ddt;
> +	unsigned long buflen;
> +	unsigned char *buf;
> +	unsigned long spacc_ctrl[2] =3D {0xF400B400, 0xF400D400};
> +	unsigned char test_str[6] =3D {0x01, 0x20, 0x54, 0x45, 0x53, 0x54};
> +	unsigned char md[2][16] =3D {
> +			 {0xc3, 0x6d, 0x0a, 0x88, 0xfa, 0x37, 0x4c, 0x9b,
> +			  0x44, 0x74, 0xeb, 0x00, 0x5f, 0xe8, 0xca, 0x25},
> +			 {0x68, 0x77, 0x04, 0x11, 0xf8, 0xe3, 0xb0, 0x1e,
> +			  0x0d, 0xbf, 0x71, 0x6a, 0xe9, 0x87, 0x1a, 0x0d}};
> +
> +	buf =3D kzalloc(spacc->config.hash_page_size, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	virt =3D dma_alloc_coherent(spacc->dptr, SPACC_TEST_DMA_BUFF_SIZE,
> +				  &dma, GFP_KERNEL);
> +	if (!virt) {
> +		kfree(buf);
> +		return -EIO;
> +	}
> +
> +	if (pdu_ddt_init(spacc->dptr, &ddt, 1)) {
> +		kfree(buf);
> +		dma_free_coherent(spacc->dptr, SPACC_TEST_DMA_BUFF_SIZE,
> +				  virt, dma);
> +		return -EIO;
> +	}
> +
> +	pdu_ddt_add(spacc->dptr, &ddt, dma, SPACC_TEST_DMA_BUFF_SIZE);
> +
> +	/* populate registers for jobs */
> +	writel((u32)ddt.phys, spacc->regmap + SPACC_REG_SRC_PTR);
> +	writel((u32)ddt.phys, spacc->regmap + SPACC_REG_DST_PTR);
> +
> +	writel(16, spacc->regmap + SPACC_REG_PROC_LEN);
> +	writel(16, spacc->regmap + SPACC_REG_PRE_AAD_LEN);
> +	writel(16, spacc->regmap + SPACC_REG_ICV_LEN);
> +	writel(6, spacc->regmap + SPACC_REG_KEY_SZ);
> +	writel(0, spacc->regmap + SPACC_REG_SW_CTRL);
> +
> +	/* repeat for 2 algorithms, CSHAKE128 and KMAC128 */
> +	for (alg =3D 0; (alg < 2) && (spacc->config.string_size =3D=3D 0); alg+=
+) {
> +		for (ss =3D 0; ss < 4; ss++) {
> +			buflen =3D (32UL << ss);
> +			if (buflen > spacc->config.hash_page_size)
> +				break;
> +
> +			memset(virt, 0, SPACC_TEST_DMA_BUFF_SIZE);
> +
> +			memset(buf, 0, spacc->config.hash_page_size);
> +			memcpy(buf, test_str, sizeof(test_str));
> +			memcpy(buf + (buflen >> 1), test_str, sizeof(test_str));
> +
> +			pdu_to_dev_s(spacc->regmap + SPACC_CTX_HASH_KEY, buf,
> +				     spacc->config.hash_page_size >> 2);
> +
> +			writel(spacc_ctrl[alg], spacc->regmap + SPACC_REG_CTRL);
> +
> +			ret =3D spacc_wait_for_job_completion(spacc, virt,
> +							    md[alg], &match);
> +			if (ret)
> +				goto err_timeout;
> +
> +			if (match)
> +				spacc->config.string_size =3D (16 << ss);
> +		}
> +	}
> +
> +	/* reset registers */
> +	writel(0, spacc->regmap + SPACC_REG_IRQ_CTRL);
> +	writel(0, spacc->regmap + SPACC_REG_IRQ_EN);
> +	writel(0xFFFFFFFF, spacc->regmap + SPACC_REG_IRQ_STAT);
> +
> +	writel(0, spacc->regmap + SPACC_REG_SRC_PTR);
> +	writel(0, spacc->regmap + SPACC_REG_DST_PTR);
> +	writel(0, spacc->regmap + SPACC_REG_PROC_LEN);
> +	writel(0, spacc->regmap + SPACC_REG_ICV_LEN);
> +	writel(0, spacc->regmap + SPACC_REG_PRE_AAD_LEN);
> +
> +	kfree(buf);
> +	pdu_ddt_free(&ddt);
> +	dma_free_coherent(spacc->dptr, SPACC_TEST_DMA_BUFF_SIZE,
> +			  virt, dma);
> +
> +	return spacc->config.string_size ? 0 : -ENODEV;
> +
> +err_timeout:
> +	dev_err(spacc->dptr,
> +		"XOF autodetect job timed out, engine not responding\n");
> +	kfree(buf);
> +	return -ETIMEDOUT;
> +}

[Severity: Medium]
Does the err_timeout path in spacc_xof_stringsize_autodetect() leak virt
and ddt?

When spacc_wait_for_job_completion() returns -ETIMEDOUT, err_timeout only
frees buf and skips resetting the hardware registers, calling
pdu_ddt_free(&ddt), and calling dma_free_coherent() on virt.  Because
spacc_init() treats -ETIMEDOUT as a fatal error, spacc_init_device() then
unwinds through pdu_mem_deinit() -> dma_pool_destroy(priv->ddt4_pool) while
ddt is still allocated from that pool.

Also, when match is true, the inner ss loop does not break after setting
spacc->config.string_size, so it continues submitting test jobs for the
remaining ss values.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118063504.8352=
59-1-pavitrakumarm@vayavyalabs.com?part=3D2
