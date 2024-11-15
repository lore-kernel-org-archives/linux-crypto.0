Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9566A291E;
	Fri, 15 Nov 2024 02:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731636581; cv=none; b=grlBvYRDYYuzAz/WE/uKGgrZ3bp5qxv1u4Y2NO4wQxfk7s7k6yXJX8T1rqUtoeBvO4DK9u1feEC8QOTOebGSliv95A8zMp67kjyfDQF4A08Kfh7gzxJO633anwgus4l4S3/K1utURR9/TxoGJXDnojXqpWbDCJ8yrzFHLYrzqDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731636581; c=relaxed/simple;
	bh=Y6ygmlK/kdjAD3oqVmbz+Gbbz7FixEkEpT0MnFz63OM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=amm5GuSXs0kTS+nO4Ju8jwpZrMDQclTpKbfDnF7MMiDVpBK9pvVtZ25MzGQ2QOmfmU+jhhW2Xms7dkH6Mz1fRkiGVfZ1vFYXV3UHkT+2Wsnxy6RsAg4tiGxPXdBOfw3g7XjqIvHWHs6RkBzvB7R+KBWQ7Wt2tMW87EMVjSG0h6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ZWq9X+Wh; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ZWq9X+Wh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SLrj4kmPTr3S2klGwW0Y2NFxxZbhgyNOjJxc8PvqMX4=; b=ZWq9X+WhW+rp5YBgSKh7Dx7gaJ
	DhdMvLF2tcvqPqCNStgPrRaBytrhwMhewMFQ51E/PQ/t6MsH1lTEoiEdwRs2jFer4NWQDHpANnVot
	DFijXh8QRr+FLEPGqDQ6UeWtCh0HP2ntpBsyigBCBkxrVfOb9JKjMDutlppyFyjUzawRHs+ZxeBuI
	wtbO8hEkCeSZzIKsGkahDcBEynjHjLyQvEQ/8c01mGb5077Ms2h84rk3bNr5INh9/3mOre2cIYZ41
	40vXRPw0c4KvBBPCn9BB3cOr+4X8h+cuGch11IY9p3W5qBjGIWbIxzplssgtiBad1TmfDyeaBTzrU
	plDOzGdw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tBlm4-00GwXt-2r;
	Fri, 15 Nov 2024 10:09:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Nov 2024 10:09:28 +0800
Date: Fri, 15 Nov 2024 10:09:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "linwenkai (C)" <linwenkai6@hisilicon.com>
Cc: Chenghai Huang <huangchenghai2@huawei.com>, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	liulongfang@huawei.com, qianweili@huawei.com,
	wangzhou1@hisilicon.com
Subject: Re: [PATCH v3 2/2] crypto: hisilicon/sec2 - fix for aead invalid
 authsize
Message-ID: <ZzatWBNAyjsuaRP6@gondor.apana.org.au>
References: <20241102025559.2256734-1-huangchenghai2@huawei.com>
 <20241102025559.2256734-3-huangchenghai2@huawei.com>
 <ZzAqQhiebKSuRzOm@gondor.apana.org.au>
 <b67cecd0-e50c-40bd-99b7-b85482e55696@hisilicon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b67cecd0-e50c-40bd-99b7-b85482e55696@hisilicon.com>

On Thu, Nov 14, 2024 at 08:47:11PM +0800, linwenkai (C) wrote:
>
> I have found another setup for fallback in the sec_aead_param_check
> function, so I need to fix it right too.

So you want to determine whether to use the fallback based on
the parameters of the request.  In that case I think you should
create a new fallback field in the request context.  Set its
initial value to that of the tfm context fallback variable, and
then modify it based on the request parameters.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
