Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D528E252904
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 06:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766127445; cv=none; b=HlPYy0kjaU5hmRVXvcA4TZMk0WZX2UQ74uDd3pAK+snZ3Z2ZzlUVDWUg1Km9VhUNG8EVuyaYda5K/YvhPTVAGBG1ovd7ug2qBmIl7P/8bfgyJsb4Zo4ni1mT65DZzpOgJD8i8NFnpfj92s6Gl1T32WSQs/VUJIy1OKAOTXx1b70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766127445; c=relaxed/simple;
	bh=TlEszEz/gd0ZtuqCls8kkmvh58JIpGa7q0M3ShYDzMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eUqcnY9YdTzzHzCcpvvp42KRB613JXgmHjFG7S6xzgfcEmdRpCxKrvMXmO2IRuMal54aMEYgz+FeHzSzeW1mTkIStEcCdFmm8kxtqlcjZcVHCg7PrKmWkruYkDPweaQaiWCu8YpZ1eMmqHQl8AlqKOatALnYd2jinkHk80q0L+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=MKrtyZ2h; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="MKrtyZ2h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=MhFfHA0VtY8370xWSCrr+arZJCyaSH3xz7z5F/jh2kY=; 
	b=MKrtyZ2hyeP+IF3rn5TpoIgEotQ+Kx7SVy31EJ1ZRnt2MZYeDLQ+xXVmz2Y1sABRg73GVKWJPuT
	IYptA6l9eKf1SKCmsQ9qzJ1GNdMhE9B+I/eiVmCvejm0syAWX8AFtMbh2BgH9Azad2rH6Bbnhk2e+
	AqIuQLhvb0xoNENBt0s7od9XTTEKmWFRM0Hdb9pLmMzIONvAmLjfcNn6Sq/mxHzzRduYOFztcoUx7
	/FxmcHNDIpXJVl1bjtOgEUAbGs67SyYXRDBD2Ks9m3BWQSkAhMrLAV33XY2Uy8QEAj2t8pSqRv1Pj
	S7jjxD8gcTBDGT7OBAROkK6jJLPQdjMvUiyg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vWUQR-00BEXo-0R;
	Fri, 19 Dec 2025 14:57:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Dec 2025 14:57:19 +0800
Date: Fri, 19 Dec 2025 14:57:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: Re: [PATCH] crypto: qat - fix warning on adf_pfvf_pf_proto.c
Message-ID: <aUT3T3hOCAWo2aGS@gondor.apana.org.au>
References: <20251120163048.29486-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251120163048.29486-1-giovanni.cabiddu@intel.com>

On Thu, Nov 20, 2025 at 04:30:46PM +0000, Giovanni Cabiddu wrote:
> Building the QAT driver with -Wmaybe-uninitialized triggers warnings in
> qat_common/adf_pfvf_pf_proto.c. Specifically, the variables blk_type,
> blk_byte, and byte_max may be used uninitialized in handle_blkmsg_req():
> 
>   make M=drivers/crypto/intel/qat W=1 C=2 "KCFLAGS=-Werror" \
>        KBUILD_CFLAGS_KERNEL=-Wmaybe-uninitialized           \
>        CFLAGS_MODULE=-Wmaybe-uninitialized
> 
>   ...
>   warning: ‘byte_max’ may be used uninitialized [-Wmaybe-uninitialized]
>   warning: ‘blk_type’ may be used uninitialized [-Wmaybe-uninitialized]
>   warning: ‘blk_byte’ may be used uninitialized [-Wmaybe-uninitialized]
> 
> Although the caller of handle_blkmsg_req() always provides a req.type
> that is handled by the switch, the compiler cannot guarantee this.
> 
> Add a default case to the switch statement to handle an invalid req.type.
> 
> Fixes: 673184a2a58f ("crypto: qat - introduce support for PFVF block messages")
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
> ---
>  .../crypto/intel/qat/qat_common/adf_pfvf_pf_proto.c    | 10 ++++++++++
>  1 file changed, 10 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
