Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2F61F3BA4;
	Mon, 13 Jul 2026 03:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783914065; cv=none; b=NqOto5j4qh03019EraTXVQtHB8Civ06WAyj/UfeqZFRyYZsSt9keF+YSkxCHd9B6BCP6eR0dLBVbiV0qypzze4kcv/TC7J46vhkfqeQje6FubPASK3j1tG4tlBgZBqjxHUpOEXh/SAJ4b+lxrXrEWB3/jZulX8zR2wbVX48WX8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783914065; c=relaxed/simple;
	bh=2lWPq+LxCQ4jip7mCPrH6UY6ix+Hu/dNxPY24Am30Ac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h7wDw4eYWdIqpLNt2lMCkzL9S6NUeomU8BFV815a9+NeLu3Wivj7Dh8CvPESgOyvw8p6CNUySBE2poNo80j3G1LwNFdrr8lWolcVDz1uHuv/PruakrxPZueMeKwK9oYRPEYOXa6w3BmHDtepgSuyB2V+YvXlJ/QYbVE0kPxTBLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=dPig2rrk; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="dPig2rrk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=9yHLLXFfJ/KSmu77sGL1iM4dJlKPxha4+7ZmMnXuIcQ=; 
	b=dPig2rrkCu+Sd6R+AcfkSQLRq7cDrH9BGKcTiO1VN17R3sunt8FHZ7RVXexkAU5gTpZeH9w81Dz
	jyH9kDFaEej41SBL+pk8nDpztEn7rl/NjkOnuIVFEVfIlYwIdhw1eYtlmfj0kpcR0+d4yI1daAJKa
	az756ZR3/V9VbP6S5VzJbgjqj65vYUt/VU58qPSlZTsYwamm6iMLpiBf999Pbujkl/7iEgD+DJ4nf
	YBymYBHeRKSXEkVWFJuBWuAR/2dkxg6f9eQeTif9P791z5oXnVMYNXY7U4lFlzUKdaEiqVJgVKaz0
	da/6Fk4iyDtDaih5XpoMCyqDKWk6hjNMudAA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wj7XO-0000000CyDl-3pnw;
	Mon, 13 Jul 2026 11:40:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 13 Jul 2026 13:40:58 +1000
Date: Mon, 13 Jul 2026 13:40:58 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>,
	Kavitha Malarvizhi <k-malarvizhi@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 1/3] crypto: ti - Add support for SHA224/256/384/512
 in DTHEv2 driver
Message-ID: <alReSoxtZcSPLIKO@gondor.apana.org.au>
References: <20260526094355.555712-1-t-pratham@ti.com>
 <20260526094355.555712-2-t-pratham@ti.com>
 <aiKgs8ipDLPlz6c4@gondor.apana.org.au>
 <e0aec964-3303-4ca2-8d96-6a5d8f5ec9e5@ti.com>
 <aiKsFNoXryzWul0y@gondor.apana.org.au>
 <8502c0bf-5cf8-4042-a1e1-4665d8fa4057@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8502c0bf-5cf8-4042-a1e1-4665d8fa4057@ti.com>

On Fri, Jun 26, 2026 at 06:27:42PM +0530, T Pratham wrote:
>
> However, this sounds contradictory to the stated purpose of the flag
> itself. Commit 7650f826f7b2 ("crypto: shash - Handle partial blocks in
> API"), in which you introduced FINAL_NONZERO, says:
> 
> "This will come in handy when this is extended to ahash where hardware
> often can't deal with a zero-length final."

That was the intention.
 
> This looks to me like a gap in the framework; the implementation of the
> feature does not exactly match the intention. What do you suggest should
> be the approach here, and going forward?

The issue is that to make it easier for the hardware, with the
existing frame-work we would have to penalise the software implementation
and make it withhold an extra block too.  Because software is so much
faster than hardware, it makes no sense to do that.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
