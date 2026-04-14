Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43ABF30EF68
	for <linux-crypto@vger.kernel.org>; Tue, 14 Apr 2026 17:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776189545; cv=none; b=hqueTDeZ4Si/f5JFX6KtGrDCIt0K29wWEj1eyk1R2WtE+rlKAnKs/rxyBvNfRJipSd/1l74f8xyRlLo1ifuZwDpy1zt5VUcdcRTUNgcDbRwrwDez2CU2TdZnyPLvemRplLhuZvCmTBo+Rp7/l46Vh1A/2lifGcyigKPwnmWGMXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776189545; c=relaxed/simple;
	bh=Hgt0EVYZbMcIpShX+GhNHB42UAT04aIDHhz3KnmHOgs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rmu2nWbAzHqlzkFjbZqb6k5gJ0LzCMDG9w++7hBpxpauB4i8lClCp5bpr7Q4zpefjT2/agY996/Ry7VL908CWfaR4YtfVflLxONfgUrVlZZqKsxpMBJaigCQ4/3r4u5Bh1/Duy9wP4+AK2A9EQU3GtGIYJXfFO2xZIEF7fqIMWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gx+GLil0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gx+GLil0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758B9C19425;
	Tue, 14 Apr 2026 17:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776189544;
	bh=Hgt0EVYZbMcIpShX+GhNHB42UAT04aIDHhz3KnmHOgs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gx+GLil0kAczXz/GqVmC1IhNRh1IqeL5VTiAjZt8JfiTudB2WsVVV32fPBGyTM6+e
	 7mBTQqGQpOIUFjU5WCv6kbgovId3vxiVa6oKXe+HH2ccMklKIvQaj8A4HcSd6usj/v
	 O350v09kr5D2HaEM4pmf6iFRSdlT01VpUQ1nh2nuVOY5KUlRZwACdh8zs7w8evQbkd
	 yh0Ee9i1qqWygYrT+0uAPWr4M4nxqrCP/F4B+JeL4/dzvfGfjtDHO8+XGFX8EC+Aq7
	 nBY1Seyh34Pab79v4S+b33amumPlOkUYL7YF0pYvgLFvSascc3vh/3bdyXofXiD62N
	 PcqXAOsQTCu8w==
Date: Tue, 14 Apr 2026 10:59:03 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Lukas Wunner <lukas@wunner.de>
Cc: Jason Donenfeld <jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>,
	Yiming Qian <yimingqian591@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Tadeusz Struk <tstruk@gigaio.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: lib/mpi - Fix integer underflow in
 mpi_read_raw_from_sgl()
Message-ID: <20260414175903.GC24456@quark>
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

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

This code (which has no tests...) is unnecessarily hard to understand,
though.  I haven't been able to fully understand the logic yet, but it
looks like it still has bugs, including still reading past the given
nbytes.  It should be possible to replace it with something simpler and
less error-prone.

- Eric
