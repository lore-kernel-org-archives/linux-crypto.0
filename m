Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47CE470E88;
	Wed, 22 Jul 2026 19:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784747091; cv=none; b=Xrhi6hCBaFLNkwj0JgmYRWq13ubeY42dizLsqjhA3InFPkikHga5j4+CmJUBZUJDVRmRAz2JWaOeGaAPnJBkMcoTeaTaisMzqUI2R8NVv+1HEyc+kgj83ESmjm24m4FKMEz+GXB36wGNOspb7B59RnfKGA6uL8xAHBGTsbPb1j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784747091; c=relaxed/simple;
	bh=+PcQHRmzAcbi9yVUtn9tpBkYfTlvAGaktACV9TyM9Ww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lyAXEKlwSE/P66RaO0QYNdfhhaQ4NfvSdA+rZEoM/nvp4uc4lzEjTyaj9mnDEP2vNHt+sSWHB6Ol3P/zxMoDDrWI6HeWjiKCW9Nx4fQs+Ra8e2/PDWxyHMN8Xq3H/gYBXkYTcpD41927sp3OwqtoVC7kYF4skqAj+tN6EeklNZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+eQ9v0F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+eQ9v0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860031F000E9;
	Wed, 22 Jul 2026 19:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784747089;
	bh=mokShYnGBNEZn5oJVFFNUx/NQU083VC2qzm2gV1Yv0g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a+eQ9v0F8QbJ7GVZij5kJZwbLGSn4We+ttUcBV0UHLcCoUk3VGeoh6n/wRz8ADHjy
	 9qn85BpdIe5IxoIgvD/AaNu2ArgzptOIwJAPca4oRw1snOHTc0LcjRs/WlaWyj1Li0
	 vnD3njLoJQy/pbGcqmA94SQKuOgY2LicpEzZvoDc4GJgpeGeNK3pMSkb//EVjog7zq
	 LHWO5/H8xCsJKzjDxBymMp3SxpkJMitOW7LvjHG7f6Uh+uJJq3BAx4drx1Fgb7G9GL
	 A/z+/XtPMH1+NBwZMmac/o6YdLyO/m1QCpJCkvgySV2IMy/ARaY5I+K++XrtqTIN2z
	 jOu10fKi75qfA==
Date: Wed, 22 Jul 2026 12:04:46 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] lib/crypto: aes-gcm: Fix CRYPTO_LIB_GF128HASH selection
Message-ID: <20260722190446.GA2118@quark>
References: <20260722021730.16897-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722021730.16897-1-ebiggers@kernel.org>

On Tue, Jul 21, 2026 at 07:17:30PM -0700, Eric Biggers wrote:
> Move the selection of CRYPTO_LIB_GF128HASH from CRYPTO_LIB_AES_GCM to
> CRYPTO_LIB_AES to avoid a build error when CRYPTO_LIB_AES=y &&
> CRYPTO_LIB_AES_GCM=m.  Like the other AES modes, AES-GCM is included in
> libaes as an optional feature rather than a dedicated module.
> 
> Fixes: 2bbb64399435 ("lib/crypto: aes: Add GCM support")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202607220918.2RL0wGGS-lkp@intel.com/
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

I folded this into the fixed commit to eliminate the bisection hazard.

- Eric
