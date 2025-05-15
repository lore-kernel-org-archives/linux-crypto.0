Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A751F153C
	for <linux-crypto@vger.kernel.org>; Thu, 15 May 2025 19:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747337460; cv=none; b=Po5n/urN3IqpNL4u9rhV/pyZAIZDxmRrLnN/DKveOETkxFSYGLlIhRd2fX9g0BFaqQmhzSMhfwpd8V2UamYezY+ol2DEt0u80QJgeioYV17tboTGXaWTdF8B9pT1SJFh4lI13NH0OA32WMpviYk4xRDspF9lJyL0vk8O5GqTuJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747337460; c=relaxed/simple;
	bh=Z6baTLlS74Ljd/hClg4pQKzc3KDjjO+3Vq1wyxMEbvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NH3E0Fj3EySMjc6sytNhPcYJMxiFmRElN5mUYWrGAxXJsLkP+KIFcztx9WgpGZLwdoE0D0HWAkTpuciIDIJjYcRSyI8Xshmizc65mTS4c1SOSBwJSmpejXCJJgE1kxmmR6FPQHT5Rr3B4WyrHFIZxuP1leDDhS7c5Bf2MUMJ5hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MNL12KC2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MNL12KC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0B0C4CEE7;
	Thu, 15 May 2025 19:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747337459;
	bh=Z6baTLlS74Ljd/hClg4pQKzc3KDjjO+3Vq1wyxMEbvw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MNL12KC24LgNMUSzwu7Gy5/PFKxsktUl2KzGEURwoeLbkwQNVioHiWNB5fkNzAINC
	 Shpt1p9Ha4+22Ys4FopizG360v+qFnM4BRfV5gKkmcCReUgqVSiq+u0zsIy9saYIRm
	 YVlcarpz8p5k5mC4fnnIH9SPZae1Ph35BAFPGVRNtHfQ+MhvzspGTY+PrDnptw2xzQ
	 oB631N6MI7WrOH/3AjBeJUid++c3VlDefqj1zkODiHMC9Pc0wTk9PbdVfR1cTw/6by
	 FYqpIA6QXx0kx5NFYrUU3pHaDEfmWGIhVxx2337xaIfMTcy7ydpP+fTNPViZg6RXMn
	 ol3s2be0L+swg==
Date: Thu, 15 May 2025 12:30:56 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v4 PATCH 10/11] crypto: testmgr - Use ahash for generic tfm
Message-ID: <20250515193056.GG1411@quark>
References: <cover.1747288315.git.herbert@gondor.apana.org.au>
 <8d8aca050771f8237895e38240a8bc2fe91207b1.1747288315.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d8aca050771f8237895e38240a8bc2fe91207b1.1747288315.git.herbert@gondor.apana.org.au>

On Thu, May 15, 2025 at 01:54:54PM +0800, Herbert Xu wrote:
> As shash is being phased out

Again, that seems weird when shash is what most users are actually using.

I would like to migrate most users to lib/crypto/ though, so eliminating shash
should make sense eventually.  But that's for a different reason than why you
seem to be pushing it (you seem to want it to be replaced with the asynchronous
hash API).  At the moment it seems premature to consider shash deprecated.

- Eric
