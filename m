Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166A817A2EA;
	Thu, 15 Jan 2026 21:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768514329; cv=none; b=iFwNGXjHU+TIiDwbbmN+pQAPs2x9SZT/mUqL29WkfHS38NGd3MWaWDXSlKbu9kBJKu/E11mrHkcoLAmtgUOtjlgp0GTlkfjluOgXPst2OnvLHZaZ0SVPd/dKWbEU3n+xwMsiN3aJw5q9hWYEwA/aHL9VN+7EgJZ1/4++eBk98dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768514329; c=relaxed/simple;
	bh=+I4EHyCRcog+i/equgmR9mk2bw+mqnXRdjAnJ5CaABE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tPnrIiqv/ra26/FWRGxJ3e1XZbTGEYDc+NOsm2lgDInmtHYkS1uBaoWQP9fVahdFi9kkrltMNVC5gDecFFh9hHsj3tPkgsoaaubbRYcLn3sRDoVXFsbsnknyD03MwDUnsSzbpg77/jir8nn6HQmNrbbjixqLND3EtiQFAX/Gijk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OK4aVYPL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OK4aVYPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC431C116D0;
	Thu, 15 Jan 2026 21:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768514328;
	bh=+I4EHyCRcog+i/equgmR9mk2bw+mqnXRdjAnJ5CaABE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OK4aVYPLAB9SF1cW9N1mkpyAAAK0qapY/LXpWSENuJV+bLMxNXr3e3m1008WoUEqA
	 aC55YDSQWMVGVFV3GXx4kwG+l2u7UIKdNsx1dyPP21mKat8vgGad/26hAGhzsfvDYh
	 ChCPBHy+4Z1xgWXmK7AWyzy7HY/Flv3pOqFUiZYBQuqXb3lxd+0xU2wg/pE3KnDFSM
	 5+NviKRydPmADUSyZAzVHLQSJsbMXUS0SwdxY89cACjZqiqiuJvqN56+ao7I8Ca/Jx
	 ux4+3nmglwSy+WKm+GjoEhJNlix5nBPXU1GuOtdWR6mWcr2S/i5F90MJm6mBVVxAah
	 6NiCWy2e7hhDA==
Date: Thu, 15 Jan 2026 13:58:12 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Holger Dengler <dengler@linux.ibm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Harald Freudenberger <freude@linux.ibm.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v1 1/1] lib/crypto: tests: Add KUnit tests for AES
Message-ID: <20260115215812.GA10598@quark>
References: <20260115183831.72010-1-dengler@linux.ibm.com>
 <20260115183831.72010-2-dengler@linux.ibm.com>
 <20260115204332.GA3138@quark>
 <76089e1f-dfc9-44e8-8e16-b965cd43d848@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76089e1f-dfc9-44e8-8e16-b965cd43d848@linux.ibm.com>

On Thu, Jan 15, 2026 at 10:51:25PM +0100, Holger Dengler wrote:
> On 15/01/2026 21:43, Eric Biggers wrote:
> > On Thu, Jan 15, 2026 at 07:38:31PM +0100, Holger Dengler wrote:
> >> Add a KUnit test suite for AES library functions, including KAT and
> >> benchmarks.
> >>
> >> Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
> > 
> > The cover letter had some more information.  Could you put it in the
> > commit message directly?  Normally cover letters aren't used for a
> > single patch: the explanation should just be in the patch itself.
> 
> Ok, I'll move the explanation to the commit message. I assume that the example
> output of the test can be dropped?

Yes, that's fine.

> > 10000000 iterations is too many.  That's 160 MB of data in each
> > direction per AES key length.  Some CPUs without AES instructions can do
> > only ~20 MB AES per second.  In that case, this benchmark would take 16
> > seconds to run per AES key length, for 48 seconds total.
> > 
> > hash-test-template.h and crc_kunit.c use 10000000 / (len + 128)
> > iterations.  That would be 69444 in this case (considering len=16),
> > which is less than 1% of the iterations you've used.  Choosing a number
> > similar to that would seem more appropriate.
> > 
> > Ultimately these are just made-up numbers.  But I think we should aim
> > for the benchmark test in each KUnit test suite to take less than a
> > second or so.  The existing tests roughly achieve that, whereas it seems
> > this one can go over it by quite a bit due to the 10000000 iterations.
> 
> As we have a fixed length, I would go stay with a fix value for the iterations
> (instead of calculating it based on len).
> 
> The benchmark has a separate loop for encrypt and decrypt, so I will do the
> half iterations on encrypt and the other half on decrypt. I will also reduce
> the iterations for the warm-ups.
> 
> What about 100 iterations for each warm-up and 500.000 iterations for each
> real measurement? Means processing 2x 8MiB with preemption disabled.

I'd suggest 50000 for each direction as well as the warm-up loop.

- Eric
