Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272B52F999A;
	Fri, 31 Oct 2025 09:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761904339; cv=none; b=SmHrvJl43faV0l4PqkanttgXrM7piKCcQsKLn+hFSd1dU77IO4CyIj6fTlUQXgNirpY4GPq2DXsqY55fNoCMrDMXVGh2etwxrMpG+UAcJJHF3ZA6XFxGlz19dc1nNvtxTHnVhL1CbwR9GrOWooq0Pn2R5Cc1X4lJmiW3tGYoeSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761904339; c=relaxed/simple;
	bh=JlYg8KvxZ6wliqjWCrIStyjy3OjRgMhWkErIAOw1qUw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VeNM/ffm/HN66CyCGCcSNP0OwThs6tWLrv4ALOCnLdcJnx7/tXPd6UxVgz7SPu3MJwZLLoborh0BiheDAa4xrYEX3itLMsamAPN+qvE3halJHq3lfbPKbPzAXRp3sYvU6Ny+jMJA+dxfCN/QnrAtHQkF1DEIOYYF5O75QmQcY5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=CRCT+PwO; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="CRCT+PwO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=7FJT+VZxyDK0hUPT/QO1U2sdxizi1Y4eZjb8JGXYg90=; 
	b=CRCT+PwO8jVtHV7WDi4nvgdXgWH3RYfhB/e9cFBFYwL/k6sBloxCN8jDAHltz40DFp20ps/vIE6
	YwHmbWz7z3UOdsyQWJeP2rkI4E7MHSx/wlS0RyIBv3tiND2bk4YgYEebjIYtV3ZbJCnS4YVLXl6H/
	gm5bLWRr4Yra7PLhIeZ+lqcoW6vz/12XRgLvkzDWrQZ7WQfT73/kWNaekLxpNiRxVQYc6Sk/aHC/D
	7MfMarAN08RUAW6k7DXlgctaeukg1t7tCJImzP5v59DVGrKCv83hDm1rNEORJpjCSTpbNihSa3ZOT
	AAV/wDYmqCm10Cj3353X7v0JuHSLfDAHO5lQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vElnb-00H1hE-0U;
	Fri, 31 Oct 2025 17:52:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 Oct 2025 17:51:59 +0800
Date: Fri, 31 Oct 2025 17:51:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jack Xu <jack.xu@intel.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Qianfeng Rong <rongqianfeng@vivo.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: qat - use simple_strtoull to improve
 qat_uclo_parse_num
Message-ID: <aQSGv2i0UfwmGRcc@gondor.apana.org.au>
References: <20251026015710.1368-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251026015710.1368-1-thorsten.blum@linux.dev>

On Sun, Oct 26, 2025 at 02:57:07AM +0100, Thorsten Blum wrote:
> Replace the manual string copying and parsing logic with a call to
> simple_strtoull() to simplify and improve qat_uclo_parse_num().
> 
> Ensure that the parsed number does not exceed UINT_MAX, and add an
> approximate upper-bound check (no more than 19 digits) to guard against
> overflow.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
> Changes in v2:
> - Use simple_strtoull(), return -EINVAL, and guard against overflow as
>   suggested by Andy
> - Link to v1: https://lore.kernel.org/lkml/20251022123622.349544-1-thorsten.blum@linux.dev/
> ---
>  drivers/crypto/intel/qat/qat_common/qat_uclo.c | 18 +++++-------------
>  1 file changed, 5 insertions(+), 13 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
