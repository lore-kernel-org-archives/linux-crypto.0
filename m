Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD3B3126D6
	for <linux-crypto@vger.kernel.org>; Wed, 15 Apr 2026 02:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776221213; cv=none; b=R776F2sTikMKdEIAKYA65gqmXxSp9K3zcHSdO1dmUIbk+DC0NHIqVosbzZoI79i+Rlqz3LFWhcUDOZXgniG4AHeatrjwExNqY2nS30e91QR0lrgFZnFqK9vasWwoVe2DSTyg4RkqoX1lSF6LoT3kDRqCzh76hpR6DL0BWgnBxaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776221213; c=relaxed/simple;
	bh=1Y4OvV5vBQqB5sO2WotJgDBCGGHB2ogr+ahl4SSAHvk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C3aftmniTi4usbvs+bBM7yGltcCmlXiO1hODZkaonZh/6j2K2Hrhd/+OCpeerXR0ZbqfuB6UvGNTqFuIMCKtzXLvycF8RoJ/0E6gVyN4LHO272BMlpOi4VZsINNHulHR4NepE0gXrxFjgdKi3XNamtsDVhzEwgavHtfDf+AFXM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eCnMIwey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eCnMIwey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20F2C19425;
	Wed, 15 Apr 2026 02:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776221213;
	bh=1Y4OvV5vBQqB5sO2WotJgDBCGGHB2ogr+ahl4SSAHvk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eCnMIweyLwxS+tT7C2lAHh5WojvTatmEM0u+Rfl7yx8qe0drJztP6HYw8/+cw3pQP
	 xS0mwLOtPLjxIfCZ7Vy+BQPKdKo4qMnYGePUtYQNeV3yg9VZNo/CUmqaX50O8Cyd6m
	 RW0ZSD2I7OVa1OC+056nEhtfuiJAaYpfRZTSEN10PdLV0ojcONQAz3gETyTp852Bwr
	 cCT9K16J1x3rhYh9YW/RAcUV3nr3SjL9fkaVQRyceZRSA8pd5CNzdJxzk/vPi8i4uo
	 0FT8jA+GU9M1Vi92MPaTF4e59NMA/dipqReMBvGXGp3hgQ0PTunw2wXxVUNx2jDYcd
	 TBsJU3KyUl+MQ==
Date: Wed, 15 Apr 2026 05:46:49 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Lukas Wunner <lukas@wunner.de>
Cc: Eric Biggers <ebiggers@kernel.org>, Jason Donenfeld <jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Yiming Qian <yimingqian591@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	David Howells <dhowells@redhat.com>,
	Tadeusz Struk <tstruk@gigaio.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: lib/mpi - Fix integer underflow in
 mpi_read_raw_from_sgl()
Message-ID: <ad78GQxoNnOEss5G@kernel.org>
References: <59eca92ff4f87e2081777f1423a0efaaadcfdb39.1776003111.git.lukas@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59eca92ff4f87e2081777f1423a0efaaadcfdb39.1776003111.git.lukas@wunner.de>

On Sun, Apr 12, 2026 at 04:19:47PM +0200, Lukas Wunner wrote:
> Yiming reports an integer underflow in mpi_read_raw_from_sgl() when
> subtracting "lzeros" from the unsigned "nbytes".
> 
> For this to happen, the scatterlist "sgl" needs to occupy more bytes
> than the "nbytes" parameter and the first "nbytes + 1" bytes of the
> scatterlist must be zero.  Under these conditions, the while loop
> iterating over the scatterlist will count more zeroes than "nbytes",
> subtract the number of zeroes from "nbytes" and cause the underflow.
> 
> When commit 2d4d1eea540b ("lib/mpi: Add mpi sgl helpers") originally
> introduced the bug, it couldn't be triggered because all callers of
> mpi_read_raw_from_sgl() passed a scatterlist whose length was equal to
> "nbytes".
> 
> However since commit 63ba4d67594a ("KEYS: asymmetric: Use new crypto
> interface without scatterlists"), the underflow can now actually be
> triggered.  When invoking a KEYCTL_PKEY_ENCRYPT system call with a
> larger "out_len" than "in_len" and filling the "in" buffer with zeroes,
> crypto_akcipher_sync_prep() will create an all-zero scatterlist used for
> both the "src" and "dst" member of struct akcipher_request and thereby
> fulfil the conditions to trigger the bug:
> 
>   sys_keyctl()
>     keyctl_pkey_e_d_s()
>       asymmetric_key_eds_op()
>         software_key_eds_op()
>           crypto_akcipher_sync_encrypt()
>             crypto_akcipher_sync_prep()
>               crypto_akcipher_encrypt()
>                 rsa_enc()
>                   mpi_read_raw_from_sgl()
> 
> To the user this will be visible as a DoS as the kernel spins forever,
> causing soft lockup splats as a side effect.
> 
> Fix it.
> 
> Reported-by: Yiming Qian <yimingqian591@gmail.com> # off-list
> Fixes: 2d4d1eea540b ("lib/mpi: Add mpi sgl helpers")
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Cc: stable@vger.kernel.org # v4.4+
> ---
>  lib/crypto/mpi/mpicoder.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/crypto/mpi/mpicoder.c b/lib/crypto/mpi/mpicoder.c
> index bf716a03c704..9359a58c29ec 100644
> --- a/lib/crypto/mpi/mpicoder.c
> +++ b/lib/crypto/mpi/mpicoder.c
> @@ -347,7 +347,7 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
>  	lzeros = 0;
>  	len = 0;
>  	while (nbytes > 0) {
> -		while (len && !*buff) {
> +		while (len && !*buff && lzeros < nbytes) {
>  			lzeros++;
>  			len--;
>  			buff++;
> -- 
> 2.51.0
> 

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
