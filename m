Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80228372B27;
	Fri, 24 Jul 2026 18:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784916595; cv=none; b=UetvRNthPHbIyzCKYjMRKjXZWXWjpDkzs5alDIZ585fgMc6uqHvlmWzYTCihKeC1PWdptDZGV/2bvHbfeMd0jEy1LfSLnhC3yZpEFfhLOlN20Y+OJigyUwJPjZvu4BMm/Lt9dM3XXXPzUYRfggQibo1vQyhN+kXsF3bPg9SgsO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784916595; c=relaxed/simple;
	bh=bFIqcyvVYPNAGB/LeXl5fQm3+zCLcP5EpI2YQJ7ys3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LnbqoS1WglsYyGMv+LI6JkjiQE4CmWAEBoYDFpJkS9pev+K4SrGQe55NXV24EDK8zCVD7ZXvdIMf6KDrWHGV9Lik7bKHQwcnIWSr/9opF1x+dP4x2hjCqg+I4XqnIxS7/XsJbLvVoldsBByJdusY+HKHwC/wR3t3QzVndS1Myb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kijzZpGp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kijzZpGp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798001F000E9;
	Fri, 24 Jul 2026 18:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784916593;
	bh=W5I2h9ahvZkwGLmDS66ZzofAw7NuUB1UxEnSrD9bZs0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kijzZpGp9sVcxDCd/soevUkdVfloe2cDVsSh0lok7I0Mj5a5k+lBw96K9yiP9DcvC
	 ZHKGyW9e2FqEhAVn4IA80eqUepmDEuGuOx1aAKYLMysStpt6HaYtjg+Bgu00VEiy5p
	 UmZjvDvoGJVmh7vACnzCVCOkKmr5fwCUfPHFbnLVT86moqTjpnW7vj253hzj9PrrIr
	 SLQJ4CWc+ShM0GyCS/Ah4m+PMBY7IUoFS1lWJNBjJ8s7BZGx1qCV3NZovKsL2fF/DC
	 9pfT3yXOsdwTmlRC6eBCPGMWFpANu9Juakvh1rX9YaAcdXPy5f4CwrVohjUauRNAFu
	 32azQUSumSWcQ==
Date: Fri, 24 Jul 2026 18:09:51 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: demiobenour@gmail.com, Harald Freudenberger <freude@linux.ibm.com>,
	acme@kernel.org, adrian.hunter@intel.com,
	alexander.shishkin@linux.intel.com, ardb@kernel.org,
	axboe@kernel.dk, corbet@lwn.net, davem@davemloft.net,
	edumazet@google.com, herbert@gondor.apana.org.au, horms@kernel.org,
	io-uring@vger.kernel.org, irogers@google.com,
	james.clark@linaro.org, jolsa@kernel.org, kuba@kernel.org,
	kuniyu@google.com, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, mark.rutland@arm.com,
	mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
	pabeni@redhat.com, peterz@infradead.org, skhan@linuxfoundation.org,
	willemb@google.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH 2/3] AF_ALG: Drop support for off-CPU cryptography
Message-ID: <20260724180951.GA1572592@google.com>
References: <20260523-af-alg-harden-v1-2-c76755c3a5c5@gmail.com>
 <20260603133312.12848-1-freude@linux.ibm.com>
 <amOGWwdjnJqyxH5L@codewreck.org>
 <20260724160034.GB2032@sol>
 <amOTjPW__CNZui3_@codewreck.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amOTjPW__CNZui3_@codewreck.org>

On Sat, Jul 25, 2026 at 01:32:12AM +0900, Dominique Martinet wrote:
> > There's no "tk(cbc(aes))" algorithm in the upstream kernel.  So, it's
> > not possible that this ever worked with upstream.  Given that, there's
> > no regression in upstream for this program, and it wouldn't be
> > appropriate to consider a sysctl knob in upstream at this time.
> 
> Bleh, you are correct, it's an NXP patch in
> drivers/crypto/caam/caamalg.c that they've been carrying in their
> tree(s) since 2018[1] and has apparently never been upstreamed...
> [1] https://github.com/nxp-imx/linux-imx/commit/6868c9e49c1854028fb46022daac3b1b10ca2c70
> 
> Sorry for not having checked, I was hoping for better.
> (I should be used to it by now...)
> 
> 
> Regardless of the specific algorithm, most recent SoCs flaunt some
> "secure element" or similiar hardware-backed keys (so one wouldn't be
> able to decrypt $whatever without running on the specific board it was
> intended for); I'm sure _some_ of them are upstream?
> (Never used it so not sure if they are reachable from af_alg, but for
> example drivers/crypto/ccree/cc_cipher.c talks about hardware key...)
> 
> There's not much I can do about the vendor's kernel I'm stuck with, but
> that doesn't make having encryption material not accessible to userspace
> useless as a concept;
> forgetting about the sysctl for now, what are the alternatives API this
> kind of implementations could be based on?
> 
> I guess I should start looking at how tpm backed encryption works,
> some other day, it's getting late here...

First, we should remember that implementing hardware-bound keys via a
standalone crypto engine is a dated approach.  Inline crypto engines and
CPUs, which work much better than and are much easier to use than legacy
standalone crypto engines, can support hardware-bound keys as well.  The
former is already supported, and is already being widely used, in the
kernel via the hardware-wrapped inline crypto keys feature.  For the
latter, see e.g. RISC-V High Assurance Cryptography.  In the CPU case no
UAPI is even needed; userspace can just use it directly.

But with that being said, yes, there are a few in-tree drivers that
register "paes" algorithms with the crypto_skcipher or crypto_aead APIs,
or "phmac" with crypto_ahash.  That made them accessible via AF_ALG.

Of course, no use of these via AF_ALG has actually been confirmed yet.
Note that any such use would be unrelated to any use via dm-crypt or
dm-integrity, as those features call the kernel's crypto code directly.

But if any are confirmed and we end up needing to allowlist any of these
specific hardware-bound key algorithms in AF_ALG for compatibility
reasons, we can do that.  That does not mean we should allowlist
out-of-tree algorithms, or asynchronous algorithms in general.

We should also remember that AF_ALG has never actually supported
creating hardware-bound keys.  Anyone using it actually needs to use a
different UAPI to create the key.  This is driver-specific.  For CAAM it
seems to involve keyctl() calls, whereas for s390 it's /dev/pkey.  Any
userspace program that (theoretically) would be using either one has to
know which type of hardware it's talking to anyway.

So with this being a dated approach and also driver-specific anyway, and
with at least one driver using a char device already, I think the
replacement here (if any is needed for the few standalone crypto engine
drivers that implement this) would just be a driver-specific char device
with the minimum functionality required.  We shouldn't overthink things.

- Eric
