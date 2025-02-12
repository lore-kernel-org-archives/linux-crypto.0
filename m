Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAE51EEA28
	for <linux-crypto@vger.kernel.org>; Wed, 12 Feb 2025 05:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739336416; cv=none; b=PD7oMxSBvUBUzxaW8BL1pBLYvQ66wjy6EsUmsl/nHDTB/fv761z+j8chhXPcxxa+TSSV6x+5C2lUZBBSWIE0WjIZSsVXogVmgQbntPFE7jYcMly0JXYOrtk9dTsnpGCH3qEJv+Vk0AQwuYieO/BgkllzGy1PPbznh1/LQ5fcEoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739336416; c=relaxed/simple;
	bh=xS31rm0DzUSKeEy8Og2CbgSubNyhb4oZ7ztjq29Xf34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XjFy0qdL6l7gmi2sV7LoWY9QUDKl2SuNuUQv1BONd8PuDCN1LY/nBl63+MAmZ5llEmeq9ifPdAukOeoN5AdyN5KzEUnRjntkLiPsZ7C7DcBqCl1XTWxNRmg8m1vzvhUaDkaw+CvE2Oj4pH8jtJgtM1mAO4QgMoK6PwW054R7JJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=XiLIGY4l; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="XiLIGY4l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nF7n0xHCocGZz6S9lFgP2bPFZiaTQzUFDLR/z3BNJj4=; b=XiLIGY4lEvtzZvAzspd85x5V9T
	7MwK/a/XIme2/hr9Siwehl5JB7saiAwQqT1hE4gwh+PUicDeY9ed1l9fDo9u/385sbbsjANh4e4+x
	Z5L1BQ8IiiVj7U3F4GL37mL/m6WvDjPWP8laSs9/HXzRObUM9U5bulMFHaeJzMUnDWh7IgvHiTvn1
	+WqP51wNXObxXwRGdJ/L7LLJLiwhRx0ajmhz+C7N9291suKLrAMLw5cqgMsY0nfjboiw12Q0kh1X/
	k1PT4USzxLFk2tgkMKpZdO+bsRKH9tuuysqO7tf5PEcwgD5+PuiAhjU7xOSDJr9zCcLMcjZVJ3cE/
	kKislgqw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ti4e5-00HDyx-2N;
	Wed, 12 Feb 2025 13:00:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 12 Feb 2025 13:00:06 +0800
Date: Wed, 12 Feb 2025 13:00:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Marek Vasut <marex@denx.de>
Cc: linux-crypto@vger.kernel.org,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Li Zhijian <lizhijian@fujitsu.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Olivia Mackall <olivia@selenic.com>
Subject: Re: [PATCH 1/2] [RFC] hwrng: fix khwrng lifecycle
Message-ID: <Z6wq1gG-4SnwwiHm@gondor.apana.org.au>
References: <20241024163121.246420-1-marex@denx.de>
 <ZyX7ind-SnHoDt7E@gondor.apana.org.au>
 <76ffb184-5047-4446-879e-2b42a7191b42@denx.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76ffb184-5047-4446-879e-2b42a7191b42@denx.de>

On Wed, Nov 27, 2024 at 07:59:00PM +0100, Marek Vasut wrote:
>
> I'm afraid this problem is still present, since kthread_park() synchronously
> waits for the kthread to call kthread_parkme(), see kernel/kthread.c :

Fair enough.  But we still need a solution to the potential
reordering between kthread_park and kthread_unpark.  Any ideas?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
