Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345BB4C97;
	Wed, 11 Mar 2026 04:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773202629; cv=none; b=ghdeShPujJnGSSybL8e2J7NAmoMKx43NbMGBCrcMg/N3GjDgBn5TBR2zXOk1yc36m859I+iYppbbe82i2ewpKVK5HBLhCEFOJbXqkdNSdi0pYQWzxVeOzgJbc++fAUxig45jc67WMr/YsgZ4MTZG7t9oYvYheVun5/jpFTSdfhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773202629; c=relaxed/simple;
	bh=hcIvrRRjQMr2pQlVfFeY6pukhq418SGc7B4G82ZRiJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=trzKJ0gTAt510Oy80JEjspdAZugb5fr1aTmPsPpz39apP5/bp7PFAssglrrBOu4ROGAhrVclr4iQHk2RoC/hJAgZr3vM6h35piliNvhL4TtpGgDp5T+AGek8eLzOZ37ayJ/Gcvo+T8BYMU8XSqQM4+itAhzQn6GMSAgr7wgQG+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=apuW8wEm; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="apuW8wEm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=FJlZk+spnSjlxBQ0dWw7JnwMaOJul2lb4Y6Xx78u5p0=; 
	b=apuW8wEmQ8PfKMjTMSZ/lrdjTCZ5CsiTeFduptKW41zqVMtDNlnD3V7J4Sfujpza2nJcEx5v+vL
	v7kc5En+U1cYM8BIb/sbIMJLB+73SCotu1Pejp6wrPrzZ1xsaXvU8Wu06lxRpndCnJRFlB4J1i6Fi
	S4qXfaxygNpdVxTjbCesnhNDoIPHu82Z6OMUK48/fcjEfAn89JqRu8Xc8Y2tYN/BcwQSGiCizoT1N
	WmEWC/HZhq2BVx7nn9qPwC8+d3VeVQRcWNlFnqNacpaXRf4DkQxHgCrCf1/xOqOjobUOIopnIb5ao
	S+wLWmkvZOez3SDtRn77wGsli4aOs/1+VIAg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w0B0D-00DNaI-1n;
	Wed, 11 Mar 2026 12:16:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Mar 2026 13:16:57 +0900
Date: Wed, 11 Mar 2026 13:16:57 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>,
	Kavitha Malarvizhi <k-malarvizhi@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 2/3] crypto: ti - Add support for AES-GCM in DTHEv2
 driver
Message-ID: <abDsufbNKkUa1msb@gondor.apana.org.au>
References: <20260226125441.3559664-1-t-pratham@ti.com>
 <20260226125441.3559664-3-t-pratham@ti.com>
 <aau2bg4gdM0VPcEo@gondor.apana.org.au>
 <26303ab7-cd14-4560-8872-021229faa137@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26303ab7-cd14-4560-8872-021229faa137@ti.com>

On Tue, Mar 10, 2026 at 10:35:15PM +0530, T Pratham wrote:
>
> What potential issue do you see? Both `dthe_aead_prep_src` and
> `dthe_prep_aead_dst` functions use `sg_split`, which anyway allocates a
> new scatterlist. Even if req->src == req->dst, the src and dst from here
> on will be different.

The copied SG list will still point to the original memroy, right?
In that case you will end up DMA mapping the same region twice, once
as input and once as output.  I don't think that's guaranteed to
work, as you're supposed to map it once as BIDIRECTIONAL.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
