Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFD02C159F
	for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 09:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749807275; cv=none; b=ciX+ZrVo/40vhBJwuS4Kb8j+blSsMrER70N/SMBPboZoQStrsKIgH144ECopRpWxGKpjsP4/dodvd8FdXuAFMCQ0gNCGHCfhmR9n1szVCLswmSKG/VRLaj67u+5S/QkEGz8EtwqFY9JPbqlZKYuZKCneXCAzlM3vEghpEuFc2y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749807275; c=relaxed/simple;
	bh=1AGC0apQfmplOKkNVT6kMyh0sWwJ0KcaaseA3gWo39M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pGIRPL9bdJyvC3jERfdzuYn0HRvq+V2Uqk2kv/9SLxrK2Uo8O74bTrHeShMD0OaN//e1RJUjbYPjrgdnUVw+Yw049DmaG1M0bWdcGaKmLmdcqbDIeTary6Wr/aWZvP0jrFwqzpH6zdFCdp9N41DqcCj6AwQhVyNLijWl/Z83oCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=iexHYeWt; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="iexHYeWt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=eiDldQfPfwzKSr2JntH/XpjfiXohsB4ICRa2zxFfcII=; b=iexHYeWtJsK0DV7P+1TVBwRz3h
	Zgm1nV6g4EMPL/2bFrWBhEOA1uttsTYNqzER9XXFGs4gR/9Ct3G2+6KHMg282WdkswmCe6+Q2Yt7u
	AtryceQNsPH2pzYT0FAvbtb9t1qPq9ANNyESiHbmL1qfBDa5vPqqAvc2FwBm+JCs8Rom4uAgaG+OR
	2hySn3SQn957Z8tv5X9PLXXBv8N49w2ZWD+ppNwla6Gr0Lpbx+Gikuv6MtVvUaIK65RVDOO2xdHAh
	1OvROULpINxDLZ9gF2KKFSLiGyxbZv4k6orfBazb058sn0NffzcqfIfWwINVblGYTqbknjBIb0zjk
	GPVhTuHA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uQ0np-00CsvH-0b;
	Fri, 13 Jun 2025 17:34:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Jun 2025 17:34:25 +0800
Date: Fri, 13 Jun 2025 17:34:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mario Limonciello <superm1@kernel.org>
Cc: mario.limonciello@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp - Add missing bootloader info reg for pspv6
Message-ID: <aEvwoaDXZpvwW25g@gondor.apana.org.au>
References: <20250519152107.2713743-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250519152107.2713743-1-superm1@kernel.org>

On Mon, May 19, 2025 at 10:21:01AM -0500, Mario Limonciello wrote:
> From: Mario Limonciello <mario.limonciello@amd.com>
> 
> The bootloader info reg for pspv6 is the same as pspv4 and pspv5.
> 
> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
>  drivers/crypto/ccp/sp-pci.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
