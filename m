Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E4B8472;
	Sat,  3 Oct 2026 03:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790999368; cv=none; b=PtMvP9bodPqdYkDp0EKtDtNskxoH94l9232lJ8/AysI/Ou3N2zCWp97ySHTnCwQGTdXSvvoXfjJnn8J/XqdOXbVsEixvep1riKx/oaWx4oa7ooeK/I+wp3A9dVDhca+tMq2xJCV4EyROLdoVVoGpLp+BViLmWL97vBzTm1CY6A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790999368; c=relaxed/simple;
	bh=pye92iNL1QQFKBK7p0G2AYW3/lry2+c1DjuTD2qsOT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o7F18ZCkDR2SsHBf5K1rSHcW/zYc5s85W+9WruGR49QIxlaKJ6A8IyrKQM0p5KZzd6ag9cVHPaSZxFtaID/S6o/eMjRRK4vkVAOJTjn+EEw4bEka/nP18aBVS8/9dnZIHqTopi0noHLNKDxDu947bQqj8H2e3J6ydTl1OZh60ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=Kv0KtzLP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Kv0KtzLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD6A1F000FF;
	Sat,  3 Oct 2026 03:49:25 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=zx2c4.com header.i=@zx2c4.com header.a=rsa-sha256 header.s=20210105 header.b=Kv0KtzLP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1790999363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nag5b5Z42Rte5kJHTxcJ30GqXYSrNFjeBXnuRfPrDyc=;
	b=Kv0KtzLPvGNjbdjM+cDqP0C4ZN9oWqG6Bw4nafvOA8rAPSpUrbHDMRRaBu/4+Fge1DK3a4
	5ZGzXwiANgKGkaUfVZq9VsIgHrm+CtvqnSFSHQeOknR5jafWn8tql+KIdKD6NvVJ89Qty3
	WKivg/wHYgYR3L5iOVFNaqryAYunp1E=
Received: 
	by mail.zx2c4.com (OpenSMTPD) with ESMTPSA id 397e1212 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sat, 3 Oct 2026 03:49:23 +0000 (UTC)
Date: Sat, 3 Oct 2026 05:49:21 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lib: Move SipHash into lib/crypto/
Message-ID: <asB7QVFMlgKgbje2@zx2c4.com>
References: <20261002223708.39183-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261002223708.39183-1-ebiggers@kernel.org>

On Fri, Oct 02, 2026 at 03:37:08PM -0700, Eric Biggers wrote:
> The addition of SipHash to lib/ predated the existence of the
> lib/crypto/ directory.  Since it's a cryptographic algorithm, move it
> from the top-level lib/ directory to lib/crypto/.
> 
> Specifically:
> 
> - Move both siphash.c and siphash_kunit.c.  Keep the header
>   <linux/siphash.h> as-is for now.
> 
> - Keep the dedicated MAINTAINERS entry for SipHash.  Just update the
>   file paths it references.

Given that I'm also listed in the crypto section, I think we may as well
delete the whole separate entry.

The only downside of this change is that those hsiphash functions are,
erm, a bit less than cryptographic-strength. But maybe such concerns
don't really matter any more at this stage, and we might as well group
it all in lib/crypto/ where it all belonged originally anyway.

Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>

Jason
