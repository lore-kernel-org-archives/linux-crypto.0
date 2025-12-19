Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38744192590;
	Fri, 19 Dec 2025 06:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766127470; cv=none; b=otJ11qjYLLhwd2n5r5SQOAa1slVE9DoRU1SbK/VDW2ii/usKHWcd34bRb1rkAPVEjv1O4L5ufC7GvHwcId3+1iUqj/5XnU/F9JWBpJqiZORWDZnSkuBYv5zSiCA1zlBOtWTi9+aS5qmWikvLN3Uk1QUNYrvCl2fDUSDdFkQ5OIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766127470; c=relaxed/simple;
	bh=kbjjyQuzWBinAet1szxeXnXhq1PmwGftyu/8TpkguZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lnooluy03ovdut5jsLtP5tm181KULG5DmD3foSdOEmkz/iSjWLLqFmE/6ZzIixX6XCN2xvg1CywrJIR5cMViyfWFiiotpM4Mv7lPOYbLbp7RhekeL548lUxt1i1/r9yxAMMpYAZeqo4P3eJ+prpLMkLSZeat+HZQpJQrxyIocgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=htqLg5rX; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="htqLg5rX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ydNqyxUFdrrM5NmvtRGrmnQ8TJksDK8qnN2PqeuyVJI=; 
	b=htqLg5rX8KgfAnUbhK1bTeOiy8MDNGBjd/3Bq9ARketVpk0zK9Adi9KH8rv3fZfqoLlkOCv6XdX
	bVFZPuO4QXxob+ejna7PxyIx0FCXr3rYqki8eLX5/3EeXz7RALcw44mUTD8MeNgv15nbOdckfZWFk
	Pb9P2ICThE2fJkqyUBc5QGwH7J96g+keW+jjV2iC95d2VIdKmQcaf7C2ltcNgfpR1yYZQpVLjQCF/
	77nCcjxBQ1BE+/nO+mGxfFMUeHEF0qwh6URkQ43UfmiPlGEc4HjQjZXX7oyEZ9ZeXSSkUDbtBv7l3
	YeOIKPp+n43xQ24IGKLU3ojwVseZ4kz5vorA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vWUQi-00BEYh-1u;
	Fri, 19 Dec 2025 14:57:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Dec 2025 14:57:36 +0800
Date: Fri, 19 Dec 2025 14:57:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Jia Jie Ho <jiajie.ho@starfivetech.com>,
	William Qiu <william.qiu@starfivetech.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] crypto: starfive - Avoid
 -Wflex-array-member-not-at-end warning
Message-ID: <aUT3YBNG1dhWzL5U@gondor.apana.org.au>
References: <aR_i5fbRzQztlaHz@kspp>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR_i5fbRzQztlaHz@kspp>

On Fri, Nov 21, 2025 at 12:56:21PM +0900, Gustavo A. R. Silva wrote:
> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
> getting ready to enable it, globally.
> 
> Move the conflicting declaration to the end of the corresponding
> structure. Notice that `struct ahash_request` is a flexible structure,
> this is a structure that contains a flexible-array member.
> 
> With these changes fix the following warning:
> 
> drivers/crypto/starfive/jh7110-cryp.h:219:49: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/crypto/starfive/jh7110-cryp.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
