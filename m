Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDBF3CDBD1;
	Mon, 18 May 2026 08:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779092513; cv=none; b=bW1k2VKo2RabqG8oJy3g3U1mlM7A05slOIS9E55YJabJrocKcWvQB1hQW4rWA23ZJvOHFiZ1eG+F5Kpu1OaqLvLtnxOvTkMzp0Fbgd7GeZSGnpZSpXiB5zofZPpjIASpsWhNrUxSO5N0qSvdGTv1PQhc+kRbyIOToB3wxy2BEpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779092513; c=relaxed/simple;
	bh=jupNb5ZCEfwVnAMPSOKII5vCCxYWEzJYSE1ukKNHy6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TU60MKTnutB39vCWzJdtUnL9T3D/1XI76WjFZDNyMwuUwj0W7/ckVv4zFQUzJZrsIRC3sGhplsO7nD5FKS/ZJjx1DGklZu8pXXX2ylpRxx3xEXL7Yf9Tt2QP8Qaoh6lTUDVn7uInJZ9+UhMVoG4wRYok+F9YQXnfPdix/G5sDrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=XWp3ipDn; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="XWp3ipDn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=KA/m99vVLVVB9er11dPrO69WnBpjru0jJzWipGXXtnQ=; 
	b=XWp3ipDngmnNKJADyCjvFyMSNrEFjGWq6M4nTDpWWUss4uvMlGaqmf+RLrC+Weu9Jcple5fIitq
	RiD6ZjYzQBa9CObk3cuyruAdcVXVm7orrSfV+Z0Hk5KaW4PU3jq3+oNBybb4wDLFvk0VbOdtMrLIR
	uEeXwC2e7TJcUbV2345ICO3vReHAWFXdRI3/AHsQw1xHG86TP89Z+PyxJ9XppHduY9AirBOWalAf+
	mhdEKpRLLB2TnLMf+84hHOD+n0xkUSLDvm8OrEZLV6C4V2zFwAtRfKVSDufHKUsLm6FirifE0/lGc
	g09w0rJNa3VUgcwQeWXPDJBKdSlb4yDvEztw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wOtEJ-00F5Sc-1y;
	Mon, 18 May 2026 16:21:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 18 May 2026 16:21:39 +0800
Date: Mon, 18 May 2026 16:21:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Scott Guo <scott_gzh@163.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	Scott GUO <scottzhguo@tencent.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] authencesn: Refactor in-place decryption
Message-ID: <agrME9xLx_XcXsGw@gondor.apana.org.au>
References: <20260515083645.4024574-1-scott_gzh@163.com>
 <4e9aee15-62e6-4d71-a836-250c5376a8fd@163.com>
 <8aaa00f3-d8e0-4de0-918b-1f025b632eb9@163.com>
 <agp6lDddmDZaoH6L@gondor.apana.org.au>
 <9f625d9d-6820-442e-9527-1b2802309993@163.com>
 <agqEvY4xJYjbZVDI@gondor.apana.org.au>
 <4fb33a60-7e62-4c73-b82a-e990dea7212d@163.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4fb33a60-7e62-4c73-b82a-e990dea7212d@163.com>

On Mon, May 18, 2026 at 02:48:39PM +0800, Scott Guo wrote:
> Then the problem comes down to whether ESP will be able to identify all the
> path and mitigate all of it.

Please don't top-post.

That's why I suggested a white-list, so only known-to-be safe
paths use zero-copy.

> 在 2026/5/18 11:17, Herbert Xu 写道:
>
> > Alternatively switch from the black-list to a white-list approach
> > and only allow ESP to do in-place processing of packets from a
> > source that's known to be writable.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
