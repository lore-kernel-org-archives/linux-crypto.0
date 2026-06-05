Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653922EEE83;
	Fri,  5 Jun 2026 10:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780653894; cv=none; b=c58OR9pG6aSdgxMK6zKCliaG0Yn6BB8DoLTdXwXtMGY0Os58UKclWWygTCtPj6wV+2xIa2NFjFLLjU0RN1qu0IakbEwp/y8uznRw9sQNt8z/Ll3mnYzVjPS0vYBdbVLTXEDMcvplEqtz0iNxg6Qx+jXzBJQXM4A8KEk4/1udc+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780653894; c=relaxed/simple;
	bh=FE22ZdPf+wKhwfzKDsrco4GUVraR4aTWRxc65nLLhPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gulcbQyEIW0bhTS3AmZITcWPSc1wrT3VdCwrjscdo12B7JEIqKQP079xgfS+ft6brZ6EOZNzHnCbayY6HvXISm5/QbfM8MbFyegYVRgwWIPrrrKGjGbHQxbNwL16vm4dc/MB3Cifg9Dzax1rg6tWgRCSOIHboQyMhIfBLQjOADs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Ax6BZji7; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Ax6BZji7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=5nLOynZ1AgtIdQmmprJhzIyBvj7O8ByMcWq9gSrAVuA=; 
	b=Ax6BZji7M+GAm650GWcCbDGg/FJVo/O53s2XrUkefacgu9M+ZLaJzH09yvlkjiJDpslo19FrAhk
	/1ETA2RF2isMnhk9Djxo8q6U12VrxvE3wDJoPj/92/CGb21CYZpAoLgCeLK9p7GlUpVLfju7Q8xbO
	Xe9a1ypiz026OnghbrGpEO0QPKLV05zodnm0s4suACNDI9x40uPvOuY9axc+4LiegqWlbxqguQbQR
	Ls2jAo9Re6ulKOQcEW3NLDG8yKZH4c6QCP4Rb53FpW7yyZrHgXSRJrmz5iDKy/MbZEskHUMxnyBcq
	xuEB5eu3yGh/Rzw1Cjbf+x8hu4G+WXF3GcEg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wVRPr-002nBr-1g;
	Fri, 05 Jun 2026 18:04:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 05 Jun 2026 18:04:39 +0800
Date: Fri, 5 Jun 2026 18:04:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Manos Pitsidianakis <manos@pitsidianak.is>
Cc: Olivia Mackall <olivia@selenic.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Harald Freudenberger <freude@linux.vnet.ibm.com>,
	PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH] hw_random/core: fix rng list on registration error
Message-ID: <aiKfN1GHrNDs_nDV@gondor.apana.org.au>
References: <20260525-hw_random_registration_rng_list-v1-1-ee1c215d544d@pitsidianak.is>
 <aiKKIdPQzFdH0m9t@gondor.apana.org.au>
 <tg5j9x.z6yluqyl72so@pitsidianak.is>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tg5j9x.z6yluqyl72so@pitsidianak.is>

On Fri, Jun 05, 2026 at 12:18:29PM +0300, Manos Pitsidianakis wrote:
>
> If yes, you could add it along with your r-b directly, otherwise I can send
> a new revision when it gets a review.

It will go through my tree but please resend.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
