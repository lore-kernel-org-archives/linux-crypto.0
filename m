Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795527780;
	b=BrZLteaLHY4KjYjsRjgxJvg2RUXcarHM7WFh9nhm8QEFzjnAve3fZoM2Avl83qNMFBE2
	 IjfkDydCzoHFVE0n3RpyxxDhvdpw1GZ1+aYsEq3acFq3PEg215wl1iHnkHuqzA7EDIggD
	 W85UZg0zmQROeec+DWgVzCzpSlk3NMekQINPN3ZWBey12tCPnsroEzP4ANk8uldpHMRRT
	 Ubt8p8AIlp+wxQrd/O43yIuLm1VIIxmew/ibQDGfNtRA1oude+SfOWRbNbcX2ymPMtawX
	 X/UB7wdMtTuuqjoLHhRmCmXz2EsuA1JQ6YQ8PbYohJqo5PQkHElqQNeTflEvLFaLlTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795527780;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bNSKQpIAH8yOkzTk50W+EupjVPfPM+QiAOnhPqE48g0=;
	b=3Gjj5gvNKUtLLADCO7odGpebm4G/SHLmUAdz31MqoAW2pqzbWIyIaRtjWF7gCCtx0/3W
	 N6HLp2UOP90Bw+zRcmeQQ/tWSR5+zc8xFsm9fz+ddZeWUZbp6/NzN+pLYZKP+LnM92p26
	 4cPg15VangLWC8b3bEdUVTnrn6SXRiXIIvKmjkfkZKZ0AT/BFpjivdXbpQIskOOFNDU3O
	 sHyUjBQPjO71VhZ4OnPX6w2yIuVDQ/6xgiMRzfb6F5KSu3qmr0Z+DZ6thYsZ+tqB9IqGc
	 oRXtUA4B7Lxn+GmD7x9V2sMb5HiBmES6phm1NdeRTsdAtDiQTnBjFVWSmSRjgf7P/dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fAcCEuxH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15CD606A322
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 13:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fAcCEuxH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE39F1F000C6;
	Tue, 24 Nov 2026 13:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795527780;
	bh=bNSKQpIAH8yOkzTk50W+EupjVPfPM+QiAOnhPqE48g0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fAcCEuxHZB1gvnZgbfTCjPUiqhAqU/fCTb065coHsmqtMQ0n0D88ENuok6o2X1nUr
	 jjaHHWOjqQIE+aAmup6VsMDM8UCi1Etigo+IQEWP9vC+pbrLhIPPtDznFTCK6l/JQx
	 ZwtM1ASuHwPa94uuQhCGdR4b+4PCYA5Xb3fatR/kLSigzY+CIskzerplpgoxOKq91R
	 1VzdC35tnB5Z7Op5yvpIfckW3O0VXydtFk6UitwdOYAajByfL15xjPpe5nOEv8RiI5
	 4Ce3I7IBFDgCUWyUTklQxaYV85BK3xmpe377DnT1wzfkC+HTR+TbPo1QV5FNUwp7+k
	 nWB+q9/vX7qYg==
Message-ID: <sashiko-outbox-231239@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] crypto: qat - fix missing DH public key validation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ryan Prinz" <rc4d5a@protonmail.com>, "Giovanni Cabiddu" <giovanni.cabiddu@intel.com>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, qat-linux@intel.com, linux-crypto@vger.kernel.org
In-Reply-To: <20261124133245.1739232-1-rc4d5a@protonmail.com>
References: <20261124133245.1739232-1-rc4d5a@protonmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 13:42:59 +0000
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
- [Low] crypto: qat - wrong commit cited in Fixes: trailer
- [Low] crypto: qat - duplicate buffer allocation and copy in
  qat_dh_compute_value()
--

commit d221623ed71046cc6a8b1c684c25928ce700035d
Author: Ryan Prinz <rc4d5a@protonmail.com>

> crypto: qat - fix missing DH public key validation
>
> qat_dh_compute_value() passes the peer's DH public value into the
> hardware queue without checking it. The only checks on req->src are
> on length (req->src_len > ctx->p_size); never on the value itself.
>
> crypto/dh.c's dh_is_pubkey_valid() is the generic software check for
> this: it rejects a value outside [2, p-2], but only when FIPS mode
> is enabled, and only for callers using the software implementation.
> QAT's hardware path has no equivalent check in either mode.
>
> QAT registers "dh" at cra_priority 1000, versus the generic software
> implementation's 100, so any caller requesting "dh" gets this
> unvalidated path whenever a QAT device is present and the requested
> modulus size (1536/2048/3072/4096 bits) is one QAT supports;
> qat_dh_set_secret() only falls back to software for sizes outside
> that set.
>
> drivers/nvme/common/auth.c requests "ffdheNNNN(dh)" for NVMe-oF's
> in-band DH-HMAC-CHAP authentication. Three of its five supported
> group sizes, 2048, 3072 and 4096 bits, match QAT's hardware sizes.
> Forcing the derived session key Ks to a known value lets an
> attacker who holds a handshake transcript perform an offline
> brute-force attack against the pre-shared key, which is what the DH
> exchange is documented to protect against on top of plain CHAP.
>
> Fixed by validating the peer-supplied value before it reaches the
> hardware queue, rejecting any value outside [2, p-2].
>
> Fixes: 2acbb8771f6a ("crypto: qat - add param check for DH")
> Signed-off-by: Ryan Prinz <rc4d5a@protonmail.com>

