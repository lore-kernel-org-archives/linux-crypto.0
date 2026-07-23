Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3264641A922;
	Thu, 23 Jul 2026 19:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784834717; cv=none; b=gafwTIjrtGXW02vl1ILLmdy6psOlk6fNai/yVI+Z98MoAaSOz/cRBOUR914YkSY7gaT+S7ALtk2VORsudkBgajYiGS/8CUt/2XR4M66r+5dUpoHomWpHK8fBxrXZD/OtSPil99NPeHDdGK5YqbvEwuhyNMEX/jZebVPZyAOj/xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784834717; c=relaxed/simple;
	bh=zLw/zKvg905RuPQKJwW0ORh67wOIgadjtm2yAv04JU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fxv76kezLk0Efv1hIOsCqqGqvBGAo6AN1awVi/6cWwu69kC0+huMiB01fpK89lyZ3iHDtSl1+mA3BnQtsbY8j8T/zOEP7K5PqMQHG27i+WjE70Q41cN0Tfcv1EK8F4doF21EId2T7KmnwdmuCvQQveMVhNnVtb+/JBHW5h88r5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kTbgP2qN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kTbgP2qN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779311F000E9;
	Thu, 23 Jul 2026 19:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784834715;
	bh=heP/XjiJUd5/SLkiAsnSW3Qm5phtl4PTK5ZUjjjAiuw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kTbgP2qNgkBkC+GOK1wadqk+axk+vXnVZdrg1khnul6x8Fp3frmtFeKKuQy4CnpOf
	 SI/c5gW8BB/kCneMFwFiu/r1SpBvqI5/BH31JRlgIecEHCGnGGCHvp/VSStHEez7/c
	 HOPonrGsBp4269aAj01HB5NnjjqYIf4dc7Wqzg6c6hqrnrgaJii5rgFSYhwz/piGVw
	 lKQXkuBJ6DxYFTjND/NJ8O9iPrfOnRUeACJLUeN64PVKDElcyF9dJsb3MHzFCjWoJQ
	 E1uz0qAOMMcKN6i7GN3zfnmNuuTs34LXrhFEya/POFtFVrE/rKqoiZzKuaWWLhMhY9
	 wWZeBIiLtr0oQ==
Date: Thu, 23 Jul 2026 12:25:14 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	Eneas U de Queiroz <cotequeiroz@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, brgl@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v6 1/8] crypto: qce - Fix HMAC self-test failures for
 empty messages
Message-ID: <20260723192514.GA110634@quark>
References: <20260717-qce-fix-self-tests-v6-0-455775fe5f6c@oss.qualcomm.com>
 <20260717-qce-fix-self-tests-v6-1-455775fe5f6c@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717-qce-fix-self-tests-v6-1-455775fe5f6c@oss.qualcomm.com>

On Fri, Jul 17, 2026 at 05:53:30PM +0200, Bartosz Golaszewski wrote:
> +/*
> + * BAM DMA cannot handle zero-length transfers, so the driver always holds
> + * back at least one byte to submit to the engine. A zero rctx->buflen at
> + * finalization time does not necessarily mean the message is empty: the
> + * caller may have imported a state that already reflects some hashed data
> + * with nothing currently buffered. Handle both cases through the software
> + * fallback: reconstruct the running state when there is one instead of
> + * assuming the message is empty.
> + */
> +static int qce_ahash_finalize_zero(struct ahash_request *req)
> +{
> +	struct qce_sha_reqctx *rctx = ahash_request_ctx_dma(req);
> +	HASH_FBREQ_ON_STACK(fbreq, req);

I'm trying to understand how this is intended to work.  This uses
crypto_tfm::fb.  But this driver doesn't set CRYPTO_ALG_NEED_FALLBACK,
so crypto_tfm::fb is actually just a pointer to the same crypto_tfm.
(See crypto_create_tfm_node() and crypto_ahash_init_tfm().)  Doesn't
this just result in an infinite recursive loop and a crash?

- Eric
