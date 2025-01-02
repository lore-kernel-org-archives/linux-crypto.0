Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA981C27;
	Thu,  2 Jan 2025 00:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735779544; cv=none; b=FwL3HvIbVCFa/vZgub3tFix5PE92H8LRdccMmX/T9KVT0rf8GvtEfgOku7N3BfUfmgX3Qd41/9pQzBB6sNZwzhdlo4zBb647pzrgtcXzaIBXTbmwpMri8sL/SNVcUg9bRbef8T3pYeug4vxW3gY4GWX2CGZCdvhBWnnp98tCIaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735779544; c=relaxed/simple;
	bh=8Lo+b2/tCz/Dts9/MYGZko3Ti09bR5abweLZIbSoYcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sg09Ir+T2WNvbZC+iQBEXnPHRW0pHB9UcH+u8xihPBMyX5vMwAh9GymsyzELKgRngW1vpxzea+RuhakN0ssYOr9qqABDKrVCIGIbyEx2xhQM4QAnZnMgS0Ja1Cs9AtkQ+d0OVD+LRdhGrgWodhPs37oynRUfjbQKHWQ8bDvDEdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=qwQMF47W; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="qwQMF47W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6dbTPOrHURArobGAdXxRrDpLkG2dvUah7PQL8Ltk/fo=; b=qwQMF47Wh6EGmYsyosIwRjkTgy
	rmMJizZDC6iKuGDvyXMkcnKC7xV22Sm1+4ph++tUjfRO8AVx//oeAYCvvU3ONJun889Wq6g+xa2tC
	h/ASrFiaxB/R0MiM+1pq1N3OcQA/LHHRALimFbar3cY20L1+SW7PY506SiTSyQby5oR5iDa1KJj8W
	2ZDMgnzCUUkImKe2Sux/HMsEkvlcgI360WFMtL9P/1uGfXGGDPwSqsKs4i1B9/h6xQlj3VMfAUjmh
	ulQOlPLFK4TpYONI1wouBrq4BZ01L4cAJoTc9riZ5Z0KTrQT1v6JDdLmSgAug6Itm1bH3xWOm58kj
	odrUuzXA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tT9L2-004xJw-3A;
	Thu, 02 Jan 2025 08:58:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 02 Jan 2025 08:58:45 +0800
Date: Thu, 2 Jan 2025 08:58:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Akhil R <akhilrajeev@nvidia.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
	"thierry.reding@gmail.com" <thierry.reding@gmail.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] crypto: tegra: Use separate buffer for setkey
Message-ID: <Z3XkxdheTGBnCmQR@gondor.apana.org.au>
References: <20241217161207.72921-1-akhilrajeev@nvidia.com>
 <20241217161207.72921-2-akhilrajeev@nvidia.com>
 <Z2_iroxlT3C1d1HQ@gondor.apana.org.au>
 <PH7PR12MB8178F6A37DE6CD41850529BBC00A2@PH7PR12MB8178.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR12MB8178F6A37DE6CD41850529BBC00A2@PH7PR12MB8178.namprd12.prod.outlook.com>

On Tue, Dec 31, 2024 at 04:25:06AM +0000, Akhil R wrote:
>
> Does it sound good, or do you think it will make the code overly complicated?

My main concern was arbitrary failure when you exceeded the 16-slot
limit.  As long as that problem goes away I'm happy with any solution.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
