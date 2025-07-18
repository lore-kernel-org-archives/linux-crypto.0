Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC12249F9
	for <linux-crypto@vger.kernel.org>; Fri, 18 Jul 2025 10:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752836380; cv=none; b=hHg0JGiQtWOh+l5uh8AosCx9MgHuGWZR5bvLf+thPUaWfQeZF0qymt91wxMKRA75hG4Nw4wKI1HQnBMSuk8P4r/G5dpMDxtrhN0sJ2dUVw4qzjYe/3MaTOHIaLYC+algMLY71HxB52QtSjo/hV5foYFeM06XhJdRweJ77BvfpvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752836380; c=relaxed/simple;
	bh=160yC/iG6Fn/YHjE0/g00NZdRiROLH6U1vEOKJ1a830=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nyihIgwlTjRHB31CbcsxqCwPMzr3rArlz1Z01ts7+FAG8bGg04aJdNWZ5g6TH4Pcclw7CgEhgDd3SC+xG5UNA4EC8EVrki2i6tIHR8QFogb1BW+ywdlpCJv3p6cu9Ou0fYgX62crp16j+m1Wfgeo9ATNdbBmwUjhxi4AE10hy40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=aU6NGvAR; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="aU6NGvAR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NNYAUGkwLxMNNvkNRL6DKpL8cFzSPNDlRSU1HLJ4w44=; b=aU6NGvARAUBt60/Df//dFtwCeP
	0/SyCM8v29rEeiTjoE2Fz/Sr9ZEtT7UYP6yxsdj1YaTCD+9AsThY9cHgn+NCfEBtS6HeW/FnWoVHx
	hHNFkpSxorMdnKNGpkJLDKc1XKiAF+NMOp7Bo45/NxO6WH1BW35gKyUJwX81PUKT6w5VeFRWb5nzQ
	uUgimDW3T6Fqmx9bIL4MaPLcm7TXUfOC/1pQECyqcnJkJkxM9TxLwwJA5V5PbEolg48oCqP5YJQ/u
	fbnysoNLybzEWKD1Xkxt5Fd8H3qgktE62o6wjZi40IoKIr/8cEjNr56gM6E/EI/rKEHC4/Njl4T6O
	pJaktxUw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uciZ1-007yam-1B;
	Fri, 18 Jul 2025 18:59:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Jul 2025 20:59:35 +1000
Date: Fri, 18 Jul 2025 20:59:35 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH] crypto: qat - fix virtual channel configuration for GEN6
 devices
Message-ID: <aHopF9cx9pP4knIZ@gondor.apana.org.au>
References: <20250707085417.1286691-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250707085417.1286691-1-suman.kumar.chakraborty@intel.com>

On Mon, Jul 07, 2025 at 09:54:17AM +0100, Suman Kumar Chakraborty wrote:
> The TCVCMAP (Traffic Class to Virtual Channel Mapping) field in the
> PVC0CTL and PVC1CTL register controls how traffic classes are mapped to
> virtual channels in QAT GEN6 hardware.
> 
> The driver previously wrote a default TCVCMAP value to this register, but
> this configuration was incorrect.
> 
> Modify the TCVCMAP configuration to explicitly enable both VC0 and VC1,
> and map Traffic Classes 0 to 7 → VC0 and Traffic Class 8 → VC1.
> Replace FIELD_PREP() with FIELD_MODIFY() to ensure that only the intended
> TCVCMAP field is updated, preserving other bits in the register. This
> prevents unintended overwrites of unrelated configuration fields when
> modifying TC to VC mappings.
> 
> Fixes: 17fd7514ae68 ("crypto: qat - add qat_6xxx driver")
> Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c | 10 +++++-----
>  drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h |  2 +-
>  2 files changed, 6 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
