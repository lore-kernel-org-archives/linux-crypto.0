Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749195C96;
	Thu,  2 Jan 2025 01:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735780227; cv=none; b=itmbBRxTsVILCVtTLZo5pdrfN3Rdw6U7Hx2pogOr/F0UnVGK6KjRmuZYaWsvOzaFfo99XwfvZhHsaAIoRz0iA0/GaR6zeITLFBU3lH1r0RRB5UF2qL3Pp2xM7it18XZyZTRGylXIqG9+QH8I0vT5hzwgrL/SzpXoAP0dU0GfwxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735780227; c=relaxed/simple;
	bh=SEQDhAowlXSMtpuIriBV2Gt8KoulPqZR/z2BFI+ezZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i/AecI3b4ddIGttuaF+QzC5fWMctRrAcRiOHtK9hbg7JeBoKD4agrY4/nLJQnCNJq9FrQjaOMEO37j8WArokY6WtwDBlTBT3rmUJw50JbqX+Bzs288b/j8jfmciTPZyqJVXSAYtbIziUZ8qH7cT1wNvV6Wz1XmyqHrtKkXn1Rdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=gVF50Kjp; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="gVF50Kjp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2Dxud7JxGUKcp46UURTaQMFNtA3oYK5oZlOaZTMVr0g=; b=gVF50KjpWNBE8hbUQ/GD0jsldj
	G+7V8Ipq4jzpntlo60L84d23Kp5YZsuhrZDOhZ4jI9+mTu4fGgK7P0zCIK822kDppBK0AbeDoLqdy
	Tl6br2+i9NskNNHoTWcXBz5E/Mxd30LEr9c1wNRVSPGLq1h0VgfmODbUxUqO9l3sFUuEi8GG8oIUZ
	c+rnPjDF6rHiKD8v8lFx9oZRL2w2wyeyOkSbilwVNqROJOR0fTzgxKsiYE1nerO6GgKtg9vp3AZLB
	sGulI2lTzyws4Ut5G9Shl1jCuu41+zrocBJ66UFqTFyQHMS1jvCi7MPbUDAWZ9f2CWBT29T13FoSF
	mbOKX2Gg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tT9WA-004xZJ-2q;
	Thu, 02 Jan 2025 09:10:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 02 Jan 2025 09:10:15 +0800
Date: Thu, 2 Jan 2025 09:10:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: kernel test robot <oliver.sang@intel.com>,
	Breno Leitao <leitao@debian.org>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-crypto@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [herbert-cryptodev-2.6:master] [rhashtable]  e1d3422c95:
 stress-ng.syscall.ops_per_sec 98.9% regression
Message-ID: <Z3XndzXUa9KYYz9f@gondor.apana.org.au>
References: <202412271017.cad7675-lkp@intel.com>
 <Z3HTN1gvVE9tfa4Y@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z3HTN1gvVE9tfa4Y@slm.duckdns.org>

On Sun, Dec 29, 2024 at 12:54:47PM -1000, Tejun Heo wrote:
>
> Hmm... the only meaningful behavior difference would be that after the
> patch, rht_grow_above_75() test is done regardless of the return value while
> before it was done only when the return value is zero. Breno, can you please
> look into whether this report is valid and whether restoring the NULL check
> makes it go away?

Actually I fixed that when committing the patch.  It should be
conditional on whether the insertion succeeds or not.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
