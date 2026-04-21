Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194F430DD30
	for <linux-crypto@vger.kernel.org>; Tue, 21 Apr 2026 03:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776740504; cv=none; b=TYTPG/A9MXdLnTyvxlYogI++VBN9YJvTZhvm2bZza2BMOdjB/a0O5jdES6bFhMLD0eHgo6cVKJK6F02RY77f7PoEugJ7YfsZbdJfJA8aMTzGOj/8vvVFXzfcxbPBElAxHvu9pt71otfPkF1aQe7t/JXMnJgcWj2Hba7sWxkNaXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776740504; c=relaxed/simple;
	bh=VnUtvUOgLJhwYBXGwSTkMGijftfKaKRIbA+Uz+mhn/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bRHXzxCWUggng6nZr43IFSywS8SflyESBaf620rQCEB1pJMMMOcup2oYYv4uiakvE0q9xGBXKzqqw8QcPq7Y9kK8hFU6Tt9kknL84APh/3Yf4DFel6IMwZrHlDAITj/cttSQcYYtfnZ3QMZ/KOnRJZBQwbYwj/Zkk0rMA47G1aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=BWRm62Ok; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="BWRm62Ok"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=DZAARs3cc1ka/w/U4nXlkJlgQqgEdrr0EnjGxxSrwrg=; 
	b=BWRm62OkYr+cnAi/LcBiNgaJfNpYd1CN0cvlvb+mw7jkaA7VjY0nNaHHJwkFB2SvNGCmQYmYp9+
	EfW+8vSpBHUNwudD0wIoqJ7dHKjscKqenxZi/GNOgXkgirErTH0VmSCLZZ6/zA5/le0Cq3X7yxDEV
	BL558ggMdv15TvV9fm/LBITHBDp2Ukm41k4lBaDiASwFacaDxnq/llEOVukGcXqFXC3LPVzf7FiPj
	XZBu4EpX0JupdQjVE40pAnLuZiZUSk+Ne8ZLwPy8zp9uBRBbU3oThuqRXuWv14/oYM4TjjgEV2udM
	oVBEONu85TdcFVl92ZevCcLNBH6CDa2SbfaQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wF1MX-007b97-0e;
	Tue, 21 Apr 2026 11:01:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 21 Apr 2026 11:01:21 +0800
Date: Tue, 21 Apr 2026 11:01:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>,
	senozhatsky@chromium.org
Subject: Re: [PATCH v2] crypto: deflate - fix decompression window size
Message-ID: <aebogashLMMuB9lg@gondor.apana.org.au>
References: <20260326100433.57324-1-giovanni.cabiddu@intel.com>
 <ac8I4mpkdn8uy8TE@gondor.apana.org.au>
 <aeEWf4j+VO0FziNj@gcabiddu-mobl.ger.corp.intel.com>
 <aeXo79eNiYnJ2ImV@gondor.apana.org.au>
 <aeYB/Jjb885fJ/mU@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeYB/Jjb885fJ/mU@gcabiddu-mobl.ger.corp.intel.com>

On Mon, Apr 20, 2026 at 11:37:48AM +0100, Giovanni Cabiddu wrote:
>
> Yes, I see your point, and I need to think this through some more.
> Some hardware implementations may not allow configuring the window size.

That's fine.  It's just like hardware that can't handle all key
sizes for AES.  You just fallback to software if you encounter
parameters that the hardware does not support.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
