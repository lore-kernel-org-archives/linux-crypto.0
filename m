Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0949F279DCC;
	Fri,  2 Jan 2026 18:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767378488; cv=none; b=XbYFowfQAC6/smSXTnZ0CBY8noUMaAuqYqifU3cx3XsYlNMA7OlB87K+dCNxJ9vORoegsM/hu33KyKQAdWjttwKAQ+njKjC2t2Y0+x8aDxZYJwm693HlNop+4yzNYVINVrEPySQgkv6e436tqWmcb1QLPDSaLct2tSlJ4PRRQxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767378488; c=relaxed/simple;
	bh=RSTYLyXFYeu4mDqhlDrH9iPT+8RmlGXPRouO21uFv8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SEyOJ+usdFY05qYTuQdA1rdLv8uLoZFKYDzPIg24raxARRD3E52rT+ICVv2uI6y8E8d3c5bR1WyLLMvJKheroi/KkZdEjxF6xZvC1+vkGLn8uI7LRyRw8hyH2gu1C1WrmIoxXpkR8cum8Y8ias0s029wQ03akKXYs7G/jAleQHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p7TORCdL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p7TORCdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBC0C116B1;
	Fri,  2 Jan 2026 18:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767378485;
	bh=RSTYLyXFYeu4mDqhlDrH9iPT+8RmlGXPRouO21uFv8Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p7TORCdLUOHJjoR/WGI8xdijCBEPvFkkk/HV1u+pJL35Xm/sz2FtWCZEYDLWIuzop
	 YdERkJfrfZeTMNVCmbMrOe1cg7nHI1i5mtQ7inNsdgGZOi1Qrd/Z7QnmXNwQLwEZ6r
	 4MmFTF7iIQsbQ6MkBFwX+FfOLj3DcgslCkLFR3VtYnCjEb51v5gED86yLiS8SculhU
	 QaxtS+pDByYY4tPHkJg5HW8UA8DV+fLKER8mQXTzJKOPPsnIld40/xLwvIceSfjpKF
	 yUjxC7n8j/fj/7uUkEarQMMxvlXrodE62qVs9u6cQB+uaflZpNy2p1sZUrD2MTBzXI
	 d9gDzbi627SdA==
Date: Fri, 2 Jan 2026 10:27:48 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: tests: polyval_kunit: Increase iterations
 for preparekey in IRQs
Message-ID: <20260102182748.GB2294@sol>
References: <20260102-kunit-polyval-fix-v1-1-5313b5a65f35@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260102-kunit-polyval-fix-v1-1-5313b5a65f35@linutronix.de>

On Fri, Jan 02, 2026 at 08:32:03AM +0100, Thomas Weiﬂschuh wrote:
> On my development machine the generic, memcpy()-only implementation of
> polyval_preparekey() is too fast for the IRQ workers to actually fire.
> The test fails.
> 
> Increase the iterations to make the test more robust.
> The test will run for a maximum of one second in any case.
> 
> Fixes: b3aed551b3fc ("lib/crypto: tests: Add KUnit tests for POLYVAL")
> Signed-off-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>

Glad to see that people are running these tests!  I actually already
applied
https://lore.kernel.org/linux-crypto/20251219085259.1163048-1-davidgow@google.com/
for this issue, which should be sufficient by itself.  Might be worth
increasing the iteration count as well, but I'd like to check whether
any other tests could use a similar change as well.

- Eric
