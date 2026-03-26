Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E23D33CEBB;
	Thu, 26 Mar 2026 20:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774556856; cv=none; b=VPbjgflrqFlaqHks/rymHyZXv8KvXsurXqkpdg5AQB6YLPIjvJ5o2mngrjvNn3YFadKG0yFojo5FRJP/lw950XkirN9TCk3tdJbLJBYzkEQffYkcsWs606kbhm80JGLImjEqCNcqrS6acjjOSNofbOGAQzc6jvWGBJKgynyo/GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774556856; c=relaxed/simple;
	bh=yn0BDY7vp9Pcr7MqnVqFCmbCbwvwJcm9ZFA8KCpszck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qn+7DJXgQIQIWK1D5sE1u+BntDN509pqtob7GjuC00vZ1SZCKjcmymyhSbF4hqr8IXhvSQR6KuQGWx3a1MDdxU/BuTwjKdgNieJUz7wJaak/k3pmzZs9N4EqbHVa6+2a9WjAjYJuiVWcWZZcajQgaf52DdjfPgvh9p9+goDhN5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rJQhQj55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rJQhQj55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B69C116C6;
	Thu, 26 Mar 2026 20:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774556856;
	bh=yn0BDY7vp9Pcr7MqnVqFCmbCbwvwJcm9ZFA8KCpszck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rJQhQj55F4A98kcgCjte8l0E67k7Zn7x8x0oCeGXtqGV2QI/Ys611BhY1+Uk4F90k
	 YtZ1UCqfXh2AQHTF5RgSXrqVPQZc51PYLm/ZZnq9D87ms/kcztYCzBXHkJ2lJ4umM5
	 Ba3ukLFcGZ0YY2P0cMzG0173oLVc3FUNu6h4cvrlW6VxWzv17CtfV7B8snb8YPPck8
	 PHYNczcIx14PQQ4hEzrd1Y9Lz83N4LSUwCsah2uHgmWEnN32YShJdv6ZzewuWo6P9E
	 P6r+eMb6A2Gm2JxhPkH9LM/BnhyY950wIR9MTSo5p3t4wdBv/HZN7aR4h1fNJCwOcG
	 asDhT+oh39bAQ==
Date: Thu, 26 Mar 2026 13:27:33 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org, x86@kernel.org,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>
Subject: Re: [PATCH 0/3] crypto: Remove arch-optimized des and des3_ede code
Message-ID: <20260326202733.GA2657@quark>
References: <20260326201246.57544-1-ebiggers@kernel.org>
 <0982d4341f58e2f1181bc472dc9c9d8542148e3c.camel@physik.fu-berlin.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0982d4341f58e2f1181bc472dc9c9d8542148e3c.camel@physik.fu-berlin.de>

On Thu, Mar 26, 2026 at 09:20:51PM +0100, John Paul Adrian Glaubitz wrote:
> On Thu, 2026-03-26 at 13:12 -0700, Eric Biggers wrote:
> > DES and 3DES are cryptographically obsolete and insecure by modern
> > standards.  Continuing to maintain highly specific, complex assembly and
> > glue code for them, especially when the code isn't testable in QEMU
> > (s390 and sparc), is unnecessary and risky.
> 
> We're working on getting crypto instructions added to QEMU though.
> 
> Adrian

In general that's good of course, but DES and 3DES?  Really?  Why is
effort going into these obsolete algorithms at all?

- Eric
