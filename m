Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4315C1FECCD;
	Fri, 16 Jan 2026 19:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768592652; cv=none; b=jhWP0Zd7mE7LSYCe6ZNJOotEIu3AKtmHW86kOw+pzo0/A6sWS4nC4mLnmjgxIrV8HCEuziajUzodJhGOfLjF/MzTzZGtdgPaUT683sbu3DFu0C2YNtP+nA/+2kTzIfvfFudCMRT6haQ7Ru1dYHgMNC9QJL5lbGcENg8vaVjzAXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768592652; c=relaxed/simple;
	bh=Omo0RXYhCnccplhQW3URwXnzE3b3CBtbpp/2JUWXAqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CmNv7zffumnqGnncBJa17M2DAirOsR3szK1l58uCveBnzllwALRYEhVtPXFyvxpiKJhLKA/CrvBDjWh8el2gNwqlO1pzSoD/jk4lvrs9ibDOBXhmTUphZC23A34UZ3G8t++1Exy7qlECaQH6et6c+LE6nd6566X/qlfaeWK9/O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WwjFVDgP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WwjFVDgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC68C116C6;
	Fri, 16 Jan 2026 19:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768592652;
	bh=Omo0RXYhCnccplhQW3URwXnzE3b3CBtbpp/2JUWXAqk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WwjFVDgPVRIMNnaevrZ+su2DGugj9D1zoam9A7/hCg0XSMHl3zndPIwxDzv3mbx8e
	 ueO6OeHYrE8DVu3Nm1NtA0RfbjG1sSto1J1huKrIm4PJ1X0ZUGBBnGeT7HEirRrBcN
	 W5iNsz9sC/FviwiB/ZoI+7wULogKCy9kJXPmhGJPKoSOpxpDoIAB4e5XT9pPBT1tDY
	 0ngWrqT0YpulwQyFKRaRciTvqKs8JjF5oWosg0tm0EgLTI9KqZtf8XMt15K645vhtS
	 zbR/nArq2l0BBej7r18iTaGXpF1yp6xbSXoCc0uCl7eZ+zfJfXpVBKDBLJq1c3JrET
	 vgNpEtm4jHlQA==
Date: Fri, 16 Jan 2026 19:44:10 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Holger Dengler <dengler@linux.ibm.com>
Cc: David Laight <david.laight.linux@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Harald Freudenberger <freude@linux.ibm.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v1 1/1] lib/crypto: tests: Add KUnit tests for AES
Message-ID: <20260116194410.GA1398962@google.com>
References: <20260115183831.72010-1-dengler@linux.ibm.com>
 <20260115183831.72010-2-dengler@linux.ibm.com>
 <20260115204332.GA3138@quark>
 <20260115220558.25390c0e@pumpkin>
 <389595e9-e13a-42e3-b0ff-9ca0dd3effe3@linux.ibm.com>
 <20260116183744.04781509@pumpkin>
 <2d5c7775-de20-493d-88cc-011d2261c079@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d5c7775-de20-493d-88cc-011d2261c079@linux.ibm.com>

On Fri, Jan 16, 2026 at 08:20:51PM +0100, Holger Dengler wrote:
> >> The benchmark loops for 100 iterations now without any warm-up. In each
> >> iteration, I measure a single aes_encrypt()/aes_decrypt() call. The lowest
> >> value of these measurements is takes as the value for the bandwidth
> >> calculations. Although it is not necessary in my environment, I'm doing all
> >> iterations with preemption disabled. I think, that this might help on other
> >> platforms to reduce the jitter of the measurement values.
> >>
> >> The removal of the warm-up does not have any impact on the numbers.
> > 
> > I'm not sure what the 'warm-up' was for.
> > The first test will be slow(er) due to I-cache misses.
> > (That will be more noticeable for big software loops - like blake2.)
> > Change to test parameters can affect branch prediction but that also only
> > usually affects the first test with each set of parameters.
> > (Unlikely to affect AES, but I could see that effect when testing
> > mul_u64_u64_div_u64().)
> > The only other reason for a 'warm-up' is to get the cpu frequency fast
> > and fixed - and there ought to be a better way of doing that.

The warm-up loops in the existing benchmarks are both for cache warming
and to get the CPU frequency fast and fixed.  It's not anything
sophisticated, but rather just something that's simple and seems to
works well enough across CPUs without depending on any special APIs.  If
your CPU doesn't do much frequency scaling, you may not notice a
difference, but other CPUs may need it.

> >> I also did some tests with IRQs disabled (instead of only preemption), but the
> >> numbers stay the same. So I think, it is save enough to stay with disables
> >> preemption.
> > 
> > I'd actually go for disabling interrupts.
> > What you are seeing is the effect of interrupts not happening
> > (which is likely for a short test, but not for a long one).
> 
> Ok, I'll send the next series with IRQ disabled. I don't see any difference on
> my systems.

Some architectures don't allow vector registers to be used when IRQs are
disabled.  On those architectures, disabling IRQs would always trigger
the fallback to the generic code, which would make the benchmark not
very useful.  That's why I've only been disabling preemption, not IRQs.

- Eric
