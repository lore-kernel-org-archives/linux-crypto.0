Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B860912F59D
	for <linux-crypto@vger.kernel.org>; Tue,  9 Apr 2024 22:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712702547; cv=none; b=h6L/S2kuVwZSs/yS6iJo+8/RgkrYRTMmdNDh6iJkHnNJy+jf6AEBPbVhXvNCr1zMamDyZ6/Cec3CEMbx4MxVeoc9IafWTd5u1ZW43wuK1MfT3DRGlCwTYHcMJH3MfK6D3iJiL1v6i/Plw+TWNTY2594eA+UWmC1iu29bfuP26ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712702547; c=relaxed/simple;
	bh=nKQiHgE9N5ptYgNS923W56iQVaLUZjQzY8Irmgx1InY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dhUfFYq5yGRLFHx73EOgbpZRSGKDGeHCN7ohDxFlrTUjlbJcdN3XZLM5Pi6mCqLwZ8pS5RelZLVV+ni/B6cM2ibJpflUl3G6NgkOP0jBsZUcEAyYm421jXUTFr9SwMZSt2nbL1g2d2uaBUJaegxCMHBRnJr8G7oy3EfpGZy9Zgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZU67ckPg; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZU67ckPg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712702546; x=1744238546;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=nKQiHgE9N5ptYgNS923W56iQVaLUZjQzY8Irmgx1InY=;
  b=ZU67ckPgGQxR8jf5NkXGqmereXxB6sxQpLUH5t/c0GYQKVh2bmWVsYVr
   GjyYYkZS7R0usdyZpS6E7oxX2bDuqo80TTd5wdSdxcaa5brtZWC2Q1TFK
   wVBArJPoPYmMTiR2UCIyd/pBDbzqwA+8rzjZbYwMKKbg2GKZZptrtAygS
   gdK66SUYvN3He0NqJrvZrxvYL53/gK6lPvcO6sE48dvoYKp7g1WlGrIqY
   M0TNvD59UP2zUIux0OaW6hmGdv+mZvN/6ucZtMAizhJ9JnvBlLCHsPEsd
   k3ZEQh+gP+Yo+GuuiE0c2vMt9mzaBIxDK+6CjBLbliopXKQ5D0++nnCvc
   g==;
X-CSE-ConnectionGUID: pzTynjyRRMmYxYkHPahRDQ==
X-CSE-MsgGUID: 1mr88UR3SCy+9tVV20om1g==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="11883226"
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="11883226"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 15:42:25 -0700
X-CSE-ConnectionGUID: +Ia+4BoHRxupv+sSKaGLsA==
X-CSE-MsgGUID: 6Rdt7zqtTmyygV4F06D7Dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="20392586"
Received: from amatsuba-mobl2.amr.corp.intel.com (HELO [10.209.3.203]) ([10.209.3.203])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 15:42:25 -0700
Message-ID: <c8fb54aac396fe5431e14261f49d4ce1f6807282.camel@linux.intel.com>
Subject: Re: [PATCH 1/3] crypto: x86/nh-avx2 - add missing vzeroupper
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: x86@kernel.org
Date: Tue, 09 Apr 2024 15:42:24 -0700
In-Reply-To: <20240406002610.37202-2-ebiggers@kernel.org>
References: <20240406002610.37202-1-ebiggers@kernel.org>
	 <20240406002610.37202-2-ebiggers@kernel.org>
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
> > From: Eric Biggers <ebiggers@google.com>
> >=20
> > Since nh_avx2() uses ymm registers, execute vzeroupper before returning
> > from it.  This is necessary to avoid reducing the performance of SSE
> > code.
> >=20
> > Fixes: 0f961f9f670e ("crypto: x86/nhpoly1305 - add AVX2 accelerated NHP=
oly1305")
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  arch/x86/crypto/nh-avx2-x86_64.S | 1 +
> >  1 file changed, 1 insertion(+)
> >=20
> > diff --git a/arch/x86/crypto/nh-avx2-x86_64.S b/arch/x86/crypto/nh-avx2=
-x86_64.S
> > index ef73a3ab8726..791386d9a83a 100644
> > --- a/arch/x86/crypto/nh-avx2-x86_64.S
> > +++ b/arch/x86/crypto/nh-avx2-x86_64.S
> > @@ -152,7 +152,8 @@ SYM_TYPED_FUNC_START(nh_avx2)
> > =20
> >  	vpaddq		T5, T4, T4
> >  	vpaddq		T1, T0, T0
> >  	vpaddq		T4, T0, T0
> >  	vmovdqu		T0, (HASH)
> > +	vzeroupper
> >  	RET
> >  SYM_FUNC_END(nh_avx2)

Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
