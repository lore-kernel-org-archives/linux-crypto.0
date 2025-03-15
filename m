Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8191CEC0;
	Sat, 15 Mar 2025 07:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742022129; cv=none; b=XSFh7jWIumPY6GVjhsH/4Rjr5r7bw269jIcIe482N9elmjlVkrXvL1IIOEtuelmHVwDbmmi43kDepOUaM5hRt0+/0HVRXwhhhrpBoxwSo0T5yS+lgN0oPJOvTFWwRtSSCxw20aRxLrbkml4ic+lK4Yoc+3nHD3BsI75hKTZ0taI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742022129; c=relaxed/simple;
	bh=u09qQqQQWeem3kD7yi7OJESXMq5QvavDAcoEfeuXhv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B0HMHmVMIsW6RVv+iDLRX+4dQRM2C+2m8xMD9xrrrBLQILUeb5KzqE3EkYx5HeXK/EjX/IGUleZA9ZcnXRP6AuPqPdo91GfLe6EPu/Zu/E9a2iHLpvp9U9mpI+1TMhJ35q/RrfVt8QgoIl2iG+RrP9FyGyR1OGwrA0GWmYQrytE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=QqAOk5Pb; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="QqAOk5Pb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DBxWDKn8W2F2PcTF0yhGuaiB9zxAIYsAk9R/fiHqBIE=; b=QqAOk5Pb3VAUKPh670hH2pSYbU
	nQUO7tRMU1px/CDNgD5mOCurclTXdlGyJT5Mv2M6znvRTAJxEyEGCX4Us3q/cbVP0+P5ZE8BEld9u
	IxoAF77AB4ogDcWOxdJdcoQaD08fTjT9qtN7HTOCk6ItILYJakuI+8JVzGxWkQQqFn+m47HkZ/riX
	k4fjTwFek1aVHNUoM2TnyYiL4FUuZSfsUyKy1v3KAZHz3xJPz8fhis0nDyPwsMVHNSkXSR0oCq78H
	NS+5tytWbyeUrdSBd1wDzu7+m64Bs3u01oEMbBN9UGPf6/QTdJc3N/OOfAzSsTHsDDZzTVil+qlL7
	pz3RTmKw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttLWu-006mr6-2T;
	Sat, 15 Mar 2025 15:01:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Mar 2025 15:01:56 +0800
Date: Sat, 15 Mar 2025 15:01:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Borislav Petkov <bp@alien8.de>
Cc: Dionna Amalie Glaze <dionnaglaze@google.com>,
	Alexey Kardashevskiy <aik@amd.com>, linux-crypto@vger.kernel.org,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp: Fix uAPI definitions of PSP errors
Message-ID: <Z9Ul5NaFlJXBRP43@gondor.apana.org.au>
References: <20250308011028.719002-1-aik@amd.com>
 <CAAH4kHaK3Z-_aYizZM0Kvmsjvs_RT88tKG5aefm2_9GTUsU4bg@mail.gmail.com>
 <20250308133308.GCZ8xHFOX4JKRG1Mpk@fat_crate.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250308133308.GCZ8xHFOX4JKRG1Mpk@fat_crate.local>

On Sat, Mar 08, 2025 at 02:33:08PM +0100, Borislav Petkov wrote:
>
> It should be corrected because the current SOB chain says that Dionna is the
> author but From is yours, making you the author when it gets applied.

I'll fix this one by hand.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
