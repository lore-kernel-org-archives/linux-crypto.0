Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85416233722
	for <linux-crypto@vger.kernel.org>; Mon, 23 Jun 2025 09:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750670713; cv=none; b=HGzNfbEgOCnqMfj//QzMP85sj8k3OH4oDyma24Cp3iCaVziqVoW31gdlQYnQIa5dw7mAYzfGuORJl1jD2qFH6Ooa0PYZYSHKjPh9nTMHoPp0I9GyTNlrj/wM/LPiW6Sbfs6BVjHlS2ZThI7BQdm7GyGf/MeSUFTtzL7TX1sPTDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750670713; c=relaxed/simple;
	bh=l9WLTmBoSvxdT9q3cFLNzRiBSKdLTNmzreyTYlEzFh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DXK23vQlbSvKy6ZjSlNSzdF3sHttKevppciq5akAMjW9avvC/uf9vh5GDI5J1SnKjVCndv9Ju+tpoDM/AX0odMrg7CC9bQaGUUBoM306fMeDl3H+gftmapuUt+SqTGwLWk/Q1Qn4t6eP84rbH9mqoHhBTeZWxl3zS1yTsiQQlJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=TY1X/Fk4; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="TY1X/Fk4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mISj+zgfMUwgsS7kiW/1+TmbLQsDDJNislXtWvRNxNA=; b=TY1X/Fk4tDHC7/Rm968WWBejKc
	gQMsD1aJqR5WfnOzytUrRWxpLBy+SUlIZ+Bq+T+mdrhbcwieSymc+4iiFTizASfUg3jnjUG8mc+UO
	/RaL5ywn9rr/UuS5YNRH5gRdh3dJQP5FkazHpK/Q+Sv3fB79iYc+W54Vw3obPNMZClD/OSUO4zR5B
	c6EeOqVfRUnPeK7mtOMuglEL+qjugVGMBqA4i5KHWqDY7suD8hVdBro+00tB9LBMVCN4kKwx8IOvI
	ov0E1r9DiOcjJ/BY5lhpR/3X9pQ9UK8s1QCiei5RO/HB0du4mwL5CSVoMfco9oPET8OHFk3nbAz22
	GWKm0WRA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uTdAt-000FeR-0w;
	Mon, 23 Jun 2025 17:25:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Jun 2025 17:25:07 +0800
Date: Mon, 23 Jun 2025 17:25:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH] crypto: qat - restore ASYM service support for GEN6
 devices
Message-ID: <aFkdc_ym0-xuKETM@gondor.apana.org.au>
References: <20250617112712.982605-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617112712.982605-1-suman.kumar.chakraborty@intel.com>

On Tue, Jun 17, 2025 at 12:27:12PM +0100, Suman Kumar Chakraborty wrote:
> Support for asymmetric crypto services was not included in the qat_6xxx
> by explicitly setting the asymmetric capabilities to 0 to allow for
> additional testing.
> 
> Enable asymmetric crypto services on QAT GEN6 devices by setting the
> appropriate capability flags.
> 
> Fixes: 17fd7514ae68 ("crypto: qat - add qat_6xxx driver")
> Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