[Severity: Low]
Commit 2acbb8771f6a ("crypto: qat - add param check for DH") only added
the req->src_len > ctx->p_size length check to prevent an integer
underflow when copying req->src.  QAT Diffie-Hellman support without
peer public key range validation was introduced in c9839143ebbf
("crypto: qat - Add DH support"), so should the Fixes: tag cite that
commit instead?

> diff --git a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c b/driver=
s/crypto/intel/qat/qat_common/qat_asym_algs.c
> index 77d59e977472d..78f1b949614b9 100644
> --- a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
> +++ b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
> @@ -216,6 +216,63 @@ static unsigned long qat_dh_fn_id(unsigned int len, =
bool g2)
>  	}
>  }
> =20
> +/* Returns true iff 2 <=3D y <=3D p - 2, given big-endian buffers of p_s=
ize bytes. */
> +static bool qat_dh_pubkey_in_range(const u8 *y, const u8 *p_minus_1,
> +				   unsigned int p_size)
> +{
> +	bool is_zero_or_one =3D true;
> +	unsigned int i;
> +
> +	for (i =3D 0; i < p_size - 1; i++) {
> +		if (y[i]) {
> +			is_zero_or_one =3D false;
> +			break;
> +		}
> +	}
> +
> +	if (is_zero_or_one && y[p_size - 1] <=3D 1)
> +		return false;
> +
> +	return memcmp(y, p_minus_1, p_size) < 0;
> +}
> +
> +static int qat_dh_peer_pubkey_valid(struct qat_dh_ctx *ctx,
> +				    struct scatterlist *src,
> +				    unsigned int src_len, gfp_t flags)
> +{
> +	unsigned int p_size =3D ctx->p_size;
> +	u8 *p_minus_1, *y;
> +	int i, ret =3D 0;
> +
> +	if (!src_len || src_len > p_size)
> +		return -EINVAL;
> +
> +	y =3D kzalloc(p_size, flags);
> +	if (!y)
> +		return -ENOMEM;
> +
> +	scatterwalk_map_and_copy(y + (p_size - src_len), src, 0, src_len, 0);
> +
> +	p_minus_1 =3D kmemdup(ctx->p, p_size, flags);
> +	if (!p_minus_1) {
> +		ret =3D -ENOMEM;
> +		goto free_y;
> +	}
> +
> +	for (i =3D p_size - 1; i >=3D 0; i--) {
> +		if (p_minus_1[i]-- !=3D 0)
> +			break;
> +	}
> +
> +	if (!qat_dh_pubkey_in_range(y, p_minus_1, p_size))
> +		ret =3D -EINVAL;
> +
> +	kfree_sensitive(p_minus_1);
> +free_y:
> +	kfree_sensitive(y);
> +	return ret;
> +}
> +
>  static int qat_dh_compute_value(struct kpp_request *req)
>  {
>  	struct crypto_kpp *tfm =3D crypto_kpp_reqtfm(req);
> @@ -241,6 +298,12 @@ static int qat_dh_compute_value(struct kpp_request *=
req)
>  	if (req->src_len > ctx->p_size)
>  		return -EINVAL;
> =20
> +	if (req->src) {
> +		ret =3D qat_dh_peer_pubkey_valid(ctx, req->src, req->src_len, flags);
> +		if (unlikely(ret))
> +			return ret;
> +	}

[Severity: Low]
This isn't a bug, but qat_dh_peer_pubkey_valid() repeats the
req->src_len > ctx->p_size check and allocates and frees y and p_minus_1
on every request, even though qat_dh_compute_value() immediately
prepares a contiguous p_size-byte buffer in vaddr right before mapping
it for DMA:

drivers/crypto/intel/qat/qat_common/qat_asym_algs.c:qat_dh_compute_value() {
    ...
		if (sg_is_last(req->src) && req->src_len =3D=3D ctx->p_size) {
			qat_req->src_align =3D NULL;
			vaddr =3D sg_virt(req->src);
		} else {
			int shift =3D ctx->p_size - req->src_len;

			qat_req->src_align =3D kzalloc(ctx->p_size, flags);
			if (unlikely(!qat_req->src_align))
				return ret;

			scatterwalk_map_and_copy(qat_req->src_align + shift,
						 req->src, 0, req->src_len, 0);

			vaddr =3D qat_req->src_align;
		}
    ...
}

Validating vaddr directly against ctx->p right before dma_map_single()
would avoid the duplicate scatterlist copy and both per-request
allocations (which can use GFP_ATOMIC when CRYPTO_TFM_REQ_MAY_SLEEP is
clear).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124133245.1739=
232-1-rc4d5a@protonmail.com?part=3D1
