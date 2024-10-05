Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E84143AB9;
	Sat,  5 Oct 2024 05:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728106803; cv=none; b=eof9krCtzUVbuMychIlBMSD7iMr4uffmOJMXi7jZWDOP+HoFwzvBHtfN52ZGbLBZljWQa9bR90dJa/SZKt3wgJovYjJP7FjbmqOesuMdqJBgKs1yVj33LL3IpBivgAgfCrKUTHvB5D/bLLdZUa33w8886kVeJJOd723N5RjNim0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728106803; c=relaxed/simple;
	bh=V9vfSAnr53Lofhb344Obu1RUJkEAYtc0w7N1CqB4Iqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l/EB0Px5B/ANvFoeW+DGBSbgUdQW4v2Ghvrz5L3zbIqGHSM2jyouNiMqgKchIKRbv21y6s1h127/L/Ny4BLiXg2TUVqgocds0m/jCdfZBEZCihygUAxWlUnj7p24paPI+tN/vbvgw6Lt66JvdCxiSjo6jcXg6x2f9GSv/tLfJm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=n+8dNeeg; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="n+8dNeeg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PHfYCzL7ZsWOGKiThO8kPb765MeRxl/8vpl7CDyhcxA=; b=n+8dNeegUsf1QCHJb9+onX4fkd
	8N78D5TbUdYjLFxvwT4L9TtQ/jE1VLz8z+n8MjIxYAQQKe+zTzbLVRvdnXM5aJmgJ7cwkDi1ZIAXX
	x0r6re0lEA23gXECpqpN6grAclY6Q1zrvRLdf4xeMGGUMRwa8nOPeTv5Coh9kqh1t/Y6SsZbYmPrB
	xaKUqa+22E9p1d9HcJBzpE3SDg4oflGeb9Iq4Fg4eyyvAHMLmWo2Of4jBXUiQGi6jZNa3NRG5cf4u
	y1GZSoRosnHdw4U+10YE3pL4gxh9S1Vf8weiiazfbHjH78mfcj1CC9bg3Hjf6SS3UolTudIJLzJpS
	WovLa5Pw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1swxMJ-0071do-3A;
	Sat, 05 Oct 2024 13:39:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Oct 2024 13:39:53 +0800
Date: Sat, 5 Oct 2024 13:39:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: linux@treblig.org
Cc: giovanni.cabiddu@intel.com, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - remove unused adf_devmgr_get_first
Message-ID: <ZwDRKUbYDImOpWZQ@gondor.apana.org.au>
References: <20240929012442.435921-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240929012442.435921-1-linux@treblig.org>

On Sun, Sep 29, 2024 at 02:24:41AM +0100, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> adf_devmgr_get_first has been unused since commit
> 4a4b0bad0653 ("crypto: qat - fix crypto_get_instance_node function")
> 
> Remove it.
> 
> (Build tested only, I don't own the hardware)
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_common_drv.h |  1 -
>  drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c    | 10 ----------
>  2 files changed, 11 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
