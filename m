Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795807340;
	b=cK5qkujbaHEPOAw4nCxhFqAV1p6zMRSTPHOiv9HjWe8konyIYCjd+3F3S/SLi4HUy54h
	 mInEsN5RqYYxnVsVO4jcGHfs2+jKs8B0NVK+hdhHDm57eR2hB6dLEa6i5a7fYSly0gbZH
	 KrhaV+XvyXtFcUBaODq4wISkop0B0pLk6Mc/shS6lJW+gyiYuILeCuTbrk9HR3krCp0lP
	 hpd4gda5gtZcPVSf2PKPyrqLS7VtfaqdutywosF7qrOaQ3CSNK324m6HdHts1O6DrEJb6
	 Vhxd8Cb9sup0IdD2mdZC3Mg2H9/+D2b+dz7eCslh3mPs07cXwijpUQI13LAwepABbYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795807340;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=dVfM+b453vx0yelfQtLzrsDgRiNdEhz6Ca/WepzbLH4=;
	b=KmNLe4UksGwSbNjSuKWnBW105xoa3DG+2P69i4MZqFMLve1H/+oNtgnyfzAXMzUiABR0
	 DBVF0f7noSEpQYRUhb/Os71PdWYDdNstqt/05CqQ5Pq4YyBHyNJVpytulAb0dRgnK0Ky+
	 TGUdYNXlQy8SumM7gvRIohNmX/CadZH6asbANpzherdnygVkcizq4tLjnjDK+BUeBi6lx
	 6uWR3JtLXqvbmRaILtT3oGpqdll20Cx/yMYwkdVzZ376C0V0EoBewJEXmE3Tz28YouKMn
	 4RLLojGx6souO1RBzfUD5MEelhQD9Kdf4uNXp8It2E2dOJ9f/+g0HeK7GTXxztpy+yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MnI1ogTp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4685A606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 19:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MnI1ogTp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34121F000C1;
	Fri, 27 Nov 2026 19:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795807339;
	bh=dVfM+b453vx0yelfQtLzrsDgRiNdEhz6Ca/WepzbLH4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MnI1ogTpttBwp+oy1NZfaC3fYL7fNVGrNmDpKX4QWLirLwxZ8kVAoIp2OUBT8ZMTx
	 xkq1kOjz0LdPNnMHYn6BkuFHFSl4Dli6hFAPcRdHHRtUJRX2gg6Fsl4X4ZMuQ+iQ3K
	 3tY01FRIx3+HuaQhR6koPzRmqm+ESDhWA4gxl1ytxSfawQ5l33ghtCj0GU+DnJ44Oi
	 TYCEp923lWoVRo2bIm/bvs5U69BbCuNDwUSntP78+QqCAzhR1e6lYdOgr3Xri0QqWm
	 pgroghqBq+9Rn3in/asJtYRAOCEueIzj9yTQJz5tgzNchCNYzXYUm58ld7wX46Ikaq
	 59EVyhXp5PccA==
Date: Fri, 27 Nov 2026 11:22:15 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: ecordonnier@snap.com
Cc: Jason@zx2c4.com, ardb@kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: mpi: use a 128-bit multiply for umul_ppmm()
 on arm64
Message-ID: <20261127192215.GC8300@quark>
References: <20261127171632.3024874-1-ecordonnier@snap.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261127171632.3024874-1-ecordonnier@snap.com>

On Fri, Nov 27, 2026 at 06:16:32PM +0100, ecordonnier@snap.com wrote:
> From: Etienne Cordonnier <ecordonnier@snap.com>
> 
> longlong.h has no arm64 entry, so umul_ppmm() falls back to the generic
> C version, which builds each 64x64->128 product out of four 32x32
> multiplications plus carry handling. umul_ppmm() is in the inner loops
> of mpihelp_mul_1(), mpihelp_addmul_1(), mpihelp_submul_1() and the
> division code, so this slows down every mpi_powm(), e.g. each RSA
> signature verification (module signatures, X.509).
> 
> Use a u128 multiplication, which the compiler turns into a mul + umulh
> pair, as the MIPS64 entry already does with a 128-bit type.
> 
> On a Cortex-A55 at 1.5 GHz, the time spent in mpi_powm() per RSA-4096
> module signature verification (measured with kprobes on a 6.1 kernel
> with this change backported) goes from 1286 us to 1201 us (-6.6%).
> A userspace build of the same code shows the same direction at other
> modulus sizes (2048/3072/4096 bits: 0.42/0.85/1.44 ms before,
> 0.35/0.70/1.19 ms after).
> 
> The crypto self-tests (CONFIG_CRYPTO_SELFTESTS_FULL) pass for
> rsa-generic on arm64 in QEMU.
> 
> AI assistance: this patch and its changelog were written by Claude
> Sonnet 5.5 (Anthropic), used through Claude Code, and reviewed by the
> submitter.
> 
> Signed-off-by: Etienne Cordonnier <ecordonnier@snap.com>
> ---
>  lib/crypto/mpi/longlong.h | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/lib/crypto/mpi/longlong.h b/lib/crypto/mpi/longlong.h
> index 6d31c3a729f1..877f19778df3 100644
> --- a/lib/crypto/mpi/longlong.h
> +++ b/lib/crypto/mpi/longlong.h
> @@ -225,6 +225,20 @@ extern UDItype __udiv_qrnnd(UDItype *, UDItype, UDItype, UDItype);
>  #define UDIV_TIME 100
>  #endif /* __arm__ */
>  
> +/***************************************
> +	**************  ARM64  ****************
> +	***************************************/
> +#if defined(__aarch64__) && W_TYPE_SIZE == 64 && \
> +	defined(CONFIG_ARCH_SUPPORTS_INT128)
> +/* The compiler turns a u128 multiply into mul + umulh. */
> +#define umul_ppmm(w1, w0, u, v)		\
> +do {					\
> +	u128 __ll = (u128)(u) * (v);	\
> +	w1 = __ll >> 64;		\
> +	w0 = __ll;			\
> +} while (0)
> +#endif /* __aarch64__ */

Well, x86_64 has no code in this file either.  This code seems to have
been written in the 1990s.  It has optimizations for all sorts of CPUs
that no one has ever heard of, and not the ones actually used today.

CONFIG_ARCH_SUPPORTS_INT128 works on x86_64 and other architectures too.
How about dropping the __aarch64__ condition and putting this in the
'#if !defined(umul_ppmm)' section of the file around line 1283?

lib/crypto/mpi/ is past due for a rewrite, though.  Minor tweaks like
this don't change that.

- Eric
