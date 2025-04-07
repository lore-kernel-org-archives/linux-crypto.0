Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB485335BA
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 05:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744003461; cv=none; b=FsHJ03LEz5J76ZohbEfSRytsinSyzVF0wX3mctgvpW++loVaV6c6OfsusBYDxV0lwWNNPNCEIrBRZGzPmKF96baxx4b7eZIsROY7oczrX3HLMha8/t/gvga97cvcSHmBi0IIrtQkmtzXdvQoChDu2e7xSi+X4NNv09rkxbS4z2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744003461; c=relaxed/simple;
	bh=OCxORkcacA6Goyk2QbYw21S9qf7KId1uqEURjWGHMf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cZrKjmFNz1F774RRI+WvJOu4FSU2MU5oeQUNH6kQi8ASqSZ2Zng3l56i7TI/FmSu2QSoQ3gr09puUQ/qRtVjiynWJKsSwFUQ8fzHE/5/eGf2mFx75zxD0fF7JlEc1QjVCvEKUoNe3+PyS2bGSzst5Whu9I8Z+k7VeSwpfXZ5Mj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=bov/5Etn; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="bov/5Etn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=R2RtxmjnnRYfYMzLnezRD523O7/NxRPl247nAkcgZOM=; b=bov/5Etn2KN16+13zIfzCK3olS
	yOmTAjMI0lGZEYUiKBCx6Zzk0etik8+QaMwHNXxlv4YXNbTSFXH8saUraEtlcBj9Lm98/uiHUHWKb
	y+bjiJ1ekrenWZJfb2hEFtQA2LjifhHNZPpZ1dG8OaR9IHib5CBATDFWV9s7RAgelbOr9PhrLeEEB
	NEeJhSj0ITalN4kAPar0v+KMkSFVwoWWYe1bOm4QczXkWBUlCzQlJksdhzhhCTQfqe0NWDFhLLz8K
	bmcipSoIHrtfGTN2y70nakVHdnw4OJcQYvI5rrXFJEIsbfAjjtUtSbewlzfyvV35k6FMY81VutqRR
	vYSgliUw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1exz-00DNIJ-03;
	Mon, 07 Apr 2025 13:24:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 13:24:15 +0800
Date: Mon, 7 Apr 2025 13:24:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - remove BITS_IN_DWORD()
Message-ID: <Z_Nhf3wbBc9NdU_f@gondor.apana.org.au>
References: <20250328103302.571774-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250328103302.571774-1-suman.kumar.chakraborty@intel.com>

On Fri, Mar 28, 2025 at 10:33:02AM +0000, Suman Kumar Chakraborty wrote:
> The BITS_IN_DWORD() macro, which represents the number of bits in the
> registers accessed by the firmware loader, is currently defined as 32.
> 
> For consistency and readability, replace this macro with the existing
> BITS_PER_TYPE() macro, which serves the same purpose.
> 
> This does not introduce any functional change.
> 
> Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  .../crypto/intel/qat/qat_common/qat_uclo.c    | 20 +++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
