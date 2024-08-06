Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4C25EE8D
	for <linux-crypto@vger.kernel.org>; Tue,  6 Aug 2024 06:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722924009; cv=none; b=NuZnkAZ/CVfUXzvfXFwK5SdfyKXL/fjXL2mSJ6zGCbMGOepoSThn8Nooju/mvTPAnn49EFcYDpyUtl+P7Lxlbd+F5ZFBCni/zBvIzORaB7w9kE3VZH5BQ0fNn+GeD1JBXdtS7IMXuPRKkOEcLoDNVFY2k1SeEMNVGJrndTI2y1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722924009; c=relaxed/simple;
	bh=cfsVJjX2B6AFeZVgoCJaJN3CFB3WnIBuenP3EBQYClg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NhBeXJ1fvJ2nLo4vNqg355muqlPav866yX2LIgt18hsDp42Jz3oKJonp8MAf3JhyY/Q1KAv9yKikXyfCLmcSK0m6A9e9f2XWJrjL71IIypBAzztBaEhM4HhukLVigb/CCljS7YBeXd8lE/+HUhSmpkbTC064rYXK7Vcl44faP4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sbD60-002iEW-2H;
	Tue, 06 Aug 2024 13:59:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 06 Aug 2024 13:59:41 +0800
Date: Tue, 6 Aug 2024 13:59:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yi Yang <yiyang13@huawei.com>
Cc: davem@davemloft.net, mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com, lujialin4@huawei.com,
	linux-crypto@vger.kernel.org,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [PATCH -next] crypto: testmgr - don't generate WARN for -EAGAIN
Message-ID: <ZrG7zWxeXQn-Mkhn@gondor.apana.org.au>
References: <20240802114947.3984577-1-yiyang13@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240802114947.3984577-1-yiyang13@huawei.com>

On Fri, Aug 02, 2024 at 11:49:47AM +0000, Yi Yang wrote:
> Since commit 8f4f68e788c3 ("crypto: pcrypt - Fix hungtask for PADATA_RESET"),
> The encryption and decryption using padata be failed when the CPU goes
> online and offline.
> We should try to re-encrypt or re-decrypt when -EAGAIN happens rather than
> generate WARN. The unnecessary panic will occur when panic_on_warn set 1.
> 
> Fixes: 8f4f68e788c3 ("crypto: pcrypt - Fix hungtask for PADATA_RESET")
> Signed-off-by: Yi Yang <yiyang13@huawei.com>
> ---
>  crypto/testmgr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

We should not expect Crypto API users to retry requests in this
manner.

If this is a reliability issue, perhaps padata should be performing
the retry? Steffen?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
