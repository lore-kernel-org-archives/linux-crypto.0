Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5298BD30B
	for <linux-crypto@vger.kernel.org>; Fri, 26 Jan 2024 09:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259971; cv=none; b=THoIhNl0mffEhFxeX2urN5y38pOywNLdCHi9QYYBSZbIHm5wy1AaCYfuRS6YHYT/0BgkgRYHHMoDTu/tLA3xszJSQAoWsNN6S3dh/70bYlBggnIWNA7QGR7Jk7vnyEH89EfmySRiC849Ox299r/pb/IquMs406iFoeRjF3FOfCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259971; c=relaxed/simple;
	bh=JIYMR9PKIpQteV+fhrlcQCP1MPn4Ra/MuZxxH52Mbes=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=drj7FtP9dsvqUb7E9SDvonjjRC6oT5xyqIZWWv6t7JxwEjQ2csXUHadSmK2dksYu3OSgh98JklA51L77QytlbCJ7g0EbGRUBY+4DDuIi5cwtQG8QR+r8QuiackHDTvZ1US1gCrLwKRjAtIszjZX3St2ojdDtwAfhlAEZmluiOgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rTIA1-006Ety-6s; Fri, 26 Jan 2024 17:06:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Jan 2024 17:06:17 +0800
Date: Fri, 26 Jan 2024 17:06:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Cc: Damian Muszynski <damian.muszynski@intel.com>,
	linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH] crypto: qat - fix arbiter mapping generation algorithm
 for QAT 402xx
Message-ID: <ZbN2CdAtOLpSUYzh@gondor.apana.org.au>
References: <20240119161325.12582-1-damian.muszynski@intel.com>
 <Zaqp5+mL/Gg2i/Oo@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zaqp5+mL/Gg2i/Oo@gcabiddu-mobl.ger.corp.intel.com>

On Fri, Jan 19, 2024 at 04:57:11PM +0000, Cabiddu, Giovanni wrote:
> Hi Herbert,
> 
> would it be possible to send this as a fix for 6.8?

Yes I will push it along.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
