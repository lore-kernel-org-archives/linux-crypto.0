Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3A2481ABB
	for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2026 09:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789552669; cv=none; b=LYYetVOM7C1ttnklT5dkN9aAK30Ny5T5uNs3oB2kORKSkLjAbK/ffYAamlxtaFy/J0LDmklOmaU69V59OPWqiaiI1wF0UBONqsD+aGy2Co5U42awaA8UMkNFxLGfMtlXxVZXl1yGYbuXPMuLYOpRz4D6ptNbE0qCMOWtcqZWCcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789552669; c=relaxed/simple;
	bh=ajlN1Ovw9D6OjwryUfFltSYQnV7VqKjOO2CmQIczu14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fo0YrvXCBcC8ADOljr279XzN44TpoEURPFcsGo2/Aal6EndN6E/RCJhmUdxQQr9rIJUlTHPivbHKh/f+Df4zlWLPXGcKC/kfhLfGpoPjF34A15EhAvY35uyVEM8zq+g3k6tKgimswLUlxtWZu0FulbXNKmYIUZWefIzoggigv7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=J6PytsE4; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="J6PytsE4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=voukWPmWs1egwBhf52ERer4eBnmSmOdbXAbybr1/NR8=; 
	b=J6PytsE4vskVm7r7AzNLbjY3BTpN5MTwtQ3H4JMrC3248qSYf4up6LUiyPeqkjBxdgQszt3Xjun
	riCWRzRBPRGAQ/8i5fbkJ8lKvTdKI6yISIEqgkhPeSlMcs6HEEo1fHY0xQlwpHpOqVrG19UjvdU2i
	tpYCkIzrpX8wzw3oAXw5h/jgDrHHDqNaLvn6eBvO3EAgJjrumomFvJqdWHVBwTJgudorJbH8TgRiG
	g0m2Ta2Uc6jlI65UQxBnooVH2MrtGc/NOux3egEtQIon8zyC4jEUmDe30RCTp6/L9RfMLDSm7l2ad
	E5nsHEpwkhVY7n3v/BGdqdpy6HhnvxCyLzuA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x6mOP-0000000EZBj-3gUu;
	Wed, 16 Sep 2026 17:57:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Sep 2026 19:57:29 +1000
Date: Wed, 16 Sep 2026 19:57:29 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: nitesh.venkatesh@intel.com
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/2] crypto: qat - fix KPT disable and clarify ABI
Message-ID: <aqpoCTKQ3e_En90V@gondor.apana.org.au>
References: <20260831063355.668528-1-nitesh.venkatesh@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831063355.668528-1-nitesh.venkatesh@intel.com>

On Mon, Aug 31, 2026 at 06:32:32AM +0000, nitesh.venkatesh@intel.com wrote:
> From: Nitesh Venkatesh <nitesh.venkatesh@intel.com>
> 
> This small series fixes a recoverability issue in the QAT KPT (Key
> Protection Technology) sysfs interface.
> 
> Patch 1 fixes the KPT enable sysfs attribute so that '0' writes are
> always accepted when the device is down. The asym-service check
> previously rejected disable writes when the service was not 'asym',
> leaving KPT reported as enabled after switching services.
> 
> Patch 2 documents that the device must be in the down state before
> the KPT enable attribute can be changed.
> 
> Nitesh Venkatesh (2):
>   crypto: qat - allow KPT disable when service is not asym
>   Documentation: qat: clarify KPT enable device-state requirement
> 
>  .../ABI/testing/sysfs-driver-qat_kpt          |  3 ++-
>  .../intel/qat/qat_common/adf_sysfs_kpt.c      | 24 ++++++++++++-------
>  2 files changed, 18 insertions(+), 9 deletions(-)
> 
> 
> base-commit: 6f440283743bd408bfe95a3d1f77aac559130e39
> -- 
> 2.52.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
