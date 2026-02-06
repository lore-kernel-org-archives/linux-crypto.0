Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D8C239E63;
	Fri,  6 Feb 2026 11:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770375687; cv=none; b=WQdTPocsB0rFhhHDXJdhCm8irv6Y7oG7AvRM203S/y+IPTgsvfgoXxvYxxsathUXk++P5gq24hKP8erCMuOnm0fePGysiQv+N0xbb28HddU64R2J/q0ZgqOCW0e6ekWutu7cFih5PB3KO/kuRTuaeCZe1NQBeHjl/uCvForfSUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770375687; c=relaxed/simple;
	bh=kApmp4DOgbJs+8dw1giGSgmKb/Birx0IQOKaCXdaR/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b2/yjx+wD7MWorJ9jVXWw6vIexxMf6141d535A6YPBegS5JTc8ry2QjmtC/bG27flYvtFFzjnTvCJzpZOIxFEujr7PmHLwVJD5xeHe9+yDBhG1q9oKZbcr68B7bhtgYF5jX0o3O/c2RIID/OSC8rWTdx4S/uU/3KuY9IS5eCUfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=WCgCZ16h; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="WCgCZ16h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=kO1AGNsvdxqYmQaD/xccSvvXSgaUptV5c7qiHvmiuEY=; 
	b=WCgCZ16hLztt7nzPGrL/KLwtDb2Fjq7cAgXGmSctobAE9SwTH+makLE4Zqh1Lvk550DZSe4bY3M
	8VVi0BBRs/TeGqhlGfqdEAUSypCinDMmYeEYJBhM/l2AVsV8BPgOPZIVmPOIziJK/ychsmiXcjsyy
	hcsK+T9SfWE2OxNbitSAwnW7rJ/t1PEZ2ZCDt6Z4+hfjuTbxn0ok+yApAmUFp5lO9hqb6COYS12AQ
	eCpjufUYFahOwxWHImUWOBODo0sSKCwRaSeFp83CQN6L1/He9fu3AmVJ5u8nKzBwcOc/vP+nFqTAK
	k3OHBBjl4tNEak9rhYGcyxQFAxEZ+SQ9oksQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1voJaJ-004zWo-1i;
	Fri, 06 Feb 2026 19:01:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Feb 2026 19:01:11 +0800
Date: Fri, 6 Feb 2026 19:01:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: davem@davemloft.net, mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com, linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: testmgr - Add test vectors for
 authenc(hmac(sha224),cbc(aes))
Message-ID: <aYXJ9-TZm6gq7ALj@gondor.apana.org.au>
References: <20260131174353.4053-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260131174353.4053-1-olek2@wp.pl>

On Sat, Jan 31, 2026 at 06:43:03PM +0100, Aleksander Jan Bajkowski wrote:
> Test vectors were generated starting from existing CBC(AES) test vectors
> (RFC3602, NIST SP800-38A) and adding HMAC(SHA224) computed with Python
> script. Then, the results were double-checked on Mediatek MT7981 (safexcel)
> and NXP P2020 (talitos). Both platforms pass self-tests.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
> v2:
>  - typo in commit name
> ---
>  crypto/testmgr.c |   7 ++
>  crypto/testmgr.h | 285 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 292 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
