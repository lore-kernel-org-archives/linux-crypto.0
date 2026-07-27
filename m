Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [144.76.133.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637F23FA5C4;
	Mon, 27 Jul 2026 10:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.133.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785148573; cv=none; b=nnlTd3RbOznIxRDxRfFx8+/rMpIv0JyZUwtVbUrZKunwkibxg8529HKM8A6qQmPdgl4LfpuRgfhKoGrvEeP3BkidOVKzb9efulZwVtMGijeQJJ6OLYxxu+mctDnfYM694GvCkkS3K0op9nQ3X3Pl3zg4oox/nhhdL4ZgDV4bycg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785148573; c=relaxed/simple;
	bh=KXIohaT5z4oJ+9IHf75f/XiqkGEe5xA/AEwCvEEnQII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HvQQcWvV8T+Va5ktxdHwp1tPVfkU9L6IpTRHlNIY2CrUjss3bbLMcWaR6tjIJ9bpuIqbHfcYCAAHocwWy4r4JwXm780GM9mFHsOEOB3lCH2pTVPOlLs7i0Yqmkm8exIY6WmRPWPEZ1Whq7UGxM7fs0VW9fHto9ifBRsIz5mq7gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=144.76.133.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout3.hostsharing.net (Postfix) with ESMTPS id 28B3DC22;
	Mon, 27 Jul 2026 12:36:01 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id E39D960332E5; Mon, 27 Jul 2026 12:36:00 +0200 (CEST)
Date: Mon, 27 Jul 2026 12:36:00 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Doruk Tan Ozturk <doruk@0sec.ai>, Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ignat Korchagin <ignat@linux.win>
Subject: Re: [PATCH 5.10/5.15.y] crypto: rsa-pkcs1pad: Don't WARN on an empty
 digest
Message-ID: <amc0kJZ37reVQdKD@wunner.de>
References: <20260720191533.15971-1-doruk@0sec.ai>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720191533.15971-1-doruk@0sec.ai>

On Mon, Jul 20, 2026 at 09:15:33PM +0200, Doruk Tan Ozturk wrote:
> KEYCTL_PKEY_VERIFY lets an unprivileged caller supply a zero-length
> digest (in_len == 0).  keyctl_pkey_params_get_2() accepts the zero
> length and the request reaches pkcs1pad_verify(), where the empty
> digest is rejected but only after being passed through
> WARN_ON(!req->dst_len).  The warning is therefore directly
> user-triggerable, and on kernels built with panic_on_warn=1 an
> unprivileged process can panic the machine -- a local denial of
> service.  Reproduced as UID 65534 in a setuid sandbox.
> 
> Keep rejecting the invalid request with -EINVAL, but do not emit a
> warning for the user-controlled length.
> 
> This is the 5.10.y/5.15.y form of the fix, where the length is read
> directly from req->dst_len rather than cached in a digest_size local.
> Mainline does not contain this code path; commit 1e562deacecc
> ("crypto: rsassa-pkcs1 - Migrate to sig_alg backend") removed
> pkcs1pad_verify() in v6.13-rc1.  This is a minimal fix for the
> affected stable branches.  The 6.1.y/6.6.y/6.12.y form
> (WARN_ON(!digest_size)) is sent as a separate patch.
> 
> Found by 0sec automated security-research tooling (https://0sec.ai).
> 
> Fixes: c7381b012872 ("crypto: akcipher - new verify API for public key algorithms")
> Cc: stable@vger.kernel.org
> Assisted-by: 0sec:multi-model
> Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>

Reviewed-by: Lukas Wunner <lukas@wunner.de>
