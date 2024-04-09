Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2156053AC
	for <linux-crypto@vger.kernel.org>; Tue,  9 Apr 2024 22:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712702307; cv=none; b=iWiyAdtihXjEip/h1VJVaVCgdumO9rm+1hBwsKr3dohJ1qKXH2tDMTU6wgmgP8iK8H2k+xVT15Oq/Rq1hWUXRBNdfZjcdAlcRKKUeRzhWqbBmSvHcrjUNgR/pg16qIS1Iu8EZAOPeCdGgikvM9K8QhI97nOti83mqDWF0USOTdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712702307; c=relaxed/simple;
	bh=jb26GpNwvZNeQlySbTBFG7MuoxLdBGeIOvyQNQMMDAY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dtCT5cWpIibtW+h9CmLpduOgbWFYpSh2Myg84foC8nxg+bg3pE0YtBhdyNg8fpf9g4bn0lyBPsy7WBFLROOgevqStzGwSGq4x0CF0m3avVhfpuzz0dCquD50OvO3ICKs7YVfyKi26yKUSNxrb+q1QnwePgwNFq6U+HlusG9sS+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ArJPQc0m; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ArJPQc0m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712702307; x=1744238307;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=jb26GpNwvZNeQlySbTBFG7MuoxLdBGeIOvyQNQMMDAY=;
  b=ArJPQc0m+FlJ//sd8Smp6ox6ovFy77qNyJFihw1F0qzrvFQYdj+m8o2h
   rx9ZjlVRKbanDZdjJET0U8FGwyHGPv17xketE8Kd7EqqS5TfTeVjcrXM6
   66/xRcQHjNz0viOc0iL89X0o+2VoW/4OkOhMh4fqcDUrIa5YSZoUoj6vr
   ZAXGnuHA5P2QeAqm7INoUgLrmXgxmMOQA8FUz8kWPYsjB1+w353LSF00J
   ouijHnv3/kYKlke0fvZksNaPSiKx0bXGuR5cgg+djoYAabzITcnLt/ngS
   +iUuBnrpROZO6uHN1WhdGKvXhWVnaLAiFO6JX4b1L2wITJpLROsVBSHK0
   w==;
X-CSE-ConnectionGUID: tAVDSY22TW6cri29lKbExQ==
X-CSE-MsgGUID: 1fv5i+oORBaU/t1Pt9KoMg==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="8269157"
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="8269157"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 15:38:26 -0700
X-CSE-ConnectionGUID: eD+1DAYYQU6jdPaUew+HIg==
X-CSE-MsgGUID: lCMDPlZkQm6bigM1LkVz/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="24865247"
Received: from amatsuba-mobl2.amr.corp.intel.com (HELO [10.209.3.203]) ([10.209.3.203])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 15:38:25 -0700
Message-ID: <73f90bdd2b5767b3004d130031ef042bd28f1698.camel@linux.intel.com>
Subject: Re: [PATCH 2/3] crypto: x86/sha256-avx2 - add missing vzeroupper
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: x86@kernel.org
Date: Tue, 09 Apr 2024 15:38:16 -0700
In-Reply-To: <20240406002610.37202-3-ebiggers@kernel.org>
References: <20240406002610.37202-1-ebiggers@kernel.org>
	 <20240406002610.37202-3-ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2024-04-05 at 20:26 -0400, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>=20
> Since sha256_transform_rorx() uses ymm registers, execute vzeroupper
> before returning from it.  This is necessary to avoid reducing the
> performance of SSE code.
>=20
> Fixes: d34a460092d8 ("crypto: sha256 - Optimized sha256 x86_64 routine us=
ing AVX2's RORX instructions")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/x86/crypto/sha256-avx2-asm.S | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/arch/x86/crypto/sha256-avx2-asm.S b/arch/x86/crypto/sha256-a=
vx2-asm.S
> index 9918212faf91..0ffb072be956 100644
> --- a/arch/x86/crypto/sha256-avx2-asm.S
> +++ b/arch/x86/crypto/sha256-avx2-asm.S
> @@ -714,10 +714,11 @@ SYM_TYPED_FUNC_START(sha256_transform_rorx)
>  	popq	%r15
>  	popq	%r14
>  	popq	%r13
>  	popq	%r12
>  	popq	%rbx
> +	vzeroupper
>  	RET
>  SYM_FUNC_END(sha256_transform_rorx)
> =20
>  .section	.rodata.cst512.K256, "aM", @progbits, 512
>  .align 64

Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
