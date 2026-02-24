Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD172E11BC;
	Tue, 24 Feb 2026 22:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771973194; cv=none; b=P41oL40S7OEQuW36hlR2OLnplf6/S++iA0bICWnoXVyd+ganfSUu8IQqnBdJEScWC+9SmF7muR0nAR4N4kB0HF42hzOz+eQ5bSJlzRKnE+JGg41eLWWci+sYIm7heIz3WuPUVagbvqe8uFbX9ZFzvkWH0L+xJtT+KYgumQisatM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771973194; c=relaxed/simple;
	bh=wNnBRKiUyzl5Cmv0v7Bl0Ai1gu0Y0qy78dEbkvy/OPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ND/jtAzPsXDx+L9kzKBEvQNrbuCHWh88HnhG/fRAGgIGSYMuADJSbC0mi0Qx07kdeO78lv80Vs4oZBXD4l0xC+Gbp+NpjSpFbw4wUEdXZuCbrLszfuzU/1HgzGsoNOefcsdaS5gys714cj1QSybtAnX+jvand5NxmEt35Ptfmzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jKAXHjkv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jKAXHjkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2DBC116D0;
	Tue, 24 Feb 2026 22:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771973194;
	bh=wNnBRKiUyzl5Cmv0v7Bl0Ai1gu0Y0qy78dEbkvy/OPI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jKAXHjkvpuXhzvepBGUSZvashkoupFy/RPadV6MaAh3245M/tI7n/qUoSVL5qtLLq
	 uzXm7bKbKk4+e/r2NMNlWEUbCSj35LydKkMK6pzfp5QHWIxhKA+lKCPVLo7b8OONYO
	 xMpvz7tBSf0OaLteCHkEZ2vupf8PK+AcOTKh8tJff/hDnqa4u8Ie2E402eavC7rmA5
	 cIuebh2KMhE66Bi2g/1mL9hLQ6i91kalKcDUAK+V5kYyRBP3nF5t9h9XcIa6zhwZAs
	 TbPc/ubJYrFVNZJA9+LrDjjjs873hlyAlLdCranIx2o6bDHHuD2GhUlddklk4Qwm5G
	 /Rq3yoxHyAgLA==
Date: Tue, 24 Feb 2026 14:46:30 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	kunit-dev@googlegroups.com,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>, Rae Moar <raemoar63@gmail.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] kunit: irq: Ensure timer doesn't fire too frequently
Message-ID: <20260224224630.GA130365@quark>
References: <20260224033751.97615-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224033751.97615-1-ebiggers@kernel.org>

On Mon, Feb 23, 2026 at 07:37:51PM -0800, Eric Biggers wrote:
> Fix a bug where kunit_run_irq_test() could hang if the system is too
> slow.  This was noticed with the crypto library tests in certain VMs.
> 
> Specifically, if kunit_irq_test_timer_func() and the associated hrtimer
> code took over 5us to run, then the CPU would spend all its time
> executing that code in hardirq context.  As a result, the task executing
> kunit_run_irq_test() never had a chance to run, exit the loop, and
> cancel the timer.
> 
> To fix it, make kunit_irq_test_timer_func() increase the timer interval
> when the other contexts aren't having a chance to run.
> 
> Fixes: 950a81224e8b ("lib/crypto: tests: Add hash-test-template.h and gen-hash-testvecs.py")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch applies to v7.0-rc1 and is targeting libcrypto-fixes
> 
>  include/kunit/run-in-irq-context.h | 44 +++++++++++++++++++-----------
>  1 file changed, 28 insertions(+), 16 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

(Additional reviews always appreciated, of course)

- Eric
