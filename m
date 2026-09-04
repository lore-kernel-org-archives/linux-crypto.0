Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668A643C7B1;
	Fri,  4 Sep 2026 09:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788515896; cv=none; b=JSI0YqDNLZNrGAFhXVfJihwjHINkFsHSEE9NL6bQ1RBqS4KWFyM6wbkl+/RTILYyMCvGzvUm3UCdFY41iNN2B4yZr/qsopPY6HWNq0ikyGejTRBnDFMORgtSEgki9WMftKaPofBydjU9FNdzY+qE+EiJSfqxdTAvSD4lw4gJIb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788515896; c=relaxed/simple;
	bh=KH739zV+7VeTKp8yPiqlFDOPYKvVGuzd5F+VdqpGPXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DB8WOPI7WabL+66Ust+/Ru8ecGpRf+904UbUmEheC87L6vW1Fq+NgFOc+XZyz0T4F0bxOOAc3i5E+N3urKTBRelnk3HMw59uOjd56WtUjRXgRSEagaqGABxw+NzkAmk/J4n9jtR3zFd6ApEClz7/+ab6LOy+60DP6EKymuhy2Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=P/4V0LVu; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="P/4V0LVu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=o5KmSjQb01scQ88Q/AFs+h9kuxz0YGOfNf4JSL22LY4=; 
	b=P/4V0LVu3dJCyIGEweuYkVobYgNcZY+fF3T0uudZT+7AMx9zWoQu5X8HFzj34c13ZLycVPEibBR
	4jroEfsT6dZBd12WjhJWam7Fk6w5HZc+q7xBxGLvUuJjJ+lHKzomWW5BBxYv8WUsNm3OQcl8rbt9l
	8d759BdppuiwmcItYaeDU0O9/eG9UbzAaJVF8lJgLgiZOVIu+HNMKZzGm4VkXRpSf60B3OA4Qyx/W
	TvQFVSNaVEuNBCXkkKYdVhI8Eug4Q0LUHAlJixLcdQQHprx3+3S7BFuH42S7Kerjq4kePPKWnMRqQ
	mh3gILPb/20CgS0pg0h9gy3Fn6q9rnjTwfNw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x2QgK-0000000AnET-2CCN;
	Fri, 04 Sep 2026 17:58:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2026 19:58:00 +1000
Date: Fri, 4 Sep 2026 19:58:00 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Fabrice Derepas <fabrice.derepas@canonical.com>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	"David S. Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] crypto: asymmetric_keys - fix OOB read in
 pefile_parse_binary
Message-ID: <apqWKCZduJmXVygI@gondor.apana.org.au>
References: <CAOs+rJVztmvHSkNxP_voc7E=girsstCKmqxG37pvO2kTaEk1TQ@mail.gmail.com>
 <fcbc6b4d5855ba42a0fccf335b2604ef0b36f092.1786802052.git.fabrice.derepas@canonical.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcbc6b4d5855ba42a0fccf335b2604ef0b36f092.1786802052.git.fabrice.derepas@canonical.com>

On Sat, Aug 15, 2026 at 04:00:19PM +0200, Fabrice Derepas wrote:
> pefile_parse_binary() reads the size field of the certificate table's
> data-directory entry, which sits at fixed index 4 of the PE optional
> header's data directory:
> 
> 	ctx->certs_size = ddir->certs.size;
> 
> but nothing ensures index 4 is present. n_data_dirents (the untrusted
> NumberOfRvaAndSizes) is only upper-bounded against header_size and may be
> 0, and header_size need only satisfy cursor < header_size < datalen. A
> crafted PE with n_data_dirents = 0 and a tiny header_size therefore causes
> the ddir->certs.size read to land past the end of the image (CWE-125). The
> chkaddr() that bounds the certificate blob runs only after this read.
> 
> verify_pefile_signature() is reached from kexec_file_load() (the
> lockdown/secure-boot enforced PE-image signature path), and the image is
> parsed before its signature is checked. The trigger needs CAP_SYS_BOOT and
> the access is out-of-bounds read only (no write).
> 
> Require the certificate table's data-directory entry (index 4) to be
> present; the existing upper-bound check then keeps ddir->certs within
> [cursor, header_size).
> 
> Fixes: 26d1164be37f ("pefile: Parse a PE binary to find a key and a signature contained therein")
> Assisted-by: copilot-cli:claude-opus-4-6 frama-c
> Signed-off-by: Fabrice Derepas <fabrice.derepas@canonical.com>
> ---
> v2: express the "index 4" bound as
>     offsetof(struct data_directory, certs) / sizeof(*dde) rather than a
>     literal 4, per Ignat Korchagin's review [1] -- self-documenting and it
>     tracks the struct layout. It is the same value (offsetof is 32,
>     sizeof(*dde) is 8, so the bound is 4). A KUnit test is added as 2/2.
> 
> [1] https://lore.kernel.org/all/CAOs+rJVztmvHSkNxP_voc7E=girsstCKmqxG37pvO2kTaEk1TQ@mail.gmail.com/
> 
> Reproduced under KASAN (CONFIG_KASAN_GENERIC, x86-64) with the KUnit case in
> 2/2: a crafted PE with data_dirs = 0 takes a slab-out-of-bounds read in
> pefile_parse_binary() on an unpatched kernel, and is rejected with -ELIBBAD
> (no KASAN report) with this patch.
> 
>  crypto/asymmetric_keys/verify_pefile.c | 5 +++++
>  1 file changed, 5 insertions(+)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
