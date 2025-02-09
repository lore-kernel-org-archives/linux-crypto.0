Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165DA18C936;
	Sun,  9 Feb 2025 10:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739096538; cv=none; b=bceO9hJYy7U2TDuhxzQ1zKJPpy8tq/SPss00LgKyCYetmIGBaAF9kwQ57whgddHS0gNvEu0f1oPOIlcoR7tZYxniPhq1qVUj6jFQhAEWGzFJQ3mtjsCqyXWsvq11LwhrVVn6FTDihksaRWpfBfVgKiqdKk1guos3mJEkwJhTMSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739096538; c=relaxed/simple;
	bh=D5KMtvnOqjJBXMxZ7izITsUzbwabIVI4frTC0DqqW1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cnlXN6ar7XYW283A3TKastIaVZ1+0O771WV3c+96oClCiJaPXt5wjAW7ezwObOKKBrS8bMTpck3z2FeZUZMKHCsIebHykFP6klLBev669XtMs8t72NhzPBcFHwUDpaU7txp+TaiH/q41sVI4SgrBm0WnQJez3wUdSW4gmZ5Xj6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=qOJTG/KH; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="qOJTG/KH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kmzFPO6oq5CUTRzosRoTRZ48O9dAE5HzMxEJjZNytxI=; b=qOJTG/KHUNdpZf2ufR/EFbcG7E
	Q5lPCGvlyBJZFqtpewBUChWj2VKiSoPF8Vllx5+cNb8MuFKXNIlVhIh2Bn7ecvxetQUeTmMjGDRXJ
	UgK5TyeZsNmwVAB4R0eboCySXYtCNi8aeC7FcddwJeEqysZ9UziZICNfuBdkOF2liUFlDjD2YdidV
	NYXmdTNqDo0AC0GBOHyZNaQHL8Pvas66N2QdWMo1XfpqI6QN0DHbnSq9aLKppuUBg9GP+EMTjqDjr
	8LaWDNpnf9yHpSCWnLkfmuShYjifhOU5bTt085D1+Nl7INEc2X1ytiiTek7XUI9y2JMd7KTYjHCOc
	9PPqiqTA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1th4Ey-00GIkK-0U;
	Sun, 09 Feb 2025 18:22:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Feb 2025 18:22:00 +0800
Date: Sun, 9 Feb 2025 18:22:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Arnaud Ebalard <arno@natisbad.org>,
	Srujana Challa <schalla@marvell.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH v2] crypto: Use str_enable_disable-like helpers
Message-ID: <Z6iByA35mExfmwGa@gondor.apana.org.au>
References: <20250114190501.846315-1-krzysztof.kozlowski@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250114190501.846315-1-krzysztof.kozlowski@linaro.org>

On Tue, Jan 14, 2025 at 08:05:01PM +0100, Krzysztof Kozlowski wrote:
> Replace ternary (condition ? "enable" : "disable") syntax with helpers
> from string_choices.h because:
> 1. Simple function call with one argument is easier to read.  Ternary
>    operator has three arguments and with wrapping might lead to quite
>    long code.
> 2. Is slightly shorter thus also easier to read.
> 3. It brings uniformity in the text - same string.
> 4. Allows deduping by the linker, which results in a smaller binary
>    file.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> ---
> 
> Changes in v2:
> 1. Also: drivers/crypto/caam/caamalg_qi2.c
> ---
>  drivers/crypto/bcm/cipher.c                         |  3 ++-
>  drivers/crypto/bcm/spu2.c                           |  3 ++-
>  drivers/crypto/caam/caamalg_qi2.c                   |  3 ++-
>  drivers/crypto/intel/qat/qat_common/adf_sysfs.c     | 10 +++-------
>  drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c   |  5 +++--
>  drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c |  3 ++-
>  6 files changed, 14 insertions(+), 13 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
