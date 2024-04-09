Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8A253AC
	for <linux-crypto@vger.kernel.org>; Tue,  9 Apr 2024 22:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712702327; cv=none; b=grpCCkJvWQr4yoePO9W3Hz3XzIcdaYvfPrMf70XIxc4wLCIcC1LypEQM2byJNOeqoEP/kQiDhb+J2Ij8QRGnRKbrlMRa9NHa8IvcsMH76Ipa2Yfppx0RpaMnLBJiGarN7fYmkISw6vSgYgZ/XNynk6AJlLwfeclPQVV1CvRoniE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712702327; c=relaxed/simple;
	bh=IeI5GxkijUCE8sQqNBpng1bCSHmPid/8ATkPu6nDI0o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J1ebZFDswtHiBQbs0iOZGkEMgXx9oCw0WB7crJtmo3RdmJoStVmvsC/2iJt50RpcbcI21Cp/AEBoAqqraQ+dVvhiSLH84J8v7XYFw5UFA8zSMnG2nJMxlHjcClZs+98t3vBLTHKkWCCPimfLY6vS0e+ykYHrkroyCJJxxMVTVLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RzA2nLqm; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RzA2nLqm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712702325; x=1744238325;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=IeI5GxkijUCE8sQqNBpng1bCSHmPid/8ATkPu6nDI0o=;
  b=RzA2nLqmc8q1OZt2+/l9MI32mipxNhTT9Dt4BRqW8BeQkInrJ5w1pR0x
   eL0MEkBd/eMZY6A+1/MJZiEs17dZa9YYGvd1f+urIOYa1y2SWSLzoI3/D
   RmYYSGALWc7OxKiDACJWjQ9xtexuiygd/jc1Z3Kqnj9gZCO6fuwHhFxm0
   Ar8c+PXnuaw3bEDr3Wva/N3/6zdX7iC9BA3xutGttMkKX/jrRTlhzn3tr
   3841eT5GqQYjI4PTqPdjXM0fmCSvNSA+/amRlbP/Msr7HkDQo0xGEKNdS
   g88eSUEpkEbf/jsEmWvFJsYcPwIOGHRRqlGz/fjkT3m9svAuc3q/Hg2qf
   g==;
X-CSE-ConnectionGUID: fkYopaZtSEawJab7lP474g==
X-CSE-MsgGUID: 5ciNnw4aTlKoSFMwltqIQw==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="30528451"
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="30528451"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 15:38:45 -0700
X-CSE-ConnectionGUID: K8t/kdWVTbqxzSakJ+FjBQ==
X-CSE-MsgGUID: TxO3FAY/RQmiBD009Mqbfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="25038744"
Received: from amatsuba-mobl2.amr.corp.intel.com (HELO [10.209.3.203]) ([10.209.3.203])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 15:38:45 -0700
Message-ID: <7143e83261b20f281fcb5913a23c785199ade357.camel@linux.intel.com>
Subject: Re: [PATCH 3/3] crypto: x86/sha512-avx2 - add missing vzeroupper
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: x86@kernel.org
Date: Tue, 09 Apr 2024 15:38:44 -0700
In-Reply-To: <20240406002610.37202-4-ebiggers@kernel.org>
References: <20240406002610.37202-1-ebiggers@kernel.org>
	 <20240406002610.37202-4-ebiggers@kernel.org>
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
> Since sha512_transform_rorx() uses ymm registers, execute vzeroupper
> before returning from it.  This is necessary to avoid reducing the
> performance of SSE code.
>=20
> Fixes: e01d69cb0195 ("crypto: sha512 - Optimized SHA512 x86_64 assembly r=
outine using AVX instructions.")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/x86/crypto/sha512-avx2-asm.S | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/arch/x86/crypto/sha512-avx2-asm.S b/arch/x86/crypto/sha512-a=
vx2-asm.S
> index f08496cd6870..24973f42c43f 100644
> --- a/arch/x86/crypto/sha512-avx2-asm.S
> +++ b/arch/x86/crypto/sha512-avx2-asm.S
> @@ -678,10 +678,11 @@ SYM_TYPED_FUNC_START(sha512_transform_rorx)
>  	pop	%r14
>  	pop	%r13
>  	pop	%r12
>  	pop	%rbx
> =20
> +	vzeroupper
>  	RET
>  SYM_FUNC_END(sha512_transform_rorx)
> =20
>  ########################################################################
>  ### Binary Data

Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
