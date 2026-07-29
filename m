Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [144.76.133.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6054F2BEFF6;
	Wed, 29 Jul 2026 20:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.133.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785356953; cv=none; b=koSHLvcxu9FRw4iAQUyvM95fmbU5Kb8EEJCsywYRFMAGpCHEzGB3OyuZXdumt+MIvZzWTK2Vde2RkFOhfOkAHsBJNoKFfEf0uYZv0uUibmvaTIOKMq/+WCRov4y3xCDsp556lXYvD01wdtIZS3nuEXhmVBhoHqcAcFZaMhHztTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785356953; c=relaxed/simple;
	bh=ds4PTrdMHbvZfoFeQElDy6/ap/Ms3ycH3FnBccAmwgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IoJCndpXE/LIcL/ZjZhm55RYHmNM2Q1aWeqh2Ah1IM5Bp0CG1Yz9xHrJEjAMEmOMMhxAw5qnnn2zzPxYBQKTZVR9KId7BeIPJWtbk7wodKmCL/S7I7Kin+lpxCjuHDtFV+y0JNmfxK9iUYxJKoSWZzmHwZCvvn86rZYWlXS1q5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=144.76.133.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout3.hostsharing.net (Postfix) with ESMTPS id 656B3C1E;
	Wed, 29 Jul 2026 22:29:08 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 366C16031592; Wed, 29 Jul 2026 22:29:08 +0200 (CEST)
Date: Wed, 29 Jul 2026 22:29:08 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Changwei Zou <changwei.zou@canonical.com>
Cc: Martin.Kepplinger-Novakovic@ginzinger.com, davem@davemloft.net,
	herbert@gondor.apana.org.au, ignat@linux.win,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	martink@posteo.de
Subject: Re: [PATCH v3] crypto: rsassa-pkcs1 - Align DMA buffer to
 CRYPTO_DMA_ALIGN
Message-ID: <ampilDNLebSAhAQA@wunner.de>
References: <20260729004156.11925-1-changwei.zou@canonical.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729004156.11925-1-changwei.zou@canonical.com>

On Wed, Jul 29, 2026 at 10:41:56AM +1000, Changwei Zou wrote:
> out_buf is used as a DMA buffer for the RSA verification operation.
> If out_buf is not aligned to CRYPTO_DMA_ALIGN, cacheline sharing
> problems (data corruption) would occur on CPUs with DMA-incoherent caches,
> leading to -EKEYREJECTED.
> 
> Fix by aligning out_buf to CRYPTO_DMA_ALIGN using PTR_ALIGN(), and
> allocating CRYPTO_DMA_ALIGN - 1 extra bytes in the child_req allocation
> to accommodate the alignment padding as child_reqsize is a variable.

sashiko believes that rsassa_pkcs1_sign() suffers from the same issue
as the _verify() code path:

https://sashiko.dev/#/patchset/20260729004156.11925-1-changwei.zou%40canonical.com

That doesn't seem to be the case right now because the only callers
in the tree (test_sig_one() and keyctl_pkey_e_d_s()) use kmalloc()
or kzalloc() for the destination buffer, which should fulfil the
alignment requirements of the caam hardware.

Thanks,

Lukas
