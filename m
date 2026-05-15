Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D993BFE41;
	Fri, 15 May 2026 10:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778840068; cv=none; b=FRyla7t+Y2uUAJIX2GPyK/JDiO8MIW89xvYywenYIDX12SGCPvV0jJ1lBSBOjnt+xbTOmA4JyDRn8x3LXh+agJlR1HBOz+DY+nq76lZ43IYUBCyglCMd3caBAw5lFu0s0pHjV8XoErd7xQfhXwAnZg2Mb/WhVW8ntOdQ6iyDOrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778840068; c=relaxed/simple;
	bh=7eWI5XM1nWdyKJ+CYQ72yaBz1Lx/sHeDDacsdlxMx6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qwz7zPfo0bVGvKLcG8H3VX3W2gZMVD0QsJiL8RvG2hyttWen7/Ft5VZ3JJh4LyH8XX16Bndc9R5x4eVkkhQULjKkXBKRWJHqLP/P5cif1/EJewQTwbPdmgtTaFZUdOotXNuILnOP42fr9m8Aom3KG6ajCgiYcMywnOgLkOPlR6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Nazg5jDc; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Nazg5jDc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=sDdjcNcL/9wFHljRXVR/2V2WOx5nSYhOWqD2hR1Zoz0=; 
	b=Nazg5jDcnCKsh1tcTdPaTMj279JwRtSkYUA6zECuhDiqtERxA8sqiVXYxR8qlJwXNn+tnI/x2q8
	bHWL5kkZaQIXVBu1C2HXwskCucck2Gsz6UFmkKd0T/ZRYbzPe4pp9S6KfH+Z+fSCgklB5r+zCq7mj
	5Sl31+6EHrt4LMfmYDDoGBxA1MM/0a1/k0txcj1ooFO8x5hl8HrqdzLfqitP3GauvGD4CsOgopJjc
	4O6p2xpR7bV2ul/7Iqx8H6HExLu13biVRuwN6QOUMPae5XnpVMD8UbBNaPXP5jR+aSqqe5DxojQsA
	vOVRKHRAqRc7DTIqeHBykSJtgtovZTkZGozQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wNpYf-00EOIN-2b;
	Fri, 15 May 2026 18:14:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 May 2026 18:14:17 +0800
Date: Fri, 15 May 2026 18:14:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tycho Andersen <tycho@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Ashish Kalra <ashish.kalra@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Brijesh Singh <brijesh.singh@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 0/4] SEV re-initialization fixes
Message-ID: <agbx-dfKrrFXegmY@gondor.apana.org.au>
References: <20260504165147.1615643-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504165147.1615643-1-tycho@kernel.org>

On Mon, May 04, 2026 at 10:51:43AM -0600, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> Here is a v2 of the HSAVE_PA clearing fixes. Changes are:
> 
> * return ENODEV instead EINVAL for the re-init cases
> * note ABI breakage in patch 3's commit log
> * CC stable on all the patches
> 
> v1 is here: https://lore.kernel.org/all/20260427161507.32686-1-tycho@kernel.org/
> 
> Thanks,
> 
> Tycho
> 
> Tycho Andersen (AMD) (4):
>   crypto/ccp: Do not initialize SNP for SEV ioctls
>   crypto/ccp: Do not initialize SNP for ioctl(SNP_COMMIT)
>   crypto/ccp: Do not initialize SNP for ioctl(SNP_VLEK_LOAD)
>   crypto/ccp: Do not initialize SNP for ioctl(SNP_CONFIG)
> 
>  drivers/crypto/ccp/sev-dev.c | 70 ++++++------------------------------
>  1 file changed, 11 insertions(+), 59 deletions(-)
> 
> 
> base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
> -- 
> 2.54.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
