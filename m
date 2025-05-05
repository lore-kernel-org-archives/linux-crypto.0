Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900CA24BCF5;
	Mon,  5 May 2025 12:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746448139; cv=none; b=aAQV6vXm/6N+Er+ZVBqeA3+FOnjTilhB44EEZ6bzQ+ZzA2GkWWPgBnMlcjqhT7eAg/lUivvnH3VuuThXwxp9uVD8D/RgBbHgvGe7uPafifBOpyfYix+e61CqxzHXqd/iZBAEYQbsIqKYtjvfb+6PHWtOjvTJG1G+x6SpMVQF6M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746448139; c=relaxed/simple;
	bh=kcxGWvgQ7OS5T5as6+IFxw5ad5yP5FYRncsZMv/ZIl0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OBJg2DyLK45h3eshTxG6ImRHcA1K3yYqkXHFm4uhtbMstvrfieBTKV2y1SvwAr3wZwBWreKqf9caq6EykUvwM7CYrwEsm4UEKfY/KK3o+nRMOdYWTBzVF5M4QEVNCe+pDdZDK+vQ6SUbaEHK7Jtt7zcPmHDBghdzNaW/kaiGq48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=W20ITmkf; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="W20ITmkf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Ca8e9Y3sNqfrAp3cjUV9l5KRXpSXCvVgQ6g+oU+iRkE=; b=W20ITmkf0tV7tzMIkpptoasgb5
	eZXZz15xpfCV19thXd+8BNpmCUqVjFSzy3+EZ5GhOGH+P3r3jANACcCo8E5bEycaVmG/74hgDDPDT
	HV4Ck6NHCU8idIiU1ZYz1lwVfp5fx+7RdUv/XNHxsT9JUFlUEYCBqjlQ8UMlEpKJDqnqkjvU2Cl4C
	da6uXwPIeaFFqclFfCRNPFAQ3slX+idpBwjX/tNzO+WzWbJXDS9vs6yF/ovsAPw5NdSDOQwAgBpLf
	htgkPUavh2xRIwmZIeq3WbIh8I4TOQtNhjz6H1GNjzWlvESlHxsSDZeH9Xgc5vSaUtogh61D27EAK
	DvILk6UQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uBuvs-003YIl-2N;
	Mon, 05 May 2025 20:28:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 05 May 2025 20:28:28 +0800
Date: Mon, 5 May 2025 20:28:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ethan Carter Edwards <ethan@ethancedwards.com>
Cc: Weili Qian <qianweili@huawei.com>, Zhou Wang <wangzhou1@hisilicon.com>,
	"David S. Miller" <davem@davemloft.net>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH 0/2] crypto: hisilicon/qm - memory allocation cleanups
Message-ID: <aBiu7EeisHseyDgU@gondor.apana.org.au>
References: <20250503-hisilicon_qm-v1-0-d4ebc242bc8a@ethancedwards.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250503-hisilicon_qm-v1-0-d4ebc242bc8a@ethancedwards.com>

On Sat, May 03, 2025 at 04:21:26PM -0400, Ethan Carter Edwards wrote:
> This series contains two small cleanups to improve code quality and
> readability. One removes a sizeof(char) piece of code (because it
> evaluates to 1 anyways) and one switches to the helper function
> devm_kcalloc.
> 
> Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
> ---
> Ethan Carter Edwards (2):
>       crypto: hisilicon/qm - remove sizeof(char)
>       crypto: hisilicon/qm - replace devm_kzalloc with devm_kcalloc
> 
>  drivers/crypto/hisilicon/qm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> ---
> base-commit: 37ff6e9a2ce321b7932d3987701757fb4d87b0e6
> change-id: 20250503-hisilicon_qm-7b581a9b3799

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
