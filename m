Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30908156225
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 03:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741232437; cv=none; b=EyPJ43Jl+mhWD4GzP/Ptj1wXY+QNQjAcjK7oTDGJifst9TD6T8nXefaydTM2iKsfaLyJzDwBQweyVyVi3+S27R9rPMM+VPLIRUovV8IiiakfphKhfuBWhHq65zLrn/ztBjPF41Xc4LuB6qly+xRtPVE/2qKx2I/4nfQZ+91syWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741232437; c=relaxed/simple;
	bh=FrMrTlKhK7ceDfmrmYxTk4F2sAYLrzDTstBL9cnYu6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=axHduzdkZKxdPHH3TQtSCS17EVQWadG7RHEv00YSlqpbDSIPlFzdY/UxR62E5WKHjtsABZ+2CJLzCt03nrmK57L2sND5UCqL3izKB6Lm8DPeG5FUV8jkgOfN6GoqCDslhrZfnBOkCBJgdSqRnjcNPrfzCWCLp2bA8QgmBuCcdp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=e1e8ydrm; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="e1e8ydrm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qrSi33iZ3CEYvllsp3oIScAyzh9fP8oW2kgGY1FCjjY=; b=e1e8ydrm4ON/ThDQi7+4roBgbI
	Mp1Uhg8CWrFU59VwpdobCNQkfCMVIh+ZEupewDBm6B2yaHukgLPVlk2HNQ2qhZi5ZLJfi4S0ULAis
	U4NcZEYn39Wam7Ig+J35YxA1xzhVCYZL/sA/bSY8St46zdUXWrgjplyAnpZHAzCDPcFJeWGYXhyP8
	H9FqG5MUriAL7OLSnleTADzjGHzJEqc0Ddblyysx9CSH3/hUxG/xkGZo6vKq9zSrFmvaAVn2mwq+R
	agDRcb+jU4KqVWwejUdZbegm9ItMQcnxOqa1Ty5lm/5tLAJVRY6lsQpAglXZba0WWYVNN88uRyU2r
	RUXBXWng==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tq263-004AYe-0F;
	Thu, 06 Mar 2025 11:40:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Mar 2025 11:40:31 +0800
Date: Thu, 6 Mar 2025 11:40:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: scatterwalk - Change scatterwalk_next calling
 convention
Message-ID: <Z8kZL2WlWX-KhkqR@gondor.apana.org.au>
References: <Z8kOABHrceBW7EiK@gondor.apana.org.au>
 <20250306031005.GB1592@sol.localdomain>
 <Z8kT90qXaTo15271@gondor.apana.org.au>
 <20250306033658.GD1592@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250306033658.GD1592@sol.localdomain>

On Wed, Mar 05, 2025 at 07:36:58PM -0800, Eric Biggers wrote:
> 
> That's exactly what happens to struct skcipher_walk.  This patch adds two
> redundant pointers to it.  Yes it's allocated on the stack, but it's still not a
> great result.

I forgot to mention that :)

I marked a few places in the patch with XXXs to indicate where
the API is being abused.  skcipher_walk happens to be one of them
where it's mixing the new done calls with the old map call.  So
I will come back to this and fix it to use the new next call instead.

At that point I intend to have exactly one virtual pointer each
for src/dst in skcipher_walk, probably the new one that I've just
added to scatterwalk.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
