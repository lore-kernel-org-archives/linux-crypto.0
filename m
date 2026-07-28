Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9A942466D;
	Tue, 28 Jul 2026 22:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785278127; cv=none; b=XAdYt47Ow6prDZstfoCJT7QUG7ZOaW45FrejgfDDQSD5lTBD5vD0bW6fAqauhsmpAxaFvo0BPxdKVuiCNdMuOHFlhnfjGSFJ3nUqeFY6UVvOOXRJnWN3sKdsdazAwm7rWx6Yc/VV6QZOkACDEu6H1xvwai45DUszUR9/4UnXTRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785278127; c=relaxed/simple;
	bh=bmuNQQmlrOGn31gH/n1Z1fIlUGYITNk7g1MEGeRcVZc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=NtlpDzYWj69CwNeJR1nJxK+s09vBve7HVB7mQz3r5twPg5ECTo107Lcrg9HxtyyVvsv85xtvGJEVyhLwOIoxgErldQ1X7sRer+U8I/pW0MTjZ+tGU1Lr53nw66qlOBV1nyZqMmI7HZlU4ojNf6ezeiLUS5jFOZxgCORhQCPPHoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Whqt1K+/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Whqt1K+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9451F00A3A;
	Tue, 28 Jul 2026 22:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785278125;
	bh=2dECJoqDvj4NsK+08JPKeYoArhUSVLNfBOHa/8BAcXA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Whqt1K+/CUV9Mh3XC8eca+9SCZtLe5sElQd/5GbDmVQ2zsVeg0iTsWidtKNnQqTm9
	 46+mFHOEJz9FrrejwzX9WRD8JHEpHjyihMxqomzDT9E5h5NO0TyfFTP2P7fAJyrjYr
	 QuZRtXFwYggWUie3bmocmDlk5UFcWRMM5uGu1OFWTgHLutyctbDC3Nh5Rhc544TAwo
	 CGtTryd+B+4TJpt+S0haGPy0MKEmm6t0yCKkcBylRKdZ1jsIx09eR9iBtMp81FOxIe
	 ytuTvAdtUFW3VxHThpyr2OrdS9TddcxTIq0LTLmZ6YW7Sa0Fj85Fknu40rnKYipvBB
	 UJB3luW1/DNrQ==
From: Thomas Gleixner <tglx@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>, x86@kernel.org
Cc: linux-um@lists.infradead.org, linux-raid@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph
 Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Eric
 Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2 1/8] x86/fpu: Check for missing AVX and AVX-512
 xstate bits
In-Reply-To: <20260728021603.79870-2-ebiggers@kernel.org>
References: <20260728021603.79870-1-ebiggers@kernel.org>
 <20260728021603.79870-2-ebiggers@kernel.org>
Date: Wed, 29 Jul 2026 00:35:22 +0200
Message-ID: <87fr12hhed.ffs@fw13>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Jul 27 2026 at 19:15, Eric Biggers wrote:
> If the CPU declares AVX or AVX-512 support, verify that the
> corresponding xstate bits are also set.  If not, warn and clear them.

That's clearly a firmware bug which has to be treated as all other
inconsistencies of that sort.

> This eliminates the perceived need for AVX and AVX-512 optimized code in
> the kernel to call cpu_has_xfeatures().  That has never been universally
> done, which strongly suggests that it has never really been needed in
> practice, but this should remove any remaining doubt.

Indeed it is inconsistent all over the place. While looking at the
follow up patches I wondered how many of these remaining nested
conditions are redundant. Most of them should be covered by the
dependency checks. If they are not, then we should add them.

> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  arch/x86/kernel/fpu/xstate.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index a7b6524a9dea2..904ff933c0d88 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -799,6 +799,23 @@ static u64 __init guest_default_mask(void)
>  	return ~(u64)XFEATURE_MASK_USER_DYNAMIC;
>  }
>  
> +/* Clear any X86_FEATURE_* used by the kernel whose xfeatures are missing. */
> +static void __init clear_cpu_caps_with_missing_xfeatures(u64 xfeatures)
> +{
> +	u64 mask;
> +
> +	mask = XFEATURE_MASK_FPSSE | XFEATURE_MASK_YMM;
> +	if (boot_cpu_has(X86_FEATURE_AVX) && (xfeatures & mask) != mask) {
> +		pr_err("x86/fpu: Disabling AVX support due to missing xstate features\n");

Please make these

       pr_err(FW_BUG "...")

As that's what it is.

Thanks,

        tglx
