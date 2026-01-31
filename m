Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4C230B517;
	Sat, 31 Jan 2026 02:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769828134; cv=none; b=g2Cw5Qz/M6ogk4z5ppZxisf53k0+S11ZHJG5LIVoObgRTL/hHTTxF9rtdoNEs2v7CQK8VIrDdYX+gFT7Att/AzPN3gEIruFjmxZm6O0Cfc5qcqqtiC0nqZVF3t86Osa/4nHvObK242pfN1iUfZvel3vNAqJpvc2roBLRDWkdijU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769828134; c=relaxed/simple;
	bh=Y8jlpLEPt+ZY90QT7kCNaZHwNmpWIm3GVsuoX6oIHws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QPmr3If+APd3g1rjIFlyoj4wg6HphLzUt47vn7kVb/BeRc2adGRnSOFsY4aG4sP/c1TSD93+BATX4yb6Wzs3mZOzgB650Pxz2qU+dz3tXC29YwdSETfC6cZ/PtaekzlDYyYKsf+/WSt/EeAFQYciW/RCKBCtipwL4c3O/Y1n/cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ssxFzetO; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ssxFzetO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=PARnfAmO8TS3qYl2afHb4aIaOUKMPPe+CbKLTktcDqM=; 
	b=ssxFzetOSSB93G/sh3CKAllOFkdW+kQt5lLgf812PrjAHbaKyYx/ruV/td2SyK6S3LmVmX76ooq
	YagM7Xw4pe5mg1cSm0tjfR4aBPlL2HJ9776nbzi1Oou3q40WWTkMlFnVMhG2KaKQW4tkKUreXl+E0
	ayt8+bpPWdTMyF2ME/rInx9/EuTRKujxESoL+z0pOzWaaW//7R9ikj3BOljCI9t9NPAE6YNxABc2V
	A+rfC2CMMBgkoO0rcU7k1Ecgg0BI8vvMFOTPtwCS8ghB7+HIakI3H/edxlxuFADYreMlSpJud6nLF
	gv+gse+4s9jNyTtlkhTzbvkjmf3zR37YX6ng==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vm18X-003S0A-1M;
	Sat, 31 Jan 2026 10:55:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 31 Jan 2026 10:55:01 +0800
Date: Sat, 31 Jan 2026 10:55:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Maxime =?iso-8859-1?Q?M=E9r=E9?= <maxime.mere@foss.st.com>,
	Eric Biggers <ebiggers@google.com>,
	Colin Ian King <colin.i.king@gmail.com>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: stm32 - Replace min_t(size_t) with just min()
Message-ID: <aX1vBYvzyxT4zdBK@gondor.apana.org.au>
References: <20260113083130.790316-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113083130.790316-2-thorsten.blum@linux.dev>

On Tue, Jan 13, 2026 at 09:31:28AM +0100, Thorsten Blum wrote:
> In most cases, min_t(size_t) and explicit casting are unnecessary
> because the values ->hw_blocksize, ->payload_{in,out}, and ->header_in
> are already of type 'size_t'. Use the simpler min() macro instead.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/stm32/stm32-cryp.c | 29 ++++++++++++++---------------
>  1 file changed, 14 insertions(+), 15 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
