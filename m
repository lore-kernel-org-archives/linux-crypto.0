Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7076F221578
	for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 11:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742555178; cv=none; b=FbvKQPOvV6TJDWZJAAaX33TuKE5KceauX0NTaJ5UkN81/ZOwBwm4uRaiYMr7ZT8FL2/VJFTHzKxgyWx4ow84jny/bRfCu5mtr++cTAk+G6pyI7NP8Nnwx3W/IR2F/y7UrpPbMxPArugpTxUEmgMtlK+L5qLOsR2cdhoLWgvSUnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742555178; c=relaxed/simple;
	bh=fRZjJmEsRJElSeTQGZf+lO0JoLPwQHDRfevJu+Jnrkk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qi5RwVC5ZVLxUEJ9p8n4w+2LuTvBJUnmRJwepEUK/oBQR1IV/MrteLIBDfku/Rh/Zk+SNFvMbuYHZ7WRnmxTsp6ZN58n110b1CMOM+O2Pi5sKGIaXmSYYksb3CpxwASSHhR3RZPyLM9+3STKMixhpJuD8KHjZsQNNgTOgbKzKbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=avGfc+gs; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="avGfc+gs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cjy6Cx1rnzfS9SjGHYqpp16aaP8kSdlTC125cU9ijX8=; b=avGfc+gskChuY5mMSSMoDSsalJ
	GM8e8ZdEtuIEckJlkDhwlcJ6PbRlRbU8TEGVlT/tT78ao3YNiNr9g1gauEAis/XrHEIdd6OAqsix9
	O6+jx05WNzpFLvzUWoKUis3c1cDzzQ6I3YeaSpBmuR7Ql2k1pNJ5S2OUt/0TFWH4LPjcyi0HqgJuB
	+0h7bfFcI+wP7OSKTjb0wBeUqGjL3vtKshc1qmKjEyCP8xVaQDCFnOFtZCQj58Zk2ctcjH2eqrPpl
	C84pchkv8hopInJutv70GxnH6z5qpap+v24mZV2JG3ZakD/ALblTcQyJuTFJlv/I7mrTXxm+ORm2s
	ooNkiDVg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tvaCa-0090ET-2D;
	Fri, 21 Mar 2025 19:06:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Mar 2025 19:06:12 +0800
Date: Fri, 21 Mar 2025 19:06:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Bairavi Alagappan <bairavix.alagappan@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH] crypto: qat - remove access to parity register for QAT
 GEN4
Message-ID: <Z91IJG9Fz6JZD0I3@gondor.apana.org.au>
References: <20250314150943.30404-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250314150943.30404-1-giovanni.cabiddu@intel.com>

On Fri, Mar 14, 2025 at 03:09:31PM +0000, Giovanni Cabiddu wrote:
> From: Bairavi Alagappan <bairavix.alagappan@intel.com>
> 
> The firmware already handles parity errors reported by the accelerators
> by clearing them through the corresponding SSMSOFTERRORPARITY register.
> To ensure consistent behavior and prevent race conditions between the
> driver and firmware, remove the logic that checks the SSMSOFTERRORPARITY
> registers.
> 
> Additionally, change the return type of the function
> adf_handle_rf_parr_err() to void, as it consistently returns false.
> Parity errors are recoverable and do not necessitate a device reset.
> 
> Fixes: 895f7d532c84 ("crypto: qat - add handling of errors from ERRSOU2 for QAT GEN4")
> Signed-off-by: Bairavi Alagappan <bairavix.alagappan@intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  .../intel/qat/qat_common/adf_gen4_ras.c       | 57 ++-----------------
>  1 file changed, 5 insertions(+), 52 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
