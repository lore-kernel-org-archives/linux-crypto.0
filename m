Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B9F35958;
	Wed, 24 Dec 2025 02:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766544731; cv=none; b=a3bdh6HmOSRS+x3zsIPwZ9t3uRrNFFPhroEDFIBoVeGwBGKSpj2NO6RJhxHcXHmkZ3mO2Yxm/Cj0HzYSiqYbvrt9IJyX2Y2Q6TpN+5drH3nbhoRPF4S3XIIzx6FgOeMENfxAzGIsU3nsOE12OhUjDHwFCvYTGuvtKoJpp5pQ6DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766544731; c=relaxed/simple;
	bh=rIobMIBytxHqliigfzI/GoLxJcNn2KjKt33gsAm/H9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rJ96I6eRCwQ7g24z1bT8HXDAGr7fmrBtr7EyWj3RkScERKS0LFH8Fx0/WV47lxH8Ue8J3TbtU1RBKHMtKy6n8DlvPAYK6O7pkE+4Vx0sW6rCbkwy5iVfdeSpiFPE2lpjAFdvFFcdRhSht0EWFeBA3VWizowSd60scrxBTzQ9ouw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=qik3LBnb; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="qik3LBnb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=/yPp9KdF5LmumiXREGGXTUo1GNMfe5ZLLyTJFeO5TDs=; 
	b=qik3LBnb2NJ3H6tqyq/kmCsfxwxdUdbbbVGoa/5PJuGeG8UjEd/U7LtelUxRXJQ9zCucF+tdR1X
	m7EDSUxIzBvtOsZUIi7+uYkjdj5zwDCikEZ/6l8rVFICcbQ/+3koW7rSHNHeRsxI0pI5valbPEb5u
	JrIRjy1o4Wx+6C7QdzInDJqRGdFGeY1ptkEDZhbRXYvoLm9wqYFdRz95m2RL0YIwrLyh1pBOSekm+
	SH7pLtuKM85qUAZs8VNSUCA8GAajJoVHjzspzKZK8bPf9Bgynw2ZRYvSMCM/78BNWA4OdFkr0QE7d
	gWUe1aMQC+c2QWn0yV60OuQ1m8tCW2OqQT5w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vYEyr-00CFU7-05;
	Wed, 24 Dec 2025 10:52:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 24 Dec 2025 10:52:05 +0800
Date: Wed, 24 Dec 2025 10:52:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: huangchenghai <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, liulongfang@huawei.com,
	qianweili@huawei.com, linwenkai6@hisilicon.com,
	wangzhou1@hisilicon.com
Subject: Re: [PATCH] crypto: hisilicon/qm - fix incorrect judgment in
 qm_get_complete_eqe_num()
Message-ID: <aUtVVZq-Jfmse8OI@gondor.apana.org.au>
References: <20251120132124.1779549-1-huangchenghai2@huawei.com>
 <aUT3IW8vlYKwWDt2@gondor.apana.org.au>
 <9e9b2fc3-7d6b-4ac2-86fe-2d88fbd2ca44@huawei.com>
 <aUjHoK9DoVIJj6oP@gondor.apana.org.au>
 <cde67fee-c90a-437e-a8be-a27865f8a2ed@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cde67fee-c90a-437e-a8be-a27865f8a2ed@huawei.com>

On Tue, Dec 23, 2025 at 09:46:31AM +0800, huangchenghai wrote:
>
> Commit f5a332980a68 ("crypto: hisilicon/qm - add the save operation of eqe
> and aeqe")
> 
> introduced an incorrect condition check, which prevents
> 
> the while loop from being entered to handle interrupt tasks.
> 
> Normally, the code should enter the while loop to process these tasks.

I see.  The original patch description threw me off as I thought
the loop condition was simply redundant, rather than inverted :)

I will add this for 6.19.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
