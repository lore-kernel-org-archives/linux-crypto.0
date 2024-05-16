Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA6C79DF
	for <linux-crypto@vger.kernel.org>; Thu, 16 May 2024 03:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715829363; cv=none; b=UXVZqcDrUnGYSxOB0+4xKvhpDDmudsnI5FfHCx2nVaXpZnhrdvH2HUfup5L1jhPam4n47oxjiyad/Cv15VyUbVORFESSeTpvEJSUJwQT+DkZMytaAN2wskV0PMeuNz4nVUjksRqkGbww4azqvyh0zGGv6Ez0tLvOBaCg6EjbnP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715829363; c=relaxed/simple;
	bh=csFlgE7z9FWm+XvtO8OEh82aIpPbpLLpyZzQ2v7H5G4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S5kvvxItrWzohZHRcSsphvYxioulLaCpQXJv7w1qnqbCEztQqs4VOiXfBQOWNveSzL7gtvvyinZ6iHeFk5Z1HQABpa2jqW9Hk9ju6vHVi4YRHZSUu3JNjfsj0SWe1RMxNSn5GcLYMj1S0QaGljlNE8B9lk9A1kiAb8OxkBDvNww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s7Rav-00Fj4o-0V;
	Thu, 16 May 2024 11:15:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 May 2024 11:15:50 +0800
Date: Thu, 16 May 2024 11:15:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com
Subject: Re: [PATCH v3 3/7] Add SPAcc ahash support
Message-ID: <ZkV6ZmONMHEX7BQy@gondor.apana.org.au>
References: <20240426042544.3545690-1-pavitrakumarm@vayavyalabs.com>
 <20240426042544.3545690-4-pavitrakumarm@vayavyalabs.com>
 <ZjS8fQE5No1rDygF@gondor.apana.org.au>
 <CALxtO0m2wC3=yP5zE3_2nboVBVRVuhwuHx9Pdfj25wynky3E-A@mail.gmail.com>
 <Zj3Ut7ToXihFEDip@gondor.apana.org.au>
 <CALxtO0myn63AwPh4vck7fpuJcttPJYLBM3TpsyBAexCMSa4GcQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALxtO0myn63AwPh4vck7fpuJcttPJYLBM3TpsyBAexCMSa4GcQ@mail.gmail.com>

On Thu, May 16, 2024 at 08:41:57AM +0530, Pavitrakumar Managutte wrote:
> Hi Herbert,
>    The SPAcc crypto accelerator has the below design
> 
>    1. The SPAcc does not allow us to read internal context (including
> the intermediate hash).
>        The hardware context is inaccessible for security reasons.

In that case you cannot support the partial hashing APIs in Linux.

You should use a software fallback for everything but the digest
call.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
