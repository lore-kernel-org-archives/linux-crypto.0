Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7AF31E855;
	Tue,  5 May 2026 09:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777973090; cv=none; b=Nl3W/GhS8mP995fgXVxrHMmYKvD8Lj8JOryY5ZT2qIqkw79TIgg2HflrnEMqSUbrnRXZofLqwI+cyIx2mA/U0x3dXjW9OXliBqpgPUL6LQ7cwxbXuzkQEPnYuVlB9GlGlegkwaoxsvHy14xsBP89RoB4CrjQEA7ll3AqQyHQLYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777973090; c=relaxed/simple;
	bh=BukDA3+29w9ZMxtvnQELfdHDnY7IRTdv18CWN04Gst0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cQaZQpzdJ3p7lZvOH1cd9XXoyL05cZu+mYdr9VN8srmta2GDbrEwHHnqqpnJVtyDmJZpLYetm36KWBnPhGdr1jmdm/ISNf6sXWv0JxaSS/AmWmgqLLrFN+1ZyNCyKg420J7n3T9+FQnoIL06S98bbmFgvHijZYJ4+YQIbNk9Yiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=rDHkQJlx; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="rDHkQJlx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=pa4FvNdcfKy9+gkU9d/DdDn+rwcZnnR9EEGoAOReuwQ=; 
	b=rDHkQJlx5WZGzILUr6NQ+0xhJ1pzanh6aAU9u4D3ovZJZDZ2h0Ifd6BZHc9B0aGpr7QLELhGaVA
	V1ZgeIF+OdqwaTRs+8K+44Gw7vGRAvYaspZ0WoeID3F0UhmCwCN9fxjNXXURbVKfdM+e4ivcwXSh8
	Zfkz+VphiaWtIJUBcsGe9Hc8DEBVbjNd1+prK+PBxdMm3HN8TzxwtcqfGsjkFtM3o9fGAvLtXE1V4
	MOAD7uDV74PiROidTopAR1XZCjh7Mw/6tll/vcpJWCO6yXfDyCpCtn+LiXzS6cRvbhO5SKBHAHIYQ
	VjIpDKNxotb35lqeaBWAInaSFIh8ncq9PRPA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wKC13-00BNpf-2b;
	Tue, 05 May 2026 17:24:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 May 2026 17:24:33 +0800
Date: Tue, 5 May 2026 17:24:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeff Barnes <jeffbarnes@linux.microsoft.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: testmgr - disallow RSA PKCS#1 SHA-1 sig algs
 in FIPS mode
Message-ID: <afm3UY1ddNQowmSc@gondor.apana.org.au>
References: <20260423-disallow_rsa_sha1_signing_in_fips_mode-v2-1-a5fe72dd8a71@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423-disallow_rsa_sha1_signing_in_fips_mode-v2-1-a5fe72dd8a71@linux.microsoft.com>

On Thu, Apr 23, 2026 at 11:21:41AM -0400, Jeff Barnes wrote:
> When booted with fips=1, RSA signature generation using SHA-1 must not be
> available.  However, pkcs1pad(rsa,sha1) can currently be instantiated
> because it is not present in alg_test_descs; alg_test() falls through the
> no_test path and succeeds, after which the algorithm appears in
> /proc/crypto as fips-capable.
> 
> Add explicit alg_test_descs entries for pkcs1pad(rsa,sha1) and
> pkcs1(rsa,sha1) without marking them fips_allowed, so they are treated as
> not FIPS-allowed when fips=1 is enabled.
> 
> Include both names to cover kernels where RSA sign/verify is provided via
> the pkcs1(...) signature template, while pkcs1pad(...) remains for the
> traditional wrapper naming and/or RSAES operations.
> 
> Signed-off-by: Jeff Barnes <jeffbarnes@linux.microsoft.com>
> ---
> This series fixes an issue where SHA-1 RSA signature generation remains
> available when booted with fips=1.
> 
> On a FIPS-enabled system, pkcs1pad(rsa,sha1) can be instantiated even
> though SHA-1 must not be available for signature generation. The reason
> is that the algorithm is not listed in crypto/testmgr.c's alg_test_descs,
> so alg_test() falls through the no_test path and succeeds. Once
> instantiated, /proc/crypto reports the algorithm as "fips: yes".
> 
> This patch adds explicit alg_test_descs entries for:
> 
>   - pkcs1pad(rsa,sha1)
>   - pkcs1(rsa,sha1)
> 
> without setting fips=1, so they are treated as not FIPS-allowed in
> FIPS mode.
> 
> Both names are covered to handle kernels where RSA signature operations
> are provided via the pkcs1(...) signature template, while pkcs1pad(...)
> remains for the historical wrapper naming and/or RSAES operations.
> 
> Reproducer / evidence (current behavior):
>   1) Boot with fips=1 (confirm /proc/sys/crypto/fips_enabled == 1)
>   2) Allocate the transform:
>        crypto_alloc_akcipher("pkcs1pad(rsa,sha1)", 0, 0)
>   3) Observe that /proc/crypto now contains:
>        name   : pkcs1pad(rsa,sha1)
>        fips   : yes
>        selftest: passed
>   4) A simple in-kernel demo module can instantiate the transform and reach
>      the signing path in FIPS mode.
> 
> With this change, attempts to instantiate these SHA-1 RSA signing
> templates in FIPS mode are rejected, preventing SHA-1 signature
> generation in approved mode.
> 
> Thanks for taking a look.
> ---
> Changes in v2:
> - Rewrap commit message body to conform to 75-column limit
> - Fix From/Signed-off-by address mismatch
> Link to v1: https://lore.kernel.org/r/20260422-disallow_rsa_sha1_signing_in_fips_mode-v1-1-1359bc7d41be@microsoft.com
> ---
>  crypto/testmgr.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
