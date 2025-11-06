Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2636A2D2495
	for <linux-crypto@vger.kernel.org>; Thu,  6 Nov 2025 07:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762412849; cv=none; b=SOsnxjm2ij+qIwURDtBW4v78MPsyqgBMMUIJy918SOb2Dwb8ozYBpUmZPyFQt9nyoXN+ESAZiKp1unSlpBy3jcKfrNG7WPuT4r+coEpcA69+ILpi6viMWJJr8YFGWdyIR+s5Cp60qrSqJhQbAWix03t3t0tqeEDUGoW481MO1w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762412849; c=relaxed/simple;
	bh=GQ6Q0Jh5DRcqTAtsFYehZY/0WC/0aSZjSyLZ/wxOAdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b/iyxTY5F3JoSLPDw1CU+XwxWuHltWntyrSKgMQAVPWg5zJKSKP7QSxa9ebSaCAlmHY/vBqLT4I0A6uje9w2OYiAtEYrdNl7c042+Pi/p5LKTIHhmdyibQ2cYz4FnqY4XLXTpdbcq7ep5TeNN274LjjBNtDj6RTjcU2T87dyTNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=KeSRBShs; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="KeSRBShs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=5y74KJIv40Vw2JQPEQoI/whfeAJ/AWjDSax0KfKrZ+0=; 
	b=KeSRBShsui2I81P3mHWLLuZ+p2gmS29LHx413he88fcBdfdjXyTnVt8+acrkZ5k6bbN87/TJ6SB
	ciR9gATNFWQVrlkYZnmZrPwiRsqeMRMEazawUfrLJFrpn//Lj8YkhhwTWvoNq0jvhNgJFNW+EC6HB
	OraX5NvQz0F75x553oj9ZwP6oOuvHHdeBv4C0n7jGd5qVz9P1SpXcOvvNeDiA3QF5qdmFicKZEaWm
	+a0mIJ6jlfajdB5Y85O1MtYkzXOP3qDvH+MPgNeacD0sJBZBzOlf1aOD7nNM6U9hFLeRRRdBPYtCR
	fbLC5EhvgBCz7n3/0xUN3whbwbuvGwjZwRxg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vGu5W-000raM-1L;
	Thu, 06 Nov 2025 15:07:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Nov 2025 15:07:18 +0800
Date: Thu, 6 Nov 2025 15:07:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Mario Limonciello (AMD)" <superm1@kernel.org>
Cc: mario.limonciello@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp - Add support for PCI device 0x115A
Message-ID: <aQxJJpMvpdGQtDmz@gondor.apana.org.au>
References: <20251029161502.2286541-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029161502.2286541-1-superm1@kernel.org>

On Wed, Oct 29, 2025 at 11:15:01AM -0500, Mario Limonciello (AMD) wrote:
> PCI device 0x115A is similar to pspv5, except it doesn't have platform
> access mailbox support.
> 
> Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
> ---
>  drivers/crypto/ccp/sp-pci.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)

Patch appiled.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
