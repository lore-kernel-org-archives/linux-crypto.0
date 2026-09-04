Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BAD22A80D;
	Fri,  4 Sep 2026 10:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788516117; cv=none; b=kXGGCoyzR69pH/u0R3skgabLtzclaLXAOYS6wim7PAJXNUOtRdtsDJuL68dFiHmumE7Iku6Vtoxg06tLB7zNbx+1hoLefnuhJGZEjZdB/7snbuoKsYsfAsFYB94/7mug1LMhSc8LG1CuJHbtlsnY6zIIZhNWrMHnW+laOLR5NX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788516117; c=relaxed/simple;
	bh=CqDqseDWnMRZVDG/T9v0HtSSYI2JlPTI/+UtnY/usK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CzL7wJv5qvNSwnGWE0igjmr7DgaOsJ2lHmiAhHipprUX4HvcPmQbno2OP2mzRKm3XVLGLY3fv7fIgNJa2mMfzkjHvuVGQMjT/oRnMjVBVdY0QmMO2SXOpa7AZVaOEWY5DylJ/W5yBcrROKFbKdiUT/AUVhAdFh62qfpf8S8UhXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=NYbOsOto; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="NYbOsOto"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=armNCMHy9WOPcvGEsucdBFdcR2CkvPxOUZdfDfLltw4=; 
	b=NYbOsOtoiH6d9Bb3lEWGf8d1iGn98RuLFnER35ilxU6WfrhQSMoMhSsM969vg228v0Cnnz035n4
	ehGK5aI5HdhhKMc/S7z9sZ/LXOnDbQNkir3KjAo4nbZDIMfU6u4Kyt9jB2LMNDTv9l0i8oTCbZJlb
	6mYW0RFnILqcBD3cig/1LXHHPk1XKrEeOdl+nfSHjXxcnlaWTN6AOA0JIa7tYPV3bdpaECFnct2mm
	B1pypfyBZUhzcIdMcRvHqvHc4yB6CCHMPic2Pi0JQIFRxVUIICha/jZIJ5mI3QFEe1myiEMW0tRfV
	60HUMGbH7Wvpenmfn/8KEWzU5XxoaOAYNeEg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x2Qk2-0000000AnLL-0fVY;
	Fri, 04 Sep 2026 18:01:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2026 20:01:50 +1000
Date: Fri, 4 Sep 2026 20:01:50 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "David C.C.M. Gall" <david.ccm.gall@googlemail.com>
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	gregkh@linuxfoundation.org
Subject: Re: [PATCH] crypto: octeontx2 - use crypto_memneq() to check HMAC
 for cipher_null authenc
Message-ID: <apqXDmZ1HpGQjKxT@gondor.apana.org.au>
References: <aoCdBZ-kLQ0rciFi@david.gall>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoCdBZ-kLQ0rciFi@david.gall>

On Sat, Aug 15, 2026 at 07:08:21PM +0200, David C.C.M. Gall wrote:
> validate_hmac_cipher_null() compares the computed and received HMAC
> with memcmp(), which short-circuits on the first differing byte and
> leaks tag-match length via timing. Use crypto_memneq() instead.
> 
> Because for cipher_null the validated payload is un-encrypted, this
> valid prefix leak allows for authenticated message forgery.
> 
> Assisted-by: gregkh_clanker_t1000
> Signed-off-by: David C.C.M. Gall <david.ccm.gall@googlemail.com>
> ---
>  drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
