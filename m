Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55B61A267;
	Wed, 22 Oct 2025 00:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761093335; cv=none; b=gNNy8uQs+EHx47+3pwn9WXGbmvUfLbZUflzUmll1FwsvbDjFSRVfunwlJ5syRuPNxfdQO8oqHstl5fsuYxomVoxv7KeorioFDzH61RSVjBVSmxUukwrGypxfAXCLvsvN9BYIeMVsacqKjl9EH2ejCCpm9UGNvNvPi9LPqdSJyzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761093335; c=relaxed/simple;
	bh=8hRdqy5Yrbx/EhG+2c8n1bTDk146L6f2IOviuCW1FCI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MVqTAlU4FyacmowqHpbSVtwLni7/UuPvy5vj+0608jlGtODyOr0hklfxRWG2ajcFhCDSk3uOG+7E0o1ycqLKWDF3XhdFHCMIwQKlh/MAMrt+0UcxknyTEE6POKVWwqgWvcejZIpzT8LWAtMuAq2ztC4eMF73LtUl65AV/Cmn2EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=PLltQZbU; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="PLltQZbU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=9HPnGCRMUx0VNHlx3dB3LZrNA7OZibLDHCKrVeOOBvA=; 
	b=PLltQZbUos+LVWwks8BshulxuIHSS2krOiFwPSEE7XtFrgkV8J0a8o065V2IOJYTzME/yPGltMM
	5QuPe+NjKkf/u+XjtWaOU8p6MRXlxBFz/0yj04Oph6cyiXx5nyOZt2bGXsKhyCdzrM289WtrcPFOw
	SFDahQUteeM8OFoLbzRLMUg8JTebM2QZFu/XRK/IlfKxhKIsekbAHYgm+VGFs7OsOPhE4JpNmtMeH
	FoGdcysMt+nYuKNBeUHhnU40MWjpe/EfKjBE7uSjp2R5zVxeUtwxct3bTHsL+kgGeDlqbxtlwoFyq
	8m5PU7p9GEuIsbyT6uJ+wcqjf65OwtTPjjQQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vBMox-00EXM4-2e;
	Wed, 22 Oct 2025 08:35:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 22 Oct 2025 08:35:19 +0800
Date: Wed, 22 Oct 2025 08:35:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>,
	Kavitha Malarvizhi <k-malarvizhi@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/4] crypto: ti - Add support for AES-XTS in DTHEv2
 driver
Message-ID: <aPgmx4LrekeGkidq@gondor.apana.org.au>
References: <20251009111727.911738-1-t-pratham@ti.com>
 <20251009111727.911738-2-t-pratham@ti.com>
 <aPHW_zyWwA36Usy1@gondor.apana.org.au>
 <07032efd-52a2-44e1-89bd-81602be9eb32@ti.com>
 <c76843e9-e644-4b9b-803f-b9eb9a31b89c@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c76843e9-e644-4b9b-803f-b9eb9a31b89c@ti.com>

On Tue, Oct 21, 2025 at 08:40:40PM +0530, T Pratham wrote:
>
> Since a similar mechanism is not available for AEADs, I was wondering if

Please add the same mechanism for AEADs.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
