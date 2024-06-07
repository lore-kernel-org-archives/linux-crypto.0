Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DEED53C;
	Fri,  7 Jun 2024 12:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717761673; cv=none; b=b/znTz6lB8E2PgmEP3Egbz670u1MhUebkj9fqppBl1WWEUzNpNLc+z5vctL4yjx/13rGOQCI0tArNYp3Zxpr4fpCqYfs4NJFOXARmjfWjf6MO6nE8ytl5U/E2kxuEJagMnFOo6zOmKW/TW4ug5PnKk5Js40O61mgn22Te50tJEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717761673; c=relaxed/simple;
	bh=8p8fuJbHt7CqPeFdlzjmbu8BWVDXgU7Df/yWpxLttSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hFucBbvFI2tdIN+eo3uvq+g8f8fopXIEQwcz5ja/LmfqttZ79cl+mKLwbgHlhFf+G33UxvOJ7h8BDCZzE7jDBAnT+g+dai4mc1ZbiXYM2qqAShs8QiSl8i5h/LtJo+MIGDoMgnMMYwIs/KB/vKa6+7VWsNcrsBqyicZBeH5k0ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sFYHI-006pMd-0M;
	Fri, 07 Jun 2024 20:01:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Jun 2024 20:01:06 +0800
Date: Fri, 7 Jun 2024 20:01:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: sa2ul - add missing MODULE_DESCRIPTION() macro
Message-ID: <ZmL2gqDd6ATPVzxd@gondor.apana.org.au>
References: <20240602-md-crypto-sa2ul-v1-1-78f8a3112221@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240602-md-crypto-sa2ul-v1-1-78f8a3112221@quicinc.com>

On Sun, Jun 02, 2024 at 04:11:17PM -0700, Jeff Johnson wrote:
> make allmodconfig && make W=1 C=1 reports:
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/crypto/sa2ul.o
> 
> Add the missing invocation of the MODULE_DESCRIPTION() macro.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
>  drivers/crypto/sa2ul.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
