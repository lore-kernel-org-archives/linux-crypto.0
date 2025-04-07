Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083562222BD
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 05:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744003697; cv=none; b=Nd2ImChZguJji3SKEtmcMfg4td2B8ylgsP+mKOoReWamhIUZh116hBO2pv1+mNMEB09FwdJzNGr0UfDqanmE6Evi+Z2QarFqPkalP+siLJNb12HNBL+Z9mVHay/aQCR/traPxnKiNNJOHkIxMb0rnJrawJGyvTwuMgMncVsMwvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744003697; c=relaxed/simple;
	bh=gmRLFlxd6p7Tx1rr2BHM+KX2TE1JKt48ZHcXyb209F4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YyI2GfRN1aHciuQlS1mQ3CN9wiA/QBz0HZiqpIQ8MGYCSyIQge/OjXHBqwyt4RSb51owhC+Um1b3Gr3dWJ4hEGyfnVcfnCmE/pMNvhwdKjV0WPNWY6O0NwWQOreg3mTLKljIUQuGhyy6Q1mlnJdbMT1eATJgssQ3hBVAYqrm4jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=mIfMCME4; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="mIfMCME4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WBjE6oHYrr/fywO+EfPCvEeab8eIWPtZXB0Gw2mLcC8=; b=mIfMCME43gRz7uN3NLSBoyJRD6
	wCPLGI8Or+QLNed6Ux9xq8M+v5uAZ1c9cMt8lQVWUknkdMezCVo0SPsXqAL+6wO79g99TJgm818p9
	bbspOalIgtiQBXAftSUJ4gRCw2gVvBPxfs1yo0Ld6QdcsyZ/+EBO85U6FhKO8sHtyuoLa6W6vxno3
	2sRZh8qKmMnZJJSJJfBoV794ZineOlwMByf0Saq19lY9QfFxL5wQKVHEVKfx5wBJe6z+WYiOsA8Jo
	mCEWOmlKUko+edO+JEnj6aK7HCN4PI8ozwOG0JTEmcCswswRuulkbWmV69+MCMOPcTIiLylYyC0WJ
	832JszGA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1f1k-00DNMl-3B;
	Mon, 07 Apr 2025 13:28:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 13:28:08 +0800
Date: Mon, 7 Apr 2025 13:28:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH] crypto: qat - switch to standard pattern for PCI IDs
Message-ID: <Z_NiaH123l25mb0A@gondor.apana.org.au>
References: <20250403200734.7415-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250403200734.7415-1-giovanni.cabiddu@intel.com>

On Thu, Apr 03, 2025 at 09:07:28PM +0100, Giovanni Cabiddu wrote:
> Update the names of the defines for PCI IDs to follow the standard
> naming convention `PCI_DEVICE_ID_<DEVICE NAME>`.
> 
> Also drop the unnecessary inner comma from the pci_device_id tables that
> use these definitions.
> 
> This does not introduce any functional change.
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/crypto/intel/qat/qat_420xx/adf_drv.c     |  2 +-
>  .../crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c |  4 ++--
>  drivers/crypto/intel/qat/qat_4xxx/adf_drv.c      |  6 +++---
>  .../intel/qat/qat_common/adf_accel_devices.h     | 16 ++++++++--------
>  drivers/crypto/intel/qat/qat_common/qat_hal.c    | 10 +++++-----
>  drivers/crypto/intel/qat/qat_common/qat_uclo.c   |  8 ++++----
>  6 files changed, 23 insertions(+), 23 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
