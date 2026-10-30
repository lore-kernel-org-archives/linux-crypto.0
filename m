Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793335653;
	b=ioO2nFwlMIISVdJNXyZZewG9wQ94P1wgRAzCAyR+/I7mK9W3og8wPpsJzAcMi5hCzdSq
	 U7T9la75eFeYHyMbZ3Xt8+l8ev7hmXkfBgpRyny9TuE90IVvMHrLtF3UKcz+ZOwAMKd7m
	 mADVJYKa04/N2xHWMh2KNObeaUzmgJYEKn8b5YQVerSe92RstvfFaumjRuW0hO2Db1dM3
	 7y3Vew/jZY5s4WJsV3dckWpZTnJJ7QULVMK38g1arb4RFgZ3iKtREdy4BJv2TEjgAmfuR
	 a+4mnO8+2h2oQ7E9aCPqV7AR3gGy4x2XOuLPQRgkp7NhzVRqGVYEt3jTO9ypIa9kbMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793335653;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=GQr6UKipqGHD6zd99UaEJhP6rQntCtcMCzTwi45iBbc=;
	b=CV12OGv4fbKLr106I+pKvtMXeYomQqwAi8ce4/S9yNzbXLgogCOyNUDh87ruIkrc4ArQ
	 9Puyxd/E8CBIiS5xQsha6cS5FfamZHzn9c72oBd8rzLK73QK+pRrcet1Xj9LuvKImas0+
	 t1VxIPAg1qgM+Mdb81uMmZxFP7PObIe1NWYthoMvUsxSezzoe54Zp2Z9jIEgKCGahHE/B
	 SNC3i3cZ8jMEkz2cxn86sH/KrdJ/8Po1o0+aHc/Y/H7/xkQDts9JfLzdpV+tboRLridbV
	 Z/ukqiVQoGIdApMmnyGWCywknk0nffkHgH8rMEsTFEqvyQBUNDUqKQ+E6GkdtcH3QLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=WBlc5iUH;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949C2606A31A;
	Fri, 30 Oct 2026 04:47:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 949C2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=WBlc5iUH
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=GQr6UKipqGHD6zd99UaEJhP6rQntCtcMCzTwi45iBbc=; 
	b=WBlc5iUH4ZDNgDqQzfvydJR82aAnMRBPMkhjjftiwO6DGu6+UInwDgNtZGItb5GeJrIOQbNItgW
	HT6hXh8wPbSbK+OLUPy8vx+hocfuWagmS9gq4o2uKg1dliS2kNFMGHlaqHqVDYb0WoMzZk+x4jmjq
	oOq8AFCh1N5fwz2ly7p6yWVURbwU9K8JvKLI/Mc1LX7NEiCAoaIxOO0x99r491CEMqu/zmuF7K5CZ
	/yReOS00OCClNr0jdqh9ql4Sdxwwi5k4tOmJWhR7EB3+ng4cg2jRFMDUxOw/K4ZfJIQ6nmeE9P2m0
	rpTdPN3KSzeaQUK0yEMA8h3Omkce9oWOC8ag==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xMeWG-00000008yii-49zp;
	Fri, 30 Oct 2026 12:47:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Oct 2026 12:47:12 +0800
Date: Fri, 30 Oct 2026 12:47:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: sashiko-reviews@lists.linux.dev
Cc: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>,
	hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com,
	chengming.zhou@linux.dev, akpm@linux-foundation.org,
	linux-mm@kvack.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, rientjes@google.com,
	willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v2 6/8] mm: zswap: Store large folios in batches.
Message-ID: <auQhULh1VTh6lWoe@gondor.apana.org.au>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-7-kanchanapsridhar2026@gmail.com>
 <sashiko-outbox-188658@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-188658@kernel.org>

On Thu, Oct 29, 2026 at 03:06:03AM +0000, sashiko-bot@kernel.org wrote:
>
> Additionally, because each CPU independently calls crypto_alloc_acomp_node()

Why do we allocate a tfm for each CPU? The tfm object is meant to be
reusable and you only need one for a given algorithm.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
