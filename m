Received: from abb.hmeau.com (unknown [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50C5195808
	for <linux-crypto@vger.kernel.org>; Fri, 25 Apr 2025 03:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745552567; cv=none; b=lwQzebmhdHFTApjfU8QiBLEQyRxW69COH6PheuaLUPmoHy34H38w1VI+OyZADwgO/1DgO6amWfz9zK0XSd2uc2MmJRbAD3WoPzoxwQ9YW6QWO6tCdKitt1fwBbZH2mPcVHAcMog3/cyunspeJEbMuEkWqFuvVEVMNHMQDB84ndo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745552567; c=relaxed/simple;
	bh=kDc/0g61g1v7uDmuqGSSuIpnqNO4nbnU2Y/NX9iA1Gk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MRL18IRddrdUEJ3HrxNO4ozFmae777GeJJaArJXzSr5Rg3v0RHx01xCZL9HuDOq66/vcTQpuMdG37bseI3KdpyzAxGEWPVikYR7BGvh4WvSF6VWO/uMZQ8mtoauT3FdEBGgkXNif0XTOLEC6M2ft8NoMa2FFYsDimPoMBSOLwhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CqVBQ0DO; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CqVBQ0DO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=A0xckRWzw4HdEx9B6woI7l/2cPE4uylkTmzkd2VX7kY=; b=CqVBQ0DOgVYD8MxzV6qUBsEOsv
	yIX6mpDgjkz23xcUyYZrJUHrsLVrPHnzzw7x5d/D2pWRrSRITj91YiYzs8Dawk8aLm7PhM/S9st0B
	bCRwQEkxuu0/X8zcWhxNjR6Llcm/+W+p16vBoSfC6MSJq9LR9wwwHqCPDmb6ZJEzTMzASHCts5z+x
	woDAZUF9e3XsH8tjT87ljdzny1bi0HvelQCdYbG5rbYuP9tJu3MBOEavVKe7+GYotkrgrKE7F+1/y
	ANIQN/VBYbBok8Xywa+sEBMp+ThIz9uWS8Utaw3Z2WI43mihFHGbpfIKxJvkKPoNaJ/9O+Ye1jwKZ
	gLdryqLA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u89xV-000ryV-0D;
	Fri, 25 Apr 2025 11:42:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Apr 2025 11:42:37 +0800
Date: Fri, 25 Apr 2025 11:42:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 08/15] crypto: poly1305 - Use API partial block handling
Message-ID: <aAsErcJZ_FeJ7YEg@gondor.apana.org.au>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
 <20c70ad952dc0893294f490a1e31c9cfe90812a9.1745490652.git.herbert@gondor.apana.org.au>
 <20250424153647.GA2427@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424153647.GA2427@sol.localdomain>

On Thu, Apr 24, 2025 at 08:36:47AM -0700, Eric Biggers wrote:
>
> So now users randomly need to "clone" the tfm for each request.  Which is easy
> to forget to do (causing key reuse), and also requires a memory allocation.

It appears that we have exactly one user of the Crypto API poly1305
other than IPsec, and that is bcachefs.  But yes I forgot to convert
it to the new interface.  It should just use the library interface
since it doesn't support any other keyed algorithms so there is zero
point in the abstraction.

Come to think of it, the IPsec usage is pointless too since the
only algorithm that can show up here is poly1305.  So I will convert
it to the library interface too.

> Well, good thing most of the users are just using the Poly1305 library instead
> of the broken Crypto API mess.

If you only support one algorithm, there is no point in using shash.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
