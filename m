Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C614720E6;
	Sat, 17 Aug 2024 07:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723878774; cv=none; b=tm12H+nZLT8kF8WDibYSvUtMRzOk3/hSV25CR/0wn/E9pAnK86amiAacvug3cA8SVx6+9nwMzNi/KvG8VW+IwRimKWO9MLzRiGjkmpRDbEpAELd3DI51XTyF/C+90iDR6FRuw6dTZvY/Vr3NiFPB5Nkxv9PFItTytcaocsVEaF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723878774; c=relaxed/simple;
	bh=/o4Vnthxc4+P95238wpYEJpmMWZOiInjNs4QutY4M+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uHrq80owYyFqSyVigUQjZamuIlPZ+PNq8DAsaVk4l4qYUyFTxad0M77QHyM6m6hyase/k0AwGMXiSdkcZk8gugzg6F0mdF3YxP+wJdV7oQKEW5cv0DRRtyZQG+mKQFGUD1ej5k2HsdXuIHuLqtmwYjvwnMVqTgvd1jyj/BDAnaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sfDTc-005IQL-1A;
	Sat, 17 Aug 2024 15:12:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 17 Aug 2024 15:12:37 +0800
Date: Sat, 17 Aug 2024 15:12:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Waiman Long <longman@redhat.com>
Cc: steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
	akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: Fix possible divide-by-0 panic in
 padata_mt_helper()
Message-ID: <ZsBNZXfVZbtZnb2Y@gondor.apana.org.au>
References: <Zrbm--AxRXgfHUek@gondor.apana.org.au>
 <e752f094-adb4-4448-8bc8-e2460330eaec@redhat.com>
 <ZrgXtLI1R5zJ9GFG@gondor.apana.org.au>
 <91d29649-ca88-4f6c-bf1d-19e49c9555df@redhat.com>
 <ZrgsU-1PdxvUVMOW@gondor.apana.org.au>
 <88c188dc-3664-45db-b54a-11feca59d7d2@redhat.com>
 <Zrgy1TDikPSkzaYP@gondor.apana.org.au>
 <c5cc5ea9-1135-4ac6-a38f-652ed07dae17@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5cc5ea9-1135-4ac6-a38f-652ed07dae17@redhat.com>

On Mon, Aug 12, 2024 at 10:04:07AM -0400, Waiman Long wrote:
>
> Anyway, using DIV_ROUND_UP() is a slight change in behavior as chunk_size
> will be increased by 1 in most cases. I am a bit hesitant to make this
> change without looking into more detail about the rationale behind the
> current code.

I don't think it matters much.  Just look at the two lines after
the division, they're both rounding the value up.  So clearly this
is expected to handle the case where work gets bunched up into the
first N CPUs, potentially leaving some CPUs unused.

But Daniel wrote the code so he can have the last say of whether
we should round up after the division or after the other two ops.

Daniel?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
