Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6D11632CA;
	Sun,  9 Feb 2025 10:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739096689; cv=none; b=r7rL+4DlfiM2wMRdyhPGDO6Nm7b5nSrBgIgwxpH/XGQzcc7GS6qM8lv9WAg8dzNZqDKXVWIkmJDyvMH++GEzvgmL7424DH8cSTaE6ElXkzcbaWXFMxanVfMxRv0qHMuEHcJjdt89gjLpF7qeQqlMwZEwXywFWIhfxaT5KmFGuGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739096689; c=relaxed/simple;
	bh=3NCPduHHQv8qdKsgN94aNo0UPsTGxLa4UahtZr2kT0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BwSbnoVe+WDwxOLUZS33UGQxxaZG1Peql7hk9t63o0biFnGBfXGbXJGCY3O9HCMph1hXrqoRDJyDp6+odC1k3Hdm8qYBRwBVrjE7HAiGZ3zLU9oPc+/YuDp4LrPPgFhxERyhlMMmX7wso7hJYXlIdX5XIImPG/zxSqRMKN0h+CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=SYscmWD7; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="SYscmWD7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6BS69AeaICn+Fpx1fgS+yRMjzgfzhGmys0CnrPMcR/0=; b=SYscmWD7QXTNk+BGGsr1+Z0kSx
	DptDF9tlATofOY+gKDyzQ31DoNAvqVTwRXKz/rKwfT4MAH+cmpeFiZv8ntQDHSIBse7YZ1AQqjatR
	h3nCinNNB/eJTTAYUGKBe4UUjHnFMSoJo+Z6s0g0RZXIHI6PMpMNUpSGVtzOBFlevmBDFrTBIj9yp
	HWHoLn02cqZywxdy1SkQFrWZUpR5ncKGt7/cfNzIBE/w2X66hEyovyFIR2fEb2/rjdgaKuPzXdwBG
	jWCehWAxeOztg0pYIYlma69D2vvk2h/vmTt5i9heCpBeTFHG4mjgnBAa9rUNJONFY+u8NtxXz+A4f
	oJjvWTKQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1th4HX-00GIpf-2F;
	Sun, 09 Feb 2025 18:24:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Feb 2025 18:24:40 +0800
Date: Sun, 9 Feb 2025 18:24:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	vinicius.gomes@intel.com,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Add Vinicius Gomes to MAINTAINERS for IAA
 Crypto
Message-ID: <Z6iCaMpVHQZAg85g@gondor.apana.org.au>
References: <20250128235744.1369399-1-kristen@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250128235744.1369399-1-kristen@linux.intel.com>

On Tue, Jan 28, 2025 at 03:57:43PM -0800, Kristen Carlson Accardi wrote:
> Add Vinicius Gomes to the MAINTAINERS list for the IAA Crypto driver.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
