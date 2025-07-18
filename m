Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0302BD585
	for <linux-crypto@vger.kernel.org>; Fri, 18 Jul 2025 10:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752836219; cv=none; b=HMSMs4WPF69J5r8yh8nebWDv86PqiJJAoybT6OVPvoZ1K91dRlEt6o8rgNLjeWH1zAOO6pce81DWKiACaJ8BsgI9owCYh0OQgHNTGNsw55Kx4M7Wdvngyve6DrV02O3taU6a+3hkE6rPuMxg4KTggHOSFxr8UUwjfoUuo1pFkmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752836219; c=relaxed/simple;
	bh=xBVrOiwNHaGSwlaQPtSzOsa0S8PL5SFbxGFm58EylS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MCFwpnA7m13M9HK9FMI4XJROq2HKSee9remZ0ynwNwEqAORcs2RzWc/Wilumd4V1Zt0HME0a967Tknd2j5cWzsge82/nIqYCs/ftrND4C/rHt0QiGhe0xdFBb1DVmjtU8QCfjZZYe99POyjYbURVRkFvPOtAz3SPqFMYgb/oYic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=cVAP3cH2; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="cVAP3cH2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CpXVCWFnYAL55NRP94yk+3DtmOxd4uiOV5zKua4xzbI=; b=cVAP3cH23vDRsm8lr+lTuFtZME
	NCelX9xHS+JtsqMbUJD4CEH3qWgSLxtejRqsiAI3RQhqsJ3OZKMDjAt2iKRNBbUf3QN0Kp9MNDMsP
	+zVus7GdEGnUPxVKef59mjJcbLD5HT95x4v4vVAH7UUBiKwDumL0Q9v3JdclpQVzuKEkBTQ0jRgw5
	T00xgLUDiQORzIKJ1S6Pzp8YyhZ7MVpjmaJ1kBOyy57USWXkhTOAhOkKbrp8l/ecrsHRHE5p2gNmN
	unk7FIk1cLhbXZrzku+yMoLO92bu+jX27katB7vXzRssSk/xToYAkZxYiJDSiQsCMTkPnMs/wlxlx
	9ydGqEgA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uciWP-007yXF-14;
	Fri, 18 Jul 2025 18:56:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Jul 2025 20:56:53 +1000
Date: Fri, 18 Jul 2025 20:56:53 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Bairavi Alagappan <bairavix.alagappan@intel.com>
Subject: Re: [PATCH] crypto: qat - disable ZUC-256 capability for QAT GEN5
Message-ID: <aHoodcd4_Ar_ugik@gondor.apana.org.au>
References: <20250630092103.17721-2-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250630092103.17721-2-giovanni.cabiddu@intel.com>

On Mon, Jun 30, 2025 at 10:20:49AM +0100, Giovanni Cabiddu wrote:
> From: Bairavi Alagappan <bairavix.alagappan@intel.com>
> 
> The ZUC-256 EEA (encryption) and EIA (integrity) algorithms are not
> supported on QAT GEN5 devices, as their current implementation does not
> align with the NIST specification. Earlier versions of the ZUC-256
> specification used a different initialization scheme, which has since
> been revised to comply with the 5G specification.
> 
> Due to this misalignment with the updated specification, remove support
> for ZUC-256 EEA and EIA for QAT GEN5 by masking out the ZUC-256
> capability.
> 
> Fixes: fcf60f4bcf549 ("crypto: qat - add support for 420xx devices")
> Signed-off-by: Bairavi Alagappan <bairavix.alagappan@intel.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
