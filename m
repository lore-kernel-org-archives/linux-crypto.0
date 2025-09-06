Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F052BF012;
	Sat,  6 Sep 2025 08:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757145780; cv=none; b=Sub/Z043w0nXS21IhmxCM+qtd1WyHwb8nbBIkKtvsSf1e38pOA485UgzTi7w9ViL6oJQShASpcl6qPxelLufZl85n7ifLNlpWJnLFjjCBokxPinMJ6Ee4HhMZ9Aq+5rOLgU6ZEb+CxID2vkb+tKvH6zEuJmNAsYSsx5i157EpGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757145780; c=relaxed/simple;
	bh=k3uQYc+IKR77HAmMYPkyOcsdx7aTCl5F+45uNA4bEsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j8OI5q1/3gX9U7qvIqpNts1emZyYE7KCaflqwa+uDNdmN0Ea8WALwQf9koK4Dc1TceK6MRhkrZ2kItfJWz1/Vg33s8Lcvn2eiIGlCQ7JOyRFS0WkeJigL3wbE2asJxGRO30iayrxfRI2e5l0rjbJ8zpN+Snaja71EVnM9vikmyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=aaSuIq1V; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="aaSuIq1V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uw+KS0sbKqwsmGXPFHUt3oqbe6TcbNZNUb0S5Bf3hXI=; b=aaSuIq1VjmC/IJ6q5oMVl508jw
	mhlguid1G7o5dYAz5cYGMFbWVLanMuM3f8QmwsKSaQpz3zLDM3UJTdBy9uDA9jDj6/AUowTNvBESf
	a5jnjEl4s3nKAo650TByQEqfn73Ys7Nt8ja2npP4B/NFymx9Yw9XPqORnfTf4i0sh1vnPtFUlgR3b
	nuTU57U1RhtzjCF6MvMxtZhRGAZ3wicJ++lbBeTO3aJqKjFP76SZsOSceDl2iEVDwi9v3J5KRtc/k
	KxXeAMhEOrSFoaWGirYZfCFV70mXMG/oEynKdCT7QiJhL2bm+21fTHacpCXJEbeuVFt74RQy5Pp0X
	CD2VZynw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uundS-003BQo-1F;
	Sat, 06 Sep 2025 16:02:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 06 Sep 2025 16:02:54 +0800
Date: Sat, 6 Sep 2025 16:02:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linuxarm@openeuler.org,
	liulongfang@huawei.com, qianweili@huawei.com,
	linwenkai6@hisilicon.com, wangzhou1@hisilicon.com,
	yinzhushuai@huawei.com
Subject: Re: [PATCH 0/2] crypto: hisilicon - add two new features and two new
 zip sysfs
Message-ID: <aLvqrtX6rpHuPUwl@gondor.apana.org.au>
References: <20250830102757.1498691-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250830102757.1498691-1-huangchenghai2@huawei.com>

On Sat, Aug 30, 2025 at 06:27:55PM +0800, Chenghai Huang wrote:
> 1.The zip device has added two new features: hash join and gather.
> 2.Add lz4 and lz77_only to the sysfs for user to recognize.
> 
> Chenghai Huang (1):
>   crypto: hisilicon/zip - add lz4 and lz77_only to algorithm sysfs
> 
> Zhushuai Yin (1):
>   crypto: hisilicon/zip - add hashjoin, gather, and UDMA data move
>     features
> 
>  drivers/crypto/hisilicon/qm.c           | 29 +++++++++++++++++++------
>  drivers/crypto/hisilicon/zip/dae_main.c | 11 ++++++++--
>  drivers/crypto/hisilicon/zip/zip_main.c |  7 ++++++
>  include/linux/hisi_acc_qm.h             |  1 +
>  include/uapi/misc/uacce/hisi_qm.h       |  1 +
>  5 files changed, 40 insertions(+), 9 deletions(-)
> 
> -- 
> 2.33.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
