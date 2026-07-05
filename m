Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F242D7386
	for <linux-crypto@vger.kernel.org>; Sun,  5 Jul 2026 05:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783229629; cv=none; b=LAxdARndYl8G/LeciuQyTv3B+Ec1DShXGkZ44Bye+yzWpFbx+mHPw3Sa8i2qaEEsf7r/FypRE91RHNmFSWq+cwW2uOUml3PYutXek95/BTe9/L5YvGZhZba1w0resouyD6WkgZh147301sEfXXphHFKq9Jdl9oPXzu7ZE4CNDm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783229629; c=relaxed/simple;
	bh=/JHZ5d1JqOQS5U6fooIrqXyMLZ3iIbkbuR0s1OFqiLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QWo37+46T0bwdG7pWORVpfK25XSoOwJl5yzZi/9yuXBVz4cZzUl9JwEY5m5RWlKcJEkHjDzfdatPNlk/0R8NHw4ya+g8Z+W64MNTivzoKQeJKvCO1EvL8bQFVcUQcyIEP1KmIiZjciMMYIeKLNN1LVVlzOkvDBZ8sQlkbcFmtes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=C3VACG++; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="C3VACG++"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=vLJZmJLp7yryHBbgocuwka/zedyBQs285vhANmqDRP4=; 
	b=C3VACG++3iBkzcf8qW28mfoX1Ynf411vHd+1LKuk00eINvUS9jO8chOzlcWyIerMzq5kYX/3TGM
	dKvzpIbOUNp8+sd/nT2/Rgu9bGiRbc2PeqypaaWIII6NWSI2m8SCQfk8PFSj5baTTk4u418lth9Xm
	BM9JwnCNnkEvjrKmOK10AUvEvgUwJSs/Dh08akV1N4OsDDhreFCySwPFkUcnqk9XoxSg1cl3dfN6+
	E5jEPlis2Z9/V9tfzkkXy7zYwDYzooZA9T8eq8MGC3CApDuco6A8HTO/f28iqXe1Sz7VGlx+rOUEz
	xeDAAEI9O2wBgD6hAjCtRqD2FxSZvX7Nphng==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wgFU8-0000000AjgI-41u4;
	Sun, 05 Jul 2026 13:33:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 05 Jul 2026 13:33:44 +0800
Date: Sun, 5 Jul 2026 13:33:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: Re: [PATCH] crypto: qat - clear AES key schedule from stack
Message-ID: <aknsuDYTebbOaYHz@gondor.apana.org.au>
References: <20260608150441.136014-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608150441.136014-1-giovanni.cabiddu@intel.com>

On Mon, Jun 08, 2026 at 04:04:20PM +0100, Giovanni Cabiddu wrote:
> qat_alg_xts_reverse_key() expands the forward XTS AES key on the stack.
> That schedule contains key material and can remain in the stack frame.
> 
> Clear the temporary crypto_aes_ctx with memzero_explicit() after the copy.
> 
> Fixes: 5106dfeaeabe ("crypto: qat - add AES-XTS support for QAT GEN4 devices")
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/qat_algs.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
