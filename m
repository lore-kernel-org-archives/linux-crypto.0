Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7E5356756;
	Wed,  1 Jul 2026 03:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782875192; cv=none; b=pFUqObaFWQcFn14UZUHuoYVoQHVuSr2EmEyvQen3NJ9bGpAWJuzzyyhflDBLKZdsGWz8xJEl/N5PgBqlU9RVWtwkXtSb9pwdrr/nUHkkor4N8KmY4+VPAIv6Fyi0FZ6N0SftPyqZVjlrn9w3KgH6k0ldNaTmf/KyLcL8gBPgzpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782875192; c=relaxed/simple;
	bh=JBciXCeia/ZKV04Q3HNw6OAQhHJB+njKCuyEUxsY6p4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bVBOCU9UeeF+8FvNbroJk96pVqRC7J9C8Os/KfS330SX0NTUaQNsEYiRXulFH5PDYneOXOuKu5mdyEaWmj8R1ml7GTc99QerqmPuJ9+Yq+PShQHBr3CJwmmsVD/GDKur1pxUO4Rl0E9C6huna1yTlUZqQLKtbilM36SOKZP1pDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZNQw/dHz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZNQw/dHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BD91F000E9;
	Wed,  1 Jul 2026 03:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782875191;
	bh=KFACxb93Pqlx2Oj8v3zDX99ADpl6A5clMxDQYx3jf/U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZNQw/dHzz1O9JrEq1vLt6KjhQIsKk3/R/uMntjLw1V97JSqUlIz/7pyAIto1AWWO4
	 HnqsXB9gPdG1V4ODA4Bemx322eGybcG1zampzGQkZcO7L6QVL1FIWfDnAfTWmmys78
	 CySR/HAMGwE5HxPa28kGCuG0F6RSpG4fWUvkXZLgPsKD82rgKxwHiuU11cRTVSS6Ni
	 UL9LyXLOWH7MJqgbShYn7vIrN+pkd9K0dxHuvrsyVlvkRKMaUOsfpMo9cKbN/qDTXN
	 4UHaAkiQR+HDntRZQJwOMO0HzygofhnO3lRvNM4W+J1IoNH5fPCYBSVhTWPaBEPO1U
	 uI45TQiFUZ6JA==
Date: Tue, 30 Jun 2026 20:04:51 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Simon Richter <Simon.Richter@hogyros.de>
Cc: Demi Marie Obenour <demiobenour@gmail.com>,
	Andy Lutomirski <luto@amacapital.net>, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, iwd@lists.linux.dev,
	linux-hardening@vger.kernel.org, Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] crypto: af_alg - Add af_alg_restrict sysctl, defaulting
 to 1
Message-ID: <20260701030451.GA1799@sol>
References: <20260622234803.6982-1-ebiggers@kernel.org>
 <CALCETrXPj0u=FZ=aFcZAHk3fFZa7rCuPEjx6cOMXmT3sdkC7SA@mail.gmail.com>
 <20260623192715.GE1850517@google.com>
 <c7cb79ce-48f9-4433-ab4f-88b4c4df996c@gmail.com>
 <20260628185404.GA2292@quark>
 <641f0391-dd4b-4b25-88f5-5298fa6bf823@hogyros.de>
 <8c24ad17-8295-47be-a562-44c23538c4cb@gmail.com>
 <d96594ba-4ad5-4541-9660-2469875db9b7@hogyros.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d96594ba-4ad5-4541-9660-2469875db9b7@hogyros.de>

On Wed, Jul 01, 2026 at 11:53:16AM +0900, Simon Richter wrote:
> Hi,
> 
> On 7/1/26 12:54 AM, Demi Marie Obenour wrote:
> 
> > That said, if the crypto_rng support is to remain, should it have a
> > non-empty allowlist for privileged processes?  Otherwise, it's dead code
> > with the default sysctl value.
[...]
> I think that embedded systems will still use this code until a better
> alternative exists, so it's not entirely dead, and the best way to get rid
> of it is to build something better.

/dev/urandom, /dev/random, and /dev/hwrng.  I.e. what userspace
*actually* uses already.  algif_rng is a redundant, much harder to use
interface that got added off to the side for some reason.

- Eric
