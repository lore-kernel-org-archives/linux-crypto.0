Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3907EF
	for <linux-crypto@vger.kernel.org>; Sat,  1 Jun 2024 03:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717214074; cv=none; b=EXTUj5pQN1YQgHH1+UVvfHGcmBvL6fRwgAUdlRjRFQEdsEmwMeXEJvhNsbTue16QLjFU0C1illcZJMC2vfZ6w3qM5RtYWSS5kcpw60i4HaojP+na/czN8SYm4C4vGFS5nB3z61T4Z0TFfwXlBTTz9rRIsBsyNCQ4XuQHYSc+Bg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717214074; c=relaxed/simple;
	bh=64G2N5i90bQeqXxnyJXkBc7wziIEggkBJyUufrswH8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zj91TYSM8uZ7PDbo3NsBJmaAmaZCbTzG7tw+7VpCyth+iC39JCcJWTcG8IQw8ckKH60XE7IXEqVbnSOHElxMqK3oCF7Ue7mKjzYxET46dDLLeIYUuNQPIQZWHIRVAlDnukr6926yYqdn8jgZcpBsNQ0m2VcWUfTPELCobi6o3dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sDFp0-004VHl-1h;
	Sat, 01 Jun 2024 11:54:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 01 Jun 2024 11:54:24 +0800
Date: Sat, 1 Jun 2024 11:54:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/3] crypto: scomp - Add setparam interface
Message-ID: <ZlqbcKUTa5e3rOtH@gondor.apana.org.au>
References: <cover.1716202860.git.herbert@gondor.apana.org.au>
 <84523e14722d0629b2ee9c8e7e3c04aa223c5fb5.1716202860.git.herbert@gondor.apana.org.au>
 <20240531054759.GE8400@google.com>
 <20240531063444.GG8400@google.com>
 <ZlmKX4dD1EcstVmN@gondor.apana.org.au>
 <20240601002415.GH8400@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240601002415.GH8400@google.com>

On Sat, Jun 01, 2024 at 09:24:15AM +0900, Sergey Senozhatsky wrote:
>
> Is it possible to share a tfm? I thought that tfm-s carry some state
> (compression workmem/scratch buffer) so one cannot do parallel compressions
> on different CPUs using the same tfm.

Yes the tfm can be shared.  The data state is kept in the request
object.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
