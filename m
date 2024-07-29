Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D928172D;
	Mon, 29 Jul 2024 16:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722271222; cv=none; b=dh6YhFuEoV9IuJY/rgofkec+ot1akLVSn/YmuZp+xGLYpX0iM7sim6pMfZ8kX71PRqRJxGEI1tt8PXRcK51OQlmeglux2CKQ0zTxpnCTz4+X4y6oorfn4YHUIbQ4XzpZi5hibD1C+Ohron1BLxeryPUyaVnxOqztgydDuBTwVXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722271222; c=relaxed/simple;
	bh=Qqac7h68dfeMELAlP8KOuokNg5MyfdTiO6541leHuTg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VWC2bmalFUcoNoRWaDvbhlwkbG2oxpwSlerTfr4CDXgY0nxZRibZSPa3lgkCt8lJXyeIH8g6xfxlitmA7oDKzXn0SzXgzx7vJeuAh9zmgiDwhS7NIbTXbGEK7MTKtlUP0K5z4f4g0jn2xSBhGoZzODJwp112ruqP9qC1kYPqejE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OXIpy+Ry; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OXIpy+Ry"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722271222; x=1753807222;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Qqac7h68dfeMELAlP8KOuokNg5MyfdTiO6541leHuTg=;
  b=OXIpy+RyUoz4jwiryYSgzUVJwkodj8gsos4jSkSkahgWg6NQPy5Fq2jV
   FOSd4JRjbWcIvFeHmcx2ahhOBSg+Zi3Mh+szyyXfsUVuqk40lT5m79hzO
   Oaa04THZgtOMWRWMljaAdvM1RO3EER580QkaZte/iEoT68DOA+YmkAcoY
   0QSJcGGfWNSAPhR6ylER/gFQY7ZVEI2QaWPnau3/fqddzPbEw5buiX0CB
   l8p5vGIqJmnbiwKaQla14eRRkMIizjWKisYe5rJvi7LwPOexUfWQBVDrD
   rYeoC4kSt1UkyP1DjnZie3Ke9Yz3JU/lfrwnHiqAZhf2GfVVqwA2O/KoU
   Q==;
X-CSE-ConnectionGUID: ZS5PJIJPQUmRBc1qAi8/Ag==
X-CSE-MsgGUID: A99gNCEGSHWUXVD7UZhIaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11148"; a="20170603"
X-IronPort-AV: E=Sophos;i="6.09,246,1716274800"; 
   d="scan'208";a="20170603"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2024 09:40:21 -0700
X-CSE-ConnectionGUID: 2x184MsDSLu1Xt4hERrv7Q==
X-CSE-MsgGUID: nGlv5BkURE+HvqK1vrFb0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,246,1716274800"; 
   d="scan'208";a="53927560"
Received: from thanhnho-mobl.amr.corp.intel.com ([10.212.114.80])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2024 09:40:19 -0700
Message-ID: <d11ad678099ccce94eacf721c8d06a38129ce2d3.camel@linux.intel.com>
Subject: Re: [PATCH] crypto: iaa - Fix potential use after free bug
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	 <davem@davemloft.net>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Mon, 29 Jul 2024 11:40:18 -0500
In-Reply-To: <e049271f-41f2-4d04-ac69-80186f2eecd9@stanley.mountain>
References: <e049271f-41f2-4d04-ac69-80186f2eecd9@stanley.mountain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Dan,

On Wed, 2024-07-24 at 11:09 -0500, Dan Carpenter wrote:
> The free_device_compression_mode(iaa_device, device_mode) function
> frees
> "device_mode" but it iss passed to iaa_compression_modes[i]->free() a
> few
> lines later resulting in a use after free.
>=20
> The good news is that, so far as I can tell, nothing implements the
> ->free() function and the use after free happens in dead code.=C2=A0 But,
> with
> this fix, when something does implement it, we'll be ready.=C2=A0 :)
>=20

Good catch, thanks for fixing this.

Reviewed-by: Tom Zanussi <tom.zanussi@linux.intel.com>


> Fixes: b190447e0fa3 ("crypto: iaa - Add compression mode management
> along with fixed mode")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
> =C2=A0drivers/crypto/intel/iaa/iaa_crypto_main.c | 4 ++--
> =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c
> b/drivers/crypto/intel/iaa/iaa_crypto_main.c
> index e810d286ee8c..237f87000070 100644
> --- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
> +++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
> @@ -495,10 +495,10 @@ static void
> remove_device_compression_modes(struct iaa_device *iaa_device)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0if (!device_mode)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0con=
tinue;
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0free_device_compression_mode(iaa_device,
> device_mode);
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0iaa_device->compression_modes[i] =3D NULL;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0if (iaa_compression_modes[i]->free)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iaa=
_compression_modes[i]->free(device_mode);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0free_device_compression_mode(iaa_device,
> device_mode);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0iaa_device->compression_modes[i] =3D NULL;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0}
> =C2=A0

