Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A7A2D542C
	for <linux-crypto@vger.kernel.org>; Wed, 11 Jun 2025 03:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749611260; cv=none; b=Gez9uh8WSJ91NS3Mgvbv3IfpkNgwxE5kEgMmdw0VaPMa27t/5sv1IU34UJlrAq/aYwz+F1V0KYQwvCsq3d6XIZAzUTPVBgted38wa7XvadFAdy7bOFtNwKqFt2cEt7Ay0yKnrn3jwXGOm2E2lnTgatD/y43zkHx15DZvMMzCaQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749611260; c=relaxed/simple;
	bh=PH21U57bz9GCFMi3dJn1Gfh3ik17GFsf17xE/seXSzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s0ekE+6G2Zx5ME6oufKLFGXFVxU3/iw87hpG/Gf0qI9y93U2bHOsjDoL60DVPvTEOxKa5SVNRvUJABDF6SEeCINxfAZ8JNQ8REgLVIvAToZ++g5d5HTv6k1I0AKLl4dM0V9BaB7UKtwmpModqcpVlDBuXNmeFC6VNJuPN7JCYN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=lfKZWK0F; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="lfKZWK0F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YnZ1hpe+PSaeNprDMvrY1ROtnnWUgzeejoj+oTxLmkc=; b=lfKZWK0Fn6xZ70smAn9fjP55qu
	8ewUVDzvjFNS9g6VNx1VQp/jbxSBhtUU1OkqEJINSN+DAvqOlMFOiDAUO4hDMHreKS4r6thDdibEQ
	mK8zffVyzJiwq+aJ5ds1+qi+2wTxQybTNIUZCqXj4HNLSysrZvKzLay07ipvDQvDIF+Zrs3m49HQ9
	0x6+aLVBpx/wIbMGq3Mtakb7BAxIF36OHw4HVXF5joiV3ccVvA54f6AyQhscAse4TZ3o8ob4MLQJL
	Aor+dz1UU5TDbY45fBozQ2Kb6iwnl4D7HbZCWkBxHlnUvzm3zmAGmQATSk9AltGeBSfFfVZRHpBeQ
	MtX40dhg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uPBoJ-00CFHO-0C;
	Wed, 11 Jun 2025 11:07:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Jun 2025 11:07:31 +0800
Date: Wed, 11 Jun 2025 11:07:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Holger Dengler <dengler@linux.ibm.com>,
	Ingo Franzki <ifranzki@linux.ibm.com>
Subject: Re: [PATCH] crypto: ahash - Add support for drivers with no fallback
Message-ID: <aEjy8yAs4j5vycGx@gondor.apana.org.au>
References: <cover.1746162259.git.herbert@gondor.apana.org.au>
 <c9e5c4beaad9c5876dc0f4ab15e16f020b992d9d.1746162259.git.herbert@gondor.apana.org.au>
 <74ae23193f7c5a295c0bfee2604b478f@linux.ibm.com>
 <aEAX4c2vU46HlBjG@gondor.apana.org.au>
 <c38cecabd936e4fae1ae4639dec3d1ea@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c38cecabd936e4fae1ae4639dec3d1ea@linux.ibm.com>

On Thu, Jun 05, 2025 at 03:29:00PM +0200, Harald Freudenberger wrote:
>
> Works perfect - tested on a fresh clone of cryptodev-2.6 with my
> phmac v12 patches on top.
> Add a Tested-by: Harald Freudenberger <freude@linux.ibm.com>
> Please push into next, maybe fix the typo "hardwre" -> "hardware"

Thanks for testing.

I've pushed it into cryptodev.  Since it is the very first commit
for the next merge window you can just pull that into your tree
and work on top of that for phmac.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
