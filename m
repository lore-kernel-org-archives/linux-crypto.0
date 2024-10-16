Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287561D172E;
	Wed, 16 Oct 2024 09:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729072431; cv=none; b=GQt6eodp7S6tBZRYFlFrdfe0gBxOxWiom498ACZXl7qvuQhOg49iCMDFqgLYA2ssDtwiDuP+vOtSP6aF1o8FRy17vxuDqvgPZ2IHwRcN7+/lLJjWmOFQ4gEL1TNCfif9qx6oBE8+QlAeqAtmMNH/6P/nPqpyOrh+kQ4sqKSxWMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729072431; c=relaxed/simple;
	bh=fEDaxA673Vw1JjJLbhAzYRCPIrt04bAsMDObPTvA13w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u3RbbrLo76wFbI2oNRH37MKElxG4qAprcm1z0OCmFna82ENowbf8h0keMK/SVADR5Ssw81oRzyTKudBDWbkn/5zfQ4ALNN6uEPJOJ8VtOnOWLNTlYA0A6PEWyAsZyHVgGW61aZ4apayD7C3864/6boXLn22NZS/VfvJtIKeGWJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=kSEHDwTB; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="kSEHDwTB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=i0wsD/ovG4OKkjkMk1uF4FxWjJEvBUcY2NZhQNdcuX4=; b=kSEHDwTBJ8DiFZhQrmfhkVqlAG
	WeNzX9Ej2/DxILBzGRhQEOwpzZ1kHBRnPgQrUq2St5MmK5uNJn/H58MyNPFKnbJhK7nuCYoeHObYL
	lWnQF6g9QUuv4nYvkz5Wlf906V8oMiu3A5zkmY+CN5i+f0E0Tln6WbVfx95n4UKnUBWW1hZ2TAdU9
	Bd+YEXD4/6dJkbgVGO0tme9OlxzTHIVNMj/4nHx6nvmd2+3nE2+RKDrSToNcfBZukomC0Db1bHiqt
	YqxQhWACNv/LwERwlqNc0kEMjdTm5RLjJbafiCIBaWWn7qrH+vdkve0nK4FSFwyWpsYMNIXInYZ1h
	sExQ5LrA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t10Yz-009nXk-34;
	Wed, 16 Oct 2024 17:53:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Oct 2024 17:53:43 +0800
Date: Wed, 16 Oct 2024 17:53:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Klaus Kudielka <klaus.kudielka@gmail.com>
Cc: regressions@lists.linux.dev, linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Arnaud Ebalard <arno@natisbad.org>,
	Romain Perier <romain.perier@free-electrons.com>
Subject: Re: [REGRESSION] alg: ahash: Several tests fail during boot on
 Turris Omnia
Message-ID: <Zw-NJwLXXQ0DwR8b@gondor.apana.org.au>
References: <38a275a4e0224266ceb9ce822e3860fe9209d50c.camel@gmail.com>
 <ZwZAExmK52txvHE8@gondor.apana.org.au>
 <7e38e34adddb14d0a23a13cf738b6b7cccbfce6f.camel@gmail.com>
 <ZwduxHxQtHdzz-kl@gondor.apana.org.au>
 <ZwePSPG8aWm6mwKK@gondor.apana.org.au>
 <15fadc356b73a1e8e24183f284b5c0a44a53e679.camel@gmail.com>
 <Zw31JIEyh28vK9q7@gondor.apana.org.au>
 <5db212655dc98945fa3f529925821879a03ff554.camel@gmail.com>
 <Zw9AsgqKHJfySScx@gondor.apana.org.au>
 <2ae8006f3cfc40ae66b34659365596ac8507d1da.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ae8006f3cfc40ae66b34659365596ac8507d1da.camel@gmail.com>

On Wed, Oct 16, 2024 at 07:51:38AM +0200, Klaus Kudielka wrote:
>
> I tend to agree - it was a nice try, but non-TDMA doesn't work at all.

Alright, so next I'm going to try to make TDMA entirely single-
threaded and see if that fixes it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
